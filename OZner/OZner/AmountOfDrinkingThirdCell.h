//
//  AmountOfDrinkingThirdCell.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/7.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AmountOfDrinkingThirdCellDelegate <NSObject>

@optional
- (void)purchaseAction;
- (void)jianKangShuiAction;

@end

@interface AmountOfDrinkingThirdCell : UITableViewCell

@property (nonatomic,assign) id<AmountOfDrinkingThirdCellDelegate> delegate;

@end
