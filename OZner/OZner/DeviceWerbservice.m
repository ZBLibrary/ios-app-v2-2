//
//  DeviceWerbservice.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/21.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "DeviceWerbservice.h"
#import "WebAssistant.h"
#import "LoginManager.h"

@implementation DeviceWerbservice

//添加设备
- (ASIFormDataRequest*)addDevice:(NSString*)mac name:(NSString*)name deviceType:(NSString*)deveiceType deviceAddress:(NSString*)deviceAddress weight:(NSString*)weight returnBlock:(void(^)(StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mac forKey:@"Mac"];
    [entrance addObject:name forKey:@"Name"];
    [entrance addObject:deveiceType forKey:@"DeviceType"];
    [entrance addObject:deviceAddress forKey:@"DeviceAddress"];
    [entrance addObject:weight forKey:@"Weight"];
    [entrance addURLString:WERB_URL_ADD_DEVICE];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(status);
    } failedBlock:^(StatusManager *status) {
        handle(status);
    }];
}
//获取设备列表
- (ASIFormDataRequest*)getDeviceList:(void(^)(StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addURLString:WERB_URL_GET_DEVICE_LIST];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        
    } failedBlock:^(StatusManager *status) {
        
    }];
}

//更新设备
- (ASIFormDataRequest*)updateDevice:(NSString*)mac keyArr:(NSArray*)keyArr valueArr:(NSArray*)valueArr returnBlock:(void(^)(StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mac forKey:@"Mac"];
    for(int i=0;i<keyArr.count;i++)
    {
        [entrance addObject:[valueArr objectAtIndex:i] forKey:[keyArr objectAtIndex:i]];
    }
    
    [entrance addURLString:WERB_URL_UPDATE_DEVICE];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        
    } failedBlock:^(StatusManager *status) {
        
    }];
}

//删除设备
- (ASIFormDataRequest*)deleteDevice:(NSString*)mac returnBlock:(void(^)(StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mac forKey:@"Mac"];
    [entrance addURLString:WERB_URL_DELETE_DEVICE];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        
    } failedBlock:^(StatusManager *status) {
        
    }];
}

//饮水量传感器
- (ASIFormDataRequest*)volumeSensor:(NSString*)mac type:(NSString*)type volume:(NSString*)volume returnBlock:(void(^)(NSNumber* rank, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mac forKey:@"mac"];
    [entrance addObject:type forKey:@"type"];
    [entrance addObject:volume forKey:@"volume"];
    [entrance addURLString:WERB_URL_VOLUME_SENSOR];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSNumber* rank = [NSNumber numberWithInt:[[dicBody objectForKey:@"state"] intValue]];
        handle(rank,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

//获取tds数据
- (ASIFormDataRequest*)tdsSensor:(NSString*)mac type:(NSString*)type tds:(NSString*)tds beforetds:(NSString*)beforetds returnBlock:(void(^)(NSNumber* rank,NSNumber* total, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mac forKey:@"mac"];
    [entrance addObject:type forKey:@"type"];
    [entrance addObject:tds forKey:@"tds"];
    [entrance addObject:beforetds forKey:@"beforetds"];
    [entrance addURLString:WERB_URL_TDS_SENSOR];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSNumber* rank = [NSNumber numberWithInt:[[dicBody objectForKey:@"rank"] intValue]];
        NSNumber* total = [NSNumber numberWithInt:[[dicBody objectForKey:@"total"] intValue]];
        handle(rank,total,status);
        NSLog(@"dicBody=%@\n",[dicBody description]);
    } failedBlock:^(StatusManager *status) {
        handle([NSNumber numberWithInt:0],[NSNumber numberWithInt:0],status);
    }];
}

