
//
//  ICXSocketProcessingCenter.m
//  ICXHealthBuddy
//
//  Created by krisouljz on 2019/7/31.
//  Copyright © 2019年 lvjiazhen. All rights reserved.
//

#import "ICXSocketProcessingCenter.h"
#import "GCDAsyncSocket.h"
#import "ICXCentralManagement.h"
#import "ICXPbRequest.h"
#import "ICXPbResponse.h"
#import "ICXPacketChecker.h"

#import "ICXMessageConstants.h"
#import "CocoaLumberjack.h"
#import "ICXNetworkMarco.h"
#import "ICXNetworkMonitor.h"
#import "ICXDataSaveManager.h"
#import "ICXAuthModule.h"
#import "ICXAuthModel.h"

#import "Eim_message.pb.h"
#import "Eim_constant.pb.h"
#import "Eim_base.pb.h"

/*  弱引用 */
#define socketWEAKSELF                        typeof(self) __weak weakSelf = self;

@interface ICXSocketProcessingCenter()<GCDAsyncSocketDelegate>

@property(strong,nonatomic) GCDAsyncSocket *socket;
@property(strong,nonatomic) dispatch_queue_t socketQueue;
@property(strong,nonatomic) ICXPacketChecker *thePacketChecker; // 处理粘包的类
@property(strong,nonatomic) NSMutableDictionary* requestCache; // 用于缓存业务请求
@property(strong,nonatomic) NSCondition* requestCacheCondition;
@property (nonatomic, strong) NSTimer *heartbeatTimer; // 全局定时器：发心跳+监听超时请求
@property (nonatomic) NSTimeInterval theLastHeartbeatTime; // 记录上次发送心跳的时间戳
@property (nonatomic) NSTimeInterval lastRefreshTokenTs;  // 记录上次刷新token的ts
@property(assign,nonatomic) NSInteger heartBeatRetryTimes; // 发心跳失败重试次数
@property(assign,nonatomic) NSInteger reconnectRetryTimes; // 重连失败重试次数

@property(strong,nonatomic) NSString *currentIp;
@property(assign,nonatomic) UInt16 currentPort;
@property(assign,nonatomic) UInt16 appId;
@property(strong,nonatomic) NSString *appkey;

@end

@implementation ICXSocketProcessingCenter

#pragma mark - Init
+ (instancetype)sharedInstance {
    static ICXSocketProcessingCenter *socketCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketCenter = [[self alloc] init];
    });
    return socketCenter;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _socketQueue = dispatch_queue_create("imSocketQueue", NULL); // 注意queue要串行的，不能是并发队列
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketQueue];
        _thePacketChecker = [[ICXPacketChecker alloc] init];
        _requestCache = [[NSMutableDictionary alloc] init];
        _requestCacheCondition = [[NSCondition alloc] init];
        
        [ICXNetworkMonitor startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reconnect) name:ICXNETWORKSTATUSWWAN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reconnect) name:ICXNETWORKSTATUSWIFI object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reconnect) name:UIApplicationProtectedDataDidBecomeAvailable object:nil];
    }
    return self;
}

#pragma mark - socket连接、断开连接
- (SInt16)getAppId{
    return self.appId;
}
// 重连:如果之前bind失败要重新绑定，否则重新鉴权、拉取消息
- (void)reconnect {
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"ISICXLogin"];
    if (loginStatus && [loginStatus isEqualToString:@"YES"]) {
        
        DDLogInfo(@"====已登录，且有网络,没有连接成功：重新连接socket====");
        [self socketConnectToServerWithIP:self.currentIp port:self.currentPort appKey:self.appkey appId:self.appId];
    }
}

