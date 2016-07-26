//
//  HomeViewController.m
//  StarShow
//
//  Created by 常 贤明 on 4/30/14.
//  Copyright (c) 2014 常 贤明. All rights reserved.
//

#import "HomeViewController.h"
#import "ExtendViewController.h"

#define TAB_VIEW_TAG    9900

@interface HomeViewController ()
{
    int m_Index;    //cxm 2014-5-28
}

@property (nonatomic, retain) NSArray* items;

@end

@implementation HomeViewController

- (void)dealloc
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil items:(NSArray* )array
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.items = array;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    NSLog(@"homecontroller.frame:%@",NSStringFromCGRect(self.view.frame));
    UIViewController* controller = (UIViewController* )[self.items objectAtIndex:0];
    controller.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [[controller view] setTag:TAB_VIEW_TAG];
    [self.view addSubview:controller.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDevices) name:@"getDevices" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCustomViewFrame:) name:@"customPopViewFrame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchCustomPopView) name:@"hideCustomViewFrame" object:nil];
    
    // 默认第一个 可以修改
    m_Index = 0;
    
    CustomPopView* cutomView = [[CustomPopView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.myCustomView = cutomView;
    self.myCustomView.delegate = self;
    self.myCustomView.myDevices = (NSMutableArray*)[[OznerManager instance]getDevices];
    self.myCustomView.myView.frame = CGRectMake(0, 0, SCREEN_WIDTH-50, cutomView.frame.size.height);
    [self.view addSubview:cutomView];
    [self.myCustomView relaodData];
    
}

- (void)updateCustomViewFrame:(NSNotification*)notification
{
    NSNumber* point = notification.object;
    
    self.myCustomView.frame = CGRectMake(-SCREEN_WIDTH+[point intValue], 0, self.myCustomView.frame.size.width, self.myCustomView.frame.size.height);
        
    //CGFloat alpha = [point floatValue]/SCREEN_WIDTH * 0.8;
       // self.myCustomView.alpha = alpha;
       // NSLog(@"alpha = %f frame.x = %f",alpha,self.myCustomView.frame.origin.x);
  
}

//更新设备
- (void)updateDevices
{
    self.myCustomView.myDevices = (NSMutableArray*)[[OznerManager instance]getDevices];
    [self.myCustomView relaodData];
}

#pragma mark-MyDeviceMainControllerDelegate
- (void)leftActionCallBack
{
    [UIView animateWithDuration:0.5 animations:^{
        self.myCustomView.frame = CGRectMake(0, 0, self.myCustomView.frame.size.width, self.myCustomView.frame.size.height);
        //self.myCustomView.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }];
}

#pragma mark-CustomPopViewDelegate
- (void)touchCustomPopView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.myCustomView.frame = CGRectMake(-SCREEN_WIDTH, 0, self.myCustomView.frame.size.width, self.myCustomView.frame.size.height);
        self.myCustomView.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftMenuShouqi_zb" object:nil];
    }];
}

- (void)addDeviceCallBack
{
    if([self.delegate respondsToSelector:@selector(customViewAddCallBack)])
    {
        [self.delegate customViewAddCallBack];
    }
}
- (void)infomationClick
{
    if ([self.delegate respondsToSelector:@selector(customViewAddInfoMation)]) {
        [self.delegate customViewAddInfoMation];
    }
}

#pragma mark - LeftItemDelegate Method
- (void)dSelectItemIndex:(NSInteger)index
{
    m_Index = (int)index;
    
    [[self.view viewWithTag:TAB_VIEW_TAG] removeFromSuperview];
    
    UIViewController* controller = (UIViewController* )[self.items objectAtIndex:index];
    controller.view.frame=CGRectMake(0, 0, mRect.size.width, mRect.size.height);
    [[controller view] setTag:TAB_VIEW_TAG];
    [self.view addSubview:controller.view];
    
    // 放大view
    [self restoreViewLocation:YES];
}

#pragma mark - HomeDelegate Method
- (void)homeSinkEvent
{
    // 移动到另一边
    //[self moveToOtherSide:YES];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.myCustomView.frame = CGRectMake(0, 0, self.myCustomView.frame.size.width, self.myCustomView.frame.size.height);
//    }];
}

#pragma mark - Father Method 手势是否有效 //cxm 2014-5-28
- (BOOL)gestureValid
{
//    ExtendViewController* controller = (ExtendViewController* )[self.items objectAtIndex:m_Index];
//    int count = [controller checkControllers];
    return (false);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
