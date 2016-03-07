//
//  GlobalSizeDef.h
//  UU
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONTROL_TOOLBAR_HEIGHT      40
//常用长度
#define UI_NAVIGATION_BAR_HEIGHT        44//导航
#define UI_TOOL_BAR_HEIGHT              44//工具栏
#define UI_SEARCH_BAR_HEIGHT            44//搜索栏
#define UI_TAB_BAR_HEIGHT               65//选项卡栏
#define UI_STATUS_BAR_HEIGHT            20//状态栏
#define UI_NAVAGATION_HEIGHT            64//导航栏ios7 
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)//屏幕高度
#define UI_VIEW_WITH_NAV_HEIGHT         (UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT)//带导航的视图高度
#define UI_INIT_Y   (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?64.0:0.0) //ios7坐标适配起始y
#define UI_SCREEN_WIDTH                 320//屏幕宽度
#define PICKER_HEIGHT                   256//pickerview高度
#define DURING_TIME                     0.3//pickerView 运动时间

#define DIAL_BAR_HEIGHT                 50 //拨号键盘bar高度             

//返回按钮字体
#define BTN_TITLE_SIZE                  15.0
#define RGB(r,g,b)                      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define COMMENT_VIEW_DEFAULT_HEIGHT                 259
#define COMMENT_VIEW_GAP                            10
#define COMMENT_TEXT_VIEW_HIEGHT                    38
#define COMMENT_VIEW_HEIGHT                         44
#define COMMENT_TEXTVIEW_WIDTH                      200
#define COMMENT_ANONYMILY_WIDTH                     46
#define COMMENT_ANONYMILY_HEIGHT                    18
#define COMMENT_SEND_WIDTH                          50
#define COMMENT_SEND_HEIGHT                         30
#define COMMENT_ANONYMILY_Y                         13
#define COMMENT_SEND_Y                              7

// 右滑有效范围
#define TOUCH_AVAILABLE_POINT                       40.

#define SCREEN_HEIGHT                               [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH                                [UIScreen mainScreen].bounds.size.width



