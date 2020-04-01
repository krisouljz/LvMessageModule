//
//  ICXMessage.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXMessage.h"
#import "ICXFunction.h"

@implementation ICXMessage

- (id)init {
    self = [super init];
    
    if (self) {
        self.responded = NO;
        self.resultCode = -1;
    }
    
    return self;
}

- (id)initWithResponder:(id)responder {
    self = [super initWithResponder:responder];
    
    if (self) {
        self.responded = NO;
        self.resultCode = -1;
    }
    
    return self;
}

- (id)initWithNotificationName:(NSString *)notificationName {
    self = [super initWithNotificationName:notificationName];
    
    if (self) {
        self.responded = YES;
        self.identifier = [ICXFunction uniqueMessageID];
    }
    
    return self;
}

- (BOOL)succeed {
    return (self.resultCode == ICXReturnValueTypeSuccess) ? YES : NO;
}

- (void)setResponded:(BOOL)responded {
    if (self.sync) {
        [self performSelectorOnMainThread:@selector(setRunloopResponded:) withObject:@(responded) waitUntilDone:YES];
    } else {
        _responded = responded;
    }
}

@end
