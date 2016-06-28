//
//  HomeViewController.h
//  StarShow
//
//  Created by 常 贤明 on 4/30/14.
//  Copyright (c) 2014 常 贤明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FatherViewController.h"
#import "LeftViewController.h"
#import "IViewSwitchProtocol.h"
#import "OZner-swift.h"

@protocol HomeControllerDelegate <NSObject>

@optional
- (void)customViewAddCallBack;

@end

@interface HomeViewController : FatherViewController<LeftItemDelegate, HomeDelegate,MyDeviceMainController_ENDelegate,CustomPopViewDelegate>
{
    
}

@property (nonatomic,strong) CustomPopView* myCustomView;
@property (nonatomic,assign) id<HomeControllerDelegate>delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil items:(NSArray* )array;

@end