- (void)socketConnectToServerWithIP:(NSString*)ip port:(UInt16)port appKey:(NSString*)appkey appId:(SInt64)appId{
    
    //    if (!self.currentIp && self.currentPort==0) {
    //        [self startHeartbeat]; // 第一次执行重连， 开启全局定时器，监听超时的请求
    //    }
    
    //本机:  10.0.161.19   9000
    //dev:  139.199.61.215   9000
    //test: 118.89.54.64   9000
    
    self.currentIp = ip;
    self.currentPort = port;
    self.appkey = appkey;
    self.appId = appId;
    
    if (self.connectStatus == ICXSocketConnectStatusConnecting || self.connectStatus == ICXSocketConnectStatusConnected ) {
        return;
    }
    
    if (self.reconnectRetryTimes > 5) {
        // 重连超过5次还没成功
        DDLogInfo(@"重连超过5次还没成功，不继续重连了，等下次  “后台回前台” 、 “网络变化” 、 下个心跳周期 、 ”重新发起请求“ 再触发重连");
        self.reconnectRetryTimes = 0;
        return;
    }
    
    if (!self.socket) {
        DDLogInfo(@"Recreating socket.");
        _socketQueue = dispatch_queue_create("imSocketQueue", NULL); // 注意queue要串行的，不能是并发队列
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketQueue];
    }
    
    DDLogInfo(@"====真的去执行重连socket====");
    self.reconnectRetryTimes += 1;
    [self connectToRemote:self.currentIp onPort:self.currentPort];
}

-(void)connectToRemote:(NSString*)remoteAddr onPort:(UInt16)port
{
    @try
    {
        NSError *err;
        if ([_socket connectToHost:remoteAddr onPort:port withTimeout:TIMEOUT_10 error:&err])
        {
            DDLogInfo(@"Connecting to %@ port %u.", remoteAddr, port);
            self.connectStatus = ICXSocketConnectStatusConnecting;
        }else{
            if (!err) {
                err = [NSError errorWithDomain:remoteAddr code:1100 userInfo:@{@"error":@"socket连接失败"}];
            }
            DDLogError(@"Couldn't connect to %@ port %u (%@).", remoteAddr, port, err);
            self.connectStatus = ICXSocketConnectStatusDisConnect;
        }
    }
    @catch (NSException *exception)
    {
        DDLogError(@"Exception: %@", [exception reason]);
        self.connectStatus = ICXSocketConnectStatusDisConnect;
    }
}

- (void)socketDisconnect
{
    [self stopHeartbeat];
    [_thePacketChecker clearCacheData];
    self.connectStatus = ICXSocketConnectStatusDisConnect;
    if (_socket) {
        if ([_socket isConnected] || ![_socket isDisconnected]) {
            [_socket setDelegate:nil];
            [_socket disconnect];
            _socket = nil;
        }
    }
}

-(BOOL)isConnected
{
    if (_socket) {
        return [_socket isConnected];
    }
    return NO;
}

- (void)reset
{
    //    DDLogInfo(@"clearRequestCache. count:%lu\n _requestCache:%@", (unsigned long)_requestCache.count, _requestCache);
    //    [_requestCacheCondition lock];
    //    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:_requestCache];
    //    for(ICXPbRequest *ongoingRequest in dic.allValues)
    //    {
    //        [self doExceptionBackWithRequest:ongoingRequest Error:ICXReturnValueTypeSocketDisconnect];
    //        [_requestCache removeObjectForKey:@(ongoingRequest.seqId)];
    //    }
    //    [_requestCacheCondition unlock];
    [self socketDisconnect];
    DDLogInfo(@"End of Reset HTSocketProcessingCenter.");
}

- (void)reSendTheRequestFromCache{
    for(ICXPbRequest *ongoingRequest in _requestCache.allValues)
    {
        int timeOut = TIMEOUT_30;
        if (ongoingRequest.Cmd==EIM_CMD_TYPEEimCmdMessage || ongoingRequest.Cmd==EIM_CMD_TYPEEimCmdGroupMessage) {
            timeOut = TIMEOUT_120;
        }
        [self sendSocketRequest:ongoingRequest withTimeout:timeOut];
    }
    
}

#pragma mark - 鉴权、心跳
// 鉴权(登录)
- (void)authLogin {
    ICXAuthModel *model = [ICXDataSaveManager getModelWithPath:ICX_Token_Save_Path];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *device_id = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *device_info = ICX_UserAgent;
    // appkey @"0cb035ae5baf4cb4a9ed98898d961fcf"
    if (!self.appkey) {
        self.appkey = @"0cb035ae5baf4cb4a9ed98898d961fcf";
    }
    AuthReqBuilder *builder = [[[[[[[AuthReq builder] setToken:model.access_token] setDeviceId:device_id] setAppKey:self.appkey] setPlatform:1] setVersion:appCurVersion] setDeviceInfo:device_info];
    NSData *data = [[builder build] data];
    
    NSLog(@"================access_token: %@===============", model.access_token);
    ICXPbRequest *pbRequest = [[ICXPbRequest alloc] initWithCmd:EIM_CMD_TYPEEimCmdAuth andAppId:self.appId andPbData:data];
    NSData* dataToSend = [pbRequest formatHeaderToData];
    
    [_socket writeData:dataToSend withTimeout:-1 tag:pbRequest.Cmd];
}

