//
//  ICXMessage.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXBaseMessage.h"
#import "ICXLogicType.h"

@interface ICXMessage : ICXBaseMessage

@property (nonatomic, assign) ICXNetworkType         networkType;
@property (nonatomic, assign) ICXRequestType         requestType;
@property (nonatomic, strong) NSMutableDictionary    *requestData;

@property (nonatomic) NSInteger             resultCode;
@property (nonatomic) ICXResponseType        responseType;
@property (nonatomic, strong) NSDictionary  *responseData;

// 已从服务器返回数据
@property (nonatomic) BOOL responded;
// 是否离线消息
@property (nonatomic) BOOL isOffline;

@end
