//
//  ImageUtil.h
//  kabao
//
//  Created by apple on 13-5-28.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    once = 1,
    twice = 2
}TIMES;

@interface ImageUtil : NSObject

//拉伸图片,不缓存
+(UIImage *)imageNamed:(NSString *)name times:(TIMES)times top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

//平铺图片,不缓存
+(UIColor *)colorFromImage:(NSString *)name times:(TIMES)times;

//创建图片,不缓存
+(UIImage *)imageNamed:(NSString *)name times:(TIMES)times;

//缓存，2倍数需要@2x标识
+(UIImage *)imageNamedWithCache:(NSString *)name top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
@end
