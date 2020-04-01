//
//  ICXMacros.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#ifndef ICXMacros_h
#define ICXMacros_h

#define MessageNotificationName(networkType,responseType) [NSString stringWithFormat:@"ht_potocol_message_notification_%i_%i",networkType,responseType]
#define AddObserver(model,networkType,responseType) [[ICXMessageInterface sharedInterface] addObserver:model name:MessageNotificationName(networkType,responseType)]

#define DataMessageNotificationName(databaseType,logicType) [NSString stringWithFormat:@"ht_data_message_notification_%i_%i",databaseType,logicType]
#define AddDataObserver(model,databaseType,logicType) [[ICXMessageInterface sharedInterface] addObserver:model name:DataMessageNotificationName(databaseType,logicType)]

#define NotifyMeesageNotificationName(notifyType) [NSString stringWithFormat:@"ht_notify_message_notification_%i",notifyType]
#define AddNotifyObserver(model,notifyType) [[ICXMessageInterface sharedInterface] addObserver:model name:NotifyMeesageNotificationName(notifyType)]

#define RemoveObserver(model) [[ICXMessageInterface sharedInterface] removeObserver:model]

#endif /* ICXMacros_h */
