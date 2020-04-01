
//
//  ICXPacketHeader.h
//  ICXHealthBuddy
//
//  Created by krisouljz on 2019/7/31.
//  Copyright © 2019年 lvjiazhen. All rights reserved.

// -------------------------------------------------------------------------------------------
// |stx   |version |cmd     |appId  |seqId    |responseFlag   |len    |data  |checksum  |etx
// |1Byte |2Byte   |4Byte   |4Byte  |4Bytes   |1Bytes         |4Bytes |不定长 |4Bytes    |1Bytes
// -------------------------------------------------------------------------------------------

/*
 标记位说明：
 stx：数据包开始标记位，1个字节
 version： 二进制协议版本号标记位， 2个字节
 cmd：  业务命令字标记位， 4个字节
 appId： 接入应用Id标记位， 4个字节
 seqId:   tcp包序列好，4个字节 ,用于返回包时，在缓存队列中找到对应的请求包数据
 responseFlag:   responseFlag标记位，1个字节，是否需要回ack确认包
 len： 整个tcp包数据长度标记位： 4个字节  【用于处理TCP粘包问题】
 data：为业务数据，可变长
 checksum:   checksum标记位，4个字节 初步采用crc32 校验
 etx： 数据包结束标记位： 1个字节
 
 注意：
 checksum = crc32(header+data);  [header指data之前的20个字节，data指pb业务数据]
 stx和ext 用于检测tcp包是否完整，所以解码器接收到的tcp包数据最小为：21个字节。
 data 数据说明：data为pb业务数据
 */

#import <Foundation/Foundation.h>
#import "ICXCmdConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICXPacketHeader : NSObject

/*
 1字节 uint8_t；byte/char
 2字节 uint16_t；short
 4字节 uint32_t；int
 8字节 uint64_t；long long
 */

@property (nonatomic)  uint8_t  stx;
@property (nonatomic)  uint16_t  version;
@property (nonatomic)  uint32_t  Cmd;
@property (nonatomic)  uint32_t  appId;
@property (nonatomic)  uint32_t  seqId;
@property (nonatomic)  uint8_t  responseFlag;
@property (nonatomic)  uint32_t  len;
@property (nonatomic)  NSData  *pbData;
@property (nonatomic)  uint32_t  checksum;
@property (nonatomic)  uint8_t  etx;

// 拆包：拆解网络返回的“完整的”二进制包
- (id)initWithNetData:(NSData*)netData;

// 用于请求的时候，构建协议
- (id)initWithReqPbData:(NSData*)pbData cmd:(uint32_t)Cmd appId:(uint32_t)appId;

// 组包：获取整个tcp协议包
- (NSData*)formatHeaderToData;


@end

NS_ASSUME_NONNULL_END



