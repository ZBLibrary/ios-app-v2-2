//
//  MyDeviceCustomSecondCellView.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/25.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDeviceCustomSecondCellViewDelegate <NSObject>

@optional
- (void)onClickbuttonAction:(UIButton*)button;

@end

@interface MyDeviceCustomSecondCellView : UIView

@property (nonatomic,strong) UILabel* titleLabe;
@property (nonatomic,strong) UIButton* actionButton;
@property (nonatomic,assign) id<MyDeviceCustomSecondCellViewDelegate>delegate;

- (void)layOutCellView:(NSString*)iconName title:(NSString*)title iconNameSelect:(NSString*)iconNameSelect;

@end
