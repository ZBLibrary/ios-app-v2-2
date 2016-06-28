//
//  WaterineChartView.h
//  OZner
//
//  Created by 赵兵 on 16/2/19.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

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
#import "waterReplenishMPGraphView_EN.h"
@interface waterReplenishChartView_EN : UIView


@property (nonatomic,strong) NSArray* weekArr;
@property (nonatomic,strong) NSArray* monthArr;

- (void)drawLineView:(int)dateType dataArr:(NSArray*)dataArr;
@end

