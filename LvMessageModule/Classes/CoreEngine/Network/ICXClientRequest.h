//
//  ICXClientRequest.h
//  Meum
//
//  Created by krisouljz on 2018/4/28.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICXPacketHeader.h"

@interface ICXClientRequest : ICXPacketHeader

@property (nonatomic, assign) float timeoutInterval;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) BOOL isSended;
@property (nonatomic, assign) BOOL dontCache;
@property (nonatomic, strong) NSString *uniqueIdentifier;
@property (nonatomic, strong) NSDictionary *dataDictionary;
@property (nonatomic, assign) int requestType;
@property (nonatomic, assign) BOOL isSpecialCMD;                // 登录、重连、状态报告等

- (NSData*)getBodyData;

@end
