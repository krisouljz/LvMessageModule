//
//  ICXPacketChecker.m
//  ICXHealthBuddy
//
//  Created by krisouljz on 2019/8/5.
//  Copyright © 2019年 lvjiazhen. All rights reserved.
//

#import "ICXPacketChecker.h"
#import "ICXPacketHeader.h"
#import "ICXMessageConstants.h"
#import "CocoaLumberjack.h"

@implementation ICXPacketChecker
- (id)init
{
    if (self = [super init]) {
        theReceiveData = [NSMutableData data];
    }
    
    return self;
}

- (void) setRowData:(NSData*)theRowData
{
    DDLogInfo(@"TCP rcv data len = [%lu]", (unsigned long)[theRowData length]);
    
    if ([theRowData length] <= 0) {
        return;
    }

    if ([theReceiveData length] > 0) {
        NSUInteger length = [theReceiveData length];
        [theReceiveData appendData:theRowData];
        //认为开头为0x04的包为新的包的开头,重置包检测
        UInt8 theFlag = 0;
        [theReceiveData getBytes:&theFlag length:1];
        UInt8 theFlag2 = 0;
        [theRowData getBytes:&theFlag2 length:1];
        if (theFlag != 0x04) {
            // 异常处理：但是这里基本不会进来，如果下面方法getCompletelyPacket处理好了的话
            DDLogInfo(@"Rcv a new packet with 0x%0X,0x%0X, reset the packet checker!!!!!!!!\n Before len = %lu, After len = %lu", theFlag, theFlag2, (unsigned long)length, (unsigned long)[theReceiveData length]);
            [theReceiveData setLength:0];
            if (theFlag2 == 0x04) {
                DDLogInfo(@"Rectify a new packet with 0x%0X. packet len = %lu", theFlag2, (unsigned long)[theRowData length]);
                [theReceiveData appendData:theRowData];
            }
        }
    }else {
        [theReceiveData appendData:theRowData];
    }
}

- (NSData*) getCompletelyPacket
{
    if ([theReceiveData length] < CLIENT_HEADER_LEN) {
        if ([theReceiveData length] > 0) {
            long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000000);
            DDLogInfo(@"receive data length:%lu < 20 , time=%lld", (unsigned long)[theReceiveData length], time);
            /*NSString *path = [[HTPath documentPath] stringByAppendingFormat:@"/errdata_%ld", time];
             [[NSFileManager defaultManager] createFileAtPath:path contents:theReceiveData attributes:nil];*/
        }
        return nil;
    }
    
    ICXPacketHeader* theHeader = [[ICXPacketHeader alloc] initWithNetData:theReceiveData];
    NSInteger theBodyLen = theHeader.len-CLIENT_HEADER_LEN; // 整个包的长度=头部前面+pbData+结束符
    if ([theReceiveData length] - CLIENT_HEADER_LEN < theBodyLen) {
        NSLog(@"缓冲区中的数据还不够一个完整包");
        return nil;
    }
    else {
        NSInteger theCompletePacketLen = theHeader.len; // 完整包的长度
        NSData* theCompletePacket = [NSData dataWithBytes:[theReceiveData bytes] length:theCompletePacketLen];
        if ([theReceiveData length] > theCompletePacketLen) {
            // 缓冲区的数据大于一个完整包，在拿到第一个完整包theCompletePacket后，要重置缓存区的数据，供下次获取[theReceiveData setData:leftData]
            NSInteger nLeftLen = [theReceiveData length] - theCompletePacketLen;
            //[theReceiveData resetBytesInRange:NSMakeRange(0, theCompletePacketLen)];
            NSData* leftData = [theReceiveData subdataWithRange:NSMakeRange(theCompletePacketLen, nLeftLen)];
            [theReceiveData setData:leftData];
            //DDLogInfo(@"The left packet checker len = %lu!!!!!", (unsigned long)[leftData length]);
        }
        else {
            // 缓存区的数据刚好等于一个完整包
            [theReceiveData setLength:0];
        }
        //DDLogInfo(@"PacketChecker get complete packet cmd = 0x%04x seq = %d", theHeader.cmdId, theHeader.seq);
        return theCompletePacket;
    }
}

- (void)clearCacheData
{
    if (theReceiveData.length > 0) {
        [theReceiveData resetBytesInRange:NSMakeRange(0, [theReceiveData length])];
        [theReceiveData setLength:0];
    }
}
@end
