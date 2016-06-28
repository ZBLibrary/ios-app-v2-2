//
//  AmountOfDrinkingWaterViewController.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/6.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "AmountOfDrinkingWaterViewController_EN.h"
//#import "AmountOfDrinkingWaterFirstCell.h"
#import "AmountOfDrinkingCell_EN.h"
//#import "AmountOfDrinkingThirdCell.h"
#import "ShareManager.h"
#import "OZner-swift.h"
@interface AmountOfDrinkingWaterViewController_EN ()
@property (nonatomic,strong) AmountOfDrinkingCell_EN* currentSecondCell;
@property (nonatomic,strong) CenterChartCell_EN* circleCell;
@property (nonatomic,assign) BOOL currentChartType;//YES 圆，NO 折线
@end

@implementation AmountOfDrinkingWaterViewController_EN

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_isShowCircel = FALSE;
    [self initDataSource];
    _currentChartType=YES;
    //[self createLeftAndRightBtn];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [[CustomTabBarView sharedCustomTabBar] hideOverTabBar];
}
- (void)initDataSource
{
    if(self.currentType == 0)
    {
        NSDate* date=[[NSDate alloc] initWithTimeIntervalSince1970:(int)([[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970])/86400*86400];
        self.hourDataSourceArr = [self sortUpdateTime:[self.myCurrentDevice.volumes getRecordByDate:date Interval:Hour]];
        self.currentCupRecord = [self.myCurrentDevice.volumes getRecordByDate:date];
        
        NSDate* weekFirstDay = [UToolBox dateStartOfWeek:[NSDate date]];
        //取整
        NSInteger dayZeor = ((int)[weekFirstDay timeIntervalSince1970])/86400*86400;
        weekFirstDay = [[NSDate alloc]initWithTimeIntervalSince1970:dayZeor];
        self.dataSourceArr = [self sortUpdateTime:[self.myCurrentDevice.volumes getRecordByDate:weekFirstDay Interval:Day]];
        
        //取这个月的
        NSDate* monthFirstDay = [UToolBox dateStartOfMonth:[NSDate date]];
        //取整
        NSInteger monthZeor = ((int)[monthFirstDay timeIntervalSince1970])/86400*86400;
        monthFirstDay = [[NSDate alloc]initWithTimeIntervalSince1970:monthZeor];
        self.dayDataSourceArr = [self sortUpdateTime:[self.myCurrentDevice.volumes getRecordByDate:monthFirstDay Interval:Day]];
    }
}

//找出最大的updatetime
- (NSArray*)sortUpdateTime:(NSArray*)arr
{
    NSComparator cmptr = ^(CupRecord* obj1, CupRecord* obj2){
        if ([obj1.start timeIntervalSince1970] > [obj2.start timeIntervalSince1970])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1.start timeIntervalSince1970] < [obj2.start timeIntervalSince1970])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray* muArr = [arr sortedArrayUsingComparator:cmptr];
    return muArr;
}


- (void)leftBtnMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnMethod
{
    if (_myCurrentDevice==nil) {
        return;
    }
    int maxValue=((NSString*)[[_myCurrentDevice settings] get:@"my_drinkwater" Default:@"2000"]).intValue;
    NSDate* date = [UToolBox todayZero];
    CupRecord* record = [[_myCurrentDevice volumes] getRecordByDate:date];
    int beatzb=100-(int)(100*(double)self.defeatRank/(double)self.defeatValue);
    getshareImageClass* getClass = [[getshareImageClass alloc]init];
    UIImage* image = [getClass getshareImagezb:self.defeatRank type:0 value:record.volume beat:beatzb maxWater:maxValue];
    //微信朋友圈
    [[ShareManager shareManagerInstance]sendShareToWeChat:WXSceneTimeline urt:@"" title:loadLanguage(@"浩泽净水家") shareImg:image];
}

#pragma mark-AmountOfDrinkingWaterFirstCellDelegate
- (void)amountOfDrinkingWaterZiXunAction
{
    [[CustomTabBarView sharedCustomTabBar]touchDownAction:[[[CustomTabBarView sharedCustomTabBar]btnMuArr]objectAtIndex:2]];
}

