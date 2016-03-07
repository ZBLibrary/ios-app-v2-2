//
//  NewUserHelpViewController.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-11-25.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTListView.h"
#import "HelpCellView.h"

@protocol NewUserHelpViewDelegate <NSObject>

@optional
- (void)onClickNewUserViewExperience;

@end

@interface NewUserHelpViewController : OCFatherViewController<JTListViewDataSource,JTListViewDelegate,HelpCellViewDelegate>
{
    JTListView* mListView;
}

@property (nonatomic,assign) id<NewUserHelpViewDelegate> userHelpViewDelegate;

@end
