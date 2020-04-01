//
//  ICXPacketChecker.h
//  ICXHealthBuddy
//
//  Created by krisouljz on 2019/8/5.
//  Copyright © 2019年 lvjiazhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*处理tcp粘包问题：获取完整的包*/

@interface ICXPacketChecker : NSObject
{
    NSMutableData* theReceiveData;
}

- (NSData*) getCompletelyPacket;
- (void) setRowData:(NSData*)theRowData;
- (void)clearCacheData;


@end

NS_ASSUME_NONNULL_END