#pragma mark-AmountOfDrinkingThirdCellDelegate
- (void)purchaseAction
{
    [[CustomTabBarView sharedCustomTabBar]touchDownAction:[[[CustomTabBarView sharedCustomTabBar]btnMuArr]objectAtIndex:1]];
}

- (void)jianKangShuiAction
{
    WeiXinURLViewController_EN* URLController=[[WeiXinURLViewController_EN alloc] initWithNibName:@"WeiXinURLViewController_EN" bundle:nil];
    [URLController setTitle:loadLanguage(@"健康水知道")];
    [self presentViewController:URLController animated:true completion:nil];
}

#pragma mark-UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 214;
    }
    else if(indexPath.row == 1)
    {
        return 256;
    }
    
    return SCREEN_HEIGHT>604 ? SCREEN_HEIGHT-470:134;
}

- (UITableViewCell*)createFirstCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* amountWaterFirstCell = @"amountWaterFirstCell";
    drinKWaterCell_EN* wCell = [tableView dequeueReusableCellWithIdentifier:amountWaterFirstCell];
    if(wCell == nil&&self.myCurrentDevice != nil)
    {
        wCell = [[[NSBundle mainBundle]loadNibNamed:@"drinKWaterCell_EN" owner:self options:nil] objectAtIndex:0];
        //0 饮水量，1 温度
        if (self.currentType==0) {
            wCell.celltype=loadLanguage(@"饮水量");
            wCell.waterValueChange=self.todayVolume;
            //wCell.rank=self.todayRank==0 ? 1:self.todayRank;
        }
        else{
            wCell.celltype=loadLanguage(@"水温");
            wCell.waterValueChange=self.myCurrentDevice.sensor.Temperature;
        }
        
    }
    [wCell.back addTarget:self action:@selector(leftBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    //[wCell.share addTarget:self action:@selector(rightBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    //[wCell.zixunButton addTarget:self action:@selector(amountOfDrinkingWaterZiXunAction) forControlEvents:UIControlEventTouchUpInside];
    wCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return wCell;
}


- (UITableViewCell*)createSecondCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* amountWaterSecondCell = @"amountWaterSecondCell";
    if (self.currentType==1) {
        _circleCell = [tableView dequeueReusableCellWithIdentifier:amountWaterSecondCell];
        _circleCell = [[[NSBundle mainBundle]loadNibNamed:@"CenterChartCell_EN" owner:self options:nil] objectAtIndex:0];
        _circleCell.myCurrentDevice=self.myCurrentDevice;
        _circleCell.cellType=1;//水温
        _circleCell.ChartType=0;//圆环图

        _circleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _circleCell;
    } else {
        
        AmountOfDrinkingCell_EN* wCell = [tableView dequeueReusableCellWithIdentifier:amountWaterSecondCell];
        if(wCell == nil)
        {
            wCell = [[AmountOfDrinkingCell_EN alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:amountWaterSecondCell];
            wCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        wCell.dataArr = self.hourDataSourceArr;
        wCell.weekArr = self.dataSourceArr;
        wCell.monthArr = self.dayDataSourceArr;
        wCell.myCurrentDevice = self.myCurrentDevice;
        
        if(self.currentSecondCell == nil)
        {
            self.currentSecondCell = wCell;
        }
        
        [wCell layOUtAmountDrinkingCell:self.currentType isShowCircle:m_isShowCircel];
        
        return wCell;
    }
    
}

- (UITableViewCell*)createThirdCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* thirdCell = @"thirdCell";
    TDSFooterCellzb_EN* wCell = [tableView dequeueReusableCellWithIdentifier:thirdCell];
    if(wCell == nil)
    {
        wCell = [[[NSBundle mainBundle]loadNibNamed:@"TDSFooterCellzb_EN" owner:self options:nil] objectAtIndex:0];
        //wCell.delegate = self;
    }
    //[wCell.waterKnowButton addTarget:self action:@selector(jianKangShuiAction) forControlEvents:UIControlEventTouchUpInside];
    //[wCell.toStoreButton addTarget:self action:@selector(purchaseAction) forControlEvents:UIControlEventTouchUpInside];
    wCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return wCell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return [self createFirstCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 1)
    {
        return [self createSecondCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        return [self createThirdCell:tableView cellForRowAtIndexPath:indexPath];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
