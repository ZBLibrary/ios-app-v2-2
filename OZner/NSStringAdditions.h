//
//  NSStringAdditions.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (NSStringAdditions)

- (NSArray *)traverseUsingRegularExp:(NSString *)reg;
- (BOOL)matchRegularExp:(NSString *)reg;

- (NSString *)stringFromMD5;

- (NSString *)encodeForURL;
- (NSString *)encodeForURLReplacingSpacesWithPlus;
- (NSString *)decodeFromURL;

- (NSDate *)timeStampDate;

//// 宽度固定，计算文本高度
//- (CGSize)caculateSizeWithFontSize:(CGFloat)fontsize withWidth:(CGFloat)width breakMode:(NSLineBreakMode)mode;

@end
