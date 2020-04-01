//
//  ICXCmdConfig.h
//  Meum
//
//  Created by krisouljz on 2018/5/16.
//  Copyright © 2018年 krisouljz All rights reserved.
//

#ifndef ICXCmdConfig_h
#define ICXCmdConfig_h

#define EIM                           @"EIM"
#define EIM_DEV                       @"EIM_DEV"
#define EIM_BETA                      @"EIM_BETA"

//MARK:- dev环境要改把DEBUG的改成EIM_DEV调试
#if defined DEBUG
    #define EIM_CMD(cmd) [NSString stringWithFormat:@"%@/%d", EIM_DEV, (int)cmd]
#elif defined BETA
    #define EIM_CMD(cmd) [NSString stringWithFormat:@"%@/%d", EIM_BETA, (int)cmd]
#else
    #define EIM_CMD(cmd) [NSString stringWithFormat:@"%@/%d", EIM, (int)cmd]
#endif
//#define EIM_CMD_NEW_MESSAGE_NOTIFY                              10000   //新消息通知
//
//#define EIM_CMD_AUTH                                            0x64    //登录 100
//#define EIM_CMD_HEARTBEAT                                       0x65    //心跳包 （request body 为空）
//#define EIM_CMD_SEND_MESSAGE                                    0x66    //发送消息
//#define EIM_CMD_SEND_GROUP_MESSAGE                              0x67    //发送群组消息
//#define EIM_CMD_PULL_MESSAGE                                    0x68    //拉取消息
//#define EIM_CMD_CREATE_GROUP                                    0x69    //创建群组
//#define EIM_CMD_QUIT_GROUP                                      0x6A    //退出群组

#define HeartbeatCycle                                          180.0
#define TIMEOUT_5                                               5.0
#define TIMEOUT_10                                              10.0
#define TIMEOUT_20                                              20.0
#define TIMEOUT_30                                              30.0
#define TIMEOUT_40                                              40.0
#define TIMEOUT_50                                              50.0
#define TIMEOUT_60                                              60.0
#define TIMEOUT_90                                              90.0
#define TIMEOUT_120                                             120.0
#define TIMEOUT_RECONNECT                                       2.0

#define CLIENT_HEADER_LEN                                       25 //二进制协议头部最少字节长度

#endif /* ICXCmdConfig_h */
