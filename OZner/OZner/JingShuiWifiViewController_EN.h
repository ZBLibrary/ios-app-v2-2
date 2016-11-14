//
//  JingShuiWifiViewController.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/20.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JinShuiqiWIFIController_ENDelegate <NSObject>

@optional
- (void)jinshuiqiConnectComplete:(NSArray*)arr;

@end

@interface JingShuiWifiViewController_EN : OCFatherViewController
{
    BOOL m_bIsAgree;
    BOOL m_bIsShow;
    NSTimer* mTimer;
    int mIndex;
}

@property (nonatomic,strong) IBOutlet UIImageView* wifiImgView;
@property (nonatomic,strong) IBOutlet UILabel* titleLabel1;
@property (nonatomic,strong) IBOutlet UILabel* titleLabel2;
@property (nonatomic,strong) IBOutlet UIView* accountBgView;
@property (nonatomic,strong) IBOutlet UITextField* accountTF;
@property (nonatomic,strong) IBOutlet UITextField* pswTF;
@property (strong, nonatomic) IBOutlet UIImageView *eyeImg;


@property (nonatomic,strong) IBOutlet UIView* agreeBgView;
@property (nonatomic,strong) IBOutlet UIButton* nextBtn;
@property (nonatomic,strong) IBOutlet UIImageView* agreeImgView;
@property (nonatomic,strong) IBOutlet UIView* connectBgView;
@property (nonatomic,strong) IBOutlet UIImageView* leftImgView;
@property (nonatomic,strong) IBOutlet UIImageView* rightImgView;
@property (nonatomic,strong) IBOutlet UIImageView* circleImgView1;
@property (nonatomic,strong) IBOutlet UIImageView* circleImgView2;
@property (nonatomic,strong) IBOutlet UIImageView* circleImgView3;
@property (nonatomic,strong) IBOutlet UIImageView* circleImgView4;
@property (nonatomic,strong) IBOutlet UIImageView* circleImgView5;
@property (nonatomic,strong) NSMutableArray* iconArrs;
@property (nonatomic,assign) id<JinShuiqiWIFIController_ENDelegate>delegate;

@property (nonatomic,strong) NSString *currenType;

@end
