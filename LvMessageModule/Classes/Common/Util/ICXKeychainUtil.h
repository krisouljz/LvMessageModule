//
//  ICXKeychainUtil.h
//  ICXCommercialPR
//
//  Created by krisouljz on 2018/3/20.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICXKeychainUtil : NSObject

+ (void)setOpenUDID:(NSString *)openUDID;
+ (NSString *)openUDID;

// SFHFKeychainUtils
+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;
+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error;
+ (BOOL) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;
+ (BOOL) purgeItemsForServiceName:(NSString *) serviceName error: (NSError **) error;

@end
