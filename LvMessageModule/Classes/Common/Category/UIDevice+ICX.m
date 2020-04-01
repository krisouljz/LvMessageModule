//
//  UIDevice+ICX.m
//  ICXCommercialPR
//
//  Created by krisouljz on 2018/3/20.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#import "UIDevice+ICX.h"
#import "ICXKeychainUtil.h"
#import "OpenUDID.h"

@implementation UIDevice (ICX)

- (NSString *)openUDID {
    
    static NSString *openUDID = nil;
    
    openUDID = [ICXKeychainUtil openUDID];
    
    if (openUDID.length <= 0) {
        
        //        openUDID = [[self serialNumber_] md5String];
        
        if (openUDID.length <= 0) {
            openUDID = [OpenUDID value];
        }
        
        if (openUDID.length <= 0) {
            openUDID = [[[[NSUUID UUID] UUIDString] lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        
        if (openUDID.length <= 0) {
            NSMutableString *string = [NSMutableString string];
            
            for (int i=0; i<32; i++) {
                [string appendString:[NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a']];
            }
            openUDID = string;
        }
        
        [ICXKeychainUtil setOpenUDID:openUDID];
        
    }
    
    return openUDID;
    
}

@end
