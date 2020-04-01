//
//  ICXBusinessBase.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICXBusinessBase : NSObject

@property (nonatomic, strong) NSString *uniqueIdentifier;
@property (nonatomic, assign) UInt32 myUserId;

- (id)initWithUniqueIdentifier:(NSString *)uniqueIdentifier andMyUserId:(UInt32)myUserId;

@end
