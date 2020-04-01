//
//  ICXMessageCenter.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXMessageCenter.h"
#import "ICXModel.h"
#import "ICXMessage.h"
#import "ICXDataMessage.h"
#import "ICXNotifyMessage.h"
#import "ICXModelObserver.h"
#import "ICXMessageOperation.h"
#import "ICXDataMessageOperation.h"
#import "ICXMessageHeader.h"

@interface ICXMessageCenter()<ICXMessageInterfaceDelegate> {
    NSRecursiveLock *observerLock;
    NSRecursiveLock *messageLock;
}

@property (nonatomic, strong) NSMutableDictionary   *messagePool;                 // 消息池
@property (nonatomic, strong) NSMutableDictionary   *messageObservers;            // 消息监听群
@property (nonatomic, strong) NSOperationQueue   *messageSendQueue;               // 消息发送队列
@property (nonatomic, strong) NSOperationQueue   *messageReceiveQueue;            // 消息接收队列

@property (nonatomic, strong) NSOperationQueue   *dataMessageSendQueue;           // db消息发送队列
@property (nonatomic, strong) NSOperationQueue   *dataMessageReceiveQueue;        // db息接收队列

@property (nonatomic, strong) NSOperationQueue   *serialMessageSendQueue;         // 特殊消息发送队列
@property (nonatomic, strong) NSOperationQueue   *serialMessageReceiveQueue;      // 特殊消息接收队列

// 特殊消息发送队列:用于拉取消息，这里的策略是当有新的拉取operation时，检查并cancel队列已有的未执行的operation
@property (nonatomic, strong) NSOperationQueue   *serialMessagePullQueue;

@end

@implementation ICXMessageCenter

ICX_DEF_SINGLETON(ICXMessageCenter, defaultCenter)

- (id)init {
    self = [super init];
    
    if (self) {
        [[ICXMessageInterface sharedInterface] setDelegate:self];
        
        _messagePool = [NSMutableDictionary dictionary];
        _messageObservers = [NSMutableDictionary dictionary];
        
        _messageSendQueue = [[NSOperationQueue alloc] init];
        _messageSendQueue.maxConcurrentOperationCount = 3;
        _messageReceiveQueue = [[NSOperationQueue alloc] init];
        _messageReceiveQueue.maxConcurrentOperationCount = 3;
        
        _serialMessageSendQueue = [[NSOperationQueue alloc] init];
        _serialMessageSendQueue.maxConcurrentOperationCount = 1;
        _serialMessageReceiveQueue = [[NSOperationQueue alloc] init];
        _serialMessageReceiveQueue.maxConcurrentOperationCount = 1;
        _serialMessagePullQueue = [[NSOperationQueue alloc] init];
        _serialMessagePullQueue.maxConcurrentOperationCount = 1;
        
        _dataMessageSendQueue = [[NSOperationQueue alloc] init];
        _dataMessageSendQueue.maxConcurrentOperationCount = 1;
        _dataMessageReceiveQueue = [[NSOperationQueue alloc] init];
        _dataMessageReceiveQueue.maxConcurrentOperationCount = 1;
        
        observerLock = [[NSRecursiveLock alloc] init];
        messageLock = [[NSRecursiveLock alloc] init];
    }
    
    return self;
}

#pragma mark - Message Observer

- (void)addObserver:(ICXModel *)model name:(NSString *)notificationName {
    [observerLock lock];
    NSMutableArray *array = [self.messageObservers objectForKey:notificationName];
    if (array) {
        for (ICXModelObserver *observer in array) {
            if (observer.model == model) {
                [observerLock unlock];
                return;
            }
        }
        ICXModelObserver *observer = [[ICXModelObserver alloc] initWithModel:model];
        [array addObject:observer];
    } else {
        array = [NSMutableArray array];
        ICXModelObserver *observer = [[ICXModelObserver alloc] initWithModel:model];
        [array addObject:observer];
        [self.messageObservers setObject:array forKey:notificationName];
    }
    [observerLock unlock];
    
}

