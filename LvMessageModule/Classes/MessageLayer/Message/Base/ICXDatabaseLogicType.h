//
//  ICXDatabaseType.h
//  HelloTalk_Binary
//
//  Created by krisouljz on 13-6-20.
//  CopyrigICX (c) 2013年 krisouljz All rigICXs reserved.
//

#define ICXDatabaseLogicTypeInitPlugin @"pluginInited"

typedef enum{
    ICXDatabaseOperationTypeInsert,
    ICXDatabaseOperationTypeDelete,
	ICXDatabaseOperationTypeUpdate,
    ICXDatabaseOperationTypeQuery,
    ICXDatabaseOperationTypeBatchQuery,    //批量查询
}ICXDatabaseOperationType;

typedef enum {
    ICXDatabaseTypeDefault,
    ICXDatabaseTypeLog,
    ICXDatabaseTypeOther
}ICXDatabaseType;

typedef enum {
    ICXDatabaseChangeTypeInsert,
	ICXDatabaseChangeTypeDelete,
	ICXDatabaseChangeTypeMove,
	ICXDatabaseChangeTypeUpdate,
    ICXDatabaseChangeTypeSelect
}ICXDatabaseChangeType;

typedef enum {
    ICXDatabaseLogicTypeInsertMessage,                       // 插入消息
    ICXDatabaseLogicTypeBatchInsertMessage,                  // 批量插入消息
    ICXDatabaseLogicTypeInsertFaqOption,                     // 插入FAQ选项
    ICXDatabaseLogicTypeUpdateFaqOption,                     // 更新FAQ选项
    ICXDatabaseLogicTypeQueryMessage,                        // 查询消息
    ICXDatabaseLogicTypeQueryHistoryMessage,                 // 查询历史消息(查询用ICXDatabaseLogicTypeQueryMessage，消息回来的时候如果是历史消息，替换为该type)
    ICXDatabaseLogicTypeUpdateMsgTransferStatus,             // 更新消息发送状态
    ICXDatabaseLogicTypeUpdateFile,                          // 更新File表:用于发送，上传回调之后
//    ICXDatabaseLogicTypeUpdateFileAfterDownload,             // 更新File表:用于接收，下载回调之后
    ICXDatabaseLogicTypeQueryFaqOption,                      // 查询Faq选项
    ICXDatabaseLogicTypeQueryLoadingMessage,                 // 查询状态为loading的消息
    ICXDatabaseLogicTypeQueryLoadingPlainMessage,            // 查询状态为loading的普通消息
    ICXDatabaseLogicTypeQueryLoadingImageMessage,            // 查询状态为loading的图片消息
    ICXDatabaseLogicTypeQueryLoadingVoiceMessage,            // 查询状态为loading的音频消息
    ICXDatabaseLogicTypeQueryLoadingVideoMessage,            // 查询状态为loading的视频消息
    ICXDatabaseLogicTypeQueryRecent2000Message,              // 查询最近的2000条消息，缓存msgid用于去重
    ICXDatabaseLogicTypeUpdateDownloadResult,                // 更新文件下载结果
    ICXDatabaseLogicTypeUpdateSurveyContent,                 // 更新survey状态
    ICXDatabaseLogicTypeQueryRecentChatlist,                 // 查询聊天列表
    ICXDatabaseLogicTypeQueryRecentUnfollowChatlist,         // 查询未关注人的聊天列表
    ICXDatabaseLogicTypeQueryFollowlist,                     // 查询我关注的人列表
    ICXDatabaseLogicTypeQueryFollowStatus,                   // 查询我关注的人列表: 是否我关注
    ICXDatabaseLogicTypeUpdateFollowlist,                    // 更新我关注的人列表(覆盖)
    ICXDatabaseLogicTypeAddToFollowlist,                     // 添加到我关注的人列表
    ICXDatabaseLogicTypeDeleteFromFollowlist,                // 从我关注的列表删除 
    ICXDatabaseLogicTypeQueryRoomInfo,                       // 查询群资料
    ICXDatabaseLogicTypeStickyRecentChatItem,                // 置顶聊天(0-普通 1-置顶)
    ICXDatabaseLogicTypeUpdateRecentChatItem,                // 更新聊天列表某项记录
    ICXDatabaseLogicTypeUpdateRecentUnfollowChatItem,        // 更新未关注人聊天列表某项记录
    ICXDatabaseLogicTypeClearRecentChatItemCount,            // 计数清零: 聊天列表某项记录
    ICXDatabaseLogicTypeClearRecentUnfollowChatItemCount,    // 计数清零: 未关注人聊天列表某项记录
    ICXDatabaseLogicTypeClearRecentChatItem,                 // 删除会话
    ICXDatabaseLogicTypeClearRecentUnfollowChatItem,         // 删除会话: 未关注人聊天列表
    ICXDatabaseLogicTypeClearChatRecord,                     // 清除某个聊天记录
    ICXDatabaseLogicTypeClearUnfollowChatRecord,             // 清除某个聊天记录: 未关注人聊天
    ICXDatabaseLogicTypeQueryStickyStatus,                   // 查询置顶状态
    ICXDatabaseLogicTypeUpdateRoomInfo,                      // 更新群资料
    ICXDatabaseLogicTypeUpdateRoomName,                      // 更新群昵称
    ICXDatabaseLogicTypeUpdateRoomDesc,                      // 更新群简介
    ICXDatabaseLogicTypeQuitRoom,                            // 退群
    ICXDatabaseLogicTypeUpdateUserInfo,                      // 更新用户资料
    ICXDatabaseLogicTypeClearAtStatus,                       // 清除at状态
    ICXDatabaseLogicTypeQueryShareContactlist,               // 查询分享列表
    ICXDatabaseLogicTypeQueryMomentNotify,                   // 查询动态通知
    ICXDatabaseLogicTypeQueryRoomMemberToGenerateHeadImage,  // 查询群成员：合成头像
    ICXDatabaseLogicTypeQueryRoomContactHistory,             // 查询最近所有联系人、群聊、群聊聊天记录：根据搜索词 模糊查询
    ICXDatabaseLogicTypeQueryRoomContactHistorySpecail,      // 查询指定的群聊、联系人的聊天记录：根据搜索词、群聊Id、单聊id 模糊查询
    ICXDatabaseLogicTypeInsertBroadcastMessage,              // 插入广播消息：群广播等
    ICXDatabaseLogicTypeQueryTabbarUnreadCount,              // 查询tabbar未读数
    ICXDatabaseLogicTypeUpdateMessageReadState,              //更新消息（语音）阅读状态
    ICXDatabaseLogicTypeDisturbStatusChatItem,               //消息免打扰
    ICXDatabaseLogicTypeQueryHistoryMessageTop,              // 查询历史消息，指定向上
    ICXDatabaseLogicTypeQueryHistoryMessageBottom,           // 查询历史消息，指定向下
    ICXDatabaseLogicTypeQueryHistoryMessageOffset,           // 查询历史消息位置
    ICXDatabaseLogicTypeUpdateRoomMenberRole,                // 更新群成员角色
    ICXDatabaseLogicTypeAddRoomMenber,                       // 添加群成员（目前是邀请成员）
    ICXDatabaseLogicTypeDeleteRoomMenber,                    // 删除群成员（目前是群主和管理员踢人）
    ICXDatabaseLogicTypeInsertCoachLastMessage,              // 插入Coach入口到聊天列表
    ICXDatabaseLogicTypeQueryChatImages,                     // 查询某个会话的所有图片、视频
    ICXDatabaseLogicTypeUpdateCoachCoachLastMessage,         // 更新Coach最新消息的时间戳
    ICXDatabaseLogicTypeQueryFirstNewMessage,                // 查询第一条未读消息
    ICXDatabaseLogicTypeQueryMessagesUpToFirstNewMessage,    // 查询第一条未读消息->最新消息之间的消息
    ICXDatabaseLogicTypeQuerryRoomLastBrodcastMessage,        //查询群里中最后一条群广播消息
    ICXDatabaseLogicTypeQuerySystemNotify,                    //查询系统通知
    ICXDatabaseLogicTypeUpdateRealatedOOB,                    //更新相关表的oob,认证信息，头像、名称
    ICXDatabaseLogicTypeQueryDabaiCorpusMessage,              //查询大白预警语料消息
    ICXDatabaseLogicTypeDeleateDabaiCorpusMessage,            //删除大白预警语料消息
    ICXDatabaseLogicTypeUpdateCardMessageContent,             //更新卡片消息内容：加标记(修改/删除)
    ICXLogicTypeRemoveLoading                                // 用于移除loading的标识，不是数据库操作
} ICXDatabaseLogicType;
