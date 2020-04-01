//
//  ICXMessageInterface.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXMessageInterface.h"
#import "ICXModel.h"
#import "ICXMessage.h"
#import "ICXDataMessage.h"
#import "ICXNotifyMessage.h"
#import "ICXMessageCenter.h"
#import "ICXInterfaceManagement.h"
//#import "ICXDatabaseCenter.h"

@implementation ICXMessageInterface

ICX_DEF_SINGLETON(ICXMessageInterface, sharedInterface)

- (id)init {
    self = [super init];
    
    if (self) {
        [[ICXInterfaceManagement getInstance] setInterfaceManagementDelegate:self];
//        [[ICXDatabaseCenter defaultCenter] setDatabaseDelegate:self];
        [[NSClassFromString(@"ICXDatabaseCenter") performSelector:@selector(defaultCenter)] performSelector:@selector(setDatabaseDelegate:) withObject:self];
    }
    
    return self;
}

#pragma mark - 上层接口

- (void)sendMessage:(ICXMessage *)message {
    [[ICXMessageCenter defaultCenter] sendMessage:message];
}

- (void)sendSyncMessage:(ICXMessage *)message {
    [[ICXMessageCenter defaultCenter] sendSyncMessage:message];
}

- (void)removeMessage:(ICXMessage *)message {
    [[ICXMessageCenter defaultCenter] removeMessage:message];
}

- (void)sendDataMessage:(ICXDataMessage *)message {
    [[ICXMessageCenter defaultCenter] sendDataMessage:message];
}

- (void)sendSyncDataMessage:(ICXDataMessage *)message {
    [[ICXMessageCenter defaultCenter] sendSyncDataMessage:message];
}

- (void)removeDataMessage:(ICXDataMessage *)message {
    [[ICXMessageCenter defaultCenter] removeDataMessage:message];
}

- (void)addObserver:(ICXModel *)model name:(NSString *)notificationName {
    [[ICXMessageCenter defaultCenter] addObserver:model name:notificationName];
}

- (void)removeObserver:(ICXModel *)model {
    [[ICXMessageCenter defaultCenter] removeObserver:model];
}

- (void)sendMessageToModelLayer:(ICXMessage *)message {
    ICXModel *model = message.responder;
    if ([model isKindOfClass:[ICXModel class]]) {
        [model receiveMessage:message];
    } else if ([model respondsToSelector:@selector(receiveMessage:)]) {
        [model performSelector:@selector(receiveMessage:) withObject:message];
    }
    
    [self removeMessage:message];
}

- (void)sendDataMessageToModelLayer:(ICXDataMessage *)message {
    ICXModel *model = message.responder;
    [model receiveDataMessage:message];
    [self removeDataMessage:message];
}

- (void)sendNotifyMessage:(ICXNotifyMessage *)message {
    [[ICXMessageCenter defaultCenter] sendNotifyMessage:message];
}


#pragma mark - 底层接口

- (void)sendMessageToPotocolLayer:(ICXMessage *)message {
    [[ICXInterfaceManagement getInstance] sendRequestType:message.networkType andSubType:message.requestType andData:message.requestData];
}

- (void)sendDataMessageToDatabaseLayer:(ICXDataMessage *)message {
    
//    [[ICXDatabaseCenter defaultCenter] executeDataMessage:message];
   [[NSClassFromString(@"ICXDatabaseCenter") performSelector:@selector(defaultCenter)] performSelector:@selector(executeDataMessage:) withObject:message];
    
}

- (void)receiveResponseType:(ICXNetworkType)type andSubType:(ICXResponseType)subType andData:(NSDictionary *)responseData {
    
    [self.delegate receiveMessageWithType:type subType:subType respondData:responseData];
    
}

- (void)socketDidDisconnectWithError:(NSError *)error andUniqueIdentifier:(NSString *)uniqueIdentifier {
    [self.delegate socketDidDisconnectWithError:error andUniqueIdentifier:uniqueIdentifier];
}


- (void)executeFinishWithDataMessage:(ICXDataMessage *)message {
    [self.delegate executeFinishWithDataMessage:message];
}


@end
