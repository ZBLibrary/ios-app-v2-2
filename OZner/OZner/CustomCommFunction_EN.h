//
//  CustomCommFunction.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 15-2-9.
//  Copyright (c) 2015年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomCommFunction_EN : NSObject
{
    dispatch_queue_t notifyQueue;
}

+(CustomCommFunction_EN*)customCommFunctionInstance;
//探头排序
- (NSArray*)sortTapListMaxTime:(NSArray*)arr;

@end
