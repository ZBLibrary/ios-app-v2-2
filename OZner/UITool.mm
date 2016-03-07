//
//  UITool.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-14.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "UITool.h"
#import "NavigaitionTitleView.h"

@implementation UITool

+ (void) showSampleMsg:(NSString *)title message:(NSString *) strMsg
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:strMsg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

// 不需要委托alert
+ (void) alertNotifyError:(NSString* )title contentStr:(NSString* )content thread:(BOOL)isOnMainThread
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:content
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    if (isOnMainThread)
    {
        [alertView show];
    }
    else
    {
        [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    [alertView release];
}

// 只要一个确定按钮
+ (void) alertNotify:(NSString* )title contentStr:(NSString* )content thread:(BOOL)isOnMainThread
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    if (isOnMainThread)
    {
        [alertView show];
    }
    else
    {
        [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    [alertView release];
}

// 有确认，取消两个按钮的Alert
+ (void) alertOkAndCancel:(NSString* )title contentStr:(NSString* )content delegate:(id)target thread:(BOOL)isOnMainThread
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:content
                                                       delegate:target
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认",nil];
    if (isOnMainThread)
    {
        [alertView show];
    }
    else
    {
        [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    [alertView release];
}

+ (void) alertOkAndCancel:(NSString* )title contentStr:(NSString* )content delegate:(id)target thread:(BOOL)isOnMainThread withTag:(int)tag
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:content
                                                       delegate:target
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认",nil];
    alertView.tag = tag;
    if (isOnMainThread)
    {
        [alertView show];
    }
    else
    {
        [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    [alertView release];
}

// 不需要回调时target设为nil即可
+ (void) showMessage:(NSString* )msg titleStr:(NSString* )title delegate:(id)target
{
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:title message:msg delegate:target cancelButtonTitle:nil otherButtonTitles:@"确定",nil] autorelease];
    [alert show];
}

#pragma mark - 自定义 导航条 按钮
+ (void)customizeNavBar:(UIViewController*)targetView withTitle:(NSString *)title
            haveLButton:(BOOL)bHaveL haveRButton:(BOOL)bHaveR
       normalImageNameL:(NSString*)nmlImgNameL highlightedImageNameL:(NSString*)hltImgNameL buttonNameL:(NSString*)btnNameL
       normanImageNameR:(NSString*)nmlImgNameR highlightedImageNameR:(NSString*)hltImgNameR buttonNameR:(NSString*)btnNameR
{
    // 有左边的按钮
    if (bHaveL)
    {
        // 设置左边按钮
        UIImage *normalImage = [UIImage imageNamed:nmlImgNameL];
        UIImage *scaledImage=[UIImage imageWithCGImage:normalImage.CGImage scale:2 orientation:UIImageOrientationUp];
        normalImage=[scaledImage stretchableImageWithLeftCapWidth:scaledImage.size.width/2 topCapHeight:scaledImage.size.height/2];
        
        UIImage* downImage = [UIImage imageNamed:hltImgNameL];
        UIImage* downScaleImage = [UIImage imageWithCGImage:downImage.CGImage scale:2 orientation:UIImageOrientationUp];
        
        UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, normalImage.size.width-2, normalImage.size.height)];
        [leftButton setTitle:btnNameL forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:BTN_TITLE_SIZE];
        [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        leftButton.titleEdgeInsets=UIEdgeInsetsMake(0, 7, 0, 0);
        [leftButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [leftButton setBackgroundImage:downScaleImage forState:UIControlStateHighlighted];
        [leftButton addTarget:targetView action:@selector(leftBtnMethod) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        targetView.navigationItem.leftBarButtonItem = leftBarItem;
        [leftBarItem release];
        [leftButton release];
    }
    
    // 有右边的按钮
    if (bHaveR)
    {
        // 设置右边按钮
        UIImage* normalImage = [UIImage imageNamed:nmlImgNameR];
        UIImage* scaledImage=[UIImage imageWithCGImage:normalImage.CGImage scale:2 orientation:UIImageOrientationUp];
        normalImage=[scaledImage stretchableImageWithLeftCapWidth:scaledImage.size.width/2 topCapHeight:scaledImage.size.height/2];
        
        UIImage* downImage = [UIImage imageNamed:hltImgNameR];
        UIImage* downScaleImage = [UIImage imageWithCGImage:downImage.CGImage scale:2 orientation:UIImageOrientationUp];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, normalImage.size.width-2, normalImage.size.height);
        [rightBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:downScaleImage forState:UIControlStateHighlighted];
        [rightBtn setTitle:btnNameR forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:BTN_TITLE_SIZE];
        rightBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 4, 0, 0);
        [rightBtn addTarget:targetView action:@selector(rightBtnMethod) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        targetView.navigationItem.rightBarButtonItem=rightBarButtonItem;
        [rightBarButtonItem release];
        [rightBtn release];
    }
    
    // 设置导航条标题
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)] autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    targetView.navigationItem.titleView = titleLabel;
}

