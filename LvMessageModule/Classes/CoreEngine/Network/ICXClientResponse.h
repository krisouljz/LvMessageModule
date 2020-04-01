//
//  ICXClientResponse.h
//  Meum
//
//  Created by krisouljz on 2018/4/28.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICXPacketHeader.h"

@interface ICXClientResponse : ICXPacketHeader

@property (nonatomic, strong) NSData* busiData;
@property (nonatomic, strong) NSString *uniqueIdentifier;
@property (nonatomic, strong) NSDictionary *dataDictionary;
@property (nonatomic, assign) int rspType;

@property (nonatomic, assign) SInt32 retCode;

- (NSData*)getBodyData;

@end
