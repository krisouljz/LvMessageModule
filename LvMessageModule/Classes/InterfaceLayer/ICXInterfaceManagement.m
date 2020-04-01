//
//  ICXInterfaceManagement.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXInterfaceManagement.h"

@implementation ICXInterfaceManagement

static ICXInterfaceManagement* kHTInterfaceManagement = nil;

+ (ICXInterfaceManagement *)getInstance
{
    if (kHTInterfaceManagement == nil) {
        kHTInterfaceManagement = [[ICXInterfaceManagement alloc] init];
    }
    return kHTInterfaceManagement;
}

- (id)init
{
    if (!htCentralManagement) {
        htCentralManagement = [ICXCentralManagement getInstance];
        htCentralManagement.centralManagementDelegate = self;
    }
    return self;
}

- (void)sendRequestType:(ICXNetworkType)type andSubType:(ICXRequestType)subType andData:(NSDictionary *)requestData
{
    if (htCentralManagement) {
        [htCentralManagement sendRequestType:type andSubType:subType andData:requestData];
    }
}

#pragma mark - ICXCentralManagementDelegate 
- (void)socketDidDisconnectWithError:(NSError *)err andUniqueIdentifier:(NSString *)uniqueIdentifier
{
    if ([_interfaceManagementDelegate respondsToSelector:@selector(socketDidDisconnectWithError:andUniqueIdentifier:)]) {
        [_interfaceManagementDelegate socketDidDisconnectWithError:err andUniqueIdentifier:uniqueIdentifier];
    }
}
- (void)receiveResponseType:(ICXNetworkType)type andSubType:(ICXResponseType)subType andData:(NSDictionary *)responseData
{
    if ([_interfaceManagementDelegate respondsToSelector:@selector(receiveResponseType:andSubType:andData:)]) {
        [_interfaceManagementDelegate receiveResponseType:type andSubType:subType andData:responseData];
    }
}

@end
