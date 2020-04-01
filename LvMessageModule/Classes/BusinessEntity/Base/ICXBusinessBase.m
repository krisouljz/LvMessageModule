//
//  ICXBusinessBase.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXBusinessBase.h"

@implementation ICXBusinessBase

- (id)initWithUniqueIdentifier:(NSString *)uniqueIdentifier andMyUserId:(UInt32)myUserId
{
    if (self = [super init]) {
        self.uniqueIdentifier = uniqueIdentifier;
        self.myUserId = myUserId;
    }
    return self;
}

@end
