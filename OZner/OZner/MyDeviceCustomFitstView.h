//
//  MyDeviceCustomFitstView.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/13.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPGraphView.h"

@interface MyDeviceCustomFitstView : UIView

@property (nonatomic,strong) MPGraphView* monthMpGraphView;
@property (nonatomic,strong) NSArray* monthArr;

- (void)layOUtTDSCell:(NSArray*)record;

@end
