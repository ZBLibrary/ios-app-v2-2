//
//  TDSDetailViewController.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/10.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OznerDevice.h"

@interface TDSDetailViewController_EN : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL m_isShowCircle;
}

@property (nonatomic,strong) IBOutlet UITableView* myTableView;
@property (nonatomic,strong) OznerDevice* myCurrentDevice;
@property (nonatomic,strong) NSArray* dataSourceArr;
@property (nonatomic,strong) NSArray* hourDataSourceArr;
@property (nonatomic,strong) NSArray* dayDataSourceArr;
//今天当前的总饮水情况
@property (nonatomic,strong) CupRecord* todayRecord;
//本周总的饮水情况
@property (nonatomic,strong) CupRecord* weekRecord;
//本月饮水的情况
@property (nonatomic,strong) CupRecord* monthRecord;
@property (nonatomic,assign) int tdsValue;
@property (nonatomic,assign) int tdsRankValue;
//全国排名多少
@property (nonatomic,assign) int defeatRank;
//全国击败了多少
@property (nonatomic,assign) int defeatValue;
@end
