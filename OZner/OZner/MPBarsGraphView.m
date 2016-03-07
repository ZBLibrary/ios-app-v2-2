//
//  MPBarsGraphView.m
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPBarsGraphView.h"

@implementation MPBarsGraphView


- (id)initWithFrame:(CGRect)frame timeType:(int)timeType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        currentTag=-1;
        self.mCurrentType = timeType;
        
        self.topCornerRadius=-1;
        UIView* separator = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-23, self.frame.size.width, 2)];
        [self addSubview:separator];
        separator.backgroundColor = [UIColor colorWithRed:232.0/255 green:242.0/255 blue:254.0/255 alpha:1.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.values.count && !self.waitToUpdate)
    {
        [self addBarsAnimated:shouldAnimate];
        
        [self.graphColor setStroke];
    }
}

- (void)addBarsAnimated:(BOOL)animated{
    
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    if (animated) {
        self.layer.masksToBounds=YES;
    }
    
    CGFloat barWidth=4;
    CGFloat leftDistance = 0 ;
    CGFloat rightDistance = 0;
    if(self.mCurrentType == 0)
    {
        leftDistance = 35;
        rightDistance = 15;
        [self createDay];
    }
    else if (self.mCurrentType == 1)
    {
        leftDistance = 35;
        rightDistance = 15;
        [self createWeek];
    }
    else if(self.mCurrentType == 2)
    {
        leftDistance = 35;
        rightDistance = 15;
        [self createMonth];
    }
    CGFloat radius=barWidth*(self.topCornerRadius >=0 ? self.topCornerRadius : 0.3);
    for (NSInteger i=0;i<self.values.count;i++) {
        
        NSNumber* heigthNum = [self.zongArr objectAtIndex:i];
        CGFloat height=self.frame.size.height-25-[heigthNum intValue];
        
        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom ];
        [button setBackgroundColor:self.graphColor];
        button.frame=CGRectMake(leftDistance+[[self.values objectAtIndex:i] intValue], height, barWidth, [heigthNum intValue]);
        
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = button.bounds;

        
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)].CGPath;

        button.layer.mask=maskLayer;
        button.tag=i;
        [self addSubview:button];
        [buttons addObject:button];
    }
    
    int nCount = 0;
    if(self.mCurrentType == 0)
    {
        nCount = 4;
    }
    else if (self.mCurrentType == 2)
    {
        nCount = (int)self.values.count;
    }
    else
    {
        nCount = 7;
    }
    
    CGFloat distance = (self.width-leftDistance-rightDistance)/(nCount-1);
    for(int i=0;i<nCount;i++)
    {
        UIView*  separatorView = [[UIView alloc]initWithFrame:CGRectMake(leftDistance+(distance)*i, self.frame.size.height-20, 1, 5)];
        separatorView.backgroundColor = [UIColor colorWithRed:232.0/255 green:242.0/255 blue:254.0/255 alpha:1.0];;
        [self addSubview:separatorView];
        
        if(self.mCurrentType == 0)
        {
            [self createDayLabel:(int)i distance:distance leftDistance:leftDistance];
        }
        else if (self.mCurrentType == 1)
        {
            [self createWeekLabel:(int)i distance:distance leftDistance:leftDistance];
        }
        else if (self.mCurrentType == 2)
        {
            [self createMonthLabel:(int)i distance:distance leftDistance:leftDistance];
        }
    }
    shouldAnimate=NO;
}

//创建月
- (void)createMonth
{
    CGFloat font = 10.0;
    NSString* str = @"3000";
    CGSize  size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:0.8];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    UIView* separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
    
    str = @"ml";
    int orignY = size.height;
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, orignY+3, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:0.8];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    
    str = @"2000";
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-23)*0.33, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:0.8];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.origin.y+size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
    
    str = @"1000";
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-23)*0.66, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:0.8];
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
//             NSDate *nowDate = [NSDate date];
//            NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
//            [myDateFormatter setDateFormat:@"MM"];
//            NSString *monthString = [myDateFormatter stringFromDate:nowDate];
//            str = [monthString stringByAppendingString:@"月1日"];
            str=@"1";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            label.frame = CGRectMake(leftDistance+(distance)*index-size.width/2, self.frame.size.height-size.height, size.width, size.height);
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
            //str = @"31";
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
            NSUInteger numberOfDaysInMonth = range.length;
            str = [NSString stringWithFormat:@"%lu",(unsigned long)numberOfDaysInMonth];
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            label.frame = CGRectMake(leftDistance+(distance)*(index+27)-size.width/2-14, self.frame.size.height-size.height, size.width, size.height);
            
            break;
        }
            
        default:
            break;
    }
    label.text = str;
    
    label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:0.6];
}

//创建zhou
- (void)createWeek
{
    CGFloat font = 10.0;
    NSString* str = @"3000";
    CGSize  size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    UIView* separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
    
    str = @"ml";
    int orignY = size.height;
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, orignY+3, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    
    str = @"2000";
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-23)*0.33, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.origin.y+size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
    
    str = @"1000";
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-23)*0.66, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.origin.y+size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
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
    label.frame = CGRectMake(leftDistance+(distance)*index-size.width/2, self.frame.size.height-size.height, size.width, size.height);
    label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:0.6];
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
            str = @"23h";
            size = [str boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
            
            break;
        }
            
        default:
            break;
    }
    label.text = str;
    label.frame = CGRectMake(leftDistance+(distance)*index-size.width/2, self.frame.size.height-size.height, size.width, size.height);
    label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:0.6];
}

//创建日
- (void)createDay
{
    CGFloat font = 10.0;
    NSString* str = @"500";
    CGSize  size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    UIView* separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
    
    str = @"ml";
    int orignY = size.height;
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, orignY+3, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    
    str = @"300";
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-23)*0.4, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.origin.y+size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
    
    str = @"100";
    size = [str boundingRectWithSize:CGSizeMake(100, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-23)*0.8, size.width, size.height)];
    label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
    label.text = str;
    label.font = [UIFont systemFontOfSize:font];
    [self addSubview:label];
    
    separatorView = [[UIView alloc]initWithFrame:CGRectMake(size.width+5, label.frame.origin.y+size.height/2-0.5, self.frame.size.width-size.width-5, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self addSubview:separatorView];
}

- (CGFloat)animationDuration{
    return _animationDuration>0.0 ? _animationDuration : .25;
}

- (void)animate{
    
    self.waitToUpdate=NO;
    
    shouldAnimate=false;
    
    [self setNeedsDisplay];
}







@end
