//
//  MPGraphViewzb.m
//  OZner
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

//
//  MPGraphView.m
//
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "waterReplenishMPGraphView_EN.h"
#import "UIBezierPath+curved.h"


@implementation waterReplenishMPGraphView_EN


+ (Class)layerClass
{
    return [CAShapeLayer class];
}
//timeType :0 周 1月
- (id)initWithFrame:(CGRect)frame timeType:(int)timeType IsBadTds:(BOOL)IsBadTds
{
    self = [super initWithFrame:frame];
    self.isBadTds=IsBadTds;

    if (self)
    {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.mCurrentType = timeType;
        currentTag=-1;
        UIView* separator = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-23, self.frame.size.width, 2)];
        [self addSubview:separator];
        separator.backgroundColor = [UIColor colorWithRed:232.0/255 green:242.0/255 blue:254.0/255 alpha:1.0];
        float leftDistance = 14*(SCREEN_WIDTH/375.0);
        
        [self createLine];
        
        leftDistance = 35;
        CGFloat rightDistance = 15;
        int nCount = 0;
        if(self.mCurrentType == 0)
        {
            nCount = 7;
        }
        else
        {
            nCount = 31;
        }
        CGFloat distance = (self.width-leftDistance-rightDistance)/(nCount-1);
        for (NSInteger i=0;i<nCount;i++)
        {
            UIView*  separatorView = [[UIView alloc]initWithFrame:CGRectMake(leftDistance+(distance)*i, self.frame.size.height-20, 1, 5)];
            separatorView.backgroundColor = [UIColor colorWithRed:232.0/255 green:242.0/255 blue:254.0/255 alpha:1.0];;
            [self addSubview:separatorView];
            
            if(self.mCurrentType == 0)
            {
                [self createWeekLabel:(int)i distance:distance leftDistance:leftDistance];
            }
            else
            {
                [self createMonthLabel:(int)i distance:distance leftDistance:leftDistance];
            }
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)stroke:(CGRect)frame color:(NSString*)color fillColor:(UIColor*)fillColor orignY:(float)orignY count:(int)count
{
    UIBezierPath* fill = [UIBezierPath bezierPath];
    fill.lineCapStyle = kCGLineCapRound; //线条拐角
    fill.lineJoinStyle = kCGLineCapRound; //终点处理
    for(int i=0;i<self.values.count-1;i++)
    {
        CGPoint p1 = [self pointAtIndex:i];
        CGPoint p2 = [self pointAtIndex:i+1];
        
        [fill moveToPoint:p1];
        [fill addLineToPoint:p2];
        [fill addLineToPoint:CGPointMake(p2.x, self.frame.size.height-23)];
        [fill addLineToPoint:CGPointMake(p1.x, self.frame.size.height-23)];
    }
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    for(int i=0;i<self.values.count-1;i++)
    {
        CGPoint p1 = [self pointAtIndex:i];
        
        CGPoint p2 = [self pointAtIndex:i+1];
        
        [path moveToPoint:p1];
        [path addLineToPoint:p2];
    }
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.frame = self.bounds;
    fillLayer.bounds = self.bounds;
    fillLayer.path = fill.CGPath;
    fillLayer.lineWidth = 0;
    fillLayer.lineJoin = kCALineJoinRound;
    self.fillColors=self.isBadTds==false ? @[
        [UIColor colorWithRed:178.0/255 green:65.0/255 blue:160.0/255 alpha:0.3],
        [UIColor colorWithRed:178.0/255 green:65.0/255 blue:160.0/255 alpha:0.2],
        [UIColor colorWithRed:178.0/255 green:65.0/255 blue:160.0/255 alpha:0.1]] : @[
        [UIColor colorWithRed:42.0/255 green:132.0/255 blue:238.0/255 alpha:0.3],
        [UIColor colorWithRed:42.0/255 green:132.0/255 blue:238.0/255 alpha:0.2],
        [UIColor colorWithRed:42.0/255 green:132.0/255 blue:238.0/255 alpha:0.1]
                                                                                                                            ];
    if(self.fillColors.count > 0)
    {
        NSMutableArray *colors=[[NSMutableArray alloc] initWithCapacity:self.fillColors.count];
        
        for (UIColor* color in self.fillColors)
        {
            if ([color isKindOfClass:[UIColor class]])
            {
                [colors addObject:(id)[color CGColor]];
            }
            else
            {
                [colors addObject:(id)color];
            }
        }
        self.fillColors=colors;
    }
    
    CAGradientLayer* layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = self.fillColors;
    layer.mask = fillLayer;
    [self.layer addSublayer:layer];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    pathLayer.bounds = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = self.isBadTds==false ? [UIColor colorWithRed:178.0/255 green:65.0/255 blue:160.0/255 alpha:1.0].CGColor:[UIColor colorWithRed:42.0/255 green:132.0/255 blue:238.0/255 alpha:1.0].CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1;
    pathLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:pathLayer];
}

