//
//  CustomCommFunction.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 15-2-9.
//  Copyright (c) 2015年 sunlinlin. All rights reserved.
//

#import "CustomCommFunction.h"

static CustomCommFunction* g_customCommFunction = nil;

@implementation CustomCommFunction

+(CustomCommFunction*)customCommFunctionInstance
{
    if(g_customCommFunction == nil)
    {
        g_customCommFunction = [[CustomCommFunction alloc] init];
    }
    
    return g_customCommFunction;
}

- (id)init
{
    if(self = [super init])
    {
        notifyQueue = dispatch_queue_create("notifyQueue", NULL);
    }
    
    return self;
}

//探头排序
- (NSArray*)sortTapListMaxTime:(NSArray*)arr
{
    NSComparator cmptr = ^(TapRecord* obj1, TapRecord* obj2){
        if ([obj1.Time timeIntervalSince1970] > [obj2.Time timeIntervalSince1970])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1.Time timeIntervalSince1970] < [obj2.Time timeIntervalSince1970])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray* muArr = [arr sortedArrayUsingComparator:cmptr];
    return muArr;
}

@end
