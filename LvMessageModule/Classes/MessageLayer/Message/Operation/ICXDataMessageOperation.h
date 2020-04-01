//
//  ICXDataMessageOperation.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICXDataMessage;

@interface ICXDataMessageOperation : NSOperation

@property (nonatomic) BOOL responded;

- (id)initWithMessage:(ICXDataMessage *)message;

@end
