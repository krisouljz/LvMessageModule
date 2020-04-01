//
//  ICXSocketProcessingCenter.h
//  ICXHealthBuddy
//
//  Created by krisouljz on 2019/7/31.
//  Copyright © 2019年 lvjiazhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICXClientRequest,ICXClientResponse;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ICXSocketConnectStatus) {
    ICXSocketConnectStatusConnecting = 1,       //正在连接中
    ICXSocketConnectStatusConnected,            //已经连接
    ICXSocketConnectStatusDisConnect,           //断开连接
};

@interface ICXSocketProcessingCenter : NSObject

+ (instancetype)sharedInstance;

@property(assign,nonatomic) ICXSocketConnectStatus connectStatus;// 连接状态
@property(strong,nonatomic) dispatch_block_t pullMessageBlock; // 拉消息的block

// 连接socket
- (void)socketConnectToServerWithIP:(NSString*)ip port:(UInt16)port appKey:(NSString*)appkey appId:(SInt64)appId;

// 断开socket
- (void)socketDisconnect;

// 重连
- (void)reconnect;

// 发送请求
- (void)sendSocketRequest:(ICXClientRequest *)request withTimeout:(unsigned int)timeout;

// 获取appId,提供给ICXCenterManagerMent
- (SInt16)getAppId;

@end

NS_ASSUME_NONNULL_END


@interface NSObject (ICXSocketProcessingCenterDelegate)

- (void)onSocketProcessingCenter:(ICXSocketProcessingCenter*)sender request:(ICXClientRequest*)theRequest receiveResponse:(ICXClientResponse*)response;
- (void)onSocketProcessingCenter:(ICXSocketProcessingCenter*)sender request:(ICXClientRequest*)theRequest didFailWithError:(SInt16)errType;

@end


