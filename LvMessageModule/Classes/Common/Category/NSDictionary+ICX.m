//
//  NSDictionary+ICX.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "NSDictionary+ICX.h"

@implementation NSDictionary (ICX)

- (id)idForKey:(id)key {
    id object = [self objectForKey:key];
    if (object && ![object isKindOfClass:[NSNull class]]) {
        return object;
    }
    return nil;
}

- (NSString *)stringForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string;
        }
        
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.stringValue;
        }
    }
    
    return nil;
}


- (BOOL)boolForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.boolValue;
        }
        
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.boolValue;
        }
    }
    
    return NO;
}

- (int)intForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.intValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.intValue;
        }
    }
    
    return -1;
}

- (NSInteger)integerForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.integerValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.integerValue;
        }
    }
    
    return -1;
}

- (uint)uintForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.unsignedIntValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.intValue;
        }
    }
    
    return 0;
}

- (double)doubleForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.doubleValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.doubleValue;
        }
    }
    
    return -1.0;
}

- (float)floatForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.floatValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.floatValue;
        }
    }
    
    return -1.0f;
}

- (long long)longLongForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.longLongValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.longLongValue;
        }
    }
    
    return -1.0;
}

- (UInt32)uInt32ForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.unsignedIntValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.intValue;
        }
    }
    
    return 0;
}

- (UInt64)uInt64ForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.unsignedLongLongValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.longLongValue;
        }
    }
    
    return 0;
}

- (NSArray *)arrayForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && [object isKindOfClass:[NSArray class]]) {
        NSArray *array = object;
        return array;
    }
    
    return nil;
}

- (NSMutableArray *)mutableArrayForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && [object isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *array = object;
        return array;
    }else if (object && [object isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:object];
        return array;
    }
    
    return nil;
}

- (NSDictionary *)dictionaryForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = object;
        return dictionary;
    }
    
    return nil;
}

- (NSDictionary *)dictionForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = object;
        return dictionary;
    }
    
    return nil;
}

- (NSMutableDictionary *)mutableDictionaryForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && [object isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *dictionary = object;
        return dictionary;
    }else if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
        return dictionary;
    }
    
    return nil;
}

@end
