//
//  ICXHttpProcessingCenter.h
//  ICXCommercialPR
//
//  Created by krisouljz on 2018/3/19.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICXLogicType.h"
#import "ICXSingleton.h"
#import "ICXRequest.h"

@protocol ICXHttpProcessingCenterDelegate <NSObject>

- (void)httpRequestFinished:(NSDictionary *)theDictionary;
- (void)httpRequestFailed:(NSDictionary *)theDictionary;

@end


@interface ICXHttpProcessingCenter : NSObject

ICX_AS_SINGLETON(ICXHttpProcessingCenter, defaultCenter)

@property (nonatomic, weak) id<ICXHttpProcessingCenterDelegate> icxHttpDelegate;

- (void)sendGetRequestType:(ICXRequestType)requestType params:(NSDictionary *)params;
- (void)sendPostRequestType:(ICXRequestType)requestType params:(NSDictionary *)params;

@end
