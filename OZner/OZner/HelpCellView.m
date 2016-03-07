//
//  HelpCellView.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-11-25.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "HelpCellView.h"

@implementation HelpCellView
@synthesize experienceDelegate;

- (id)initWithFrame:(CGRect)frame nIndex:(int)nIndex
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSString* imageName = [NSString stringWithFormat:@"new_help_%d",nIndex];
        imageView.image = [UIImage imageNamed:imageName];
        
        [self addSubview:imageView];
        [imageView release];
        
        [self setSelfBackGround:nIndex];
        //添加立即体验按钮
        
//        for (int i=0; i<3; i++)
//        {
//            UIImageView* circleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-70)/2+i*20, [UIScreen mainScreen].bounds.size.height-180*(SCREEN_HEIGHT/667.0), 10, 10)];
//            
//            if(i==nIndex)
//            {
//                circleImgView.image = [UIImage imageNamed:@"dot_guide_2.png"];
//            }
//            else
//            {
//                circleImgView.image = [UIImage imageNamed:@"dot_guide_1.png"];
//            }
//            
//            [self addSubview:circleImgView];
//            [circleImgView release];
//        }
    }
    
    return self;
}

- (void)setSelfBackGround:(int)nIndex
{
    self.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0];
}

- (void)onAction
{
    if([self.experienceDelegate respondsToSelector:@selector(onClickExperienceAction)])
    {
        [self.experienceDelegate onClickExperienceAction];
    }
}

@end
