// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import <ProtocolBuffers/ProtocolBuffers.h>

// @@protoc_insertion_point(imports)



typedef NS_ENUM(SInt32, EIM_CMD_TYPE) {
  EIM_CMD_TYPEEimCmdAuth = 100,
  EIM_CMD_TYPEEimCmdHeartbeat = 101,
  EIM_CMD_TYPEEimCmdMessage = 102,
  EIM_CMD_TYPEEimCmdGroupMessage = 103,
  EIM_CMD_TYPEEimCmdPullMessage = 104,
  EIM_CMD_TYPEDeviceReconnectionAuth = 105,
  EIM_CMD_TYPEEimUserMsgNotification = 200,
  EIM_CMD_TYPEEimUserAddBlackList = 201,
  EIM_CMD_TYPEEimCreateGroup = 202,
  EIM_CMD_TYPEEimInviteJoinGroup = 203,
  EIM_CMD_TYPEEimRemoveFromGroup = 204,
  EIM_CMD_TYPEEimGroupOwnerTransfer = 205,
  EIM_CMD_TYPEEimAddGroupManager = 206,
  EIM_CMD_TYPEEimAddGroupAnnouncement = 207,
  EIM_CMD_TYPEEimSetGroupName = 208,
  EIM_CMD_TYPEEimSetGroupUserNickname = 209,
  EIM_CMD_TYPEEimQuitGroup = 210,
  EIM_CMD_TYPEEimVoipCreateToken = 211,
  EIM_CMD_TYPEEimCreateVoipSolo = 212,
  EIM_CMD_TYPEEimCreateVoipGroup = 213,
  EIM_CMD_TYPEEimJoinVoip = 214,
  EIM_CMD_TYPEEimRefuseVoip = 215,
  EIM_CMD_TYPEEimCancelVoip = 216,
  EIM_CMD_TYPEEimHangupVoip = 217,
  EIM_CMD_TYPEEimBusyVoip = 218,
  EIM_CMD_TYPEEimAgroaConnectedVoip = 219,
  EIM_CMD_TYPEEimVoipBroadcastAck = 220,
  EIM_CMD_TYPEEimJoinVoipBroadcastAck = 221,
  EIM_CMD_TYPEEimRefuseVoipBroadcastAck = 222,
  EIM_CMD_TYPEEimCancelVoipBroadcastAck = 223,
  EIM_CMD_TYPEEimHangupVoipBroadcastAck = 224,
  EIM_CMD_TYPEEimReportRunStatus = 225,
  EIM_CMD_TYPEEimJoinGroup = 226,
  EIM_CMD_TYPEEimSetGroupNotificaton = 227,
  EIM_CMD_TYPEEimDeleteGroupManager = 228,
  EIM_CMD_TYPEAuthAck = 1000,
  EIM_CMD_TYPEHeaetbeatAck = 1001,
  EIM_CMD_TYPESendMessageAck = 1002,
  EIM_CMD_TYPEPullMessageAck = 1003,
  EIM_CMD_TYPEPullSequenceAck = 1004,
  EIM_CMD_TYPEUserMsgNotificationAck = 1005,
  EIM_CMD_TYPEUserAddBlackListAck = 1006,
  EIM_CMD_TYPEReportRunStatusAck = 1007,
  EIM_CMD_TYPECreateGroupAck = 1008,
  EIM_CMD_TYPEUpdateGroupRemarkAck = 1009,
  EIM_CMD_TYPEUpdateGroupNameAck = 1010,
  EIM_CMD_TYPEJoinGroupAck = 1011,
  EIM_CMD_TYPEUpdateGroupNicknameAck = 1012,
  EIM_CMD_TYPEQuitGroupAck = 1013,
  EIM_CMD_TYPEAddGroupMangerAck = 1014,
  EIM_CMD_TYPEInviteJoinGroupAck = 1015,
  EIM_CMD_TYPERemoveFromGroupAck = 1016,
  EIM_CMD_TYPEGroupOwnerTransferAck = 1017,
  EIM_CMD_TYPEDeviceReconnectionAuthAck = 1018,
  EIM_CMD_TYPESetGroupNotificationAck = 1019,
  EIM_CMD_TYPEDeleteGroupManagerAck = 1020,
  EIM_CMD_TYPEEimNotifyNewMsgPush = 10000,
  EIM_CMD_TYPEEimCreateGroupBroadcase = 10001,
  EIM_CMD_TYPEEimJoinGroupBroadcase = 10002,
  EIM_CMD_TYPEEimQuitGroupBroadcase = 10003,
  EIM_CMD_TYPEEimSetManagerGroupBroadcase = 10004,
  EIM_CMD_TYPEEimOwnerTranserBroadcase = 10005,
  EIM_CMD_TYPEEimGroupRenameBroadcase = 10006,
  EIM_CMD_TYPEEimOwnerQuitGroupBroadcase = 10007,
  EIM_CMD_TYPEEimDeleteUserGroupBroadcase = 10008,
  EIM_CMD_TYPEEimSoloVoipBroadcast = 10009,
  EIM_CMD_TYPEEimGroupVoipBroadcast = 10010,
  EIM_CMD_TYPEEimUserJoinVoipBroadcast = 10011,
  EIM_CMD_TYPEEimRefuseVoipBroadcast = 10012,
  EIM_CMD_TYPEEimCancelVoipBroadcast = 10013,
  EIM_CMD_TYPEEimHangupVoipBroadcast = 10014,
  EIM_CMD_TYPEEimBusyToVoipBroadcast = 10015,
  EIM_CMD_TYPEEimAgoraConnectedVoipBroadcast = 10016,
  EIM_CMD_TYPEEimOwnerDeleteGroupBroadcast = 10017,
  EIM_CMD_TYPEEimGroupRemarkUpdateBroadcast = 10018,
};

BOOL EIM_CMD_TYPEIsValidValue(EIM_CMD_TYPE value);
NSString *NSStringFromEIM_CMD_TYPE(EIM_CMD_TYPE value);

typedef NS_ENUM(SInt32, EIM_RET_CODE) {
  EIM_RET_CODERetSuccess = 0,
  EIM_RET_CODERetInternalErr = 1,
  EIM_RET_CODERetPbErr = 2,
  EIM_RET_CODERetTokenInvalid = 3,
  EIM_RET_CODERetSessionTimeout = 4,
  EIM_RET_CODERetCmdInvalid = 5,
  EIM_RET_CODERetWnsUidMiss = 6,
  EIM_RET_CODERetInputParamErr = 11,
  EIM_RET_CODERetGroupNotExists = 1001,
  EIM_RET_CODERetInBlackList = 1002,
  EIM_RET_CODERetNotInGroup = 1003,
  EIM_RET_CODERetNotGroupManager = 1004,
  EIM_RET_CODERetCanNotDeleteGroupOwner = 1006,
  EIM_RET_CODERetNotGroupOwner = 1007,
};

BOOL EIM_RET_CODEIsValidValue(EIM_RET_CODE value);
NSString *NSStringFromEIM_RET_CODE(EIM_RET_CODE value);


@interface EimConstantRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end


// @@protoc_insertion_point(global_scope)
