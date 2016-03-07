//
//  UToolBox.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-14.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "UToolBox.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sys/utsname.h"
#import <sys/time.h>
#import <libxml/HTMLparser.h>
#import <CoreText/CoreText.h>
#import <CoreLocation/CoreLocation.h>

@implementation UToolBox

+ (id) filterNull:(id)obj
{
    return [obj isEqual:[NSNull null]] ? nil : obj;
}

// 获取设备
+ (NSString* ) getDeviceDescription
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

// 获取app版本号
+ (NSString* ) getAPPVersion
{
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults]objectForKey:CURRENT_VERSION_INFO];
    NSString* versionStr = [dic objectForKey:@"CFBundleShortVersionString"];
    return versionStr;
}

// 获取app名字
+ (NSString* ) getAPPName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow(infoDictionary);
    
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}

+ (NSString *) gen_uuid;
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}

+(int) lenghtWithString:(NSString *)string
{
    int len = (int)string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return (int)len + (int)numMatch;
}

+ (NSMutableDictionary*)getAttributedStringHeightWithString:(NSAttributedString *)string WidthValue:(CGFloat)width fontsize:(float)fontsize
{
    if([string isKindOfClass:[NSNull class]] || string.length == 0)
    {
        return nil;
    }
   
    CGSize s ;
    int total_height = 0;
    int total_width = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    CGRect drawingRect = CGRectMake(0, 0, width, 2000.0);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = ( NSArray *) CTFrameGetLines(textFrame);

    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    CGFloat line_y = origins[[linesArray count] -1].y;
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    total_width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat space = ([linesArray count]-1)*1.0;
    total_height = 2000.0 - line_y + ceilf(descent)+ceilf(ascent) + ceilf(space) +1;
    
    if ([linesArray count] > 1)
    {
        s = CGSizeMake(width, total_height);
    }
    else//只有一行
    {
        s = CGSizeMake(total_width + 1, total_height);
    }
    
    NSMutableDictionary* muDic = [[[NSMutableDictionary alloc] init] autorelease];
    [muDic setValue:[NSString stringWithFormat:@"%f",s.height]forKey:@"height"];
    [muDic setValue:[NSString stringWithFormat:@"%f",s.width] forKey:@"width"];
    [muDic setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[linesArray count]] forKey:@"count"];
    
    CFRelease(textFrame);
    return muDic;
    
}

+ (CGFloat)getAgoThreeTotalHeight:(NSAttributedString *)string WidthValue:(CGFloat)width fontsize:(float)fontsize
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    CGRect drawingRect = CGRectMake(0, 0, width, 2000.0);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    
    NSArray *linesArray = ( NSArray *) CTFrameGetLines(textFrame);
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    CFRelease(textFrame);
    CFRelease(path);
    CFRelease(framesetter);
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    total_height = 0;
    for (int i=0; i<3; i++)
    {
        CTLineRef line = (CTLineRef) [linesArray objectAtIndex:i];
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        total_height += (ceil(ascent) +ceil(descent) +ceil(leading)+1);
    }
    
    return total_height;
}
//ios7 需要自己重新计算textview contentsize
+(CGFloat)measureHeightOfUITextView:(UITextView *)txtView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {//7.0以上我们需要自己计算高度
        float height = [[NSString stringWithFormat:@"%@\n ",txtView.text]
         boundingRectWithSize:CGSizeMake(txtView.frame.size.width, CGFLOAT_MAX)
         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
         attributes:[NSDictionary dictionaryWithObjectsAndKeys:txtView.font,NSFontAttributeName, nil] context:nil].size.height;
        
        if(height < 35)
        {
            return 35 ;
        }
        else
        {
            return ceilf(height) ;
        }
        
        
    }
    else
    {
        return  txtView.contentSize.height ;
    }
    
}


//原图路径加 _s 获取缩略图路径
+ (NSString* )convertToThumbPath:(NSString* )sourceStr
{
    NSArray* strs = [sourceStr componentsSeparatedByString:@"."];
    NSString* expand = [strs lastObject];
    
    NSString* thumbPath = nil;
    thumbPath = [[sourceStr componentsSeparatedByString:[NSString stringWithFormat:@".%@",expand]] objectAtIndex:0];
    thumbPath = [thumbPath stringByAppendingFormat:@"_s.%@",expand];
    
    return thumbPath;
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}


