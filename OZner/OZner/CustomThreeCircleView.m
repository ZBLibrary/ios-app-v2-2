//
//  CustomThreeCircleView.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/7.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "CustomThreeCircleView.h"

@implementation CustomThreeCircleView

- (id)initWithFrame:(CGRect)frame high:(double)high middle:(double)middle low:(double)low type:(int)type
{
    if(self = [super initWithFrame:frame])
    {
        self.highScale = low;
        self.middleScale = middle;
        self.lowScale = high;
        self.backgroundColor = [UIColor clearColor];
        NSString* title = loadLanguage(@"偏烫");
        if(type == 0)
        {
            title =loadLanguage(@"较差");
        }
        NSString* str = [NSString stringWithFormat:@"%@ %d%%",title,(int)(high*100)];
        CGSize size = [str boundingRectWithSize:CGSizeMake(self.frame.size.width/2, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-size.width-5, 0, size.width, 10)];
        label.textColor = [UIColor colorWithRed:241.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
        
        title =loadLanguage(@"适中");
        if(type == 0)
        {
            title =loadLanguage(@"一般");
        }

        str = [NSString stringWithFormat:@"%@ %d%%",title,(int)(middle*100)];
        size = [str boundingRectWithSize:CGSizeMake(self.frame.size.width/2, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-size.width-5, 15, size.width, size.height)];
        label.textColor = [UIColor colorWithRed:128.0/255 green:94.0/255 blue:230.0/255 alpha:1.0];
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
        
        title = loadLanguage(@"偏凉");
        if(type == 0)
        {
            title = loadLanguage(@"健康");
        }
        str = [NSString stringWithFormat:@"%@ %d%%",title,(int)(low*100)];
        size = [str boundingRectWithSize:CGSizeMake(self.frame.size.width/2, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-size.width-5, 30, size.width, 10)];
        label.textColor = [UIColor colorWithRed:70.0/255 green:143.0/255 blue:241.0/255 alpha:1.0];
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, size.height / 2 + 35, 30, 50)];
        imageview.image = [UIImage imageNamed:@"zuo1"];
        [self addSubview:imageview];
        
        UIImageView * twoimageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-30 , size.height / 2 + 35, 30, 50)];
        twoimageview.image = [UIImage imageNamed:@"you1"];
        [self addSubview:twoimageview];
        
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    int high = self.lowScale * 360;
    if(high > 270)
    {
        high = 270;
    }
    int middle = self.middleScale*360;
    if(middle > 270)
    {
        middle = 270;
    }
    int low = self.highScale*360;
    if(low > 270)
    {
        low = 270;
    }
   
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    
    //设置画笔宽度
    CGContextSetLineWidth(context, 10);
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:236.0/255 green:240.0/255 blue:249.0/255  alpha:1.0].CGColor);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2 ,self.frame.size.height/2-5 ,(270*M_PI/180),(180*M_PI/180), 0);
    
    CGContextStrokePath(context);

    context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    //设置画笔宽度
    CGContextSetLineWidth(context, 10);
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:241.0/255 green:102.0/255 blue:102.0/255 alpha:1.0].CGColor);
    if(high>0 && high  <= 90)
    {
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2 ,self.frame.size.height/2-5 ,(270*M_PI/180),((270+high)*M_PI/180) , 0);
    }
    else
    {
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2 ,self.frame.size.height/2-5 ,(270*M_PI/180),((high-90)*M_PI/180) , 0);
    }
    CGContextStrokePath(context);
    
    context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    //设置画笔宽度
    CGContextSetLineWidth(context, 10);
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:236.0/255 green:240.0/255 blue:249.0/255 alpha:1.0].CGColor);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2 ,self.frame.size.height/2-20 ,(270*M_PI/180),(180*M_PI/180), 0);
    CGContextStrokePath(context);
    
    context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    //设置画笔宽度
    CGContextSetLineWidth(context, 10);
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:128.0/255 green:94.0/255 blue:230.0/255 alpha:1.0].CGColor);
    if(middle > 0 && middle <=90 )
    {
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2 ,self.frame.size.height/2-20 ,(270*M_PI/180),((270+middle)*M_PI/180) , 0);
    }
    else
    {
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2 ,self.frame.size.height/2-20 ,(270*M_PI/180),((middle-90)*M_PI/180) , 0);
    }
    CGContextStrokePath(context);
    
    context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    //设置画笔宽度
    CGContextSetLineWidth(context, 10);
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:236.0/255 green:240.0/255 blue:249.0/255 alpha:1.0].CGColor);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-35 ,(270*M_PI/180),(180*M_PI/180) , 0);
    CGContextStrokePath(context);
    
    context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    //设置画笔宽度
    CGContextSetLineWidth(context, 10);
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:70.0/255 green:143.0/255 blue:241.0/255 alpha:1.0].CGColor);
    if(low > 0 && low <= 90 )
    {
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-35 ,(270*M_PI/180),((270+low)*M_PI/180) , 0);
    }
    else
    {
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,self.frame.size.height/2-35 ,(270*M_PI/180),((low-90)*M_PI/180) , 0);
    }
    CGContextStrokePath(context);
}

@end
