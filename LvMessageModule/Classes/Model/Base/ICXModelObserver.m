//
//  ICXModelObserver.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXModelObserver.h"

@implementation ICXModelObserver

- (id)initWithModel:(ICXModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

@end
