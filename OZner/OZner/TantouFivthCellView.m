//
//  TantouFivthCellView.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/14.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "TantouFivthCellView.h"

@implementation TantouFivthCellView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-76)/2, 0, 76, 76)];
        self.iconImgView = imgView;
        [self addSubview:imgView];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, frame.size.width, 12)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:58.0/255 green:58.0/255 blue:58.0/255 alpha:1.0];
        self.firstLabel = label;
        [self addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 117, frame.size.width, 12)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:58.0/255 green:58.0/255 blue:58.0/255 alpha:1.0];
        self.secodLabel = label;
        [self addSubview:label];
    }
    
    return self;
}
@end
