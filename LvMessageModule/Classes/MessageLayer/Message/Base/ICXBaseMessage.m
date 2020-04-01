//
//  ICXBaseMessage.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXBaseMessage.h"
#import "ICXFunction.h"

@implementation ICXBaseMessage

- (id)init {
    self = [super init];
    
    if (self) {
        self.cache = YES;
        self.identifier = [ICXFunction uniqueMessageID];
        self.priority = NSOperationQueuePriorityNormal;
        self.needNotify = NO;
    }
    
    return self;
}

- (id)initWithResponder:(id)responder {
    self = [super init];
    
    if (self) {
        self.cache = YES;
        self.responder = responder;
        self.identifier = [ICXFunction uniqueMessageID];
        self.priority = NSOperationQueuePriorityNormal;
        self.needNotify = NO;
    }
    
    return self;
}

- (id)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    
    if (self) {
        self.cache = YES;
        self.identifier = identifier;
        self.priority = NSOperationQueuePriorityNormal;
        self.needNotify = NO;
    }
    
    return self;
}

- (id)initWithNotificationName:(NSString *)notificationName {
    self = [super init];
    
    if (self) {
        self.cache = YES;
        self.notificationName = notificationName;
        self.priority = NSOperationQueuePriorityNormal;
        self.needNotify = YES;
    }
    
    return self;
}

@end