- (void)removeObserver:(ICXModel *)model {
    [observerLock lock];
    NSArray *allValues = self.messageObservers.allValues;
    for (NSMutableArray *array in allValues) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
        for (ICXModelObserver *observer in tempArray) {
            if (observer.model == model || !observer.model) {
                [array removeObject:observer];
            }
        }
    }
    [observerLock unlock];
}

#pragma mark - Potocol Message

- (void)sendMessage:(ICXMessage *)message {
    // 判断消息是否需要缓存
    if (message.cache) {
        [self setMessageToPool:message];
    }
    ICXMessageOperation *operation = [[ICXMessageOperation alloc] initWithMessage:message];
    operation.responded = NO;
    
    if (message.requestType == ICXRequestTypeSendMessage || message.requestType == ICXRequestTypeSendRoomMessage) {
        // 聊天消息通过串行发送队列
        [self.serialMessageSendQueue addOperation:operation];
    }
//    else if (message.requestType == ICXRequestTypePullMessage) {
//        // FIXME: - 拉取消息是否也要串行?
//        [self.serialMessagePullQueue cancelAllOperations];
//        [self.serialMessagePullQueue addOperation:operation];
//    }
    else if (message.requestType == ICXRequestTypeCancelHttpRequest) {
        // 如果是取消http请求的消息，那么在对应的消息插入取消标记。
        // msg.isCancel = YES，底层返回上来的时候判断这个属性，如果是YES则直接删除该消息
        NSString *identifier = [message.requestData stringForKey:ICX_CancelIdentifier];
        if (identifier) {
            ICXMessage *msg = [self messageWithIdentifier:identifier];
            msg.isCancel = YES;
        }
        [self.messageSendQueue addOperation:operation];
    }else {
        [self.messageSendQueue addOperation:operation];
    }
}

- (void)setMessageToPool:(ICXMessage *)message {
    // 防止messageId重复
    [messageLock lock];
    NSString *identifier = [NSString stringWithFormat:@"pt%@",message.identifier];
    
    while(message.identifier.length <= 0 || [self.messagePool objectForKey:identifier]) {
        message.identifier = [ICXFunction uniqueMessageID];
        identifier = [NSString stringWithFormat:@"pt%@",message.identifier];
    }
    
    if (message.requestData) {
        [message.requestData setObject:message.identifier forKey:ICX_UniqueIdentifier];
    } else {
        message.requestData = [NSMutableDictionary dictionaryWithObject:message.identifier forKey:ICX_UniqueIdentifier];
    }
    [self.messagePool setObject:message forKey:identifier];
    [messageLock unlock];
}

- (ICXMessage *)messageWithIdentifier:(NSString *)identifier {
    [messageLock lock];
    ICXMessage *message = [self.messagePool objectForKey:[NSString stringWithFormat:@"pt%@",identifier]];
    [messageLock unlock];
    return message;
}

- (void)sendSyncMessage:(ICXMessage *)message {
    [self sendMessage:message];
    
    while (!message.responded) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)receiveMessage:(ICXMessage *)message {
    ICXMessageOperation *operation = [[ICXMessageOperation alloc] initWithMessage:message];
    operation.responded = YES;
    if (message.responseType == ICXNotifyTypeNewMessage) {
        // FIXME: - 消息通知是否也要串行?
        // FIXME: - 拉取消息的response是否也要串行?
        [self.serialMessageReceiveQueue addOperation:operation];
    }
    else {
        NSLog(@" receiveMessage&&&& %@",message.identifier);
        [self.messageReceiveQueue addOperation:operation];
    }
    
//    if (![message isKindOfClass:[ICXMessage class]]) {
//        HTDDLogError(@"接收协议消息类型错误! 消息传入为:%@",message);
//        return;
//    }
//
//    if (message.responseType == HTResponseTypeLogin ||
//        message.responseType == HTResponseTypeLoginVerification ||
//        message.responseType == HTResponseTypeReconnection ||
//        message.responseType == HTResponseTypeLogout ||
//        message.responseType == HTResponseTypeStatusReport ||
//        message.responseType == HTResponseTypeRegisterStep1 ||
//        message.responseType == HTResponseTypeRegisterStep2 ||
//        message.responseType == HTResponseTypeForgotPassword) {
//        HTMessaageOperation *operation = [[HTMessaageOperation alloc] initWithMessage:message];
//        operation.responded = YES;
//        [self.messageReceiveQueue addOperation:operation];
//    } else {
//        if ([self isDatabaseInitFinished]) {
//            HTMessaageOperation *operation = [[HTMessaageOperation alloc] initWithMessage:message];
//            operation.responded = YES;
//            if (message.requestType == HTRequestTypeMessage) {
//                // 聊天消息通过串行接收队列
//                [self.serialMessageReceiveQueue addOperation:operation];
//            } else {
//                [self.messageReceiveQueue addOperation:operation];
//            }
//        } else {
//            [self performSelectorOnMainThread:@selector(delayHandleMessage:) withObject:message afterDelay:3.0];
//        }
//    }
}

