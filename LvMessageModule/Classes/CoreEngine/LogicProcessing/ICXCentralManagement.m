//
//  ICXCentralManagement.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXCentralManagement.h"
#import "ICXHttpProcessingCenter.h"
#import "ICXSocketProcessingCenter.h"
#import "NSDictionary+ICX.h"
#import "ICXDefineKeyValues.h"
#import "ICXCmdConfig.h"
#import "ICXLogicType.h"
#import "ICXPbRequest.h"
#import "Eim_constant.pb.h"

@interface ICXCentralManagement()<ICXHttpProcessingCenterDelegate>


@end

@implementation ICXCentralManagement

static ICXCentralManagement* kHTCentralManagement = nil;

+ (ICXCentralManagement *)getInstance
{
    if (kHTCentralManagement == nil) {
        kHTCentralManagement = [[ICXCentralManagement alloc] init];
    }
    return kHTCentralManagement;
}

- (id)init {
    if (self = [super init]) {
        [ICXHttpProcessingCenter defaultCenter].icxHttpDelegate = self;
    }
    
    return self;
}

// 发送网络请求
- (void)sendRequestType:(ICXNetworkType)type andSubType:(ICXRequestType)subType andData:(NSDictionary *)requestData {
    switch (type) {
        case ICXNetworkTypeTcp:
            switch (subType) {
                case ICXRequestTypeSendMessage:
                case ICXRequestTypeSendFaqOptionMessage:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimCmdMessage];
                    break;
                case ICXRequestTypeSendRoomMessage:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimCmdGroupMessage];
                    break;
                case ICXRequestTypePullMessage:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimCmdPullMessage];
                    break;
                case ICXRequestTypeReportUserStatus:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimReportRunStatus];
                    break;
                case ICXRequestTypeJoinRoom:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimJoinGroup];
                    break;
                case ICXRequestTypeQuitRoom:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimQuitGroup];
                    break;
                case ICXRequestTypeSetRoomName:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimSetGroupName];
                    break;
                case ICXRequestTypeSetRoomNotice:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimAddGroupAnnouncement];
                    break;
                case ICXRequestTypeSetManager:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimAddGroupManager];
                    break;
                case ICXRequestTypeDeleteManager:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimDeleteGroupManager];
                    break;
                case ICXRequestTypeInviteJoinGroup:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimInviteJoinGroup];
                    break;
                case ICXRequestTypeRemoveMenber:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimRemoveFromGroup];
                    break;
                case ICXRequestTypeCreateNotification:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimUserMsgNotification];
                    break;
                case ICXRequestTypeCreateGroupNotification:
                    [self sendProtoBufRequest:requestData type:subType cmd:EIM_CMD_TYPEEimSetGroupNotificaton];
                    break;
                default:
                    break;
            }
            break;
        case ICXNetworkTypeHttp:
            switch (subType) {
                case ICXRequestTypeSendMessage:
                    [[ICXHttpProcessingCenter defaultCenter] sendGetRequestType:subType params:requestData];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (void)sendProtoBufRequest:(NSDictionary *)myRequestDic type:(ICXRequestType)type cmd:(UInt16)cmd {
    NSString *uniqueIdentifier = [myRequestDic stringForKey:ICX_UniqueIdentifier];
    NSData *data = [myRequestDic objectForKey:ICX_ProtobufReqBody];
    SInt16 appId = [[ICXSocketProcessingCenter sharedInstance] getAppId];
    ICXPbRequest *request = [[ICXPbRequest alloc] initWithType:type andAppId:appId andCmd:cmd andData:data andUniqueIdentifier:uniqueIdentifier];
    request.dataDictionary = myRequestDic;
    int timeOut = TIMEOUT_30;
    if (cmd==EIM_CMD_TYPEEimCmdMessage || cmd==EIM_CMD_TYPEEimCmdGroupMessage) {
        timeOut = TIMEOUT_120;
    }
    [[ICXSocketProcessingCenter sharedInstance] sendSocketRequest:request withTimeout:timeOut];
}

#pragma mark - Send Request
//- (void)sendRequest:(HTClientRequest *)request withTimeout:(CGFloat)timeout {
//    if ([HTFunction isUseWns]) {
//        [htWnsProcessingCenter sendWNSRequest:request withTimeout:timeout];
//    }else {
//        [htSocketProcessingCenter sendRequest:request delegate:self withTimeout:timeout];
//    }
//}

//#pragma mark - Http Response
//
//- (void)handleHttpData:(NSDictionary *)responseDic type:(ICXRequestType)type reqData:(NSDictionary *)dict {
//    // 处理http接口返回数据
//
//    [self httpRequestFinished:@{}];
//}

#pragma mark - ICXHttpProcessingCenterDelegate
- (void)httpRequestFinished:(NSDictionary *)theDictionary
{
    ICXResponseType subType = [theDictionary intForKey:ICX_HttpRequestType];
    if ([self.centralManagementDelegate respondsToSelector:@selector(receiveResponseType:andSubType:andData:)]) {
        [self.centralManagementDelegate receiveResponseType:ICXNetworkTypeHttp andSubType:subType andData:theDictionary];
    }
}

- (void)httpRequestFailed:(NSDictionary *)theDictionary
{
    ICXResponseType subType = [theDictionary intForKey:ICX_HttpRequestType];
    if ([self.centralManagementDelegate respondsToSelector:@selector(receiveResponseType:andSubType:andData:)]) {
        [self.centralManagementDelegate receiveResponseType:ICXNetworkTypeHttp andSubType:subType andData:theDictionary];
    }
}

- (void)socketReceiveResponse:(ICXClientResponse*)response request:(ICXClientRequest*)theRequest {
    ICXResponseType responseType = 0;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (theRequest) {
        dic = [NSMutableDictionary dictionaryWithDictionary:theRequest.dataDictionary];
        dic[ICX_ProtobufRspBody] = [response getBodyData];
        dic[ICX_ReturnValue] = @(response.retCode);
    }
    else {
        dic[ICX_ProtobufRspBody]  = response.pbData; // 10000的命令字里面携带的消息体MessageResp
    }
    
    switch (response.Cmd) {
        case EIM_CMD_TYPEEimNotifyNewMsgPush:
            responseType = ICXNotifyTypeNewMessage;
            break;
            // 将请求的命令字也放进来，是为了响应请求超时时，socket直接将request中的命令字抛回来做失败处理(此时没有服务器响应，不知道响应的ack命令字)
        case EIM_CMD_TYPEEimCmdMessage:
        case EIM_CMD_TYPEEimCmdGroupMessage:
        case EIM_CMD_TYPESendMessageAck:
            if (theRequest.requestType == ICXRequestTypeSendMessage) {
                responseType = ICXResponseTypeSendMessage;
            }
            else if (theRequest.requestType == ICXRequestTypeSendRoomMessage) {
                responseType = ICXResponseTypeSendRoomMessage;
            }
            else if (theRequest.requestType == ICXRequestTypeSendFaqOptionMessage) {
                responseType = ICXResponseTypeSendFaqOptionMessage;
            }
            break;
        case EIM_CMD_TYPEEimCmdPullMessage:
        case EIM_CMD_TYPEPullMessageAck:
            responseType = ICXResponseTypePullMessage;
            break;
        case EIM_CMD_TYPEEimReportRunStatus:
        case EIM_CMD_TYPEReportRunStatusAck:
            responseType = ICXResponseTypeReportUserStatus;
            break;
        case EIM_CMD_TYPEEimJoinGroup:
        case EIM_CMD_TYPEJoinGroupAck:
            responseType = ICXResponseTypeJoinRoom;
            break;
        case EIM_CMD_TYPEEimQuitGroup:
        case EIM_CMD_TYPEQuitGroupAck:
            responseType = ICXResponseTypeQuitRoom;
            break;
        case EIM_CMD_TYPEEimSetGroupName:
        case EIM_CMD_TYPEUpdateGroupNameAck:
            responseType = ICXResponseTypeSetRoomName;
            break;
        case EIM_CMD_TYPEEimAddGroupAnnouncement:
        case EIM_CMD_TYPEUpdateGroupRemarkAck:
            responseType = ICXResponseTypeSetRoomNotice;
            break;
        case EIM_CMD_TYPEEimAddGroupManager:
        case EIM_CMD_TYPEAddGroupMangerAck:
            responseType = ICXResponseTypeSetManager;
            break;
        case EIM_CMD_TYPEEimDeleteGroupManager:
        case EIM_CMD_TYPEDeleteGroupManagerAck:
            responseType = ICXResponseTypeDeleteManager;
            break;
        case EIM_CMD_TYPEEimInviteJoinGroup:
        case EIM_CMD_TYPEInviteJoinGroupAck:
            responseType = ICXResponseTypeInviteJoinGroup;
            break;
        case EIM_CMD_TYPEEimRemoveFromGroup:
        case EIM_CMD_TYPERemoveFromGroupAck:
            responseType = ICXResponseTypeRemoveMenber;
            break;
        case EIM_CMD_TYPEEimUserMsgNotification:
        case EIM_CMD_TYPEUserMsgNotificationAck:
            responseType = ICXResponseTypeCreateNotification;
            break;
        case EIM_CMD_TYPEEimSetGroupNotificaton:
        case EIM_CMD_TYPESetGroupNotificationAck:
            responseType = ICXResponseTypeCreateGroupNotification;
            break;
        default:
            break;
    }
    
    if (_centralManagementDelegate && [_centralManagementDelegate respondsToSelector:@selector(receiveResponseType:andSubType:andData:)]) {
        [_centralManagementDelegate receiveResponseType:ICXNetworkTypeTcp andSubType:responseType andData:dic];
    }
}

- (void)socketDidFailWithError:(ICXReturnValueType)errType request:(ICXClientRequest*)theRequest {
    
}

@end



