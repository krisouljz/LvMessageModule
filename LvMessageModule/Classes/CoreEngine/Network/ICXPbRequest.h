//
//  ICXPbRequest.h
//  Meum
//
//  Created by krisouljz on 2018/4/28.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#import "ICXClientRequest.h"

@interface ICXPbRequest : ICXClientRequest

// 业务类型的请求
- (id)initWithType:(int)type andAppId:(SInt16)appId andCmd:(UInt16)cmd andData:(NSData *)data andUniqueIdentifier:(NSString *)uniqueIdentifier;

// 鉴权，心跳的请求
- (id)initWithCmd:(UInt16)cmd andAppId:(SInt16)appId andPbData:(NSData *)pbData;

@end


