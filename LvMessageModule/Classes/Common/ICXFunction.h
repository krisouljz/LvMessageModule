//
//  ICXFunction.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICXCmdConfig.h"

@interface ICXFunction : NSObject

+ (NSString *)uniqueMessageID;
+ (BOOL)isPureNumber:(NSString *)string;
+ (NSString *)cmdFromHexCmd:(UInt16)hexCmd;

+ (NSString *)transformedDate:(NSDate*)date format:(NSInteger)formatType;

@end
