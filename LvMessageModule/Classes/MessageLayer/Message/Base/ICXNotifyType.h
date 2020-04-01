//
//  ICXNotifyType.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#ifndef ICXNotifyType_h
#define ICXNotifyType_h
typedef enum {
    ICXNotifyTypeChangeRoomNameOperator = 1,                 // 更新群名称操作广播
    ICXNotifyTypeChangeChangeRoomIntroOperator,          // 更新群介绍操作广播
    ICXNotifyTypeChangeGroupManagerOperator,             // 更新群管理员操作广播
    ICXNotifyTypeNumChangeGroupOperator,                     // 其它群操作广播（群成员数量变化的广播）
} ICXNotifyType;

#endif /* ICXNotifyType_h */
