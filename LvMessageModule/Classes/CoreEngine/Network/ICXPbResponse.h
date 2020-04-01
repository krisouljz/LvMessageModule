//
//  ICXPbResponse.h
//  Meum
//
//  Created by krisouljz on 2018/4/28.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#import "ICXClientResponse.h"

@interface ICXPbResponse : ICXClientResponse

/*
 * type:请求对应的类型
 * uniqueIdentifier:请求对应的uniqueIdentifierId
 * netData:服务器返回的“完整的”二进制包
 */
- (id)initWithType:(int)type uniqueIdentifier:(NSString *)uniqueIdentifier netData:(NSData*)netData;

@end
