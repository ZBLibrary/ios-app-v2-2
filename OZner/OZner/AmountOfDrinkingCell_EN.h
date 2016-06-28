//
//  AmountOfDrinkingCell.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/6.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPlot.h"
#import "MPBarsGraphView.h"
#import "CustomThreeCircleView_EN.h"

@interface AmountOfDrinkingCell_EN : UITableViewCell
//日
@property (nonatomic,strong) MPBarsGraphView* myBarView;
@property (nonatomic,strong) CustomThreeCircleView_EN* dayCircleView;
@property (nonatomic,strong) CustomThreeCircleView_EN* dayTDSCircleView;
//week
@property (nonatomic,strong) MPBarsGraphView* myWeekBarView;
@property (nonatomic,strong) CustomThreeCircleView_EN* weekCircleView;
@property (nonatomic,strong) CustomThreeCircleView_EN* weekTDSCircleView;
//month
@property (nonatomic,strong) MPBarsGraphView* myMonthBarView;
@property (nonatomic,strong) CustomThreeCircleView_EN* monthCircleView;
@property (nonatomic,strong) CustomThreeCircleView_EN* monthTDSCircleView;
@property (nonatomic,strong) Cup* myCurrentDevice;

@property (nonatomic,strong) UISegmentedControl* currentControl;


@property (nonatomic,assign) int currentType;
@property (nonatomic,strong) NSArray* dataArr;
@property (nonatomic,strong) NSArray* weekArr;
@property (nonatomic,strong) NSArray* monthArr;
@property (nonatomic,assign) BOOL isShowCircle;

@property (nonatomic,strong) CustomThreeCircleView_EN* myThreeCircleView;

- (void)layOUtAmountDrinkingCell:(int)type isShowCircle:(BOOL)isShowCircle;
- (void)showCircle:(BOOL)isShowCircle type:(int)type;

@end