//缩略图去除 _s 获取原图路径
+ (NSString* )convertToSourcePath:(NSString* )thumbStr
{
    NSArray* strs = [thumbStr componentsSeparatedByString:@"_s"];
    NSString* sourcePath = nil;
    if ([strs count] >= 2)
    {
        sourcePath = [strs objectAtIndex:0];
        sourcePath = [sourcePath stringByAppendingString:[strs objectAtIndex:1]];
    }
    return sourcePath;
}

+ (CGSize)textSizeForText:(NSString*)text length:(int)length font:(int)font
{
    //判断返回是否为NSNull
    if([text isKindOfClass:[NSNull class]]){
        CGSize theSize=CGSizeMake(0, 0);
        return theSize;
    }
    else{
        CGFloat height = MAX([self numberOfLines:text]*30, [self numberOfLinesForMessage:text length:length]*30);
        
        
        return [text boundingRectWithSize:CGSizeMake(length, height)
         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
         attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil] context:nil].size;
    }

}

+ (int)numberOfLinesForMessage:(NSString *)txt length:(int)length
{
    return ((int)txt.length / length) + 1;
}

+(NSUInteger)numberOfLines:(NSString*)text
{
    return [text componentsSeparatedByString:@"\n"].count + 1;
}


// 生成二维码字符串
+ (NSString* ) buildDisilicideStr:(UNDWORD)uID withURL:(NSString*) url
{
    NSString* disilicideStr = nil;
    if (uID > 0)
    {
        disilicideStr = [NSString stringWithFormat:@"%@?userid=%llu",url,uID];
    }
    return disilicideStr;
}


+ (UNDWORD) getNow
{
    struct timeval t;
    gettimeofday(&t,NULL);
    long long dwTime = ((long long)1000000 * t.tv_sec + (long long)t.tv_usec)/1000;
    return dwTime;
}

//根据经纬度计算两个之间的距离
+ (NSString*)distanceBetweenOrderBy:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2
{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double distance = [curLocation distanceFromLocation:otherLocation];
    
    [otherLocation release];
    [curLocation release];
    if(distance <=999)
    {
        NSString* title = @"附近";
        return title;
    }
    else
    {
        NSString* title = [NSString stringWithFormat:@"%.1f公里",distance/1000];
        return title;
    }
}

// 时间是否是同一天比较
+ (BOOL) dateIsSameDay:(NSDate* )date1 otherDate:(NSDate* )date2
{
    NSCalendar *gregorian = [[[NSCalendar alloc]
                              initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    
    NSDateComponents *component1 = [gregorian components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                        fromDate: date1];
    NSDateComponents* component2 = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date2];

    if (component1.year == component2.year && component1.month == component2.month && component1.day == component2.day)
    {
        return YES;
    }
    
    return NO;
}

//判断时间是否是同一星期返回传入时间的开始日期,如果两个开始日期相同则是同一星期
/*
 NSGregorianCalendar 阳历
 NSBuddhistCalendar 佛历
 NSChineseCalendar 中国日历
 NSHebrewCalendar 希伯来日历
 NSIslamicCalendar 伊斯兰日历
 NSIslamicCivilCalendar 伊斯兰民事日历
 NSJapaneseCalendar 日本日历
 */
+ (NSDate*)dateStartOfWeek:(NSDate*)date
{
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese] autorelease];
    [gregorian setFirstWeekday:2];//设置星期从星期一开始
    
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    
    NSDateComponents* componentsToSubtract = [[[NSDateComponents alloc] init] autorelease];
    
    [componentsToSubtract setDay:-((([components weekday]-[gregorian firstWeekday])+7)%7)];
    
    NSDate* beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    return beginningOfWeek;
}

//取这个月的第一天零点
+ (NSDate*)theMonthFirstDayZero
{
    //取这个月的
    NSDate* monthFirstDay = [UToolBox dateStartOfMonth:[NSDate date]];
    //取整
    NSInteger monthZeor = ((int)[monthFirstDay timeIntervalSince1970])/86400*86400;
    monthFirstDay = [[NSDate alloc]initWithTimeIntervalSince1970:monthZeor];
    
    return monthFirstDay;
}

+ (NSDate*)dateFromStr:(NSString*)dateStr
{
    //NSTimeZone* localzone = [NSTimeZone localTimeZone];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:GTMzone];
    NSDate *bdate = [dateFormatter dateFromString:dateStr];
    //NSDate *day = [NSDate dateWithTimeInterval:([localzone secondsFromGMT]) sinceDate:bdate];
    return bdate;
}

