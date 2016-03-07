//
//  LoginManager.h
//  UMarket
//
//  Created by 孙 林林 on 13-8-22.
//  Copyright (c) 2013年 王 家振. All rights reserved.
//

#import <Foundation/Foundation.h>

#define keySessionToken         @"sessionToken"
#define keyDisplayName          @"displayName"
#define keyPassword             @"password"
#define keyUserID               @"userID"
#define keyLoginName            @"loginName"
#define keyLabel                @"label"
#define keyAvataurl             @"avataurl"
#define keyGender               @"gender"


#define ACHIVER_SIZE    128

#define ACHIVER_FILE    @"userinfo_achiver"

@interface LoginManager : NSObject
{
    LoginUserInfo* mLoginInfo;
}

@property (nonatomic,retain) LoginUserInfo* loginInfo;
@property (nonatomic,assign) BOOL isEnterBackGround;

//保存过滤关键字的数组
@property (nonatomic,retain) NSArray* keyWordArr;

+(LoginManager*)loginInstance;
+ (NSArray*)gainKeyWordArr:(NSString*)fileName;

//编码
- (void) encodeParamObject;
//解码
- (void) decodeParamObject;

@end
