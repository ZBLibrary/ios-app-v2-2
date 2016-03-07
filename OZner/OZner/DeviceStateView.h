//
//  DeviceStateView.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/29.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceStateView : UIView

@property (nonatomic,strong) UIImageView* circleImgView;
@property (nonatomic,strong) UILabel* contentLabel;
@property (nonatomic,assign) int angle;
@property (nonatomic,assign) BOOL isRunning;

- (void)layOUtCircleView:(NSString*)content state:(int)state;
- (void)startAnimation;

@end
