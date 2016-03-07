//
//  FatherViewController.h
//  StarShow
//
//  Created by 常 贤明 on 4/30/14.
//  Copyright (c) 2014 常 贤明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FatherViewController : UIViewController
{
    CGRect          mRect;
}

// 手势是否有效(子类实现)，默认无效
- (BOOL)gestureValid;
// 滑动
- (void)moveToOtherSide:(BOOL)bRight;
// 复位
- (void)restoreViewLocation:(BOOL)bRemove;

@end
