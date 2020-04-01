//
//  ICXInterfaceManagement.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICXCentralManagement.h"
#import "ICXLogicType.h"

@protocol ICXInterfaceManagementDelegate <NSObject>
@optional
- (void)socketDidDisconnectWithError:(NSError *)err andUniqueIdentifier:(NSString *)uniqueIdentifier;
- (void)receiveResponseType:(ICXNetworkType)type andSubType:(ICXResponseType)subType andData:(NSDictionary *)responseData;
@end

@interface ICXInterfaceManagement : NSObject<ICXCentralManagementDelegate> {
    ICXCentralManagement *htCentralManagement;
}

@property(nonatomic, weak) id<ICXInterfaceManagementDelegate> interfaceManagementDelegate;

+ (ICXInterfaceManagement *)getInstance;

- (void)sendRequestType:(ICXNetworkType)type andSubType:(ICXRequestType)subType andData:(NSDictionary *)requestData;
//- (void)receiveResponseType:(ICXNetworkType)type andSubType:(ICXRequestType)subType andData:(NSDictionary *)responseData;

@end
