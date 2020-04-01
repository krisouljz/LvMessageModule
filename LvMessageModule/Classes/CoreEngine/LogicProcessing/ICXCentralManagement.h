//
//  ICXCentralManagement.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICXLogicType.h"
#import "ICXClientRequest.h"
#import "ICXClientResponse.h"

@protocol ICXCentralManagementDelegate <NSObject>
- (void)socketDidDisconnectWithError:(NSError *)err andUniqueIdentifier:(NSString *)uniqueIdentifier;
- (void)receiveResponseType:(ICXNetworkType)type andSubType:(ICXResponseType)subType andData:(NSDictionary *)responseData;
@end

@interface ICXCentralManagement : NSObject

@property(nonatomic, weak) id<ICXCentralManagementDelegate> centralManagementDelegate;

+ (ICXCentralManagement *)getInstance;

- (void)sendRequestType:(ICXNetworkType)type andSubType:(ICXRequestType)subType andData:(NSDictionary *)requestData;
//- (void)handleHttpData:(NSDictionary *)responseDic type:(ICXRequestType)type reqData:(NSDictionary *)dict;
- (void)socketReceiveResponse:(ICXClientResponse*)response request:(ICXClientRequest*)theRequest;
- (void)socketDidFailWithError:(ICXReturnValueType)errType request:(ICXClientRequest*)theRequest;

@end