- (void)delayHandleMessage:(ICXMessage *)message {
    if ([self isDatabaseInitFinished]) {
        if (message.responder) {
            ICXMessageOperation *operation = [[ICXMessageOperation alloc] initWithMessage:message];
            operation.responded = YES;
            [self.messageReceiveQueue addOperation:operation];
        } else {
            [self notifyMessage:message];
        }
    } else {
        [self performSelectorOnMainThread:@selector(delayHandleMessage:) withObject:message afterDelay:3.0];
    }
}

- (void)delayHandleSerialMessage:(ICXMessage *)message {
    if ([self isDatabaseInitFinished]) {
        if (message.responder) {
            ICXMessageOperation *operation = [[ICXMessageOperation alloc] initWithMessage:message];
            operation.responded = YES;
            [self.serialMessageReceiveQueue addOperation:operation];
        } else {
            [self notifySerialMessage:message];
        }
    } else {
        [self performSelectorOnMainThread:@selector(delayHandleSerialMessage:) withObject:message afterDelay:3.0];
    }
}

- (void)removeMessage:(ICXMessage *)message {
    // Message响应完毕后再广播消息
    
    // 需要广播的消息，并且没有取消则发送广播
    
    if (message.needNotify && !message.isCancel) {
        message.notificationName = MessageNotificationName(message.networkType, message.responseType);
        [self notifyMessage:message];
    }
    [messageLock lock];
    if (message.identifier.length > 0) {
        NSString *identifier = [NSString stringWithFormat:@"pt%@",message.identifier];
        if ([self.messagePool objectForKey:identifier]) {
            [self.messagePool removeObjectForKey:identifier];
        }
    }
    [messageLock unlock];
}

- (void)notifyMessage:(ICXBaseMessage *)message {
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(_notifyMessage:) object:message];
    [self.messageReceiveQueue addOperation:operation];
}

- (void)notifySerialMessage:(ICXBaseMessage *)message {
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(_notifyMessage:) object:message];
    [self.serialMessageReceiveQueue addOperation:operation];
}

// 广播消息
- (void)_notifyMessage:(ICXBaseMessage *)message {
    
    if (!message.notificationName) {
        return;
    }
    
    [observerLock lock];
    
    NSArray *array = [self.messageObservers objectForKey:message.notificationName];
    
    if (array.count > 0) {
        NSArray *tempArray = [NSArray arrayWithArray:array];
        for (ICXModelObserver *observer in tempArray) {
            
            ICXModel *model = observer.model;
            
            if (message.responder == model || !model) {
                // 排除发起model
                continue;
            }
            
            if ([message isKindOfClass:[ICXMessage class]]) {
                [model performSelectorInBackground:@selector(receiveMessage:) withObject:(ICXMessage *)message];
            } else if ([message isKindOfClass:[ICXDataMessage class]]) {
                [model performSelectorInBackground:@selector(receiveDataMessage:) withObject:(ICXDataMessage *)message];
            } else if ([message isKindOfClass:[ICXNotifyMessage class]]) {
                [model performSelectorInBackground:@selector(receiveNotifyMessage:) withObject:(ICXNotifyMessage *)message];
            }
        }
    }
    
    [observerLock unlock];
    
}

