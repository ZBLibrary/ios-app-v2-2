//
//  AylaDiagnosticHelper.m
//  iOS_AylaLibrary
//
//  Created by Andy on 3/21/16.
//  Copyright © 2016 AylaNetworks. All rights reserved.
//

#import "AylaDiagnosticHelper.h"
#import "AylaNetworks.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#include <sys/sysctl.h>

#define APP_INFO_DICT [[NSBundle mainBundle] infoDictionary]
#define APP_NAME APP_INFO_DICT[@"CFBundleDisplayName"] == nil ? APP_INFO_DICT[@"CFBundleName"] : APP_INFO_DICT[@"CFBundleDisplayName"]
#define APP_VERSION_NAME APP_INFO_DICT[@"CFBundleShortVersionString"]
#define APP_VERSION_CODE APP_INFO_DICT[@"CFBundleVersion"]

@implementation AylaDiagnosticHelper

+ (NSString *)generateDiagnostics
{
    return [NSString stringWithFormat:@"\n\n"\
            @"************************************\n"\
            @"OS Version:%@ \nModel:%@ \nLocale:%@ \nRegion:%@ \nTimezone:%@ \nCarrier:%@ \nApp version name:%@ \nApp version code:%@ \nLib version name:%@ \nisJailbroken:%@\n"\
            @"************************************"\
            , self.OSVersion, self.model, self.language, self.region, self.timezone, self.carrier, APP_VERSION_NAME, APP_VERSION_CODE, amlVersion, @(self.isJailbroken)];
}

// ---------------------------- diagnostic info ----------------------------------
+ (NSString *)model
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return deviceModel;
}

+ (NSString *)OSVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)language
{
    return [NSLocale preferredLanguages].firstObject;
}

+ (NSString *)region
{
    NSLocale *currentLocal = [NSLocale currentLocale];
    NSString *countryCode = [currentLocal objectForKey:NSLocaleCountryCode];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; // always show as English
    return [usLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
}

+ (NSString *)carrier
{
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    return  carrier.carrierName;
}

+ (NSString *)timezone
{
    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    return timezone.name;
}

+ (BOOL)isJailbroken
{
#if TARGET_OS_SIMULATOR
    return NO;
#else
    NSURL* url = [NSURL URLWithString:@"cydia://package/com.example.package"];
    return [[UIApplication sharedApplication] canOpenURL:url];
#endif
}

@end
