//
//  WaterPurifier_Ayla.m
//  OznerLibraryDemo
//
//  Created by 赵兵 on 16/7/14.
//  Copyright © 2016年 Ozner. All rights reserved.
//

#import "WaterPurifier_Ayla.h"
#import "OznerDevice.hpp"
#import "Helper.h"





@interface WaterPurifier_Ayla()
{
    NSTimer* updateTimer;
    int _requestCount;
}
@end
@implementation WaterPurifier_Ayla

NSString* Property_Power = @"Power";
NSString* Property_Heating = @"Heating";
NSString* Property_Cooling = @"Cooling";
NSString* Property_Sterilization = @"Sterilization";
NSString* Property_Status = @"Status";
int requestCount = 0;

-(instancetype)init:(NSString *)identifier Type:(NSString *)type Settings:(NSString *)json
{
    if (self=[super init:identifier Type:type Settings:json])
    {
        self->_info=[[WaterPurifierInfo alloc] init];
//        self->_status=[[WaterPurifierStatus alloc] init:^(NSData *data,OperateCallback cb) {
//            return [self setStatus:data Callback:cb];
//        }];
//        self->_sensor=[[WaterPurifierSensor alloc] init];
        _isOffline=false;
    }
    return self;
}

-(NSString*) getProperty:(NSString*) name {
    if (io == nil) return @"";
    return [(AylaIO*)io getProperty:name];
}

-(BOOL)getPower
{
    if (_isOffline) {
        return false;
    }
    NSString* value = [self getProperty:Property_Power];
    if (!StringIsNullOrEmpty(value))
        return [NSNumber numberWithInt:value.intValue].boolValue;
    return false;
}
-(void)setPower:(BOOL)Power Callback:(OperateCallback)cb
{
    if (io == nil) {
        if (cb != nil)
            cb([NSError errorWithDomain:@"Connection Closed" code:0 userInfo:nil]);
        return;
    }
    NSMutableDictionary* object =  [[NSMutableDictionary alloc] init];
    [object setValue:Property_Power forKey:@"name"];
    [object setValue:[NSNumber numberWithBool:Power].stringValue forKey:@"value"];
    [io send:(NSData *)object Callback:cb];
}
-(BOOL)getHot
{
    if (_isOffline) {
        return false;
    }
    NSString* value = [self getProperty:Property_Heating];
    
    if (!StringIsNullOrEmpty(value))
        return [NSNumber numberWithInt:value.intValue].boolValue;
    return false;
}
-(void)setHot:(BOOL)Hot Callback:(OperateCallback)cb
{
    if (io == nil) {
        if (cb != nil)
            cb([NSError errorWithDomain:@"Connection Closed" code:0 userInfo:nil]);
        return;
    }
    NSMutableDictionary* object =  [[NSMutableDictionary alloc] init];
    [object setValue:Property_Heating forKey:@"name"];
    [object setValue:[NSNumber numberWithBool:Hot].stringValue forKey:@"value"];
    [io send:(NSData *)object Callback:cb];
}
-(BOOL)getCool
{
    if (_isOffline) {
        return false;
    }
    NSString* value = [self getProperty:Property_Cooling];
    
    if (!StringIsNullOrEmpty(value))
        return [NSNumber numberWithInt:value.intValue].boolValue;
    return false;
}
-(void)setCool:(BOOL)Cool Callback:(OperateCallback)cb
{
    if (io == nil) {
        if (cb != nil)
            cb([NSError errorWithDomain:@"Connection Closed" code:0 userInfo:nil]);
        return;
    }
    NSMutableDictionary* object =  [[NSMutableDictionary alloc] init];
    [object setValue:Property_Cooling forKey:@"name"];
    [object setValue:[NSNumber numberWithBool:Cool].stringValue forKey:@"value"];
    [io send:(NSData *)object Callback:cb];
}
-(BOOL)getSterilization
{
    if (_isOffline) {
        return false;
    }
    NSString* value = [self getProperty:Property_Sterilization];
    
    if (!StringIsNullOrEmpty(value))
        return [NSNumber numberWithInt:value.intValue].boolValue;
    return false;
}
-(void)setSterilization:(BOOL)Sterilization Callback:(OperateCallback)cb
{
    if (io == nil) {
        if (cb != nil)
            cb([NSError errorWithDomain:@"Connection Closed" code:0 userInfo:nil]);
        return;
    }
    NSMutableDictionary* object =  [[NSMutableDictionary alloc] init];
    [object setValue:Property_Sterilization forKey:@"name"];
    [object setValue:[NSNumber numberWithBool:Sterilization].stringValue forKey:@"value"];
    [io send:(NSData *)object Callback:cb];
}
-(void) setOffline:(BOOL)value
{
    if (value != _isOffline) {
        _isOffline = value;
        [self doStatusUpdate];
    }
}


