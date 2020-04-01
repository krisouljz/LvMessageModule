
//
//  ICXPacketHeader.m
//  ICXHealthBuddy
//
//  Created by krisouljz on 2019/7/31.
//  Copyright © 2019年 lvjiazhen. All rights reserved.
//

#import "ICXPacketHeader.h"
#import "ICXSocketUntils.h"
#import "ICXMessageConstants.h"
#import "CocoaLumberjack.h"

static UInt32 kSeqId = 1;
@implementation ICXPacketHeader
// 二进制解码
- (id)initWithNetData:(NSData*)netData{
    self = [super init];
    if (self) {
        
        if ([netData length] >= CLIENT_HEADER_LEN)
        {
            //            [netData getBytes:&_stx range:NSMakeRange(0,1)];
            ////            _stx = swap_uint16(_stx); //一个字节的不存在字节序，不用高低位转
            //            [netData getBytes:&_version range:NSMakeRange(1,2)];
            //            _version = swap_uint16_short(_version);
            //            [netData getBytes:&_Cmd range:NSMakeRange(3,4)];
            //            _Cmd = swap_uint32_int(_Cmd);
            //            [netData getBytes:&_appId range:NSMakeRange(7,4)];
            //            _appId = swap_uint32_int(_appId);
            //            [netData getBytes:&_checksum range:NSMakeRange(11,4)];
            //            _checksum = swap_uint32_int(_checksum);
            //            [netData getBytes:&_responseFlag range:NSMakeRange(15,1)];
            ////            _responseFlag = swap_uint16(_responseFlag); //一个字节的不用高低位转
            //            [netData getBytes:&_len range:NSMakeRange(16,4)];
            //            _len = swap_uint32_int(_len);
            //            // 获取pbData的长度
            //            SInt64 pbDataLength = netData.length-CLIENT_HEADER_LEN;
            //            _pbData = [netData subdataWithRange:NSMakeRange(20,pbDataLength)];
            ////            _pbData = [ICXSocketUntils dataWithReverse:_pbData];
            //            // len后面是不定长的data
            //            [netData getBytes:&_etx range:NSMakeRange(20+pbDataLength,1)];
            //
            
            
            [netData getBytes:&_stx range:NSMakeRange(0,1)];
            NSData *subVersionData = [netData subdataWithRange:NSMakeRange(1,2)];
            _version = CFSwapInt16BigToHost(*(int*)[subVersionData bytes]);
            NSData *subCmdData = [netData subdataWithRange:NSMakeRange(3,4)];
            _Cmd = CFSwapInt32BigToHost(*(int*)[subCmdData bytes]);
            NSData *subAppidData = [netData subdataWithRange:NSMakeRange(7,4)];
            _appId = CFSwapInt32BigToHost(*(int*)[subAppidData bytes]);
            
            //            NSData *subChecksumData = [netData subdataWithRange:NSMakeRange(11,4)];
            //            _checksum = CFSwapInt32BigToHost(*(int*)[subChecksumData bytes]);
            
            NSData *subSeqIdData = [netData subdataWithRange:NSMakeRange(11,4)];
            _seqId = CFSwapInt32BigToHost(*(int*)[subSeqIdData bytes]);
            [netData getBytes:&_responseFlag range:NSMakeRange(15,1)];
            NSData *subLenData = [netData subdataWithRange:NSMakeRange(16,4)];
            _len = CFSwapInt32BigToHost(*(int*)[subLenData bytes]);
            
            if (_len != netData.length) {
                DDLogInfo(@"包不完整：出现粘包了");
            }else{
                SInt64 pbDataLength = netData.length-CLIENT_HEADER_LEN;
                
                NSData *subChecksumData = [netData subdataWithRange:NSMakeRange(20+pbDataLength,4)];
                uint32_t serverChecksum = CFSwapInt32BigToHost(*(int*)[subChecksumData bytes]);
                NSData *crcData = [netData subdataWithRange:NSMakeRange(0,netData.length-5)];
                uint32_t crc32Checksum = [ICXSocketUntils getCrc32FromData:crcData];
                if (serverChecksum==crc32Checksum) {
                    // crc校验正确
                    _checksum = serverChecksum;
                    _pbData = [netData subdataWithRange:NSMakeRange(20,pbDataLength)];
                    [netData getBytes:&_etx range:NSMakeRange(24+pbDataLength,1)];
                }else{
                    DDLogInfo(@"crc校验错误，serverChecksum=%d,crc32Checksum=%d",serverChecksum,crc32Checksum);
                }
            }
            
        }
        
    }
    return self;
}

