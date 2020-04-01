//
//  ICXDataMessage.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXBaseMessage.h"
#import "ICXDatabaseLogicType.h"

@interface ICXDataMessage : ICXBaseMessage

@property (nonatomic) ICXDatabaseType databaseType;
//@property (nonatomic) ICXDatabaseOperationType operationType;
@property (nonatomic) ICXDatabaseLogicType logicType;
@property (nonatomic, strong) NSArray *resultSet;
@property (nonatomic) int retryTimes;

// 已经返回数据库执行结果
@property (nonatomic) BOOL responded;

- (instancetype)initWithLogicType:(ICXDatabaseLogicType)logicType;

@end