- (void)createLine
{
    CGFloat font = 10.0;
    for (int i=0; i<5; i++) {
        NSString* str = [NSString stringWithFormat:@"%d",100-20*i]; //@"较差";
        CGSize  size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, i*(self.frame.size.height-23)/5, size.width, size.height)];
        label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
        label.text = str;
        label.font = [UIFont systemFontOfSize:font];
        [self addSubview:label];
        
        UIView* separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.origin.y+size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
        separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:0.7];
        [self addSubview:separatorView];
        //安全线
        if (i==3) {
            UIView* separatorView1 = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.origin.y+size.height/2-0.5+15, self.frame.size.width-size.width-5, 1)];
            separatorView1.backgroundColor = [UIColor colorWithRed:78.0/255 green:184.0/255 blue:85.0/255 alpha:0.3];
            [self addSubview:separatorView1];
        }
    }
    
    
    
    

}

- (void)createMonthLabel:(int)index distance:(CGFloat)distance leftDistance:(CGFloat)leftDistance
{
    UILabel* label = [[UILabel alloc]init];
    NSString* str;
    CGSize size;
    switch (index)
    {
        case 0:
        {
            str = @"1";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            label.frame = CGRectMake(leftDistance+(distance)*index-size.width/2, self.frame.size.height-size.height, size.width, size.height);
            self.currentMonthLabel = label;
            break;
        }
        case 1:
        {
            str = @"11";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            label.frame = CGRectMake(leftDistance+(distance)*(index+9)-size.width/2, self.frame.size.height-size.height, size.width, size.height);
            break;
        }
        case 2:
        {
            
            str = @"21";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            label.frame = CGRectMake(leftDistance+(distance)*(index+18)-size.width/2, self.frame.size.height-size.height, size.width, size.height);
            break;
        }
        case 3:
        {
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
            NSUInteger numberOfDaysInMonth = range.length;
            str = [NSString stringWithFormat:@"%lu",(unsigned long)numberOfDaysInMonth];
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            label.frame = CGRectMake(leftDistance+(distance)*(index+27)-size.width/2, self.frame.size.height-size.height, size.width, size.height);
            self.endMonthLabel = label;
            
            break;
        }
            
        default:
            break;
    }
    label.text = str;
    
    label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
}

- (void)createWeekLabel:(int)index distance:(CGFloat)distance leftDistance:(CGFloat)leftDistance
{
    UILabel* label = [[UILabel alloc]init];
    NSString* str;
    CGSize size;
    switch (index)
    {
        case 0:
        {
            str = loadLanguage(@"周一");
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            break;
        }
        case 1:
        {
            str = @"周二";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            break;
        }
        case 2:
        {
            str = @"周三";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            break;
        }
        case 3:
        {
            str = @"周四";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            
            break;
        }
        case 4:
        {
            str = @"周五";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            break;
        }
        case 5:
        {
            str = @"周六";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            break;
        }
        case 6:
        {
            str = @"周日";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            break;
        }
            
        default:
            break;
    }
    label.text = str;
    label.frame = CGRectMake(leftDistance+(distance)*index-size.width/2.0, self.frame.size.height-size.height, size.width, size.height);
    label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
}


- (UIBezierPath *)graphPathFromPoints{
    
    BOOL fill=self.fillColors.count;
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    
    for (UIButton* button in buttons)
    {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    
    for (NSInteger i=0;i<points.count;i++)
    {
        CGPoint point=[self pointAtIndex:i];
        
        if(i==0)
            [path moveToPoint:point];
        
        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(25, 25)];
        [button setBackgroundColor:self.graphColor];
        button.layer.cornerRadius=3;
        button.frame=CGRectMake(0, 0, 6, 6);
        button.center=point;
        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [self addSubview:button];
        
        [buttons addObject:button];
        
        [path addLineToPoint:point];
    }
    
    if (self.curved)
    {
        path=[path smoothedPathWithGranularity:20];
    }
    
    if(fill)
    {
        
        CGPoint last=[self pointAtIndex:points.count-1];
        CGPoint first=[self pointAtIndex:0];
        [path addLineToPoint:CGPointMake(last.x,self.height-23)];
        [path addLineToPoint:CGPointMake(first.x,self.height-23)];
        [path addLineToPoint:first];
    }
    
    if (fill)
    {
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        
        gradient.mask=maskLayer;
    }
    
    path.lineWidth=self.lineWidth ? self.lineWidth : 1;
    
    
    return path;
}

- (CGPoint)pointAtIndex:(NSInteger)index{
    
    NSNumber* heng = [self.values objectAtIndex:index];
    NSNumber* zong = [self.zongArr objectAtIndex:index];
    return CGPointMake(35+heng.floatValue, self.frame.size.height-23-zong.floatValue);
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    
    self.waitToUpdate=NO;
    gradient.hidden=0;
    
}

- (void)displayPoint:(UIButton *)button
{
    [UIView animateWithDuration:.2 animations:^{
        button.transform=CGAffineTransformMakeScale(1, 1);
    }];
}

#pragma mark Setters
-(void)setCurved:(BOOL)curved{
    _curved=curved;
    [self setNeedsDisplay];
}

@end

