//
//  ICXDataMessage.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXDataMessage.h"

@implementation ICXDataMessage

- (instancetype)initWithLogicType:(ICXDatabaseLogicType)logicType {
    self = [super init];
    if (self) {
        _logicType = logicType;
    }
    
    return self;
}

@end
