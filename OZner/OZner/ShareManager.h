//
//  ShareManager.h
//  OZner
//
//  Created by sunlinlin on 16/1/9.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface ShareManager : NSObject<WXApiDelegate>

+(ShareManager*)shareManagerInstance;
//分享到微信
- (void)sendShareToWeChat:(enum WXScene)sence urt:(NSString*)url title:(NSString*)title shareImg:(UIImage*)shareImg;

@end
