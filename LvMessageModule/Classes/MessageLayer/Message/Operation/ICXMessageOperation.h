//
//  ICXMessageOperation.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICXMessage;

@interface ICXMessageOperation : NSOperation

@property (nonatomic) BOOL responded;

- (id)initWithMessage:(ICXMessage *)message;

@end