- (void)receiveMessageWithType:(ICXNetworkType)networkType subType:(ICXResponseType)responseType respondData:(NSDictionary *)respondData {
    NSString *identifier = [respondData stringForKey:ICX_UniqueIdentifier];
    
    ICXMessage *message = nil;
    if (identifier.length > 0) {
        message = [self messageWithIdentifier:identifier];
    }
    
    // 底层返回上来的时候判断这个属性，如果是YES则直接删除该消息，不往Model层抛消息。
    if (message.isCancel) {
        [[ICXMessageInterface sharedInterface] removeMessage:message];
        return;
    }
    
//    if (responseType != HTResponseTypeDisconnectSocket && responseType != HTResponseTypePing) {
//        if (![message isKindOfClass:[ICXMessage class]]) {
//            if (message) {
//                HTDDLogError(@"接收协议消息类型错误! 消息传入为:%@! responseType : %i respondData : %@ ", message, responseType, respondData);
//                return;
//            }
//        }
//    }
    
    if (message) {
        // 主动消息
        message.resultCode = [respondData intForKey:ICX_ReturnValue];
        message.responseData = respondData;
        message.responseType = responseType;
        message.responded = YES;
        
        [self receiveMessage:message];
        
//        if (message.resultCode == HTRtValueTypeSessionInvalid) {
//            // SessionId失效
//            DDLogError(@"sessionid 失效,responseType=%d", message.responseType);
//            ICXMessage *errorMessage = [[ICXMessage alloc] initWithNotificationName:MessageNotificationName(networkType, HTResponseTypeSessionIdInvalid)];
//            errorMessage.priority = NSOperationQueuePriorityVeryHigh;
//            [self notifyMessage:errorMessage];
//        } else {
//            if (IS_SPECIAL_ERROR_CODE(message.resultCode)) {
//                // 其他特殊错误码
//                ICXMessage *errorMessage = [[ICXMessage alloc] initWithNotificationName:MessageNotificationName(networkType, responseType)];
//                [self notifyMessage:errorMessage];
//            }
//            
//            [self receiveMessage:message];
//        }
        
    } else {
        // 被动消息
        message = [[ICXMessage alloc] initWithNotificationName:MessageNotificationName(networkType, responseType)];
        message.networkType = networkType;
        message.responseType = responseType;
        message.responseData = respondData;
        message.priority = NSOperationQueuePriorityNormal;
        message.needNotify = YES;
        if ([self isDatabaseInitFinished]) {
            [self notifyMessage:message];
        } else {
            [self performSelectorOnMainThread:@selector(delayHandleMessage:) withObject:message afterDelay:3.0];
        }
    }
}

- (void)dispatchMessageWithType:(ICXNetworkType)networkType subType:(ICXResponseType)responseType respondData:(NSDictionary *)respondData
{
    ICXMessage *message = [[ICXMessage alloc] initWithNotificationName:MessageNotificationName(networkType, responseType)];
    message.networkType = networkType;
    message.responseType = responseType;
    message.responseData = respondData;
    message.priority = NSOperationQueuePriorityNormal;
    message.needNotify = YES;
    if ([self isDatabaseInitFinished]) {
        [self notifyMessage:message];
    } else {
        [self performSelectorOnMainThread:@selector(delayHandleMessage:) withObject:message afterDelay:3.0];
    }
}

- (void)dispatchSerialMessageWithType:(ICXNetworkType)networkType subType:(ICXResponseType)responseType respondData:(NSDictionary *)respondData
{
    ICXMessage *message = [[ICXMessage alloc] initWithNotificationName:MessageNotificationName(networkType, responseType)];
    message.networkType = networkType;
    message.responseType = responseType;
    message.responseData = respondData;
    message.priority = NSOperationQueuePriorityNormal;
    message.needNotify = YES;
    if ([self isDatabaseInitFinished]) {
        [self notifySerialMessage:message];
    } else {
        [self performSelectorOnMainThread:@selector(delayHandleSerialMessage:) withObject:message afterDelay:3.0];
    }
}