// 心跳相关
- (void)startHeartbeat {
    
    NSLog(@"===start heartbeatTimer ===");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.heartbeatTimer != nil) {
            [self stopHeartbeat];
            self.theLastHeartbeatTime = 0.0;
        }
        self.heartbeatTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(heartbeatTimerFired) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.heartbeatTimer forMode:NSDefaultRunLoopMode];
        NSLog(@"===heartbeatTimer reset===");
    });
    
}
- (void)stopHeartbeat {
    __block __weak NSTimer *weakTimer = _heartbeatTimer;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakTimer invalidate];
        weakTimer = nil;
        NSLog(@"===stopHeartbeat===");
    });
}

// 生成m~n之间的随机整数
-(int)arc4randomFrom:(int)m to:(int)n{
    return m + arc4random()%(n - m + 1);
}

- (void)heartbeatTimerFired {
    //    NSLog(@"===heartbeatTimerFired===");
    NSTimeInterval timeIntervalNow = [NSDate timeIntervalSinceReferenceDate];
    // 发送心跳包:改成HeartbeatCycle +/- 20秒作为心跳周期
    NSInteger randomCount = [self arc4randomFrom:-20 to:20];
    if (timeIntervalNow - _theLastHeartbeatTime - randomCount >= HeartbeatCycle) {
        [self doHeartbeat];
        _theLastHeartbeatTime = timeIntervalNow;
    }
    // 检查已经超时的请求，并做超时回调处理
    NSMutableArray* theTimeoutRequests = [NSMutableArray array];
    [_requestCacheCondition lock];
    for(ICXPbRequest *request in _requestCache.allValues)
    {
        if (timeIntervalNow - request.startTime > request.timeoutInterval ) //is timeout
        {
            [theTimeoutRequests addObject:request];
        }
    }
    for (ICXPbRequest *timeOutRequest in theTimeoutRequests) {
        
        if (timeOutRequest.Cmd == EIM_CMD_TYPEEimCmdHeartbeat) {
            if (self.heartBeatRetryTimes>5) {
                [self reconnect]; // 发心跳失败重试5次后重连
            }else{
                // 发心跳没响应，立即重发心跳
                [self doHeartbeat];
            }
        }else{
            // 业务的请求超时
            [self doExceptionBackWithRequest:timeOutRequest Error:ICXReturnValueTypeRequestTimeout];
        }
        // 从_requestCache中移除已经处理调的超时请求
        [_requestCache removeObjectForKey:@(timeOutRequest.seqId)];
    }
    [_requestCacheCondition unlock];
}

- (void)doHeartbeat{
    if (![ICXNetworkMonitor networkOn]) {
        return;
    }
    
    if (self.connectStatus != ICXSocketConnectStatusConnected) {
        [self reconnect];
        return;
    }
    
    self.heartBeatRetryTimes += 1;
    DDLogInfo(@"===doHeartbeat===");
    HeartBeatReqBuilder *builder = [[HeartBeatReq builder] setFlag:YES];
    NSData *data = [[builder build] data];
    ICXPbRequest *pbRequest = [[ICXPbRequest alloc] initWithCmd:EIM_CMD_TYPEEimCmdHeartbeat andAppId:self.appId andPbData:data];
    pbRequest.timeoutInterval = TIMEOUT_20;
    [_requestCache setObject:pbRequest forKey:@(pbRequest.seqId)]; // 缓存起来
    NSData* dataToSend = [pbRequest formatHeaderToData];
    [_socket writeData:dataToSend withTimeout:-1 tag:pbRequest.Cmd];
}

- (void)setConnectStatus:(ICXSocketConnectStatus)connectStatus{
    _connectStatus = connectStatus;
    NSLog(@"setConnectStatus=%ld",(long)connectStatus);
}

