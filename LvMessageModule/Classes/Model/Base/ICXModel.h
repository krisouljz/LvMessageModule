//
//  ICXModel.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICXMessage.h"
#import "ICXDataMessage.h"
#import "ICXNotifyMessage.h"
#import "ICXMacros.h"
#import "ICXMessageInterface.h"

@interface ICXModel : NSObject

@property (nonatomic, weak) id responder;

- (id)initWithResponder:(id)responder;
- (void)sendMessage:(ICXMessage *)message;
- (void)receiveMessage:(ICXMessage *)message;

- (void)sendDataMessage:(ICXDataMessage *)message;
- (void)receiveDataMessage:(ICXDataMessage *)message;

- (void)sendNotifyMessage:(ICXNotifyMessage *)message;
- (void)receiveNotifyMessage:(ICXNotifyMessage *)message;

- (void)respondMessageOnMainThread:(ICXBaseMessage *)message;

@end
