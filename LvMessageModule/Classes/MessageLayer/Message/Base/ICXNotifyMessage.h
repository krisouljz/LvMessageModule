//
//  ICXNotifyMessage.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXBaseMessage.h"
#import "ICXNotifyType.h"

@interface ICXNotifyMessage : ICXBaseMessage

@property (nonatomic) ICXNotifyType type;

+ (ICXNotifyMessage *)messageWithType:(ICXNotifyType)type;
+ (ICXNotifyMessage *)messageWithType:(ICXNotifyType)type data:(NSMutableDictionary *)data;

@end