+(NSMutableArray*)getWeekFromToday
{
    NSMutableArray* muArr = [[[NSMutableArray alloc]init] autorelease];
    NSDate* date=[NSDate date];
    date = [UToolBox dateStartOfWeek:date];
    NSString* dateStr = [UToolBox stringFromDate:date format:@"yyyy-MM-dd HH:mm:ss"];
    date = [UToolBox dateFromStr:dateStr];
    [muArr addObject:date];
    
    for(int i=0;i<6;i++)
    {
        date = [UToolBox GetTomorrowDay:date];
        NSString* dateStr = [UToolBox stringFromDate:date format:@"yyyy-MM-dd HH:mm:ss"];
        date = [UToolBox dateFromStr:dateStr];
        [muArr addObject:date];
    }
    
    return muArr;
}

+ (NSDate*)dateStartOfMonth:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSString *datestr=[NSString stringWithFormat:@"%ld-%ld-01 %ld:%ld:%ld",(long)[dateComponent year],(long)[dateComponent month],(long)[dateComponent hour],(long)[dateComponent minute],(long)[dateComponent second]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDate *firstDay = [dateFormatter dateFromString:datestr];

    return firstDay;
}

+ (NSDate*)dateByAddCountDay:(int)count
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setDay:([components day]+count)];
    NSDate *currentDate = [gregorian dateFromComponents:components];
    return currentDate;
}

+ (NSMutableArray*)getMonthFromToday
{
    NSMutableArray* muArr = [[[NSMutableArray alloc]init] autorelease];
    NSDate* monthDate = [UToolBox dateStartOfMonth:[NSDate date]];
    NSString* dateStr = [UToolBox stringFromDate:monthDate format:@"yyyy-MM-dd HH:mm:ss"];
    monthDate = [UToolBox dateFromStr:dateStr];
    [muArr addObject:monthDate];
    
    NSArray* arr = [dateStr componentsSeparatedByString:@" "];
    dateStr = [arr objectAtIndex:0];
    arr = [dateStr componentsSeparatedByString:@"-"];
    dateStr = [arr objectAtIndex:1];
    int nCount = [UToolBox monthCount:[dateStr intValue]];
    for(int i = 1; i< nCount;i++)
    {
        monthDate = [UToolBox GetTomorrowDay:monthDate];
        NSString* dateStr = [UToolBox stringFromDate:monthDate format:@"yyyy-MM-dd HH:mm:ss"];
        monthDate = [UToolBox dateFromStr:dateStr];
        [muArr addObject:monthDate];
    }
    return muArr;
}

//返回 今天的零点
+ (NSDate*)todayZero
{
    NSDate* date=[[NSDate alloc] initWithTimeIntervalSince1970:(int)([[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970])/86400*86400];
    return date;
}

+ (int)monthCount:(int)month
{
    switch (month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
        {
            return 31;
        }
        case 4:
        case 6:
        case 9:
        case 11:
        {
            return 30;
        }
        case 2:
        {
            return 28;
        }
            
        default:
            return 0;
    }
}

+(NSDate *)GetTomorrowDay:(NSDate *)aDate
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    return beginningOfWeek;
}

// alert提示
+ (void) alertNotifyError:(NSString* )title content:(NSString* )content threadState:(BOOL)isOnMainThread target:(id)delgate btnNum:(int)num
{
    UIAlertView *alertView = nil;
    if (num == 1)
    {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:content
                                              delegate:delgate
                                     cancelButtonTitle:@"确定"
                                     otherButtonTitles:nil, nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:content
                                              delegate:delgate
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"确定", nil];
    }
    
    if (isOnMainThread)
    {
        [alertView show];
    }
    else
    {
        [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    [alertView release];
}


//NSdate转NSString
+ (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format
{
    //NSDate* date = [NSDate dateWithTimeIntervalSince1970:sec];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString* strDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    return strDate;
}

//sec 转换为NSString
+ (NSString*)stringFromInterval:(long long)sec format:(NSString*)format
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:sec];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString* strDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    return strDate;
}

