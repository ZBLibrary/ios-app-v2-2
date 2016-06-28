//
//  AmountOfDrinkingWaterViewController.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/6.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OZner-swift.h"
#import "Cup.h"
#import "OCFatherViewController.h"


@interface AmountOfDrinkingWaterViewController_EN : OCFatherViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL m_isShowCircel;
}

@property (nonatomic,strong) IBOutlet UITableView* myTableView;
@property (nonatomic,assign) int currentType;
@property (nonatomic,strong) Cup* myCurrentDevice;
@property (nonatomic,assign) int todayVolume;
@property (nonatomic,assign) int todayRank;
@property (nonatomic,assign) int defeatRank;//全国排名
@property (nonatomic,assign) int defeatValue;//全国人数
@property (nonatomic,strong) NSArray* dataSourceArr;
@property (nonatomic,strong) NSArray* hourDataSourceArr;
@property (nonatomic,strong) NSArray* dayDataSourceArr;
@property (nonatomic,strong) CupRecord* currentCupRecord;
//@property (nonatomic,strong) CenterChartCell* wCell;
@end
