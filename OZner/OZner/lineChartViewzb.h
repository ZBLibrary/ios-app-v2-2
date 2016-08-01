//
//  lineChartViewzb.h
//  OZner
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPlot.h"
#import "MPBarsGraphView.h"
#import "MPGraphViewzb.h"
@interface lineChartViewzb : UIView
//@property (nonatomic,strong) MPGraphView* dayMpGraphView;
//@property (nonatomic,strong) MPGraphView* weekMpGraphView;
//@property (nonatomic,strong) MPGraphView* monthMpGraphView;
@property (nonatomic,assign) int CellType;//0 TDS,1 水温
@property (nonatomic,assign) NSString* title1;
@property (nonatomic,assign) NSString* title2;
@property (nonatomic,assign) NSString* title3;
@property (nonatomic,strong) NSArray* dataArr;
@property (nonatomic,strong) NSArray* weekArr;
@property (nonatomic,strong) NSArray* monthArr;
//今天当前的总饮水情况
@property (nonatomic,strong) CupRecord* todayRecord;
//本周总的饮水情况
@property (nonatomic,strong) CupRecord* weekRecord;
//本月饮水的情况
@property (nonatomic,strong) CupRecord* monthRecord;
- (void)drawLineView:(int)cellType dateType:(int)dateType dataArrzb:(NSArray*)dataArrzb Recordzb:(CupRecord*)Recordzb;
@end