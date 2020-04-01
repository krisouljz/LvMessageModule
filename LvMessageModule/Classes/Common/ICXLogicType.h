//
//  ICXLogicType.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#ifndef ICXLogicType_h
#define ICXLogicType_h
#import "ICXAuthModule.h"

#define ICX_MAX_SEQ_ID                 @"curMaxSeqId"

#define ICX_USER_ID                    @"userId"
#define ICX_FROM_ID                    @"fromId"
#define ICX_TO_ID                      @"toId"
#define ICX_ROOM_ID                    @"roomId"

#define ICX_CHAT_STICKY_STATUS         @"stickyStatus"
#define ICX_CHAT_DISTURB_STATUS         @"disturbStatus"


#define EIM_MESSAGE_TYPE               @"type"

#define EIM_MESSAGE_TYPE_TEXT          @"TEXT"
#define EIM_MESSAGE_TYPE_IMAGE         @"IMAGE"
#define EIM_MESSAGE_TYPE_VOICE         @"VOICE"
#define EIM_MESSAGE_TYPE_VIDEO         @"VIDEO"
#define EIM_MESSAGE_TYPE_FILE          @"FILE"
#define EIM_MESSAGE_TYPE_CUSTOMER      @"CUSTOMER"
#define EIM_MESSAGE_TYPE_CARD          @"CARD" // 卡片消息 各种分享卡片
#define EIM_MESSAGE_TYPE_BUILT_IN_NOTIFICATION          @"BUILT_IN_NOTIFICATION" // 系统内置通知消息(群组相关通知、好友通知)

#define EIM_MESSAGE_TYPE_FAQ           @"faq"
#define EIM_MESSAGE_TYPE_FAQ_REPLY     @"faqReply"

#define EIM_MESSAGE_ID                 @"msgId"
#define EIM_MESSAGE_DATA               @"data"
#define EIM_MESSAGE_FAQ_ID             @"faqId"
#define EIM_MESSAGE_FAQ_NAME           @"name"
#define EIM_MESSAGE_FAQ_DIALOGUE       @"dialogue"
#define EIM_MESSAGE_FAQ_CODE           @"code"
#define EIM_MESSAGE_FAQ_OPTION         @"option"
#define EIM_MESSAGE_FAQ_OPTION_ID      @"optionId"
#define EIM_MESSAGE_FAQ_OPTION_NAME    @"optionName"

#define EIM_MESSAGE_INDEXPATH          @"indexPath"
#define EIM_MESSAGE_COUNT              @"count"
#define EIM_MESSAGE_OFFSET             @"offset"
#define EIM_MESSAGE_PAGE               @"page"
#define ICX_RoomEntity                 @"RoomEntity"
#define ICX_RoomMembers                @"RoomMembers"
#define ICX_MyFollowEntity             @"MyFollowEntity"
#define ICX_MyFollowList               @"MyFollowList"
#define ICX_MessageEntity              @"MessageEntity"
#define ICX_FileEntity                 @"FileEntity"
#define ICX_ChildEntity                @"ChildEntity"
#define ICX_LastMessageEntity          @"LastMessageEntity"
#define ICX_UnfollowLastMessageEntity  @"UnfollowLastMessageEntity"
#define ICX_IsBatchInsertForPullEnd    @"ICX_IsBatchInsertForPullEnd"
#define ICX_ChatbotQuickReply          @"ICX_ChatbotQuickReply"
#define ICX_AlbumAuthRequest           @"ICX_AlbumAuthRequest"
#define ICX_Unfollow_Room_ID           -100088 // 未关注人用一个虚拟的room
#define ICX_FAQ_Robot_ID               -10001
#define ICX_Coach_ID                   -10002
#define ICX_TanXiaoYun_ID              -10003
#define ICX_Moment_Notify_ID           -10004  // 动态
#define ICX_System_Notify_ID           -10005  // 系统
#define ICX_Dabai_ID                   -10006  // 大白
//#define ICX_Coach_ID   [[NSUserDefaults standardUserDefaults] objectForKey:@"ACCOUNTID"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"ACCOUNTID"] integerValue] : -10002
#define EIMServerDomain           @"https://eim.lvjiazhen.com"// Meum_EIM_Domin        //@"https://139.199.61.215"

#define ICX_Moment_NotifyType_USER_FOLLOWED    @"USER_FOLLOWED" //关注通知
#define ICX_Moment_NotifyType_POSTS_LIKED    @"POSTS_LIKED" //动态点赞
#define ICX_Moment_NotifyType_COMMENT_LIKED    @"COMMENT_LIKED" //评论点赞
#define ICX_Moment_NotifyType_POSTS_COMMENT    @"POSTS_COMMENT" //动态评论通知
#define ICX_Moment_NotifyType_COMMENT_REPLY    @"COMMENT_REPLY" //评论回复通知

