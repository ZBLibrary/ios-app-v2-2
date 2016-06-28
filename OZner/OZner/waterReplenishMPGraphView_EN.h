//
//  WaterMPGraphView.h
//  OZner
//
//  Created by 赵兵 on 16/2/19.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

//
//  MPGraphViewzb.h
//  OZner
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

//
//  MPGraphView.h
//
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPlot.h"


@interface waterReplenishMPGraphView_EN : MPPlot{
    
    CAGradientLayer *gradient;
}

@property (nonatomic,assign) BOOL curved;
@property (nonatomic,retain) NSArray *fillColors; // array of colors or CGColor
@property (nonatomic,assign) int mCurrentType;//0周，1 月

@property (nonatomic,retain) UILabel* currentMonthLabel;
@property (nonatomic,retain) UILabel* endMonthLabel;

@property (nonatomic,assign) BOOL isBadTds;
//纵坐标
@property (nonatomic,strong) NSArray* zongArr;

- (id)initWithFrame:(CGRect)frame timeType:(int)timeType IsBadTds:(BOOL)IsBadTds;
- (void)stroke:(CGRect)frame color:(NSString*)color fillColor:(UIColor*)fillColor orignY:(float)orignY count:(int)count;

@end
