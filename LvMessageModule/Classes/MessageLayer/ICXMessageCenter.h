//
//  ICXMessageCenter.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICXSingleton.h"

@class ICXModel;
@class ICXMessage;
@class ICXDataMessage;
@class ICXNotifyMessage;

@interface ICXMessageCenter : NSObject

ICX_AS_SINGLETON(ICXMessageCenter, defaultCenter)

- (void)sendMessage:(ICXMessage *)message;
- (void)removeMessage:(ICXMessage *)message;

- (void)sendDataMessage:(ICXDataMessage *)message;
- (void)removeDataMessage:(ICXDataMessage *)message;

- (void)sendSyncMessage:(ICXMessage *)message;
- (void)sendSyncDataMessage:(ICXDataMessage *)message;

- (void)addObserver:(ICXModel *)model name:(NSString *)notificationName;
- (void)removeObserver:(ICXModel *)model;

- (void)sendNotifyMessage:(ICXNotifyMessage *)message;

@end
