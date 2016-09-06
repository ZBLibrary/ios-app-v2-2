//
//  AylaIOManager.h
//  OznerLibraryDemo
//
//  Created by 赵兵 on 16/7/13.
//  Copyright © 2016年 Ozner. All rights reserved.
//

#import "IOManager.h"
#import "AylaIO.h"
 typedef void (^AylaLoginSuccess)(BOOL);
@interface AylaIOManager : IOManager
{
    //MQTTProxy* proxy;
    NSMutableDictionary* listenDeviceList;
}

-(void) Start:(NSString*) user Token:(NSString*)Token CallBack: (AylaLoginSuccess)callback;
-(AylaIO*) createAylaIO:(AylaDevice*)device;
-(void) removeDevice:(NSString*) identifier;
-(AylaDevice*) getAylaDevice:(NSString*) identifier;
+(BOOL) isAylaSSID:(NSString*) ssid;
@end
