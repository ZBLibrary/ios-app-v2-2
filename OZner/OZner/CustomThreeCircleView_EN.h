//
//  CustomThreeCircleView.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/7.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomThreeCircleView_EN : UIView

@property (nonatomic,assign) int currentType;
@property (nonatomic,assign) double highScale;
@property (nonatomic,assign) double middleScale;
@property (nonatomic,assign) double lowScale;

- (id)initWithFrame:(CGRect)frame high:(double)high middle:(double)middle low:(double)low type:(int)type;

@end
