//
//  MyTabBarController.m
//  CustomTab
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CustomTabBarView.h"

#define NAV_VIEW_TAG   8899
#define RELEASE_OFF_SET 8945

//static CustomTabBarController *myTabBarController = nil;

@interface CustomTabBarController ()<CustomTabDelegate>
{
    BOOL        m_bIsUserInfo;
    int         m_Index;
    int         m_nCurrentIndex;//当前选中的
    
    UINavigationController* mReleaseNav;
}
@end

@implementation CustomTabBarController
@synthesize lastChosenMediaType;
@synthesize mItems;
@synthesize movieURL;
@synthesize videoPath;

- (void)dealloc
{
    self.mItems = nil;
    self.lastChosenMediaType = nil;
    self.videoPath = nil;
    self.movieURL = nil;
    if (mReleaseNav) {[mReleaseNav release]; mReleaseNav = nil;}
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self initControllers];
    }
    return self;
}

- (id)initWithControllers:(NSArray* )controllers
{
    if (self = [super init]) {
        // Custom initialization
        self.mItems = controllers;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UINavigationController* nav = (UINavigationController* )[mItems objectAtIndex:0];
    nav.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [[nav view] setTag:NAV_VIEW_TAG];
    [self.view addSubview:nav.view];

    // 默认第1个
    m_Index = 0;
    m_nCurrentIndex = 0;
    
    [self initTabBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)initTabBar
{
    CustomTabBarView* barView = [CustomTabBarView sharedCustomTabBar];
    [barView unselectItems];
    [barView bindingDelegate:self];
    barView.frame = CGRectMake(0, self.view.frame.size.height - UI_TAB_BAR_HEIGHT, self.view.frame.size.width, UI_TAB_BAR_HEIGHT);
    [barView selectItemAtIndex:m_Index];
    [self.view addSubview:barView];
}

// bar切换
- (void)mainTabBar:(CustomTabBarView *)mainTabBar touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    [[self.view viewWithTag:NAV_VIEW_TAG] removeFromSuperview];
    UIViewController* controller = (UIViewController* )[mItems objectAtIndex:itemIndex];
    m_Index = (int)itemIndex;
    UIView *navView=[controller view];
    navView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    navView.tag = NAV_VIEW_TAG;
    [self.view insertSubview:navView belowSubview:[CustomTabBarView sharedCustomTabBar]];
}

#pragma mark - 父类方法:查看导航器内视图个数
- (int)checkControllers
{
    UINavigationController* controller = (UINavigationController* )[mItems objectAtIndex:m_Index];
    NSArray* array = [controller viewControllers];
    return (int)[array count];
}

- (BOOL)checkForce
{
    // 只有首页响应手势
    if (m_Index == 0)
    {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
