//
//  CustomNoDeviceView.h
//  OZner
//
//  Created by sunlinlin on 16/1/12.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomNoDeviceView_ENDelegate <NSObject>

@optional
- (void)customNodeviceAddDeviceAction;

@end

@interface CustomNoDeviceView_EN : UIView

@property (nonatomic,assign) id<CustomNoDeviceView_ENDelegate>delegate;

@end
