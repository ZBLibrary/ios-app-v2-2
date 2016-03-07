//
//  NewUserHelpViewController.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-11-25.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "NewUserHelpViewController.h"

@interface NewUserHelpViewController ()

@end

@implementation NewUserHelpViewController
@synthesize userHelpViewDelegate;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatListView];
    
    if (IOS_7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

- (void)creatListView
{
    mListView = [[JTListView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    mListView.delegate = self;
    mListView.dataSource = self;
    mListView.backgroundColor = [UIColor clearColor];
    mListView.pagingEnabled = YES;
    mListView.clipsToBounds = YES;
    mListView.showsHorizontalScrollIndicator = NO;
    mListView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mListView];
    [mListView reloadData];
}

#pragma mark- HelpCellViewDelegate
- (void)onClickExperienceAction
{
    if([self.userHelpViewDelegate respondsToSelector:@selector(onClickNewUserViewExperience)])
    {
        [self.userHelpViewDelegate onClickNewUserViewExperience];
    }
}

- (void)listViewCurrentIndex:(int)nIndex
{
    if(nIndex == 2)
    {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
        
    }
}

- (void)onTimer
{
    if([self.userHelpViewDelegate respondsToSelector:@selector(onClickNewUserViewExperience)])
    {
        [self.userHelpViewDelegate onClickNewUserViewExperience];
    }
}

#pragma mark - JTListViewDataSource
- (NSUInteger)numberOfItemsInListView:(JTListView *)listView
{
    return 3;
}

- (UIView *)listView:(JTListView *)listView viewForItemAtIndex:(NSUInteger)index
{
    HelpCellView* cellView = [[[HelpCellView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) nIndex:(int)index] autorelease];
    
    cellView.experienceDelegate = self;
    
    return cellView;
}


#pragma mark - JTListViewDelegate
- (CGFloat)listView:(JTListView *)listView widthForItemAtIndex:(NSUInteger)index
{
    return SCREEN_WIDTH;
}

- (CGFloat)listView:(JTListView *)listView heightForItemAtIndex:(NSUInteger)index
{
    return SCREEN_HEIGHT;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if(mListView)
    {
        mListView.delegate = nil;
        [mListView release];
    }
    
    [super dealloc];
}

@end
