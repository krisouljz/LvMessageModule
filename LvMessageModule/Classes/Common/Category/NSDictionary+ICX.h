//
//  NSDictionary+ICX.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ICX)

- (id)idForKey:(id)key;
- (NSString *)stringForKey:(id)key;
- (BOOL)boolForKey:(id)key;
- (int)intForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (uint)uintForKey:(id)key;
- (double)doubleForKey:(id)key;
- (float)floatForKey:(id)key;
- (long long)longLongForKey:(id)key;
- (UInt32)uInt32ForKey:(id)key;
- (UInt64)uInt64ForKey:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSMutableArray *)mutableArrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (NSDictionary *)dictionForKey:(id)key;
- (NSMutableDictionary *)mutableDictionaryForKey:(id)key;

@end
