//
//  LeftViewController.h
//  StarShow
//
//  Created by 常 贤明 on 4/30/14.
//  Copyright (c) 2014 常 贤明. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_CELL_HEIGHT     44
#define FIRST_CELL_HEIGHT       175

@protocol LeftItemDelegate <NSObject>

- (void)dSelectItemIndex:(NSInteger)index;

@end

@interface LeftViewController : UIViewController
{
    NSArray* mCellArr;
    NSArray* mCellBgArr;
}

@property (nonatomic,assign)id<LeftItemDelegate> iDelegate;
@property (nonatomic,retain) NSArray* cellArr;
@property (nonatomic,retain) NSArray* cellBgArr;

@end
