//
//  ICXNotifyMessage.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXNotifyMessage.h"
#import "ICXMacros.h"

@implementation ICXNotifyMessage

+ (ICXNotifyMessage *)messageWithType:(ICXNotifyType)type {
    ICXNotifyMessage *message = [[ICXNotifyMessage alloc] init];
    message.notificationName = NotifyMeesageNotificationName(type);
    message.type = type;
    message.priority = NSOperationQueuePriorityHigh;
    return message;
}

+ (ICXNotifyMessage *)messageWithType:(ICXNotifyType)type data:(NSMutableDictionary *)data {
    ICXNotifyMessage *message = [[ICXNotifyMessage alloc] init];
    message.type = type;
    message.notificationName = NotifyMeesageNotificationName(type);
    message.customData = data;
    message.priority = NSOperationQueuePriorityHigh;
    return message;
}

@end