- (id)initWithReqPbData:(NSData*)pbData cmd:(uint32_t)Cmd appId:(uint32_t)appId{
    self = [super init];
    if (self) {
        _stx = 0x04;
        _version = 1;
        _Cmd = Cmd;
        _appId = appId;
        _checksum = 0;
        _seqId = [ICXPacketHeader getSeqId];
        _responseFlag = 1;
        _len = (uint32_t)(pbData.length+CLIENT_HEADER_LEN);
        _pbData = pbData;
        _etx = 0x05;
    }
    return self;
}

// 二进制编码，装包
- (NSData*)formatHeaderToData
{
    //    NSMutableData* headerData = [NSMutableData data];
    //    [headerData appendBytes:&_stx length:1];
    //    uint16_t mVersion = CFSwapInt16HostToLittle(_version);
    //    [headerData appendBytes:&mVersion length:2];
    //    uint16_t mCmd = CFSwapInt32HostToLittle(_Cmd);
    //    [headerData appendBytes:&mCmd length:4];
    //    uint16_t mAppId = CFSwapInt32HostToLittle(_appId);
    //    [headerData appendBytes:&mAppId length:4];
    //    uint16_t mchecksum = CFSwapInt32HostToLittle(_checksum);
    //    [headerData appendBytes:&mchecksum length:4];
    //    [headerData appendBytes:&_responseFlag length:1];
    //    uint16_t mlen = CFSwapInt32HostToLittle(_len);
    //    [headerData appendBytes:&mlen length:4];
    //    [headerData appendData:_pbData];
    //    [headerData appendBytes:&_etx length:1];
    //    return (NSData*)headerData;
    
    
    NSMutableData* headerData = [NSMutableData data];
    [headerData appendData:[ICXSocketUntils byteFromUInt8:_stx]];
    [headerData appendData:[ICXSocketUntils bytesFromUInt16:_version]];
    [headerData appendData:[ICXSocketUntils bytesFromUInt32:_Cmd]];
    [headerData appendData:[ICXSocketUntils bytesFromUInt32:_appId]];
    [headerData appendData:[ICXSocketUntils bytesFromUInt32:_seqId]];
    [headerData appendData:[ICXSocketUntils byteFromUInt8:_responseFlag]];
    [headerData appendData:[ICXSocketUntils bytesFromUInt32:_len]];
    [headerData appendData:_pbData];
    int32_t crcChecksum = [ICXSocketUntils getCrc32FromData:headerData];
    [headerData appendData:[ICXSocketUntils bytesFromUInt32:crcChecksum]];
    [headerData appendData:[ICXSocketUntils byteFromUInt8:_etx]];
    return (NSData*)headerData;
}

/*
 UINT_MAX 是unsigned int 类型的变量的最大值。 4294967295 (0xffffffff)
 */
+ (UInt32)getSeqId
{
    if (kSeqId == 0 || kSeqId >= UINT_MAX) {
        long long time = [[NSDate date] timeIntervalSince1970];
        kSeqId = (UInt32)(time & 0x7fffffff); // 得到一个 0 <= X <= 0x7fffffff的数.
    }else {
        kSeqId++;
    }
    return kSeqId;
}


@end


