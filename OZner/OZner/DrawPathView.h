//
//  DrawPathView.h
//  TwoCards
//
//  Created by sunlinlin on 15-4-6.
//  Copyright (c) 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPlot.h"

@interface DrawPathView : MPPlot
{
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
//纵坐标
@property (nonatomic,strong) NSArray* zongArr;

- (id)initWithFrame:(CGRect)frame timeType:(int)timeType;
- (void)stroke:(CGRect)frame color:(NSString*)color fillColor:(UIColor*)fillColor orignY:(float)orignY count:(int)count;

@end
