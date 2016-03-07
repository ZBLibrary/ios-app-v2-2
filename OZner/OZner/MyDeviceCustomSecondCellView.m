//
//  MyDeviceCustomSecondCellView.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/25.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "MyDeviceCustomSecondCellView.h"

@implementation MyDeviceCustomSecondCellView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 33*(SCREEN_HEIGHT/667.0), frame.size.width, 14*(SCREEN_HEIGHT/667.0))];
        label.font = [UIFont systemFontOfSize:14.0*(SCREEN_HEIGHT/667.0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0];
        self.titleLabe = label;
        [self addSubview:label];
        
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake((frame.size.width-60)/2, 50, 60, 60)];
        [self addSubview:button];
        self.actionButton = button;
        [button addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)layOutCellView:(NSString*)iconName title:(NSString*)title iconNameSelect:(NSString*)iconNameSelect
{
    self.titleLabe.text = title;
    
    UIImage* img = [UIImage imageNamed:iconName];
    self.actionButton.frame = CGRectMake((self.frame.size.width-img.size.width)/2, self.titleLabe.frame.size.height+self.titleLabe.frame.origin.y+15*(SCREEN_HEIGHT/667.0), img.size.width, img.size.height);
    [self.actionButton setBackgroundImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:[UIImage imageNamed:iconNameSelect] forState:UIControlStateHighlighted];
}

- (void)onAction:(UIButton*)button
{
    if([self.delegate respondsToSelector:@selector(onClickbuttonAction:)])
    {
        [self.delegate onClickbuttonAction:button];
    }
}

@end
