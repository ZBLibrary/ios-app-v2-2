//
//  TDSDetailViewController.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/10.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "TDSDetailViewController.h"

#import "DeviceWerbservice.h"
#import "CustomTabBarView.h"
#import "ShareManager.h"
#import "MBProgressHUD.h"
#import "OZner-swift.h"

@interface TDSDetailViewController ()

//@property (nonatomic,strong) TDSDetailSecondCell* currentSecondCell;

@end

@implementation TDSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_isShowCircle = YES;
    [self initDataSource];
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
    if([self.myCurrentDevice isKindOfClass:[Cup class]])
    {
        Cup* cup = (Cup*)self.myCurrentDevice;
        //取今天的零点
        //去今天的0点时间
        NSDate* date=[[NSDate alloc] initWithTimeIntervalSince1970:(int)([[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970])/86400*86400];
        self.hourDataSourceArr = [self sortUpdateTime:[cup.volumes getRecordByDate:date Interval:Hour]];
        self.todayRecord = [cup.volumes getRecordByDate:date];
        
        NSDate* weekFirstDay = [UToolBox dateStartOfWeek:[NSDate date]];
        //取整
        NSInteger dayZeor = ((int)[weekFirstDay timeIntervalSince1970])/86400*86400;
        weekFirstDay = [[NSDate alloc]initWithTimeIntervalSince1970:dayZeor];
        self.dataSourceArr = [self sortUpdateTime:[cup.volumes getRecordByDate:weekFirstDay Interval:Day]];
        self.weekRecord = [cup.volumes getRecordByDate:weekFirstDay];
        
        //取这个月的
        NSDate* monthFirstDay = [UToolBox dateStartOfMonth:[NSDate date]];
        //取整
        NSInteger monthZeor = ((int)[monthFirstDay timeIntervalSince1970])/86400*86400;
        monthFirstDay = [[NSDate alloc]initWithTimeIntervalSince1970:monthZeor];
        self.dayDataSourceArr = [self sortUpdateTime:[cup.volumes getRecordByDate:monthFirstDay Interval:Day]];
        self.monthRecord = [cup.volumes getRecordByDate:monthFirstDay];
        NSLog(@"%@,%@",self.dayDataSourceArr,self.monthRecord );
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
    getshareImageClass* getClass = [[getshareImageClass alloc]init];
    int beatzb=100-(int)((100*(double)self.defeatRank)/((double)self.defeatValue));
    NSLog(@"%d",self.defeatValue);
    
    UIImage* image = [getClass getshareImagezb:self.defeatRank type:1 value:self.tdsValue beat:beatzb maxWater:0];
    
    //微信朋友圈
    [[ShareManager shareManagerInstance]sendShareToWeChat:WXSceneTimeline urt:@"" title:@"浩泽净水家" shareImg:image];
}
- (void)toWhatTDS
{
    ToWhatViewController* tdsState=[[ToWhatViewController alloc] initWithNibName:@"ToWhatViewController" bundle:nil];
    [tdsState setTitle:@"什么是TDS?"];
    [self.navigationController pushViewController:tdsState animated:YES];
}
//#pragma mark-AmountOfDrinkingWaterFirstCellDelegate
- (void)amountOfDrinkingWaterZiXunAction
{
    [[CustomTabBarView sharedCustomTabBar]touchDownAction:[[[CustomTabBarView sharedCustomTabBar]btnMuArr]objectAtIndex:2]];
}

//#pragma mark-AmountOfDrinkingThirdCellDelegate
- (void)purchaseAction
{
    [[CustomTabBarView sharedCustomTabBar]touchDownAction:[[[CustomTabBarView sharedCustomTabBar]btnMuArr]objectAtIndex:1]];
}

- (void)jianKangShuiAction
{
    WeiXinURLViewController* URLController=[[WeiXinURLViewController alloc] initWithNibName:@"WeiXinURLViewController" bundle:nil];
    [URLController setTitle:@"健康水知道"];
    [self presentViewController:URLController animated:true completion:nil];
}


#pragma mark-UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 194;
    }
    else if(indexPath.row == 1)
    {
        return 256;
    }
    NSLog(@"%f",SCREEN_HEIGHT);
    return SCREEN_HEIGHT>584 ? (SCREEN_HEIGHT-450):134;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)createFirstCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* amountWaterFirstCell = @"amountWaterFirstCell";
    TDSDetailCellzb* wCell = [tableView dequeueReusableCellWithIdentifier:amountWaterFirstCell];
    if(wCell == nil)
    {
        wCell = [[[NSBundle mainBundle]loadNibNamed:@"TDSDetailCellzb" owner:self options:nil] objectAtIndex:0];
    }
    
    wCell.TDSValueChange =  self.tdsValue;
    wCell.rankValueChange = self.tdsRankValue;
    NSLog(@"%d",self.tdsRankValue);
    [wCell.BackClick addTarget:self action:@selector(leftBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [wCell.shareCick addTarget:self action:@selector(rightBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [wCell.toZiXun addTarget:self action:@selector(amountOfDrinkingWaterZiXunAction) forControlEvents:UIControlEventTouchUpInside];
    [wCell.toTDSState addTarget:self action:@selector(toWhatTDS) forControlEvents:UIControlEventTouchUpInside];

    wCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return wCell;
}

- (UITableViewCell*)createSecondCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tdsSecondCell = @"tdsSecondCell";
    CenterChartCell* circleCell = [tableView dequeueReusableCellWithIdentifier:tdsSecondCell];
    circleCell = [[[NSBundle mainBundle]loadNibNamed:@"CenterChartCell" owner:self options:nil] objectAtIndex:0];
    circleCell.myCurrentDevice=(Cup*)self.myCurrentDevice;
    circleCell.cellType=0;//水温
    circleCell.ChartType=0;//圆环图
    
    circleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return circleCell;

}

- (UITableViewCell*)createThirdCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* thirdCell = @"thirdCell";
    TDSFooterCellzb* wCell = [tableView dequeueReusableCellWithIdentifier:thirdCell];
    if(wCell == nil)
    {
        wCell = [[[NSBundle mainBundle]loadNibNamed:@"TDSFooterCellzb" owner:self options:nil] objectAtIndex:0];
        //wCell.delegate = self;
    }
    [wCell.waterKnowButton addTarget:self action:@selector(jianKangShuiAction) forControlEvents:UIControlEventTouchUpInside];
    [wCell.toStoreButton addTarget:self action:@selector(purchaseAction) forControlEvents:UIControlEventTouchUpInside];
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
