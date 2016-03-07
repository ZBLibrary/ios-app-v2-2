//
//  UINavgationBar+Custom.m
//  BlackRoom

//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "UINavgationBar+Custom.h"

@implementation UINavigationBar (Customized)

-(void)loadNavigationBar
{
    [self setBarTintColor:[UIColor colorWithRed:110.0/255 green:206.0/255 blue:250.0/255 alpha:1.0]];
    //[self setBackgroundImage:[UIImage imageNamed:@"bg_clear_addDevice"] forBarMetrics:UIBarMetricsDefault];
    //self.shadowImage =  [UIImage imageNamed:@"bg_clear_addDevice"];
}

- (void)loadBlackNavgationBar
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [self setBarTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    }
    else
    {
        [self setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    }
}

@end
