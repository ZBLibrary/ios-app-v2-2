//
//  NetworkEntrance.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//
//生成请求字典

#import <Foundation/Foundation.h>
#import "NSData+NSDictionary+JSON.h"
#import "NetworkManager.h"

@interface NetworkEntrance : NSObject


//--------------------request url----------------------
//指定url
- (void)addURLString:(NSString *)urlString;

//--------------------request head---------------------
//指定cmd
- (void)addCmd:(NSString *)cmd;
//指定时间
- (void)addCreateDate:(NSString *)createDate;


//--------------------request body---------------------
//生成post字典
- (void)addObject:(id)object forKey:(NSString *)key;
- (void)addFilePath:(NSString *)object forKey:(NSString *)key;
- (void)addBodyDic:(NSDictionary *)dic;


//--------------------response -------------------------
//返回body字典
- (NSMutableDictionary *)bodyDicFromEntrance;
//返回file数组
- (NSMutableArray *)fileArrFromEntrance;
//返回head字典
- (NSMutableDictionary *)headDicFromEntrance;
//返回post字典
- (NSMutableDictionary *)postDicFromEntrance;
//返回data
- (NSData *)postDataFromEntrance;
//返回字符串
- (NSData *)postStringFromEntrance;
//返回url
- (NSString *)urlStringFromEntrance;
@end
