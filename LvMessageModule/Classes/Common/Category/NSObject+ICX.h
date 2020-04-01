//
//  NSObject+ICX.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ICX)

- (void)addNotificationWithName:(NSString *)name selector:(SEL)selector;
- (void)removeObserverWithNotificationName:(NSString *)name;

- (void)performBlockInBackground:(dispatch_block_t)block;
- (void)performBlockOnMainThread:(dispatch_block_t)block isSync:(BOOL)isSync;
- (void)performBlock:(dispatch_block_t)block afterDelay:(NSTimeInterval)delay;

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object afterDelay:(NSTimeInterval)delay;
- (void)customPerformSelectorOnMainThread:(SEL)selector withObject:(id)object waitUntilDone:(BOOL)wait;

@end