#pragma mark - 发送业务请求：
- (void)sendSocketRequest:(ICXClientRequest *)request withTimeout:(unsigned int)timeout{
    
    if (![ICXNetworkMonitor networkOn]) {
        [self doExceptionBackWithRequest:request Error:ICXReturnValueTypeNetUnReachable];
        return;
    }
    
    
    if (self.connectStatus != ICXSocketConnectStatusConnected) {
        [self doExceptionBackWithRequest:request Error:ICXReturnValueTypeSocketDisconnect];
        [self reconnect];
        return;
    }
    
    DDLogInfo(@"发送业务请求：seqId=%d，cmd=%d",request.seqId,request.Cmd);
    request.timeoutInterval = timeout; // 设置每个请求的超时时间
    [_requestCache setObject:request forKey:@(request.seqId)];
    NSData* dataToSend = [request formatHeaderToData];
    [_socket writeData:dataToSend withTimeout:-1 tag:request.Cmd];
}

#pragma mark - 异常回调处理
- (void)doExceptionBackWithRequest:(ICXClientRequest*)request Error:(ICXReturnValueType)errorReturnType{
    ICXPbResponse *response = [[ICXPbResponse alloc] initWithType:request.requestType uniqueIdentifier:request.uniqueIdentifier netData:nil];
    [self assginResponse:response andExceptionRequest:(ICXPbRequest*)request];
    response.retCode = errorReturnType; //
    [[ICXCentralManagement getInstance] socketReceiveResponse:response request:request];
    DDLogInfo(@"异常回调处理：errorReturnType=%d,seqId=%d，cmd=%d",errorReturnType,request.seqId,request.Cmd);
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    DDLogInfo(@"Connected to %@ %u.", host, port);
    self.connectStatus = ICXSocketConnectStatusConnected;
    socketWEAKSELF
    [_socket performBlock:^{
        // 后台支持socket连接
        [weakSelf.socket enableBackgroundingOnSocket];
    }];
    // 连接成功后，发起鉴权
    [self authLogin];
    //读取数据,发送的tag是0，读的tag是100
    [self.socket readDataWithTimeout:-1 tag:100];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    DDLogError(@"Socket Disconnected. error = %@", [err description]);
    self.connectStatus = ICXSocketConnectStatusDisConnect;
    if (err) {
        /*
         * socket错误码：
         code == 3 ==>连接超时 Error Domain=GCDAsyncSocketErrorDomain Code=3 'Attempt to connect to host timed out
         code == 7 ==>服务器主动断开连接 Error Domain=GCDAsyncSocketErrorDomain Code=7, 'Socket closed by remote peer'
         code == 22 ==>无效参数  Domain=NSPOSIXErrorDomain Code=22 "Invalid argument" UserInfo={_kCFStreamErrorCodeKey=22, _kCFStreamErrorDomainKey=1}
         code == 32 ==>写的时候通道破裂 Error Domain=NSPOSIXErrorDomain Code=32 'Broken pipe'
         code == 51 ==>断网后  Error Domain=NSPOSIXErrorDomain Code=51 "Network is unreachable",Error in connect() function
         code == 57 ==>socket断开连接 Error Domain=NSPOSIXErrorDomain Code=57 'Socket is not connected'
         code == 61 ==>socket连接被拒绝 Error Domain=NSPOSIXErrorDomain Code=61 "Connection refused"
         */
        if (!([err.domain isEqualToString:NSPOSIXErrorDomain] && err.code == 51)) {
            // 有网络，但是连接失败 （重置socket,执行重连）
            [self reset];
            [self reconnect];
        }
    }
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    socketWEAKSELF
    if (![sock isEqual:_socket]) {
        DDLogError(@"sock != socket");
        return;
    }
    
    [sock readDataWithTimeout:-1 tag:0];
    
    [_thePacketChecker setRowData:data];
    
    while (YES) {
        NSData* packetData = [_thePacketChecker getCompletelyPacket];
        if (packetData == nil) {
            DDLogError(@"packetData is nil");
            break;
        }
        
        @try {
            
            ICXPbResponse *response = [[ICXPbResponse alloc] initWithNetData:packetData];
            if (response.Cmd == EIM_CMD_TYPEEimNotifyNewMsgPush) {
                // 服务器主动下发的通知
                [[ICXCentralManagement getInstance] socketReceiveResponse:response request:nil];
                DDLogInfo(@"服务器主动下发的通知：cmd=%d,pbDataLenth=%d",response.Cmd,response.pbData.length);
            }else{
                // 主动请求的服务器响应
                BaseResultResp *baseRsp = [BaseResultResp parseFromData:response.pbData];
                if (baseRsp.status.retCode==EIM_RET_CODERetTokenInvalid) {
                    // token失效
                    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
                    if (ts - self.lastRefreshTokenTs > 300) {
                        self.lastRefreshTokenTs = [[NSDate date] timeIntervalSince1970];
                        
                        [ICXAuthManager refreshTokenWithBlock:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error, BOOL isValid) {
                            if (isValid) {
                                DDLogInfo(@"====token失效，刷新token成功，重连然后拉取====");
                                [weakSelf authLogin];
                            } else {
                                DDLogInfo(@"====socket刷token失败====");
                            }
                        }];
                    }else{
                        // 重刷token还是失败
                        [self reset];
                        [self reconnect];
                    }
                }else if (baseRsp.status.retCode==EIM_RET_CODERetSuccess){
                    // 接口回调成功
                    if (response.Cmd==EIM_CMD_TYPEAuthAck) { // 鉴权接口回调
                        AuthResp *rsp = [AuthResp parseFromData:response.pbData];
                        NSLog(@"鉴权响应成功:reconnectionToken=%@,expireIn=%lld",rsp.reconnectionToken,rsp.expireIn);
                        // 开启全局定时器
                        [self startHeartbeat];
                        // 重新发送缓存中的请求
                        [self reSendTheRequestFromCache];
                        NSInteger delayTime = (self.requestCache.count>0?1:0); // 此处延迟1秒的原因是：避免本地正在loadding的消息（服务器其实已收到，只是还没收到该消息的回包），应该重发该消息然后尽量等该消息的回包回来后再拉消息，不然会出现，本地loadding消息状态会更新失败
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            // 开始拉消息
                            if (self.pullMessageBlock) {
                                self.pullMessageBlock();
                            }
                        });
                        
                    }else if (response.Cmd==EIM_CMD_TYPEHeaetbeatAck){ // 心跳接口回调
                        NSLog(@"心跳响应成功");
                        [_requestCache removeObjectForKey:@(response.seqId)];
                        self.heartBeatRetryTimes = 0;
                        
                    }else{ // 其它业务接口回调
                        // 先拿到该响应对应的request
                        DDLogInfo(@"收到业务请求回包：seqId=%d，cmd=%d",response.seqId,response.Cmd);
                        ICXPbRequest *request = [_requestCache objectForKey:@(response.seqId)];
                        response = [[ICXPbResponse alloc] initWithType:request.requestType uniqueIdentifier:request.uniqueIdentifier netData:packetData];
                        response.dataDictionary = request.dataDictionary;
                        response.retCode = baseRsp.status.retCode;
                        [[ICXCentralManagement getInstance] socketReceiveResponse:response request:request];
                        [_requestCache removeObjectForKey:@(response.seqId)];
                    }
                }else{
                    // 服务器返回的其它错误码
                    DDLogInfo(@"其它错误retCode=%d",baseRsp.status.retCode);
                    ICXPbRequest *request = [_requestCache objectForKey:@(response.seqId)];
                    response = [[ICXPbResponse alloc] initWithType:request.requestType uniqueIdentifier:request.uniqueIdentifier netData:packetData];
                    response.dataDictionary = request.dataDictionary;
                    response.retCode = baseRsp.status.retCode;
                    [[ICXCentralManagement getInstance] socketReceiveResponse:response request:request];
                    [_requestCache removeObjectForKey:@(response.seqId)];
                }
            }
            
        } @catch (NSException *exception) {
            DDLogError(@"readData Exception: %@", [exception reason]);
        }
        
    }
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    DDLogInfo(@"didWriteDataWithTag:%lu", tag);
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length{
    return TIMEOUT_10;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length{
    return TIMEOUT_10;
}

#pragma mark - private
- (void)assginResponse:(ICXPbResponse*)response andExceptionRequest:(ICXPbRequest*)exceptionRequest{
    response.stx = exceptionRequest.stx;
    response.version = exceptionRequest.version;
    response.Cmd = exceptionRequest.Cmd;
    response.appId = exceptionRequest.appId;
    response.checksum = exceptionRequest.checksum;
    response.seqId = exceptionRequest.seqId;
    response.responseFlag = exceptionRequest.responseFlag;
    response.len = exceptionRequest.len;
    //    response.pbData = exceptionRequest.pbData;
    response.etx = exceptionRequest.etx;
}

@end










