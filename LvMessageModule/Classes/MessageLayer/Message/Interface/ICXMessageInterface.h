//
//  ICXMessageInterface.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICXSingleton.h"
#import "ICXInterfaceManagement.h"
//#import "ICXDatabaseDelegate.h"

@class ICXModel;
@class ICXMessage;
@class ICXDataMessage;
@class ICXNotifyMessage;

@protocol ICXMessageInterfaceDelegate <NSObject>

@required

- (void)receiveMessageWithType:(ICXNetworkType)type subType:(ICXResponseType)subType respondData:(NSDictionary *)responseData;
- (void)socketDidDisconnectWithError:(NSError *)error andUniqueIdentifier:(NSString *)uniqueIdentifier;
- (void)executeFinishWithDataMessage:(ICXDataMessage *)message;

@end

@interface ICXMessageInterface : NSObject<ICXInterfaceManagementDelegate>

@property (nonatomic,weak) id<ICXMessageInterfaceDelegate> delegate;

ICX_AS_SINGLETON(ICXMessageInterface, sharedInterface)

- (void)sendMessage:(ICXMessage *)message;
- (void)sendSyncMessage:(ICXMessage *)message;
- (void)removeMessage:(ICXMessage *)message;

- (void)sendDataMessage:(ICXDataMessage *)message;
- (void)sendSyncDataMessage:(ICXDataMessage *)message;
- (void)removeDataMessage:(ICXDataMessage *)message;

- (void)addObserver:(ICXModel *)model name:(NSString *)notificationName;
- (void)removeObserver:(ICXModel *)model;

- (void)sendMessageToPotocolLayer:(ICXMessage *)message;
- (void)sendDataMessageToDatabaseLayer:(ICXDataMessage *)message;
- (void)sendNotifyMessage:(ICXNotifyMessage *)message;

- (void)sendMessageToModelLayer:(ICXMessage *)message;
- (void)sendDataMessageToModelLayer:(ICXDataMessage *)message;

- (void)executeFinishWithDataMessage:(ICXDataMessage *)message;

@end
