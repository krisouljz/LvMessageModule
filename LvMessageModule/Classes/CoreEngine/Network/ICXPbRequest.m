//
//  ICXPbRequest.m
//  Meum
//
//  Created by krisouljz on 2018/4/28.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#import "ICXPbRequest.h"

@implementation ICXPbRequest
// 业务类型的请求
- (id)initWithType:(int)type andAppId:(SInt16)appId andCmd:(UInt16)cmd andData:(NSData *)data andUniqueIdentifier:(NSString *)uniqueIdentifier {
    if (self = [super initWithReqPbData:data cmd:cmd appId:appId])
    {
        self.startTime = [NSDate timeIntervalSinceReferenceDate];
        self.uniqueIdentifier = uniqueIdentifier;
        self.pbData = data;
        self.requestType = type;
    }
    return self;
}

// 鉴权，心跳的请求
- (id)initWithCmd:(UInt16)cmd andAppId:(SInt16)appId andPbData:(NSData *)pbData{
    if (self = [super initWithReqPbData:pbData cmd:cmd appId:appId])
    {
        self.startTime = [NSDate timeIntervalSinceReferenceDate];
        self.pbData = pbData;
        self.isSpecialCMD = YES;
    }
    return self;
}

- (NSData*)getBodyData {
    return self.pbData;
}

@end


