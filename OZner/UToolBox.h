//
//  UToolBox.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-14.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UToolBox : NSObject

// 过滤掉值为NSNull的值，如果为NSNull则返回nil
+ (id) filterNull:(id) obj;

// 获取设备
+ (NSString* ) getDeviceDescription;

// 获取app版本号
+ (NSString* ) getAPPVersion;

// 获取app名字
+ (NSString* ) getAPPName;
//生成UUId
+ (NSString *) gen_uuid;

// 生成二维码字符串
+ (NSString*) buildDisilicideStr:(UNDWORD)uID withURL:(NSString*) url;

// 获取现在的时间
+ (UNDWORD) getNow;

//根据经纬度计算两个之间的距离
+ (NSString*)distanceBetweenOrderBy:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2;

// 时间是否是同一天比较
+ (BOOL) dateIsSameDay:(NSDate* )date1 otherDate:(NSDate* )date2;
//判断时间是否是同一星期返回传入时间的开始日期,如果两个开始日期相同则是同一星期
+ (NSDate*)dateStartOfWeek:(NSDate*)date;
//返回当前天所在的一周
+(NSMutableArray*)getWeekFromToday;
+ (NSMutableArray*)getMonthFromToday;
+ (NSDate*)dateStartOfMonth:(NSDate*)date;
+ (int)monthCount:(int)month;
+ (NSDate*)dateByAddCountDay:(int)count;
//返回 今天的零点
+ (NSDate*)todayZero;
//取这个月的第一天零点
+ (NSDate*)theMonthFirstDayZero;
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;

// alert提示
+ (void) alertNotifyError:(NSString* )title content:(NSString* )content threadState:(BOOL)isOnMainThread target:(id)delgate btnNum:(int)num;

//ios7 需要自己重新计算textview contentsize
+(CGFloat)measureHeightOfUITextView:(UITextView *)txtView;

// 字符串的高度
+ (CGSize)textSizeForText:(NSString*)text length:(int)length font:(int)font;
//字符串的行数
+(NSUInteger)numberOfLines:(NSString*)text;
//NSdate转NSString
+ (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format;
//sec 转换为NSString
+ (NSString*)stringFromInterval:(long long)sec format:(NSString*)format;
+ (void)addLocalNotification:(NSString*)body count:(int)count;
///Date()/转换
+ (NSString*)timeStr:(NSString*)dateStr;
//计算汉字的个数
+(int) lenghtWithString:(NSString *)string;

//原图路径加 _s 获取缩略图路径
+ (NSString* )convertToThumbPath:(NSString* )sourceStr;
//缩略图去除 _s 获取原图路径
+ (NSString* )convertToSourcePath:(NSString* )thumbStr;

//获取星座
+ (NSString *)starStringFromMonth:(int)month day:(int)day;

//星座 to starId
+ (int)starStringToStarId:(NSString *)starString;

//starId to 星座
+ (NSString *)starIdTostarString:(int)starId;

//NSString to NSAttributedString
+ (NSMutableDictionary*)getAttributedStringHeightWithString:(NSAttributedString *)string WidthValue:(CGFloat)width fontsize:(float)fontsize;

//获取前三行字符串的高度
+ (CGFloat)getAgoThreeTotalHeight:(NSAttributedString *)string WidthValue:(CGFloat)width fontsize:(float)fontsize;
//16进制转化成 iOS可用的颜色
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
//把服务器时间转化为longlong
+ (UNDWORD)longlongTimeFromStr:(NSString*)dateStr;

//跳转到AppStore
+ (void)skipToAppStore:(int)appId;
//取前三位手机号码以及后三位手机号码
+ (NSString*)getSubStringByPhoneNum:(NSString*)phone;


@end
