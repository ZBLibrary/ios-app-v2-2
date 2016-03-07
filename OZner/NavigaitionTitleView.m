//
//  NavigaitionTitleView.m
//  VirtualLovers
//
//  Created by shengjoy_iOS on 15/4/20.
//  Copyright (c) 2015年 sunlinlin. All rights reserved.
//

#import "NavigaitionTitleView.h"

@implementation NavigaitionTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = frame;
        self.navTitleLabel = label;
        [self addSubview:label];
    }
    return self;
}

-(void)dealloc
{
    self.navTitleLabel = nil;
}


@end
