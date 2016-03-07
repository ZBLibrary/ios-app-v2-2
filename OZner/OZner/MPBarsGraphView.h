//
//  MPBarsGraphView.h
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPPlot.h"

@interface MPBarsGraphView : MPPlot{
    
    BOOL shouldAnimate;
}

@property (nonatomic,readwrite) CGFloat topCornerRadius;
@property (nonatomic,assign)    int mCurrentType;
@property (nonatomic,retain)    NSMutableArray* zongArr;

- (id)initWithFrame:(CGRect)frame timeType:(int)timeType;


@end
