//
//  FatherViewController.m
//  StarShow
//
//  Created by 常 贤明 on 4/30/14.
//  Copyright (c) 2014 常 贤明. All rights reserved.
//

#import "FatherViewController.h"

#define CARD_LOCATION 250
#define KOFFSET 200.f
#define KOFFSET2 60.f
#define MAX_SCALE   0.8f

@interface FatherViewController ()<UIGestureRecognizerDelegate>
{
    float           lastOffSet;
    UIButton*       mRestBtn;
    
}
@end

@implementation FatherViewController

- (void)dealloc
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    mRestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mRestBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    mRestBtn.backgroundColor = [UIColor clearColor];
    [mRestBtn addTarget:self action:@selector(resetBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mRestBtn];
    [self.view sendSubviewToBack:mRestBtn];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    mRect = self.view.frame;
}

- (void)resetBtnEvent:(id)sender
{
    [self restoreViewLocation:YES];
}

#pragma mark gestureDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{

    //return YES;
    return [self gestureValid];
}

#pragma mark 手势方法
- (void)handlePanFrom:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat xOffSet = [recognizer translationInView:self.view].x;
        
        xOffSet += lastOffSet;
        if (xOffSet <= 0)
        {
            xOffSet = 0;
        }
        
        float scale = (320. - xOffSet) / 320.;
        //NSLog(@"xoffset:%f-----scale:%f",xOffSet,scale);
        if (scale <= MAX_SCALE)
        {
            scale = MAX_SCALE;
        }
        
        CGAffineTransform contentTransform = CGAffineTransformMakeScale(scale, scale);
        self.view.transform = contentTransform;
        
        self.view.frame = CGRectMake(xOffSet,
                                                          self.view.frame.origin.y,
                                                          self.view.frame.size.width,
                                                          self.view.frame.size.height);
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (lastOffSet == CARD_LOCATION)
        {
            if (self.view.frame.origin.x > KOFFSET)
            {
                [self moveToOtherSide:YES];
            }
            else
            {
                [self restoreViewLocation:YES];
            }
        }
        else
        {
            if (self.view.frame.origin.x > KOFFSET2)
            {
                [self moveToOtherSide:YES];
            }
            else
            {
                [self restoreViewLocation:YES];
            }
        }
    }
}

#pragma mark 向右移动
- (void)moveToOtherSide:(BOOL)bRight
{
    if (bRight)
    {
        [self animateHomeViewToSide:CGRectMake(CARD_LOCATION,
                                               self.view.frame.origin.y,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height)];
        
        lastOffSet = CARD_LOCATION;
    }
    else
    {
        [self animateHomeViewToSide:CGRectMake(0,
                                               self.view.frame.origin.y,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height)];
        
        lastOffSet = 0;
    }
    
    
}

- (void)animateHomeViewToSide:(CGRect)newViewRect
{
    CGAffineTransform contentTransform = CGAffineTransformIdentity;
    if (newViewRect.origin.x == 0)
    {
        contentTransform = CGAffineTransformMakeScale(1.0, 1.0);
        newViewRect = mRect;
    }
    else
    {
        contentTransform = CGAffineTransformMakeScale(MAX_SCALE, MAX_SCALE);
        newViewRect = CGRectMake(CARD_LOCATION, (mRect.size.height - mRect.size.height*MAX_SCALE)/2, mRect.size.width*MAX_SCALE, mRect.size.height*MAX_SCALE);
    }
    
    [UIView beginAnimations:@"right_yes" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDelegate:self];
    self.view.transform = contentTransform;
    self.view.frame = newViewRect;
    [UIView commitAnimations];
}

#pragma mark roomHallView复位
- (void)restoreViewLocation:(BOOL)bRemove
{
    CGRect r = self.view.frame;
    if (r.origin.x == 0)
    {
        lastOffSet = 0.f;
        return;
    }
    r.origin.x = 0;
    r.origin.y = 0;
    r.size = mRect.size;
    
    CGAffineTransform contentTransform = CGAffineTransformMakeScale(1.0, 1.0);
    if (bRemove)
    {
        [UIView beginAnimations:@"location_yes" context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDelegate:self];
        
        self.view.transform = contentTransform;
        self.view.frame = r;
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:@"location_no" context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.view.transform = contentTransform;
        self.view.frame = r;
        [UIView commitAnimations];
        
    }
    
    lastOffSet = 0.f;
}

#pragma mark 点击左边滑出
- (void)hitLeftRestoreLocation
{
    CGAffineTransform contentTransform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView beginAnimations:@"left_hit" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDelegate:self];
    
    self.view.transform = contentTransform;
    self.view.frame = CGRectMake(0,
                                                      self.view.frame.origin.y,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height);
    [UIView commitAnimations];
    
    lastOffSet = 0.f;
}

-(void )animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"right_yes"])
    {
        //NSLog(@"frame:%@---transform",NSStringFromCGRect(self.view.frame));
        [self.view bringSubviewToFront:mRestBtn];
    }
    else if ([animationID isEqualToString:@"location_yes"])
    {
        [self.view sendSubviewToBack:mRestBtn];
    }
    else if ([animationID isEqualToString:@"left_hit"])
    {
        [UIView beginAnimations:@"left_hit_2" context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDelegate:self];
        
        self.view.frame = CGRectMake(0,
                                                          self.view.frame.origin.y,
                                                          self.view.frame.size.width,
                                                          self.view.frame.size.height);
        [UIView commitAnimations];
    }
    else if ([animationID isEqualToString:@"left_hit_2"])
    {
        //[overView removeFromSuperview];
    }
}

- (BOOL)gestureValid
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
