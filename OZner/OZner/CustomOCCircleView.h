//
//  CustomOCCircleView.h
//  OZner
//
//  Created by sunlinlin on 16/1/13.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomOCCircleViewDelegate <NSObject>

- (void)seeTdsDetail;

@end

@interface CustomOCCircleView : UIView

@property (nonatomic,assign) CGFloat currentTDSValue;
//临时TDS存储器
@property (nonatomic,assign) CGFloat originalTDSValue;
@property (nonatomic,assign) int currentDefeatValue;
@property (nonatomic,assign) int currentRankValue;
@property (nonatomic,strong) UILabel* tdsLabel;
@property (nonatomic,strong) UIImageView* tdsStateImgIview;
@property (nonatomic,strong) UILabel* tdsStateValueLabel;
@property (nonatomic,strong) UILabel* tdsFirstLabel;
@property (nonatomic,strong) UILabel* tdsDescLabel;
@property (nonatomic,strong) CAGradientLayer* myLayer;
@property (nonatomic,assign) id<CustomOCCircleViewDelegate>delegate;
@property (nonatomic,assign) int isFirstLoad;
- (id)initWithFrame:(CGRect)frame tdsValue:(int)tdsValue beatValue:(int)beatValue rankValue:(int)rankValue;
-(void)update;

@end
