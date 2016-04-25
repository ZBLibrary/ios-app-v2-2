//
//  MyTabBarView.h
//  CustomTab
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabDelegate;

//tabBar
#define UI_MY_TAB_BAR_HEIGHT            10
#define UI_MY_TAB_BAR_REAL_HEIGHT       95
#define ASSIST_HEIGHT        10

@interface CustomTabBarView : UIView

@property (nonatomic,retain) NSMutableArray* btnMuArr;
@property (nonatomic,retain) NSMutableArray* badgeMuArr;
@property (nonatomic,assign) int currentSelectEdIndex_ZB;
//通知view
@property (nonatomic,retain) NSMutableArray* notifyViewArr;

+ (id) sharedCustomTabBar;
- (void) bindingDelegate:(id <CustomTabDelegate>)mainTabBarDelegate;
- (void) selectItemAtIndex:(NSInteger)index;
- (void) unselectItems;
//隐藏 露出箭头
- (void)hideMyTabBar;
//显示
- (void)showMyTabBar;

//彻底隐藏
- (void)hideOverTabBar;
//显示
- (void)showAllMyTabBar;

-(void)dimAllButtonsByIdex:(int)nIdex;
- (void)touchDownAction:(UIButton*)button;

@end

@protocol CustomTabDelegate <NSObject>

@optional
- (void)mainTabBar:(CustomTabBarView *)mainTabBar  touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void)mainTabBar:(CustomTabBarView *)mainTabBar touchDownAtItemAtIndex:(NSUInteger)itemIndex;
- (void)mainTabBar:(CustomTabBarView *)mainTabBar changeSelectToIndex:(NSUInteger)itemIndex;

@end

