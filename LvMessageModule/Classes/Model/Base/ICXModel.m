//
//  ICXModel.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXModel.h"
#import "ICXMessageInterface.h"

@implementation ICXModel

- (id)initWithResponder:(id)responder {
    self = [super init];
    
    if (self) {
        self.responder = responder;
    }
    
    return self;
}

- (void)sendMessage:(ICXMessage *)message {
    if (!message.responder) {
        message.responder = self;
    }
    
    //    if (![message.reqeustData objectForKey:HT_ProtocolData]) {
    //        [message.reqeustData setObject:[NSMutableArray array] forKey:HT_ProtocolData];
    //    }
    
    if (message.sync) {
        [[ICXMessageInterface sharedInterface] sendSyncMessage:message];
    } else {
        [[ICXMessageInterface sharedInterface] sendMessage:message];
    }
    
}

- (void)receiveMessage:(ICXMessage *)message {
    // 子类继承此方法
    
}

- (void)sendDataMessage:(ICXDataMessage *)message {
    if (!message.responder) {
        message.responder = self;
    }
    // 默认都直接调用wcdb，不走operation queue
    if (message.sync) {
        [[ICXMessageInterface sharedInterface] sendSyncDataMessage:message];
    } else {
        [[ICXMessageInterface sharedInterface] sendDataMessage:message];
    }

    
}

- (void)receiveDataMessage:(ICXDataMessage *)message {
    // 子类继承此方法
}


- (void)sendNotifyMessage:(ICXNotifyMessage *)message {
    if (!message.responder) {
        message.responder = self;
    }
    [[ICXMessageInterface sharedInterface] sendNotifyMessage:message];
}

- (void)receiveNotifyMessage:(ICXNotifyMessage *)message {
    // 子类继承此方法
}


- (void)respondMessageOnMainThread:(ICXBaseMessage *)message {
    
    if (!self.responder) {
        return;
    }
    
    if ([message isKindOfClass:[ICXMessage class]]) {
        if ([self.responder respondsToSelector:@selector(receiveMessage:)]) {
            if ([NSThread isMainThread]) {
                [self.responder receiveMessage:(ICXMessage *)message];
            } else {
                [self.responder performSelectorOnMainThread:@selector(receiveMessage:) withObject:message waitUntilDone:NO];
            }
            
        }
    } else if ([message isKindOfClass:[ICXDataMessage class]]) {
        if ([self.responder respondsToSelector:@selector(receiveDataMessage:)]) {
            if ([NSThread isMainThread]) {
                [self.responder receiveDataMessage:(ICXDataMessage *)message];
            } else {
                [self.responder performSelectorOnMainThread:@selector(receiveDataMessage:) withObject:message waitUntilDone:NO];
            }
        }
    } else if ([message isKindOfClass:[ICXNotifyMessage class]]) {
        if ([self.responder respondsToSelector:@selector(receiveNotifyMessage:)]) {
            if ([NSThread isMainThread]) {
                [self.responder receiveNotifyMessage:(ICXNotifyMessage *)message];
            } else {
                [self.responder performSelectorOnMainThread:@selector(receiveNotifyMessage:) withObject:message waitUntilDone:NO];
            }
        }
    }
    
}

@end
