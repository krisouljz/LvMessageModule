//
//  ICXBaseMessage.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICXBaseMessage : NSObject

- (id)initWithIdentifier:(NSString *)identifier;
- (id)initWithNotificationName:(NSString *)notificationName;

@property (nonatomic, strong) id responder;
// 唯一标识
@property (nonatomic, copy) NSString *identifier;
// 自定义数据
@property (nonatomic, strong) id customData;
// 优先级
@property (nonatomic) NSOperationQueuePriority priority;
// 消息是否需要全局通知
@property (nonatomic) BOOL needNotify;
// 通知名称
@property (nonatomic, copy) NSString *notificationName;
// 消息返回值是否为成功状态
@property (nonatomic) BOOL succeed;
// 是否同步
@property (nonatomic) BOOL sync;
// 是否取消
@property (nonatomic) BOOL isCancel;

@property (nonatomic) BOOL cache;

- (id)initWithResponder:(id)responder;

@end
