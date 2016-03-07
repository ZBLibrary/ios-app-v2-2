//
//  ShareManager.m
//  OZner
//
//  Created by sunlinlin on 16/1/9.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import "ShareManager.h"

static ShareManager* g_StaticManagerInstance = nil;

@implementation ShareManager

+(ShareManager*)shareManagerInstance
{
    if(!g_StaticManagerInstance)
    {
        g_StaticManagerInstance = [[ShareManager alloc] init];
    }
    
    return g_StaticManagerInstance;
}

- (id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}


//分享到微信
- (void)sendShareToWeChat:(enum WXScene)sence urt:(NSString*)url title:(NSString*)title shareImg:(UIImage*)shareImg
{
    if([WXApi isWXAppInstalled])
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        
        [message setThumbImage:[UIImage imageNamed:@"icon85_85.png"]];
        
        WXImageObject* imageObject = [[WXImageObject alloc]init];
        imageObject.imageData = UIImagePNGRepresentation(shareImg);
        message.mediaObject = imageObject;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = sence;
        
        [WXApi sendReq:req];
    }
    else
    {
        [UITool showSampleMsg:@"" message:@"您还没有安装手机微信"];
    }
}

#pragma mark- WXApiDelegate
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    NSLog(@"weixin onResp:(BaseResp*)resp.....\n");
}


@end