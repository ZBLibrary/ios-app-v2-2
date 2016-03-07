//
//  ImageUtil.m
//  kabao
//
//  Created by apple on 13-5-28.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

+(UIImage *)imageNamed:(NSString *)name times:(TIMES)times top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    return [[UIImage imageWithCGImage:[UIImage imageNamed:name].CGImage scale:times orientation:UIImageOrientationUp] resizableImageWithCapInsets:UIEdgeInsetsMake(top, left,bottom, right)];
}

+(UIColor *)colorFromImage:(NSString *)name times:(TIMES)times
{
    return [UIColor colorWithPatternImage:[UIImage imageWithCGImage:[UIImage imageNamed:name].CGImage scale:times orientation:UIImageOrientationUp]];   
}

+(UIImage *)imageNamed:(NSString *)name times:(TIMES)times
{
    return [UIImage imageWithCGImage:[UIImage imageNamed:name].CGImage scale:times orientation:UIImageOrientationUp]; 
}

+(UIImage *)imageNamedWithCache:(NSString *)name top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    return [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top, left,bottom, right)];
}

@end

