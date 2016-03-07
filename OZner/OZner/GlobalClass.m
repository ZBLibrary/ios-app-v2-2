//
//  GlobalClass.m
//  OZner
//
//  Created by sunlinlin on 15/12/12.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "GlobalClass.h"

@implementation GlobalClass

@end

@implementation LoginUserInfo

- (id)init
{
    if(self = [super init])
    {
        self.sessionToken = nil;
        self.displayName = nil;
        self.userID = nil;
        self.loginName = nil;
        self.password = nil;
        self.avatarUrl = nil;
        self.gender = nil;
    }
    
    return self;
}

- (void)selfCopy:(LoginUserInfo *)stUserInfo
{
    stUserInfo.sessionToken = self.sessionToken;
    stUserInfo.displayName = self.displayName;
    stUserInfo.userID = self.userID;
    stUserInfo.loginName = self.loginName;
    stUserInfo.password = self.password;
    stUserInfo.avatarUrl = self.avatarUrl;
    stUserInfo.gender = self.gender;
}


- (void)dealloc
{
    [super dealloc];
}

@end

@implementation TextColorClass

- (void)dealloc
{
    self.text = nil;
    [super dealloc];
}

@end

@implementation UserInfo

- (void)InitSubFieldName
{
    ADD_FIELD(_userId, @"UserId");
    ADD_FIELD(_clientId, @"ClientId");
    ADD_FIELD(_mobile, @"Mobile");
    ADD_FIELD(_passWord, @"PassWord");
    ADD_FIELD(_nickName, @"NickName");
    ADD_FIELD(_sex, @"Sex");
    ADD_FIELD(_birthday, @"Birthday");
    ADD_FIELD(_height, @"Height");
    ADD_FIELD(_weight, @"Weight");
    ADD_FIELD(_imgpath, @"ImgPath");
    ADD_FIELD(_isEaseSweat, @"IsEasySweat");
    ADD_FIELD(_isBind, @"IsBind");
    ADD_FIELD(_userTalkCode, @"UserTalkCode");
    ADD_FIELD(_deviceInfo, @"DeviceInfo");
    ADD_FIELD(_version, @"Version");
    ADD_FIELD(_disabled, @"Disabled");
    ADD_FIELD(_createBy, @"CreateBy");
    ADD_FIELD(_createTime, @"CreateTime");
    ADD_FIELD(_modifyTime, @"ModifyTime");
    ADD_FIELD(_modifyBy, @"ModifyBy");
    ADD_FIELD(_language, @"Language");
    ADD_FIELD(_area, @"Area");
    ADD_FIELD(_email, @"Email");
    ADD_FIELD(_friendSupport, @"FriendSupport");
    ADD_FIELD(_ucode, @"ucode");
    ADD_FIELD(_lktMemberUcode, @"LktMemberUcode");
    ADD_FIELD(_isRecomment, @"IsRecomment");
    ADD_FIELD(_recommentVol, @"RecommentVol");
}

- (void)dealloc
{
    self.userId = nil;
    self.clientId = nil;
    self.mobile = nil;
    self.passWord = nil;
    self.nickName = nil;
    self.sex = nil;
    self.birthday = nil;
    self.height = nil;
    self.weight = nil;
    self.imgpath = nil;
    self.isEaseSweat = nil;
    self.isBind = nil;
    self.userTalkCode = nil;
    self.deviceInfo = nil;
    self.version = nil;
    self.disabled = nil;
    self.createBy = nil;
    self.createTime = nil;
    self.modifyBy = nil;
    self.modifyTime = nil;
    self.language = nil;
    self.area = nil;
    self.email = nil;
    self.friendSupport = nil;
    self.ucode = nil;
    self.lktMemberUcode = nil;
    self.isRecomment = nil;
    self.recommentVol = nil;
    [super dealloc];
}

@end

@implementation UserVerifMsgInfo

- (void)InitSubFieldName
{
    ADD_FIELD(_msgId, @"ID");
    ADD_FIELD(_mobile, @"Mobile");
    ADD_FIELD(_friendMobile, @"FriendMobile");
    ADD_FIELD(_requestContent, @"RequestContent");
    ADD_FIELD(_status, @"Status");
    ADD_FIELD(_disabled, @"Disabled");
    ADD_FIELD(_createBy, @"CreateBy");
    ADD_FIELD(_createTime, @"CreateTime");
    ADD_FIELD(_modifyBy, @"ModifyBy");
    ADD_FIELD(_modifytime, @"ModifyTime");
}

- (void)dealloc
{
    self.msgId = nil;
    self.mobile = nil;
    self.friendMobile = nil;
    self.requestContent = nil;
    self.status = nil;
    self.disabled = nil;
    self.createBy = nil;
    self.createTime = nil;
    self.modifyBy = nil;
    self.modifytime = nil;
    [super dealloc];
}

@end

@implementation UserNickImgInfo

- (void)InitSubFieldName
{
    ADD_FIELD(_mobile, @"mobile");
    ADD_FIELD(_nickName, @"nickname");
    ADD_FIELD(_headImg, @"headimg");
    ADD_FIELD(_score, @"Score");
    ADD_FIELD(_status, @"Status");
}

- (void)dealloc
{
    self.mobile = nil;
    self.nickName = nil;
    self.headImg = nil;
    self.score = nil;
    self.status = nil;
    [super dealloc];
}

@end


@implementation FriendVolumeDetail

- (void)InitSubFieldName
{
    ADD_FIELD(_rank, @"rank");
    ADD_FIELD(_userId, @"userid");
    ADD_FIELD(_volume, @"volume");
    ADD_FIELD(_nickName, @"Nickname");
    ADD_FIELD(_icon, @"Icon");
    ADD_FIELD(_score, @"Score");
}

- (void)dealloc
{
    self.rank = nil;
    self.userId = nil;
    self.volume = nil;
    self.nickName = nil;
    self.icon = nil;
    self.score = nil;
    [super dealloc];
}

@end


















































