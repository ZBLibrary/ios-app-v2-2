//
//  CustomOCCircleView.m
//  OZner
//
//  Created by sunlinlin on 16/1/13.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import "CustomOCCircleView.h"


@implementation CustomOCCircleView

- (id)initWithFrame:(CGRect)frame tdsValue:(int)tdsValue beatValue:(int)beatValue rankValue:(int)rankValue
{
    if(self = [super initWithFrame:frame])
    {
        self.currentTDSValue = tdsValue;
        self.currentDefeatValue = beatValue;
        self.currentRankValue = rankValue;
        self.isFirstLoad=0;
        CGFloat height = SCREEN_HEIGHT/667.0;
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0,44*height,self.frame.size.width,19*height)];
        label.text = loadLanguage(@"水质纯净值TDS");
        self.tdsFirstLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:19*height];
        label.textColor = [UIColor colorWithRed:59.0/255 green:113.0/255 blue:223.0/255 alpha:1.0];
        [self addSubview:label];
        
        UIImageView* stateImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        self.tdsStateImgIview = stateImgView;
        UILabel* stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,59,40,15)];
        self.tdsStateValueLabel = stateLabel;
        NSString* title = loadLanguage(@"暂无");
        self.originalTDSValue=self.currentTDSValue;
        if(self.currentTDSValue > 250)
        {
            
            self.currentTDSValue = 250;
        }
        
        if( self.currentTDSValue > 0)
        {
            stateImgView.hidden = false;
            if (self.currentTDSValue <= tds_good)
            {
                stateImgView.image = [UIImage imageNamed:@"baobiao.png"];
                title = loadLanguage(@"好");
            }
            else if (self.currentTDSValue <= tds_bad)
            {
                stateImgView.image = [UIImage imageNamed:@"yiban.png"];
                title = loadLanguage(@"一般");
            }
            else
            {
                stateImgView.image = [UIImage imageNamed:@"cha.png"];
                title = loadLanguage(@"偏差");
            }
            
            CGSize titleSize = [title boundingRectWithSize:CGSizeMake(self.frame.size.width, 14*height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*height]} context:nil].size;
            stateImgView.frame = CGRectMake((self.frame.size.width-16-titleSize.width-5)/2, label.frame.size.height+label.frame.origin.y+4*height, 16, 16);
            stateLabel.frame = CGRectMake(stateImgView.frame.origin.x+stateImgView.frame.size.width+5, label.frame.size.height+label.frame.origin.y+5*height, 40, 15);
        }
        else
        {
            stateImgView.hidden = true;
            //CGSize titleSize = [title boundingRectWithSize:CGSizeMake(self.frame.size.width, 14*height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*height]} context:nil].size;
            stateLabel.frame = CGRectMake(0, label.frame.size.height+label.frame.origin.y+5*height, 40, 15);
        }
        
        [self addSubview:stateImgView];
        stateLabel.frame=CGRectMake(0,59,50,20);
        stateLabel.text = title;
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.font = [UIFont systemFontOfSize:10];
        stateLabel.textColor = [UIColor colorWithRed:105.0/255 green:163.0/255 blue:237.0/255 alpha:1.0];
        [self addSubview:stateLabel];
        
        UILabel* thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,stateLabel.frame.size.height+stateLabel.frame.origin.y+12*height,self.frame.size.width,48*height)];
        self.tdsLabel = thirdLabel;
        if(self.currentTDSValue/400.0 > 0)
        {
            
            thirdLabel.text = [NSString stringWithFormat:@"%d",(int)self.originalTDSValue];
        }
        else
        {
            thirdLabel.text = loadLanguage(@"暂无");
        }
        
        thirdLabel.textAlignment = NSTextAlignmentCenter;
     
        //thirdLabel.font = [UIFont systemFontOfSize:48*height];Avenir／／STHeitiSC
        thirdLabel.font = [UIFont fontWithName:@".SFUIDisplay-Thin" size:48*height];
        thirdLabel.textColor = [UIColor colorWithRed:59.0/255 green:113.0/255 blue:223.0/255 alpha:1.0];
        [self addSubview:thirdLabel];
        
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0,thirdLabel.frame.origin.y,frame.size.width,thirdLabel.frame.size.height)];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(tdsAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel* fourthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,thirdLabel.frame.size.height+thirdLabel.frame.origin.y+13*height,self.frame.size.width,19*height)];
        fourthLabel.text = loadLanguage(@"击败了0%的用户");
        fourthLabel.hidden=true;
        fourthLabel.textAlignment = NSTextAlignmentCenter;
        fourthLabel.font = [UIFont fontWithName:@".SFUIDisplay-Thin" size:17];// systemFontOfSize:17];
        self.tdsDescLabel = fourthLabel;
        //fourthLabel.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
        [self addSubview:fourthLabel];
        
        self.backgroundColor = [UIColor grayColor];
    }
    
    return self;
}

//点击tdsaction
- (void)tdsAction
{
    if([self.delegate respondsToSelector:@selector(seeTdsDetail)])
    {
        [self.delegate seeTdsDetail];
    }
}

-(void)update
{
    [self setNeedsDisplay];
}

