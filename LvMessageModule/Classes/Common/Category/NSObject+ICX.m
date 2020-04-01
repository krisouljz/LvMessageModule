//
//  NSObject+ICX.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "NSObject+ICX.h"

@implementation NSObject (ICX)

static NSOperationQueue *backgroundQueue;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        backgroundQueue = [[NSOperationQueue alloc] init];
        backgroundQueue.maxConcurrentOperationCount = 10;
    });
}

- (void)addNotificationWithName:(NSString *)name selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];
}

- (void)removeObserverWithNotificationName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)performBlockInBackground:(dispatch_block_t)block {
    [backgroundQueue addOperationWithBlock:block];
}

- (void)performBlockOnMainThread:(dispatch_block_t)block isSync:(BOOL)isSync {
    if ([NSThread isMainThread]) {
        block();
    } else {
        if (isSync) {
            dispatch_sync(dispatch_get_main_queue(),block);
        }
        else {
            dispatch_async(dispatch_get_main_queue(),block);
        }
    }
    
}

- (void)performBlock:(dispatch_block_t)block afterDelay:(double)delay {
    [self performSelector:@selector(performDelayBlock:) withObject:block afterDelay:delay];
}

- (void)performDelayBlock:(dispatch_block_t)block {
    block();
}

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object afterDelay:(NSTimeInterval)delay {
    if ([NSThread isMainThread]) {
        [self performSelector:selector withObject:object afterDelay:delay];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:selector withObject:object afterDelay:delay];
        });
    }
}

- (void)customPerformSelectorOnMainThread:(SEL)selector withObject:(id)object waitUntilDone:(BOOL)wait{
    if ([self respondsToSelector:selector]) {
        [self performSelectorOnMainThread:selector withObject:object waitUntilDone:wait];
    }
}

@end
