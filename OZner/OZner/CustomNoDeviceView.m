//
//  CustomNoDeviceView.m
//  OZner
//
//  Created by sunlinlin on 16/1/12.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import "CustomNoDeviceView.h"

@implementation CustomNoDeviceView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39*(SCREEN_HEIGHT/667.0), SCREEN_WIDTH, 17*(SCREEN_HEIGHT/667.0))];
        label.text= loadLanguage(@"请添加设备");
        label.textColor = [UToolBox colorFromHexRGB:@"3b536e"];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height+8*(SCREEN_HEIGHT/667.0), SCREEN_WIDTH, 17*(SCREEN_HEIGHT/667.0))];
        label.text= loadLanguage(@"开启浩泽智能生活");
        label.textColor = [UToolBox colorFromHexRGB:@"3b536e"];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-144*(SCREEN_WIDTH/375.0))/2, label.frame.origin.y+label.frame.size.height+39*(SCREEN_HEIGHT/667.0), 144*(SCREEN_WIDTH/375.0), 39*(SCREEN_HEIGHT/667.8))];
        [button addTarget:self action:@selector(onAction) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 20*(SCREEN_WIDTH/375.0);
        button.layer.borderColor = [UToolBox colorFromHexRGB:@"3c89f2"].CGColor;
        button.layer.borderWidth = 1;
        [button setTitle:loadLanguage(@"添加设备") forState:UIControlStateNormal];
        [button setTitleColor:[UToolBox colorFromHexRGB:@"3c89f2"] forState:UIControlStateNormal];
       button.titleLabel.font = [UIFont systemFontOfSize:17*(SCREEN_HEIGHT/667.0)];
        [self addSubview:button];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)onAction
{
    if([self.delegate respondsToSelector:@selector(customNodeviceAddDeviceAction)])
    {
        [self.delegate customNodeviceAddDeviceAction];
    }
}

@end
