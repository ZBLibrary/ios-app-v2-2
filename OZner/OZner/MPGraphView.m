//
//  MPGraphView.m
//
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPGraphView.h"
#import "UIBezierPath+curved.h"


@implementation MPGraphView


+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame timeType:(int)timeType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.mCurrentType = timeType;
        currentTag=-1;
        UIView* separator = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-23-44, self.frame.size.width, 2)];
        [self addSubview:separator];
        separator.backgroundColor = [UIColor colorWithRed:232.0/255 green:242.0/255 blue:254.0/255 alpha:1.0];
        float leftDistance = 14*(SCREEN_WIDTH/375.0);
        if (timeType != 28) {//28 表示水探头页面
            
            UIView* circleView = [[UIView alloc]initWithFrame:CGRectMake(0, separator.frame.origin.y+separator.frame.size.height+23+15*(SCREEN_HEIGHT/667.0), 11, 11)];
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = circleView.frame.size.width/2;
            circleView.layer.borderColor = [UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:1.0].CGColor;
            circleView.layer.borderWidth = 1;
            [self addSubview:circleView];
            
            NSString* content = @"健康(0%)";
            
            CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 14*(SCREEN_HEIGHT/667.0)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0*(SCREEN_HEIGHT/667.0)]} context:nil].size;
            int orignX = 0;
            float middleDiatance = (SCREEN_WIDTH-leftDistance*2-size.width*3-15-33)/2;
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(circleView.frame.size.width+circleView.frame.origin.x+5, circleView.frame.origin.y-(size.height-circleView.frame.size.height)/2, size.width+20, size.height)];
            label.text = content;
            self.firstLabel = label;
            orignX = size.width+label.frame.origin.x+middleDiatance;
            label.textColor = [UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:1.0];
            label.font = [UIFont systemFontOfSize:14*(SCREEN_HEIGHT/667.0)];
            [self addSubview:label];
            
            circleView = [[UIView alloc]initWithFrame:CGRectMake(orignX, separator.frame.origin.y+separator.frame.size.height+23+15*(SCREEN_HEIGHT/667.0), 11, 11)];
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = circleView.frame.size.width/2;
            circleView.layer.borderColor = [UIColor colorWithRed:125.0/255 green:68.0/255 blue:231.0/255 alpha:1.0].CGColor;
            circleView.layer.borderWidth = 1;
            [self addSubview:circleView];
            
            content = @"一般(0%)";
            size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 14*(SCREEN_HEIGHT/667.0)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0*(SCREEN_HEIGHT/667.0)]} context:nil].size;
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(circleView.frame.size.width+circleView.frame.origin.x+5, circleView.frame.origin.y-(size.height-circleView.frame.size.height)/2, size.width+20, size.height)];
            self.secondLabel = label;
            label.text = content;
            orignX = size.width+label.frame.origin.x+middleDiatance;
            label.textColor = [UIColor colorWithRed:125.0/255 green:68.0/255 blue:231.0/255 alpha:1.0];
            label.font = [UIFont systemFontOfSize:14*(SCREEN_HEIGHT/667.0)];
            [self addSubview:label];
            
            circleView = [[UIView alloc]initWithFrame:CGRectMake(orignX, separator.frame.origin.y+separator.frame.size.height+23+15*(SCREEN_HEIGHT/667.0), 11, 11)];
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = circleView.frame.size.width/2;
            circleView.layer.borderColor = [UIColor colorWithRed:242.0/255 green:98.0/255 blue:100.0/255 alpha:1.0].CGColor;
            circleView.layer.borderWidth = 1;
            [self addSubview:circleView];
            
            content = @"较差(0%)";
            size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 14*(SCREEN_HEIGHT/667.0)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0*(SCREEN_HEIGHT/667.0)]} context:nil].size;
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(circleView.frame.size.width+circleView.frame.origin.x+5, circleView.frame.origin.y-(size.height-circleView.frame.size.height)/2, size.width+20, size.height)];
            label.text = content;
            self.thirdLabel = label;
            orignX = size.width+label.frame.origin.x+middleDiatance;
            label.textColor = [UIColor colorWithRed:242.0/255 green:98.0/255 blue:100.0/255 alpha:1.0];
            label.font = [UIFont systemFontOfSize:14*(SCREEN_HEIGHT/667.0)];
            [self addSubview:label];
        }
        
        
        [self createMonth];
        
        
        leftDistance = 35;
        CGFloat rightDistance = 15;
        int nCount = 0;
        if(self.mCurrentType == 0)
        {
            nCount = 4;
        }
        else if(self.mCurrentType == 1)
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
            UIView*  separatorView = [[UIView alloc]initWithFrame:CGRectMake(leftDistance+(distance)*i, self.frame.size.height-20-44, 1, 5)];
            separatorView.backgroundColor = [UIColor colorWithRed:232.0/255 green:242.0/255 blue:254.0/255 alpha:1.0];;
            [self addSubview:separatorView];
            
            if(self.mCurrentType == 0)
            {
                [self createDayLabel:(int)i distance:distance leftDistance:leftDistance];
            }
            else if(self.mCurrentType == 1)
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
        [fill addLineToPoint:CGPointMake(p2.x, self.frame.size.height-23-44)];
        [fill addLineToPoint:CGPointMake(p1.x, self.frame.size.height-23-44)];
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
    pathLayer.strokeColor = [UIColor colorWithRed:125.0/255 green:68.0/255 blue:231.0/255 alpha:1.0].CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1;
    pathLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:pathLayer];
}

