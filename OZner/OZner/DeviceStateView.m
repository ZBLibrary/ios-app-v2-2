//
//  DeviceStateView.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/29.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "DeviceStateView.h"

@implementation DeviceStateView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIImageView* imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:@"icon_state_circle.png"];
        self.circleImgView = imgView;
        [self addSubview:imgView];
        
        self.angle = 0;
        self.isRunning = FALSE;
        
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithRed:59.0/255 green:113.0/255 blue:223.0/255 alpha:1.0];
        label.font = [UIFont systemFontOfSize:12.0];
        self.contentLabel = label;
        [self addSubview:label];
    }
    
    return self;
}

- (void)layOUtCircleView:(NSString*)content state:(int)state
{
    CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    if(state == 0)
    {
        self.circleImgView.frame = CGRectMake((SCREEN_WIDTH-15-5-size.width)/2, 0, 15, 15);
        self.circleImgView.image = [UIImage imageNamed:@"icon_state_circle.png"];
    }
    else if(state == 1)
    {
        self.circleImgView.frame = CGRectMake((SCREEN_WIDTH-12-5-size.width)/2, 1.5, 12, 12);
        self.circleImgView.image = [UIImage imageNamed:@"icon_state_tanhao.png"];
    }
    
    self.contentLabel.frame = CGRectMake(self.circleImgView.frame.origin.x+self.circleImgView.frame.size.width+5, 0, size.width+1, 15);
    self.contentLabel.text = content;
}

- (void)startAnimation
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.05];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    
    self.circleImgView.transform = CGAffineTransformMakeRotation(self.angle * (M_PI /180.0f));
    
    [UIView commitAnimations];
}

-(void)endAnimation
{
    if(self.isRunning)
    {
        self.angle += 15;
        
        [self startAnimation];
    }
}


@end
