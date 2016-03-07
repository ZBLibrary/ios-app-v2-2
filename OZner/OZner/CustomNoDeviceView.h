//
//  CustomNoDeviceView.h
//  OZner
//
//  Created by sunlinlin on 16/1/12.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomNoDeviceViewDelegate <NSObject>

@optional
- (void)customNodeviceAddDeviceAction;

@end

@interface CustomNoDeviceView : UIView

@property (nonatomic,assign) id<CustomNoDeviceViewDelegate>delegate;

@end