-(void) updateStatus:(OperateCallback)cb {
    if (io == nil) {
        [self setOffline:true];
        //if (cb != nil&cb != NULL)
            //cb([NSError errorWithDomain:@"Connection Closed" code:0 userInfo:nil]);
        
    } else {
        
        if ([self isOffline] != [(AylaIO*)io isOffLine]) {
            [self setOffline:[(AylaIO*)io isOffLine]];
            
        }
        //if ([self isOffline] == false) {
            [(AylaIO*)io updateProperty];
        //}
        
    }
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"Power:%@,Hot:%@,Cool:%@,TDS1:%d,TDS2:%d",
            
            [NSNumber numberWithBool:[self getPower]],[NSNumber numberWithBool:[self getHot]],[NSNumber numberWithBool:[self getCool]] ,self.TDS1,self.TDS2];
}

//绑定io关键第一步
-(void)doSetDeviceIO:(BaseDeviceIO *)oldio NewIO:(BaseDeviceIO *)newio
{
    if ([newio isReady]) {
        [self DeviceIODidReadly:newio];
    }
   
}




-(void)loadAylaStatus:(NSString*)Value
{
    if (Value==nil) {
        return;
    }
    
    NSData* valueData=[Helper getBinaryByhex:Value];
    @try {
        //NSData* valueData = [Value dataUsingEncoding:NSUTF8StringEncoding];
        BytePtr bytes=(BytePtr)[valueData bytes];
        @try {
            [self->_info load_Ayla:bytes];
        } @catch (NSException *exception) {
            
        }
        NSString* tds1=[[NSString alloc] initWithBytes:bytes+104 length:2 encoding:NSASCIIStringEncoding];
        NSString* tds2=[[NSString alloc] initWithBytes:bytes+106 length:2 encoding:NSASCIIStringEncoding];
        _TDS1 = *((short*)(bytes+104));
        _TDS2 = *((short*)(bytes+106));
        NSLog(@"tds1:%d,tds2:%d",tds1.intValue,tds2.intValue);
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } 
    
}
//关键
-(void)DeviceIO:(BaseDeviceIO *)io recv:(NSData *)data
{
    _requestCount=0;
    if (_isOffline)
    {
        _isOffline=false;
        [self doStatusUpdate];
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if (dict.count > 0) {
        for (NSString* key in [dict allKeys]) {
            
            if ([key isEqualToString:Property_Status]) {
                [self loadAylaStatus:[dict objectForKey:key]];
                break;
            }
        }
        [self doSensorUpdate];
        [self doStatusUpdate];
    }
}


-(BOOL)DeviceIOWellInit:(BaseDeviceIO *)Io
{
    @try {
        _isOffline = false;
        _info.MainBoard  = [self getProperty:@"version"];
        [self loadAylaStatus:[self getProperty:@"Status"]];
        return true;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        return false;
    }
    
}
//
//
-(void)DeviceIODidReadly:(BaseDeviceIO *)Io
{
    [self setOffline:false];
    [self start_auto_update];
    @try {
        [super DeviceIODidReadly:Io];
    }
    @catch (NSException *exception) {
        
    }
    
}
//
-(void)DeviceIODidDisconnected:(BaseDeviceIO *)Io
{
    //[self stop_auto_update];
    [self doSensorUpdate];
    @try {
        [super DeviceIODidDisconnected:Io];
    }
    @catch (NSException *exception) {
        
    }
}
//
-(void)stop_auto_update
{
    if (self->updateTimer)
    {
        [updateTimer invalidate];
        updateTimer=nil;
    }
}
-(void)start_auto_update
{
    if (updateTimer)
        [self stop_auto_update];
    if (!updateTimer)
    {
        
        updateTimer=[NSTimer scheduledTimerWithTimeInterval:2.5 target:self
                                                   selector:@selector(updateStatus:)
                                                   userInfo:nil repeats:YES];
        [updateTimer fire];
    }
}

//-(void)auto_update
//{
//    [self reqeusetStatsus];
//}

@end


