//
//  NSAttributedStringView.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-12-18.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedStringView : UIView

@property (nonatomic,retain) NSString* mySourceString;
@property (nonatomic,retain) NSMutableArray* contentMuArr;
@property (nonatomic,assign) int textFont;

- (void)toAssinMySourceString:(NSString*)string muArr:(NSMutableArray*)muArr font:(int)font;

@end