//获取滤芯设备服务时间
- (ASIFormDataRequest*)filterService:(NSString*)mac returnBlock:(void(^)(NSString* modifyTime,NSNumber* userDay, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mac forKey:@"mac"];
    [entrance addURLString:WERB_URL_FILTER_SERVICE];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSString* modifyTime = [dicBody objectForKey:@"modifytime"];
        NSNumber* userDay = [dicBody objectForKey:@"useday"];
        handle(modifyTime,userDay,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,nil,status);
    }];
}
//更新滤芯服务时间 /OznerDevice/RenewFilterTime
- (ASIFormDataRequest*)RenewFilterTime:(NSString*)mac devicetype:(NSString*)devicetype code:(NSString*)code  returnBlock:(void(^)(NSDictionary* Dic,NSString* state, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mac forKey:@"mac"];
    [entrance addObject:devicetype forKey:@"devicetype"];
    [entrance addObject:code forKey:@"code"];
    [entrance addURLString:WERB_URL_Renew_Filter_Time];
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSString* state = [dicBody objectForKey:@"state"];
        handle(dicBody,state,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,nil,status);
    }];
}
//获取好友内的当天排名详情
- (ASIFormDataRequest*)volumeFriendRank:(void(^)(NSNumber* rank,NSMutableArray* muArr, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addURLString:WERB_URL_VOLUME_FRIEND_RANK];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSMutableArray* arrtmp=[dicBody objectForKey:@"data"];
        if (arrtmp.count>0) {
            
            handle([arrtmp[0] objectForKey:@"rank"],arrtmp,status);
        }
        else
        {
            handle(0,nil,status);
        }

    } failedBlock:^(StatusManager *status) {
        handle(0,nil,status);
    }];
}
//获取好友内的TDS排名详情/OznerDevice/TdsFriendRank
- (ASIFormDataRequest*)TdsFriendRank:(NSString*)type returnBlock:(void(^)(NSNumber* rank,NSMutableArray* muArr, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:type forKey:@"type"];
    [entrance addURLString:WERB_URL_Tds_Friend_Rank];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSMutableArray* arrtmp=[dicBody objectForKey:@"data"];
        if (arrtmp.count>0) {
            
            handle([arrtmp[0] objectForKey:@"rank"],arrtmp,status);
        }
        else
        {
            handle([NSNumber numberWithInt:1],nil,status);
        }
        
    } failedBlock:^(StatusManager *status) {
        handle([NSNumber numberWithInt:1],nil,status);
    }];
}
//ip定位天气信息
- (ASIFormDataRequest*)getWeather:(NSString*)cityName returnBlock:(void(^)(NSString*pollution,NSString* cityname,NSString* PM25,NSString* AQI,NSString* temperature,NSString* humidity,NSString* dataFrom,StatusManager* status))handle
{
    NetworkEntrance* entrance = [NetworkEntrance alloc];
    if(cityName.length > 0)
    {
        [entrance addObject:cityName forKey:@"city"];
    }
    [entrance addURLString:WERB_URL_GET_WHEATHER];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSString* dataFrom=(NSString*)[dicBody objectForKey:@"weatherform"];
        //解析json
        NSString *responseString=(NSString*)[dicBody objectForKey:@"data"];;
        
        NSData *tmpdata = [responseString dataUsingEncoding:NSUTF8StringEncoding];
     
        NSError *error = nil;
        
        id jsonObject = [NSJSONSerialization JSONObjectWithData:tmpdata options:NSJSONReadingAllowFragments error:&error];
        
        if ([jsonObject isKindOfClass:[NSMutableDictionary class]]){
            
            id tmpdictionary = [[jsonObject objectForKey:@"HeWeather data service 3.0"] objectAtIndex:0];
            id tmpdic=[[tmpdictionary objectForKey:@"aqi"] objectForKey:@"city"];
            NSString* pollution=(NSString*)[tmpdic objectForKey:@"qlty"];//中度污染
            NSString* AQI=(NSString*)[tmpdic objectForKey:@"aqi"];
            NSString* PM25=(NSString*)[tmpdic objectForKey:@"pm25"];
            NSString* cityname=(NSString*)[[tmpdictionary objectForKey:@"basic"] objectForKey:@"city"];//上海
            NSString* tmptime=(NSString*)[[[tmpdictionary objectForKey:@"basic"] objectForKey:@"update"]
                      objectForKey:@"loc"];//"2015-12-25 02:54"
            dataFrom=[dataFrom stringByAppendingString:@"   "];
            dataFrom=[dataFrom stringByAppendingString:tmptime];
            dataFrom=[dataFrom stringByAppendingString:@"发布"];
            NSString* humidity=(NSString*)[[tmpdictionary objectForKey:@"now"] objectForKey:@"hum"];
            NSString* temperature=(NSString*)[[tmpdictionary objectForKey:@"now"] objectForKey:@"tmp"];
           
            handle(pollution,cityname,PM25,AQI,temperature,humidity,dataFrom,status);
            
        }else {
            
            handle(@"",@"",@"",@"",@"",@"",@"",status);
            
        }
        
        
        
    } failedBlock:^(StatusManager *status) {
        handle(@"",@"",@"",@"",@"",@"",@"",status);
    }];
}
//获取净水器周月数据
- (ASIFormDataRequest*)GetDeviceTdsFenBu:(NSString*)mac returnBlock:(void(^)(NSArray* weekRecord,NSArray* monthRecord,StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:mac forKey:@"mac"];
    [entrance addURLString:Get_Device_Tds_FenBu];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSMutableArray* tmpweek=[dicBody objectForKey:@"week"];
        NSMutableArray* tmpmonth=[dicBody objectForKey:@"month"];
        handle(tmpweek,tmpmonth,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,nil,status);
    }];
}
//获取水机滤芯服务到期时间
- (ASIFormDataRequest*)GetMachineLifeOutTime:(NSString*)mac  returnBlock:(void(^)(NSString* endTime,NSString* nowTime, StatusManager* status))handle{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:mac forKey:@"mac"];
    //[entrance addObject:code forKey:@"code"];
    [entrance addURLString:Get_Machine_LifeOut_Time];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle([dicBody objectForKey:@"time"],[dicBody objectForKey:@"nowtime"],status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,nil,status);
    }];
}
//检查水机的功能种类
- (ASIFormDataRequest*)GetMachineType:(NSString*)type returnBlock:(void(^)(NSString* MachineType,NSString* Attr,NSString* BuyUrl, StatusManager* status))handle{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:type forKey:@"type"];
    [entrance addURLString:Get_Machine_Type];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSLog(@"%@",dicBody);
        id tmpdic=[dicBody objectForKey:@"data"];
        handle([tmpdic objectForKey:@"MachineType"],[tmpdic objectForKey:@"Attr"],[tmpdic objectForKey:@"buylinkurl"],status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,nil,nil,status);
    }];
}
//更新补水仪的数值  /OznerDevice/UpdateBuShuiYiNumber Face ，Eyes ,Hands, Neck
- (ASIFormDataRequest*)UpdateBuShuiYiNumber:(NSString*)mac ynumber:(NSString*)ynumber snumber:(NSString*)snumber action:(NSString*)action returnBlock:(void(^)(StatusManager* status))handle{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:mac forKey:@"mac"];
    [entrance addObject:ynumber forKey:@"ynumber"];
    [entrance addObject:snumber forKey:@"snumber"];
    [entrance addObject:action forKey:@"action"];
    [entrance addURLString:Update_BuShuiYi_Number];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSLog(@"%@",dicBody);
        handle(status);
    } failedBlock:^(StatusManager *status) {
        handle(status);
    }];
}

//获取周月补水仪器数值分布  /OznerServer/GetBuShuiFenBu Face ，Eyes ,Hands, Neck
- (ASIFormDataRequest*)GetBuShuiFenBu:(NSString*)mac action:(NSString*)action returnBlock:(void(^)(NSDictionary *Attr, StatusManager* status))handle{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:mac forKey:@"mac"];
    [entrance addObject:action forKey:@"action"];
    [entrance addURLString:Get_BuShui_FenBu];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSLog(@"%@",dicBody);
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}
//GetPost/OznerDevice/GetTimesCountBuShui获取补水仪检测次数
- (ASIFormDataRequest*)GetTimesCountBuShui:(NSString*)mac action:(NSString*)action returnBlock:(void(^)(NSString * Times, StatusManager* status))handle{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:mac forKey:@"mac"];
    [entrance addObject:action forKey:@"action"];
    [entrance addURLString:Get_TimesCount_BuShui];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSLog(@"%@",dicBody);
        handle(@"",status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}
@end