- (void)socketDidDisconnectWithError:(NSError *)error andUniqueIdentifier:(NSString *)identifier {
    
    ICXMessage *message = nil;
    
    if (identifier.length > 0) {
        message = [self messageWithIdentifier:identifier];
    }
    
//    if (!message) {
//        message = [[ICXMessage alloc] initWithNotificationName:MessageNotificationName(HTNetworkTypeTcp, HTResponseTypeDisconnect)];
//        message.networkType = ICXNetworkTypeTcp;
//        message.responseType = HTResponseTypeDisconnect;
//        message.priority = NSOperationQueuePriorityVeryHigh;
//        message.needNotify = YES;
//        [self notifyMessage:message];
//    }
}

- (BOOL)isDatabaseInitFinished {
//    return [[HTMessageInterface sharedInterface] databaseInitFinished];
    return YES;
}

//// 数据库初始化完成
//- (void)databaseInitFinished:(BOOL)success {
//
//}

#pragma mark - Data Message


- (void)executeFinishWithDataMessage:(ICXDataMessage *)message {

    [self receiveDataMessage:message];

}


- (void)sendDataMessage:(ICXDataMessage *)message {
    [self setDataMessageToPool:message];
    ICXDataMessageOperation *operation = [[ICXDataMessageOperation alloc] initWithMessage:message];
    operation.responded = NO;
    [self.dataMessageSendQueue addOperation:operation];

}

- (void)sendSyncDataMessage:(ICXDataMessage *)message {
    [[ICXMessageInterface sharedInterface] sendDataMessageToDatabaseLayer:message];
    if (message.needNotify) {
        message.notificationName = DataMessageNotificationName(message.databaseType, message.logicType);
        [self notifyMessage:message];
    }
}


- (void)setDataMessageToPool:(ICXDataMessage *)message {
    // 防止messageId重复
    [messageLock lock];
    NSString *identifier = [NSString stringWithFormat:@"db%@",message.identifier];

    while(message.identifier.length <= 0 || [self.messagePool objectForKey:identifier]) {
        message.identifier = [ICXFunction uniqueMessageID];
        identifier = [NSString stringWithFormat:@"db%@",message.identifier];
    }

    [self.messagePool setObject:message forKey:identifier];
    [messageLock unlock];
}

- (ICXDataMessage *)dataMessageWithIdentifier:(NSString *)identifier {
    [messageLock lock];
    ICXDataMessage *dataMessage = [self.messagePool objectForKey:[NSString stringWithFormat:@"db%@",identifier]];
    [messageLock unlock];

    return dataMessage;
}


- (void)receiveDataMessage:(ICXDataMessage *)message {

    if (![message isKindOfClass:[ICXDataMessage class]]) {
        NSLog(@"接收数据库消息类型错误! 消息传入为:%@",message);
        return;
    }

    ICXDataMessageOperation *operation = [[ICXDataMessageOperation alloc] initWithMessage:message];
    operation.responded = YES;
    [self.dataMessageReceiveQueue addOperation:operation];
    NSLog(@"====data operation receiveDataMessage: %@====", message.identifier);
}

- (void)removeDataMessage:(ICXDataMessage *)message {

    // 需要广播的消息
    if (message.needNotify) {
        message.notificationName = DataMessageNotificationName(message.databaseType, message.logicType);
        [self notifyMessage:message];
    }

    [messageLock lock];
    if (message.identifier.length > 0) {
        NSString *identifier = [NSString stringWithFormat:@"db%@",message.identifier];

        if ([self.messagePool objectForKey:identifier]) {
            [self.messagePool removeObjectForKey:identifier];
        }
    }
    [messageLock unlock];
}


#pragma mark - Notify Message
- (void)sendNotifyMessage:(ICXNotifyMessage *)message {
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(_notifyMessage:) object:message];
    [self.messageSendQueue addOperation:operation];
}

- (void)reset {
    [observerLock lock];
    [self.messageObservers removeAllObjects];
    [observerLock unlock];
    
    [messageLock lock];
    [self.messagePool removeAllObjects];
    [messageLock unlock];
    
    [_messageSendQueue cancelAllOperations];
    [_messageReceiveQueue cancelAllOperations];
    [_serialMessageSendQueue cancelAllOperations];
    [_serialMessageReceiveQueue cancelAllOperations];
    [_serialMessagePullQueue cancelAllOperations];
    
    [_dataMessageSendQueue cancelAllOperations];
    [_dataMessageReceiveQueue cancelAllOperations];
}

@end
