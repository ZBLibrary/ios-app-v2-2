//
//  TDSDetailSecondCell.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/10.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPlot.h"
#import "MPBarsGraphView.h"
#import "MPGraphView.h"
#import "CustomThreeCircleView.h"

@interface TDSDetailSecondCell : UITableViewCell

@property (nonatomic,strong) MPGraphView* dayMpGraphView;
@property (nonatomic,strong) MPGraphView* weekMpGraphView;
@property (nonatomic,strong) MPGraphView* monthMpGraphView;
@property (nonatomic,strong) CustomThreeCircleView* dayTDSCircleView;
@property (nonatomic,strong) CustomThreeCircleView* weekTDSCircleView;
@property (nonatomic,strong) CustomThreeCircleView* monthTDSCircleView;
@property (nonatomic,strong) UILabel* titleLabel;
@property (nonatomic,strong) NSArray* dataArr;
@property (nonatomic,strong) NSArray* weekArr;
@property (nonatomic,strong) NSArray* monthArr;
//今天当前的总饮水情况
@property (nonatomic,strong) CupRecord* todayRecord;
//本周总的饮水情况
@property (nonatomic,strong) CupRecord* weekRecord;
//本月饮水的情况
@property (nonatomic,strong) CupRecord* monthRecord;
@property (nonatomic,strong) UISegmentedControl* currentControl;
@property (nonatomic,assign) int currentType;
@property (nonatomic,assign) BOOL isShowCircle;

- (void)layOUtTDSCell:(int)type;
- (void)showCircle:(BOOL)isShowCircle type:(int)type;

@end
