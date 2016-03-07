//
//  TanTouErWeimaCell.h
//  OZner
//
//  Created by sunlinlin on 16/1/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TanTouErWeimaCellDeleagte <NSObject>

- (void)scanDiscode;

@end

@interface TanTouErWeimaCell : UITableViewCell

@property (nonatomic,assign) id<TanTouErWeimaCellDeleagte>delegate;

@end
