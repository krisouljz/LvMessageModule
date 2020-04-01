//
//  ICXMessageOperation.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXMessageOperation.h"
#import "ICXModel.h"
#import "ICXMessageInterface.h"

@interface ICXMessageOperation ()

@property (nonatomic, strong) ICXMessage *message;

@end

@implementation ICXMessageOperation

- (id)initWithMessage:(ICXMessage *)message {
    self = [super init];
    
    if (self) {
        self.message = message;
        self.queuePriority = message.priority;
    }
    
    return self;
}

- (void)main {
    if (!self.responded) {
        NSLog(@"==== **request operation send: %@====", self.message.identifier);
        [[ICXMessageInterface sharedInterface] sendMessageToPotocolLayer:self.message];
    } else {
        [[ICXMessageInterface sharedInterface] sendMessageToModelLayer:self.message];
        NSLog(@"==== **request operation receive: %@====", self.message.identifier);
    }
}

- (BOOL)isConcurrent {
    return YES;
}

@end
