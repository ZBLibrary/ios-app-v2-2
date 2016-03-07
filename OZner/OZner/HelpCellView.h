//
//  HelpCellView.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-11-25.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelpCellViewDelegate <NSObject>

@optional
- (void)onClickExperienceAction;

@end

@interface HelpCellView : UIView<HelpCellViewDelegate>

@property (nonatomic,assign) id<HelpCellViewDelegate> experienceDelegate;

- (id)initWithFrame:(CGRect)frame nIndex:(int)nIndex;

@end
