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


@interface MPGraphViewzb_EN : MPPlot{
    
    CAGradientLayer *gradient;
}

@property (nonatomic,assign) BOOL curved;
@property (nonatomic,retain) NSArray *fillColors; // array of colors or CGColor
@property (nonatomic,assign) int mCurrentType;
@property (nonatomic,retain) UILabel* firstLabel;
@property (nonatomic,retain) UILabel* secondLabel;
@property (nonatomic,retain) UILabel* thirdLabel;
@property (nonatomic,retain) UILabel* currentMonthLabel;
@property (nonatomic,retain) UILabel* endMonthLabel;
@property (nonatomic,assign) int CellType;//0 TDS,1 水温
@property (nonatomic,assign) NSString* title1;
@property (nonatomic,assign) NSString* title2;
@property (nonatomic,assign) NSString* title3;
//@property (nonatomic,assign) BOOL isMonthHideBottom;
//纵坐标
@property (nonatomic,strong) NSArray* zongArr;

- (id)initWithFrame:(CGRect)frame timeType:(int)timeType cellType:(int)cellType title1:(NSString*)title1 title2:(NSString*)title2 title3:(NSString*)title3;
- (void)stroke:(CGRect)frame color:(NSString*)color fillColor:(UIColor*)fillColor orignY:(float)orignY count:(int)count;

@end
