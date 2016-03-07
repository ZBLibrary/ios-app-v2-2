//
//  AmountOfDrinkingWaterFirstCell.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/6.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AmountOfDrinkingWaterFirstCellDelegate <NSObject>

@optional
- (void)amountOfDrinkingWaterZiXunAction;

@end

@interface AmountOfDrinkingWaterFirstCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIView* zixunBgView;
@property (nonatomic,strong) IBOutlet UIImageView* zixunImgView;
@property (nonatomic,strong) IBOutlet UILabel* zixunLabel;
@property (nonatomic,strong) IBOutlet UILabel* firstLabel;
@property (nonatomic,strong) IBOutlet UILabel* titleLabel;
@property (nonatomic,strong) IBOutlet UILabel* secodLabel;
@property (nonatomic,strong) IBOutlet UILabel* thirdLabel;
@property (nonatomic,strong) IBOutlet UILabel* rankLabel;
@property (nonatomic,strong) IBOutlet UIImageView* cupImgView;
@property (nonatomic,assign) int volume;
@property (nonatomic,assign) int maxTemp;
@property (assign,nonatomic) int tdsValue;
@property (nonatomic,assign) int rankValue;
@property (nonatomic,strong) IBOutlet UIImageView* iconImgView;
@property (nonatomic,strong) IBOutlet UILabel* wishLabel;
@property (nonatomic,assign) id<AmountOfDrinkingWaterFirstCellDelegate>delegate;

- (void)layOUtWaterFirstCell:(int)type;

@end
