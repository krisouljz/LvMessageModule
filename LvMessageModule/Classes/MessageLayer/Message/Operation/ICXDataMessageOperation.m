//
//  ICXDataMessageOperation.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXDataMessageOperation.h"
#import "ICXDataMessage.h"
#import "ICXMessageInterface.h"

@interface ICXDataMessageOperation ()

@property (nonatomic, strong) ICXDataMessage *message;

@end

@implementation ICXDataMessageOperation

- (id)initWithMessage:(ICXDataMessage *)message {
    self = [super init];
    
    if (self) {
        self.message = message;
        self.queuePriority = message.priority;
    }
    
    return self;
}

- (void)main {
    if (!self.responded) {
        NSLog(@"====data operation send: %@====", self.message.identifier);
        [[ICXMessageInterface sharedInterface] sendDataMessageToDatabaseLayer:self.message];
    } else {
        NSLog(@"====data operation receive: %@====", self.message.identifier);
        [[ICXMessageInterface sharedInterface] sendDataMessageToModelLayer:self.message];
    }
}

- (BOOL)isConcurrent {
    return YES;
}

@end