#pragma mark - 设置导航条, 左边为凌形按钮，右边为长方形按钮
+ (void)customizeNavBar:(UIViewController*)targetView withTitle:(NSString *)title buttonNameL:(NSString*)btnNameL buttonNameR:(NSString*)btnNameR
{
    // 有左边的按钮
    if (btnNameL)
    {
        // ------ 改
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 60, 25);
        leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [leftButton setTitle:btnNameL forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton addTarget:targetView action:@selector(leftBtnMethod) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        targetView.navigationItem.leftBarButtonItem = leftBarItem;
        [leftBarItem release];
    }
    
    // 有右边的按钮
    if (btnNameR)
    {
        // 设置右边按钮
        UIImage* normalImage = [UIImage imageNamed:@"btn_nav_next_normal"];
        UIImage* scaledImage=[UIImage imageWithCGImage:normalImage.CGImage scale:2 orientation:UIImageOrientationUp];
        normalImage=[scaledImage stretchableImageWithLeftCapWidth:scaledImage.size.width/2 topCapHeight:scaledImage.size.height/2];
        
        UIImage* downImage = [UIImage imageNamed:@"btn_nav_next_push.png"];
        UIImage* downScaleImage = [UIImage imageWithCGImage:downImage.CGImage scale:2 orientation:UIImageOrientationUp];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, normalImage.size.width-2, normalImage.size.height);
        [rightBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:downScaleImage forState:UIControlStateHighlighted];
        //加载的是图片
        if ([btnNameR rangeOfString:@".png"].location != NSNotFound)
        {
            UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 29, 25)];
            UIImage* normalImage = [UIImage imageNamed:btnNameR];
            btnImage.image = normalImage;
            btnImage.center = rightBtn.center;
            btnImage.backgroundColor = [UIColor clearColor];
            [rightBtn addSubview:btnImage];
            [btnImage release];
        
        }else{
            [rightBtn setTitle:btnNameR forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:BTN_TITLE_SIZE];
            rightBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 4, 0, 0);
        }        
        [rightBtn addTarget:targetView action:@selector(rightBtnMethod) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        targetView.navigationItem.rightBarButtonItem=rightBarButtonItem;
        [rightBarButtonItem release];
    }
    
    // 设置导航条标题
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)] autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:UIFONT_SYSTERM_DEFAULT_SIZE];
    titleLabel.text = title;
    //targetView.navigationItem.titleView = titleLabel;
    targetView.navigationController.view.backgroundColor = [UIColor whiteColor];
    targetView.navigationItem.title = title; //--- 改
}

- (void)rightBtnMethod
{
    NSLog(@"rightBtnMethod\n");
}

- (void)leftBtnMethod
{
    NSLog(@"leftBtnMethod\n");
}
// 设置导航条,左右都是图片按钮
+ (void)customizeNavBar:(UIViewController* )target withTitle:(NSString* )title buttonImgL:(UIView* )left buttonImgR:(UIView* )right
{
    float w1 = 0;
    float w2 = 0;
    
    target.navigationItem.leftBarButtonItem = nil;
    target.navigationItem.rightBarButtonItem = nil;
    if (left)
    {
        target.navigationItem.leftBarButtonItem.width = left.frame.size.width;
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:left];
        target.navigationItem.leftBarButtonItem = leftItem;
        [leftItem release];
        w1 = left.frame.size.width*2+8;//target.navigationItem.leftBarButtonItem.width;
    }
    
    if (right)
    {
        target.navigationItem.rightBarButtonItem.width = right.frame.size.width;
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
        target.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
        w2 = right.frame.size.width;
    }
   
    if (title)
    {
        //左边默认启示间距8
        NavigaitionTitleView * titleView = [[[NavigaitionTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)]autorelease];
        titleView.navTitleLabel.text = title;
        titleView.navTitleLabel.font = [UIFont systemFontOfSize:UIFONT_SYSTERM_SIZE_LARGER];
        titleView.navTitleLabel.textColor = [UIColor whiteColor];
        if(w1>w2 && w2 == 0)
        {
            titleView.navTitleLabel.frame = CGRectMake(16,0,SCREEN_WIDTH-w1*2, 46);
        }
        else if (w1> w2 && w2>0)
        {
            if(w1 == 62 && w2 == 30)
            {
                titleView.navTitleLabel.frame = CGRectMake(16,0,SCREEN_WIDTH-w1*2, 46);
            }
            else
            {
                titleView.navTitleLabel.frame = CGRectMake(8,0,SCREEN_WIDTH-w1*2, 46);
            }
        }
        else if(w1 < w2)
        {
            if(w1 == 0)
            {
                titleView.navTitleLabel.frame = CGRectMake(34,0,SCREEN_WIDTH-w2*2-16, 46);
            }
            else if (w2 == 65)
            {
                titleView.navTitleLabel.frame = CGRectMake(32,0,SCREEN_WIDTH-w2*2-16, 46);
            }
            else if(w1 == 30 && w2 == 62)
            {
                 titleView.navTitleLabel.frame = CGRectMake(42,0,SCREEN_WIDTH-w2*2-16, 46);
            }
            else if(w1 == 37 && w2 == 62)
            {
                titleView.navTitleLabel.frame = CGRectMake(40,0,SCREEN_WIDTH-w2*2-16, 46);
            }
            else
            {
                titleView.navTitleLabel.frame = CGRectMake(18,0,SCREEN_WIDTH-w2*2-16, 46);
            }
        }
        else if (w1 == w2 && w1 == 0)
        {
             titleView.navTitleLabel.frame = CGRectMake(2,0,SCREEN_WIDTH-w2*2-16, 46);
        }
        else if (w1 == w2 && w1 > 0)
        {
            if(w1 == 62)
            {
                titleView.navTitleLabel.frame = CGRectMake(24,0,SCREEN_WIDTH-w2*2-18, 46);
            }
            else
            {
                titleView.navTitleLabel.frame = CGRectMake(10,0,SCREEN_WIDTH-w2*2-16, 46);
            }
        }
        else if (w1 == w2 && w1 == 30)
        {
            titleView.navTitleLabel.frame = CGRectMake(10,0,SCREEN_WIDTH-w2*2-16, 46);
        }
        else
        {
            titleView.navTitleLabel.frame = CGRectMake(2,0,SCREEN_WIDTH-16, 46);
        }
        target.navigationItem.titleView = titleView;

        [target.navigationItem.titleView setBackgroundColor:[UIColor clearColor]];
        
    }
    //target.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [target setNeedsStatusBarAppearanceUpdate];
}

@end
