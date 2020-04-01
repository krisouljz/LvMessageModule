//
//  ICXHttpProcessingCenter.m
//  ICXCommercialPR
//
//  Created by krisouljz on 2018/3/19.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#import "ICXHttpProcessingCenter.h"
#import "ICXFunction.h"
#import "ICXDefineKeyValues.h"

@implementation ICXHttpProcessingCenter

ICX_DEF_SINGLETON(ICXHttpProcessingCenter, defaultCenter)

- (void)sendGetRequestType:(ICXRequestType)requestType params:(NSDictionary *)params {
    NSString *url = [self urlForRequestType:requestType];
    [ICXRequest requestByGetWithURL:url params:params success:^(id responseObject) {
        [self httpRequestFinishedWithResponseObject:responseObject requestType:requestType params:params];
    } failed:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self httpRequestFailedWithRequestType:requestType params:params];
    }];
}

- (void)sendPostRequestType:(ICXRequestType)requestType params:(NSDictionary *)params {
    NSString *url = [self urlForRequestType:requestType];
    [ICXRequest requestByPostWithURL:url params:params success:^(id responseObject) {
        [self httpRequestFinishedWithResponseObject:responseObject requestType:requestType params:params];
    } failed:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self httpRequestFailedWithRequestType:requestType params:params];
    }];
}

- (void)httpRequestFinishedWithResponseObject:(id)responseObject requestType:(ICXRequestType)requestType params:(NSDictionary *)params {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
        NSString *statusStr = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"errorCode"]];
        int statusCode = ICXReturnValueTypeExceptionError;
        if (statusStr && [ICXFunction isPureNumber:statusStr]) {
            statusCode = [statusStr intValue];
        }
        dic[ICX_ReturnValue] = @(statusCode);
        dic[ICX_HttpRequestType] = @(requestType);
        [dic addEntriesFromDictionary:responseObject];
        
        [self.icxHttpDelegate httpRequestFinished:dic];
    }
}

- (void)httpRequestFailedWithRequestType:(ICXRequestType)requestType params:(NSDictionary *)params {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[ICX_ReturnValue] = @(-1);
    dic[ICX_HttpRequestType] = @(requestType);
    
    [self.icxHttpDelegate httpRequestFailed:@{}];
}


/**
 根据不同的请求类型生成url

 @param requestType 请求类型
 @return url
 */
- (NSString *)urlForRequestType:(ICXRequestType)requestType {
    
    NSString *url = @"";
    NSString *domain = @"https://image.baidu.com/";
    NSString *suffix = @"";
    switch (requestType) {
        case ICXRequestTypeSendMessage:
            suffix = @"channel/listjson?pn=0&rn=30&tag1=%E7%BE%8E%E5%A5%B3&tag2=%E5%85%A8%E9%83%A8&ie=utf8";
            break;
            
        default:
            break;
    }
    url = [domain stringByAppendingString:suffix];
    
    return url;
}

@end