- (void)createMonth
{
    CGFloat font = 10.0;
    NSString* str = @"较差";
    CGSize  size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    UIView* separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
    
    
    str = @"一般";
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-23-44)*0.33, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.origin.y+size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
    
    str = @"健康";
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-23-44)*0.66, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.origin.y+size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
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
            label.frame = CGRectMake(leftDistance+(distance)*index-size.width/2, self.frame.size.height-size.height-44, size.width, size.height);
            self.currentMonthLabel = label;
            break;
        }
        case 1:
        {
            str = @"11";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            label.frame = CGRectMake(leftDistance+(distance)*(index+9)-size.width/2, self.frame.size.height-size.height-44, size.width, size.height);
            break;
        }
        case 2:
        {
            
            str = @"21";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            label.frame = CGRectMake(leftDistance+(distance)*(index+18)-size.width/2, self.frame.size.height-size.height-44, size.width, size.height);
            break;
        }
        case 3:
        {
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
            NSUInteger numberOfDaysInMonth = range.length;
            str = [NSString stringWithFormat:@"%lu",(unsigned long)numberOfDaysInMonth];
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            label.frame = CGRectMake(leftDistance+(distance)*(index+27)-size.width/2, self.frame.size.height-size.height-44, size.width, size.height);
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
            str = @"周一";
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
    label.frame = CGRectMake(leftDistance+(distance)*index-size.width/2, self.frame.size.height-size.height-44, size.width, size.height);
    label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
}

- (void)createDayLabel:(int)index distance:(CGFloat)distance leftDistance:(CGFloat)leftDistance
{
    UILabel* label = [[UILabel alloc]init];
    NSString* str;
    CGSize size;
    switch (index)
    {
        case 0:
        {
            str = @"0h";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            break;
        }
        case 1:
        {
            str = @"8h";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            break;
        }
        case 2:
        {
            str = @"16h";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            break;
        }
        case 3:
        {
            str = @"24h";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            
            break;
        }
            
        default:
            break;
    }
    label.text = str;
    label.frame = CGRectMake(leftDistance+(distance)*index-size.width/2, self.frame.size.height-size.height-44, size.width, size.height);
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
        [path addLineToPoint:CGPointMake(last.x,self.height-23-44)];
        [path addLineToPoint:CGPointMake(first.x,self.height-23-44)];
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
    return CGPointMake(35+heng.floatValue, self.frame.size.height-23-44-zong.floatValue);
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
