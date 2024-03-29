//
//  ParseDictionaryData.h
//  BusinessPlatform
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>

//添加字段宏定义
#define ADD_FIELD(fn,strFn) ADD_WEB_DB(fn,strFn,nil)


//添加字段宏定义
#define ADD_DB(fn,strFn) ADD_WEB_DB(fn,nil,strFn)

//添加字段宏定义
#define ADD_WEB_DB(fn,webStrFn,dbStrFn) ADD_WEB_DB_WEBIN_DBIN_WEBOUT_DBOUT(fn,webStrFn,dbStrFn,NO,NO,NO,NO)


//添加字段宏定义
/*
 **  fn is the real variable,which will be mapped,the variable map to web interface with webStrFn or to db with
 **  dbStrFn,bToNumWebIn controls weather convert NSString type to NSNumber type when you want to post a dictionary to
 **  webservice,so as bToNumDbIn except associate with database,bToStrWebOut controls weather convert NSNumber or NSString
 **  type to the variable type when you want to wrap a dictionary to entity,so as bToStrDbOut except associate with
 **  database
 */
#define ADD_WEB_DB_WEBIN_DBIN_WEBOUT_DBOUT(fn,webStrFn,dbStrFn,bToNumWebIn,bToNumDbIn,bToStrWebOut,bToStrDbOut) if (webStrFn != nil)\
{ObjFieldName * webfiled_##fn=[[ObjFieldName alloc] init]; \
webfiled_##fn.key=webStrFn;							\
webfiled_##fn.bToNumIn=bToNumWebIn;							\
webfiled_##fn.bToStrOut=bToStrWebOut;							\
[webfiled_##fn setValue:&fn];						\
[fieldArray addObject:webfiled_##fn]; \
[webfiled_##fn release];}\
if (dbStrFn != nil)\
{ObjFieldName * dbfiled_##fn=[[ObjFieldName alloc] init]; \
dbfiled_##fn.key=dbStrFn;							\
dbfiled_##fn.bToNumIn=bToNumDbIn;							\
dbfiled_##fn.bToStrOut=bToStrDbOut;							\
[dbfiled_##fn setValue:&fn];						\
[dbFieldArray addObject:dbfiled_##fn]; \
[dbfiled_##fn release];}

@interface ObjFieldName : NSObject
{
	NSString		*key;
	void            **value;
}

@property (nonatomic, retain)NSString	*key;
@property (nonatomic, assign)BOOL       bToNumIn;
@property (nonatomic, assign)BOOL       bToStrOut;

- (NSObject**) getValue;
- (void) setValue:(NSObject **) valueAddr;

@end


@interface ParseDictionaryData : NSObject {
	NSMutableArray		*fieldArray;
    NSMutableArray      *dbFieldArray;
}
//初始化
- (id)init;

//设置键值对对象
- (void)InitSubFieldName;

//读取web字典数据
- (id)InitWithDictionary:(NSDictionary *) dicObj;

//读取db字典数据
- (id)InitWithDBDictionary:(NSDictionary *) dicObj;

//转化为web字典数据
- (NSMutableDictionary *)convertToDictionary;

//转化为db字典数据
- (NSMutableDictionary *)convertToDBDictionary;

//获取web的keys
- (NSMutableArray *)allKeys;

//获取db的keys
- (NSMutableArray *)allDBKeys;


@end
