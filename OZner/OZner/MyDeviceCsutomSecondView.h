//
//  MyDeviceCsutomSecondView.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/25.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTListView.h"
#import "MyDeviceCustomSecondCellView.h"
#import "WaterPurifier.h"

@interface MyDeviceCsutomSecondView : UIView<JTListViewDataSource,JTListViewDelegate,MyDeviceCustomSecondCellViewDelegate>
{
    JTListView* mListView;
}

@property (nonatomic,strong) NSMutableArray* titleArr;
@property (nonatomic,strong) NSMutableArray* normalImgArr;
@property (nonatomic,strong) NSMutableArray* selectImgArr;
@property (nonatomic,strong) WaterPurifier* waterDevice;

@end
