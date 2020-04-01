//
//  ICXModelObserver.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICXModel;

@interface ICXModelObserver : NSObject

@property (nonatomic, weak) ICXModel *model;

- (id)initWithModel:(ICXModel *)model;

@end