//设置状态值
-(void)setStateValue
{
    self.originalTDSValue = self.currentTDSValue;
    if(self.originalTDSValue>250)
    {
        self.currentTDSValue = 250;
    }
    if(self.originalTDSValue>5000)
    {
        self.currentTDSValue = 0;
    }
    if(self.currentTDSValue > 0)
    {
        CGFloat height = SCREEN_HEIGHT/667.0;
        NSString* title = loadLanguage(@"暂无");
        
        self.tdsStateImgIview.hidden = false;
        self.tdsStateValueLabel.hidden=false;
        if(self.currentTDSValue <= tds_good)
        {
            self.tdsStateImgIview.image = [UIImage imageNamed:@"baobiao.png"];
            title = loadLanguage(@"健康");
        }
        else if (self.currentTDSValue <= tds_bad)
        {
            self.tdsStateImgIview.image = [UIImage imageNamed:@"yiban.png"];
            title = loadLanguage(@"一般");
        }
        else
        {
            self.tdsStateImgIview.image = [UIImage imageNamed:@"cha.png"];
            title = loadLanguage(@"较差");
        }
        
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(self.frame.size.width, 14*height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*height]} context:nil].size;
        self.tdsStateImgIview.frame = CGRectMake((self.frame.size.width-16-titleSize.width-5)/2, self.tdsFirstLabel.frame.size.height+self.tdsFirstLabel.frame.origin.y+4*height, 16, 16);
        self.tdsStateValueLabel.frame = CGRectMake(self.tdsStateImgIview.frame.origin.x+self.tdsStateImgIview.frame.size.width+5, self.tdsFirstLabel.frame.size.height+self.tdsFirstLabel.frame.origin.y+5*height, 40, 15);
        self.tdsStateValueLabel.text = title;
    }
    else
    {
        self.tdsStateImgIview.hidden = true;
        self.tdsStateValueLabel.hidden=true;
        NSString* title = loadLanguage(@"暂无");
        CGFloat height = SCREEN_HEIGHT/667.0;
        //CGSize titleSize = [title boundingRectWithSize:CGSizeMake(self.frame.size.width, 14*height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*height]} context:nil].size;
        self.tdsStateValueLabel.frame = CGRectMake(self.tdsStateImgIview.frame.origin.x+self.tdsStateImgIview.frame.size.width+5, self.tdsFirstLabel.frame.size.height+self.tdsFirstLabel.frame.origin.y+5*height, 40, 15);
        self.tdsStateValueLabel.text = title;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    for(UIView* view in self.subviews)
    {
        if( ![view isKindOfClass:[UILabel class]] &&  ![view isKindOfClass:[UIImageView class]] &&  ![view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    if(self.myLayer)
    {
        [self.myLayer removeFromSuperlayer];
    }
    [self setStateValue];
   
    
    if(self.originalTDSValue > 0 && self.originalTDSValue < 5000)
    {
        self.tdsLabel.text = [NSString stringWithFormat:@"%d",(int)self.originalTDSValue];
        
    }
    else
    {
        self.tdsLabel.text = loadLanguage(@"暂无");
    }
    if(self.currentDefeatValue > 0)
    {
        NSLog(@"%d",self.currentDefeatValue);
        NSLog(@"%d",self.currentRankValue);
        CGFloat per = (CGFloat)((CGFloat)(self.currentDefeatValue-self.currentRankValue)/((CGFloat)self.currentDefeatValue) * 100.0);
       // CGFloat text =
        self.tdsDescLabel.text = [NSString stringWithFormat:@"%@%d%%%@",loadLanguage(@"击败了"),(int)per,loadLanguage(@"的用户")];
        self.tdsDescLabel.hidden=false;
    }
    else
    {
        self.tdsDescLabel.text = loadLanguage(@"击败了0%的用户");
        self.tdsDescLabel.hidden=true;
    }
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    //设置画笔宽度
    CGContextSetLineWidth(context, 2);
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.8].CGColor);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height-20*(SCREEN_HEIGHT/667.0),(self.frame.size.width-15)/2 ,(180*M_PI/180),0 , 0);
    CGContextStrokePath(context);
    
    int radius = (self.frame.size.width-15)/2;
    CGFloat angele = (self.currentTDSValue)/250.0*(180);
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.height-20*SCREEN_HEIGHT/667.0) radius:radius startAngle:180*(M_PI/180) endAngle:(180+angele)*(M_PI/180) clockwise:YES].CGPath;
    arc.lineCap = @"round"; //线条拐角
    arc.fillColor = [UIColor clearColor].CGColor;
    arc.strokeColor = [UIColor purpleColor].CGColor;
    arc.lineWidth = 10;
    if (self.isFirstLoad==0&&self.currentTDSValue>1&&self.isFirstLoad!=1) {
        self.isFirstLoad=1;
        NSTimer *timer= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(animateEndSet:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode ];//:myTimerforMode:NSDefaultRunLoopMode];
            CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            drawAnimation.duration            = 5.0;
        
            drawAnimation.repeatCount         = 0;
            drawAnimation.removedOnCompletion = NO;
            drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            drawAnimation.toValue   = [NSNumber numberWithFloat:10.0f];
            drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [arc addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
        
    }

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:9.0/255 green:142.0/255 blue:254.0/255 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:134.0/255 green:102.0/255 blue:255.0/255 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:215.0/255 green:67.0/255 blue:113.0/255 alpha:1.0].CGColor ];
    gradientLayer.startPoint = CGPointMake(0,0.5);
    gradientLayer.endPoint = CGPointMake(1,0.5);
    self.myLayer = gradientLayer;
    
    [self.layer addSublayer:gradientLayer];
    gradientLayer.mask = arc;
}
- (void)animateEndSet:(NSTimer*)timer
{
    self.isFirstLoad=3;
    if (timer.isValid) {
        [timer invalidate];
    }
    timer=nil;
}
@end
