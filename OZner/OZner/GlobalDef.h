//
//  GlobalDef.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-15.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#ifndef BlackRoom_GlobalDef_h
#define BlackRoom_GlobalDef_h

typedef struct _RecordTime
{
    UInt8 year;
    UInt8 month;
    UInt8 day;
    UInt8 hour;
    UInt8 min;
    UInt8 sec;
}*lpRecordTime,TRecordTime;

//设置id的值类别
typedef enum
{
    SETTING_VALUES_OFF = 0, //关
    SETTING_VALUES_ON,      //开
    SETTING_VALUES_DEFAULT  //还没设置
}Setting_ID_Values;

//设置ID
typedef enum {
    SET_ID_REMERB_PSW = 0,                //是否记住密码
    SET_ID_DEVICE_CUP_FIRST,              //水杯饮水量
    SET_ID_DEVICE_CUP_SECOND              //水杯温度
}SETID;

//数据库当前版本值
#define DATABASE_CURRENT_VALUE          120100

//水温低
#define TEMPERATURE_LOW                 25
#define TEMPERATURE_HIGH                65

#define kDatabase                              @"db_ozner_"
#define kDatabase_uid                          @"db_ozner_uid.db"
#define kDatabase_pub                          @"db_ozner_pub.db"

//保存当前版本和buidInfo
#define CURRENT_VERSION_INFO                    @"Current_Version_Info"

#endif