//把服务器时间转化为longlong
+ (UNDWORD)longlongTimeFromStr:(NSString*)dateStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //设置时区
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    dateStr = [[dateStr componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSDate* date = [dateFormatter dateFromString:dateStr];
    [dateFormatter release];
    
    NSTimeInterval longTime = [date timeIntervalSince1970];
    
    return longTime;
}

+ (NSString*)timeStr:(NSString *)dateStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //设置时区
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    dateStr = [[dateStr componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSDate* date = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval longTime = [date timeIntervalSince1970];
    
    NSString* timeStr = [NSString stringWithFormat:@"%lld",(UNDWORD)longTime*1000];
    
    [dateFormatter release];
    
    return timeStr;
}

+ (NSString *)starStringFromMonth:(int)month day:(int)day
{
    switch (month) {
        case 3:
        {
            if (day <= 20) {
                return @"双鱼座";
            }
            else
            {
                return @"白羊座";
            }
            
        }
            break;
        case 4:
        {
            if (day <= 19) {
                return @"白羊座";
            }
            else
            {
                return @"金牛座";
            }
            
        }
            break;
        case 5:
        {
            if (day <= 20) {
                return @"金牛座";
            }
            else
            {
                return @"双子座";
            }
            
        }
            break;
        case 6:
        {
            if (day <= 21) {
                return @"双子座";
            }
            else
            {
                return @"巨蟹座";
            }
            
        }
            break;
        case 7:
        {
            if (day <= 22) {
                return @"巨蟹座";
            }
            else
            {
                return @"狮子座";
            }
            
        }
            break;
        case 8:
        {
            if (day <= 22) {
                return @"狮子座";
            }
            else
            {
                return @"处女座";
            }
            
        }
            break;
        case 9:
        {
            if (day <= 22) {
                return @"处女座";
            }
            else
            {
                return @"天秤座";
            }
            
        }
            break;
        case 10:
        {
            if (day <= 23) {
                return @"天秤座";
            }
            else
            {
                return @"天蝎座";
            }
            
        }
            break;
        case 11:
        {
            if (day <= 22) {
                return @"天蝎座";
            }
            else
            {
                return @"射手座";
            }
            
        }
            break;
        case 12:
        {
            if (day <= 21) {
                return @"射手座";
            }
            else
            {
                return @"摩羯座";
            }
            
        }
            break;
        case 1:
        {
            if (day <= 19) {
                return @"摩羯座";
            }
            else
            {
                return @"水瓶座";
            }
            
        }
            break;
        case 2:
        {
            if (day <= 18) {
                return @"水瓶座";
            }
            else
            {
                return @"双鱼座";
            }
            
        }
            break;
            
        default:
            return nil;
    }
    return nil;
}


+ (int)starStringToStarId:(NSString *)starString
{
    NSArray *arr = [NSArray arrayWithObjects:@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座", nil];
    for (int i=0;i<[arr count];i++) {
        NSString *str = [arr objectAtIndex:i];
        if ([str isEqualToString:starString]) {
            return i;
        }
    }
    NSLog(@"传入星座错误");
    return -1;
}


+ (NSString *)starIdTostarString:(int)starId
{
    if (starId<0||starId>11) {
        NSLog(@"传入星座id错误");
        return nil;
    }
    else
    {
        NSArray *arr = [NSArray arrayWithObjects:@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座", nil];
        return [arr objectAtIndex:starId];
    }
}

+ (void)addLocalNotification:(NSString*)body count:(int)count
{
    
    //定义本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    //设置调用时间
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0.0];//通知触发的时间，10s以后
    notification.repeatInterval=1;//通知重复次数
    
    //设置通知属性
    notification.alertBody=body; //通知主体
    notification.applicationIconBadgeNumber=count;//应用程序图标右上角显示的消息数
    notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
    notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    //调用通知
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    [notification release];
}

//取前三位手机号码以及后三位手机号码
+ (NSString*)getSubStringByPhoneNum:(NSString*)phone
{
    if(phone.length>3)
    {
        NSString* preStr = [phone substringWithRange:NSMakeRange(0, 3)];
        NSString* suffStr = [phone substringWithRange:NSMakeRange(phone.length-3, 3)];
        return [NSString stringWithFormat:@"%@****%@",preStr,suffStr];
    }
    else
    {
        return @"";
    }
    
}

//跳转到AppStore
+ (void)skipToAppStore:(int)appId
{
    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",appId];
    if(IOS_7) {
        evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",appId];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
}

+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