#define ICX_MEMORY_CACHE_MESSAGE_ID    @"recent_messages_id"
#define ICX_YY_CACHE_LAST_MESSAGE      @"last_message"
#define ICX_YY_CACHE_LAST_MESSAGE_TS   @"last_message_ts"
#define ICX_YY_CACHE_LAST_TS           @"last_ts"

#define ICX_Chart_X      @"ICX_Chart_X"
#define ICX_Chart_Y      @"ICX_Chart_Y"
#define ICX_Chart_Y2      @"ICX_Chart_Y2"
#define ICX_Chart_XV      @"ICX_Chart_XV" //正负向图

// 状态：离线注销：OFFLINE  app在线：ONLINE  app后台运行：BACKGROUND
#define ICX_User_Foreground       @"ONLINE"
#define ICX_User_Background       @"BACKGROUND"
#define ICX_User_Offline          @"OFFLINE"
#define ICX_User_Status_Report    @"status_report"        // 上报状态0，1
#define ICX_User_Status_Fail      @"status_report_fail"   // 上报失败的状态

#define ICX_User_Enter_Background_TS    @"enter_background_ts"

#define ICX_Message_Send_Buffer_Change_Notify        @"ICX_Message_Send_Buffer_Change_Notify" // send buffer 变化通知
#define ICX_Message_Send_Buffer_Add_Replace_Notify   @"ICX_Message_Send_Buffer_Add_Replace_Notify"    //send buffer 添加/替换通知
#define ICX_Message_Send_Buffer_Remove_Notify        @"ICX_Message_Send_Buffer_Remove_Notify" //send buffer 移除通知

#define ICX_Message_card_modifiedStatus              @"ICX_Message_card_modifiedStatus" //卡片消息修改状态：UPDATE表示部分数据修改过，DELETED表示数据都被修改过，NORMAL或不填表示数据没被修改

typedef enum {
    ICXNetworkTypeHttp             = 0,
    ICXNetworkTypeTcp,
    ICXNetworkTypeOther,
}ICXNetworkType;

typedef enum {
    ICXRequestTypeCancelHttpRequest  = 0,
    ICXRequestTypeSendMessage,
    ICXRequestTypeSendRoomMessage,
    ICXRequestTypePullMessage,
    ICXRequestTypeSendFaqOptionMessage,
    ICXRequestTypeReportUserStatus,
    ICXRequestTypeJoinRoom,
    ICXRequestTypeQuitRoom,
    ICXRequestTypeSetRoomName,
    ICXRequestTypeSetRoomNotice,
    ICXRequestTypeSetManager,
    ICXRequestTypeDeleteManager,
    ICXRequestTypeInviteJoinGroup,
    ICXRequestTypeRemoveMenber,
    ICXRequestTypeCreateNotification,
    ICXRequestTypeCreateGroupNotification,
}ICXRequestType;

typedef enum {
    ICXResponseTypeCancelHttpRequest  = 0,
    ICXResponseTypeSendMessage,
    ICXResponseTypeSendRoomMessage,
    ICXResponseTypePullMessage,
    ICXResponseTypeSendFaqOptionMessage,
    ICXResponseTypeReportUserStatus,
    ICXResponseTypeJoinRoom,
    ICXResponseTypeQuitRoom,
    ICXResponseTypeSetRoomName,
    ICXResponseTypeSetRoomNotice,
    ICXResponseTypeSetManager,
    ICXResponseTypeDeleteManager,
    ICXResponseTypeInviteJoinGroup,
    ICXResponseTypeRemoveMenber,
    ICXResponseTypeCreateNotification,
    ICXResponseTypeCreateGroupNotification,
    // 服务器主动通知
    ICXNotifyTypeNewMessage,
    
}ICXResponseType;

typedef enum {
    ICXReturnValueTypeSuccess             = 0,
    ICXReturnValueTypeExceptionError,
    ICXReturnValueTypeNetUnReachable,       // 网络不可用
    ICXReturnValueTypeSocketDisconnect,     // socket断开了连接
    ICXReturnValueTypeRequestTimeout,       // 请求超时
}ICXReturnValueType;

#define ICX_ProtobufReqBody                          @"ProtobufReqBody"
#define ICX_ProtobufRspBody                          @"ProtobufRspBody"

#endif /* ICXLogicType_h */
