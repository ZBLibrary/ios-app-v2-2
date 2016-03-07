//
//  GlobalClass.h
//  OZner
//
//  Created by sunlinlin on 15/12/12.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseDictionaryData.h"


@interface GlobalClass : NSObject


@end

@interface LoginUserInfo : NSObject

@property (nonatomic,retain) NSString* sessionToken; //session标识
@property (nonatomic,retain) NSString* displayName;  //昵称
@property (nonatomic,retain) NSString* userID;      //用户id
@property (nonatomic,retain) NSString* loginName;   //用户姓名
@property (nonatomic,retain) NSString* password;    //密码
@property (nonatomic,retain) NSString* avatarUrl;   //上传文件的随机值
@property (nonatomic,retain) NSString* gender;

- (void)selfCopy:(LoginUserInfo*)stUserInfo;

@end

//文字的颜色类
@interface TextColorClass : NSObject

@property (nonatomic, retain) NSString* text;
@property (nonatomic, assign) int font;
@property (nonatomic, assign) float red;
@property (nonatomic, assign) float green;
@property (nonatomic, assign) float blue;

@end

//用户信息
@interface UserInfo : ParseDictionaryData

@property (nonatomic,assign) UNDWORD _id;
@property (nonatomic,strong) NSString* userId;
@property (nonatomic,strong) NSString* clientId;
@property (nonatomic,strong) NSString* mobile;
@property (nonatomic,strong) NSString* passWord;
@property (nonatomic,strong) NSString* nickName;
@property (nonatomic,strong) NSString* sex;
@property (nonatomic,strong) NSString* birthday;
@property (nonatomic,strong) NSString* height;
@property (nonatomic,strong) NSString* weight;
@property (nonatomic,strong) NSString* imgpath;
@property (nonatomic,strong) NSString* isEaseSweat;
@property (nonatomic,strong) NSString* isBind;
@property (nonatomic,strong) NSString* userTalkCode;
@property (nonatomic,strong) NSString* deviceInfo;
@property (nonatomic,strong) NSString* version;
@property (nonatomic,strong) NSString* disabled;
@property (nonatomic,strong) NSString* createBy;
@property (nonatomic,strong) NSString* createTime;
@property (nonatomic,strong) NSString* modifyBy;
@property (nonatomic,strong) NSString* modifyTime;
@property (nonatomic,strong) NSString* language;
@property (nonatomic,strong) NSString* area;
@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* friendSupport;
@property (nonatomic,strong) NSString* ucode;
@property (nonatomic,strong) NSString* lktMemberUcode;
@property (nonatomic,strong) NSString* isRecomment;
@property (nonatomic,strong) NSString* recommentVol;

@end

//用户验证信息
@interface UserVerifMsgInfo : ParseDictionaryData

@property (nonatomic,assign) UNDWORD _id;
@property (nonatomic,retain) NSString* msgId;
@property (nonatomic,retain) NSString* mobile;
@property (nonatomic,retain) NSString* friendMobile;
@property (nonatomic,retain) NSString* requestContent;
@property (nonatomic,retain) NSNumber* status;
@property (nonatomic,retain) NSNumber* disabled;
@property (nonatomic,retain) NSString* createBy;
@property (nonatomic,retain) NSString* createTime;
@property (nonatomic,retain) NSString* modifyBy;
@property (nonatomic,retain) NSString* modifytime;

@end

//用户头像昵称信息
@interface UserNickImgInfo : ParseDictionaryData

@property (nonatomic,assign) UNDWORD _id;
@property (nonatomic,retain) NSString* mobile;
@property (nonatomic,retain) NSString* nickName;
@property (nonatomic,retain) NSString* headImg;
@property (nonatomic,retain) NSString* score;
@property (nonatomic,retain) NSString* status;

@end

//好友饮水详情
@interface FriendVolumeDetail : ParseDictionaryData

@property (nonatomic,assign) UNDWORD _id;
@property (nonatomic,retain) NSString* rank;
@property (nonatomic,retain) NSString* userId;
@property (nonatomic,retain) NSString* volume;
@property (nonatomic,retain) NSString* nickName;
@property (nonatomic,retain) NSString* icon;
@property (nonatomic,retain) NSString* score;

@end














