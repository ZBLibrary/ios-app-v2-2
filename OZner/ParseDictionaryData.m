//
//  ParseDictionaryData.m
//  BusinessPlatform
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "ParseDictionaryData.h"

@implementation ObjFieldName


@synthesize key;
 

- (NSObject**) getValue
{
	return (NSObject**)value;
}

- (void) setValue:(NSObject **) valueAddr
{
	value = (void **)valueAddr;
}

//释放内存
- (void)dealloc
{
    [key release];
    [super dealloc];
}

@end

@implementation ParseDictionaryData

//初始化
- (id)init
{
	self=[super init];

	if(self)
	{
		if (fieldArray != nil) 
		{
			[fieldArray release];
			fieldArray = nil;
		}

        if (dbFieldArray != nil)
		{
			[dbFieldArray release];
			dbFieldArray = nil;
		}
		fieldArray=[[NSMutableArray alloc] init];
        dbFieldArray=[[NSMutableArray alloc] init];
		[self InitSubFieldName];
	}
	
	return self;
}

//读取字典数据
- (id)InitWithDictionary:(NSDictionary *) dicObj
{
	self = [self init];
	if(self)
	{
		[self SetDictionary:dicObj];
	}
	
	return self;
}

//读取数据库字典数据
- (id)InitWithDBDictionary:(NSDictionary *) dicObj
{
    self = [self init];
	if(self)
	{
		[self SetDBDictionary:dicObj];
	}
	
	return self;
}

//转化为字典数据
- (NSMutableDictionary *)convertToDictionary
{
    NSMutableDictionary *objDic = [[[NSMutableDictionary alloc] initWithCapacity:20] autorelease];
    for(ObjFieldName * filed in fieldArray)
	{
        //        NSLog(@"%@",filed.key);
		NSObject** objValue=[filed getValue];
        if ((*objValue != nil)
            &&(![*objValue isKindOfClass:[NSNull class]])) {
            if (filed.bToNumIn && [*objValue isKindOfClass:[NSString class]]) {
                NSNumber *tempValue = [NSDecimalNumber decimalNumberWithString:(NSString *)*objValue];
                [objDic setValue:tempValue forKey:filed.key];
            }
            else
            {
                [objDic setValue:*objValue forKey:filed.key];
            }
        }
    }
    return objDic;
}

//转化为db字典数据
- (NSMutableDictionary *)convertToDBDictionary
{
    NSMutableDictionary *objDic = [[[NSMutableDictionary alloc] initWithCapacity:20] autorelease];
    for(ObjFieldName * filed in dbFieldArray)
	{
		NSObject** objValue=[filed getValue];
        if ((*objValue != nil)
            &&(![*objValue isKindOfClass:[NSNull class]])) {
            if (filed.bToNumIn && [*objValue isKindOfClass:[NSString class]]) {
                NSNumber *tempValue = [NSDecimalNumber decimalNumberWithString:(NSString *)*objValue];
                [objDic setValue:tempValue forKey:filed.key];
            }
            else
            {
                [objDic setValue:*objValue forKey:filed.key];
            }
        }
        else
        {
            [objDic setValue:[NSNull null] forKey:filed.key];
        }
    }
    return objDic;
}

//设置键值对对象
- (void)InitSubFieldName
{

}

//读取字典数据
- (id)SetDictionary:(NSDictionary *) dicObj
{
	for(ObjFieldName * filed in fieldArray)
	{
		NSObject** objValue=[filed getValue];
        
        if (([dicObj objectForKey:filed.key] !=nil)
            &&(![[dicObj objectForKey:filed.key] isKindOfClass:[NSNull class]])) {
            [*objValue release];
            if (filed.bToStrOut&&[[dicObj objectForKey:filed.key] isKindOfClass:[NSNumber class]])
                *objValue=[[[dicObj objectForKey:filed.key] stringValue] retain];
            else
                *objValue=[[dicObj objectForKey:filed.key] retain];
        }
    }
	return self;
}

//读取数据库字典数据
- (id)SetDBDictionary:(NSDictionary *) dicObj
{
	for(ObjFieldName * filed in dbFieldArray)
	{
		NSObject** objValue=[filed getValue];		
        
        if (([dicObj objectForKey:filed.key] !=nil)
            &&(![[dicObj objectForKey:filed.key] isKindOfClass:[NSNull class]])) {
            [*objValue release];
            if (filed.bToStrOut&&[[dicObj objectForKey:filed.key] isKindOfClass:[NSNumber class]])
                *objValue=[[[dicObj objectForKey:filed.key] stringValue] retain];
            else
                *objValue=[[dicObj objectForKey:filed.key] retain];
        }
    }
    
	return self;
}

//获取web的keys
- (NSMutableArray *)allKeys
{
    NSMutableArray *dbKeysArr = [[[NSMutableArray alloc] initWithCapacity:20] autorelease];
    for(ObjFieldName * filed in fieldArray)
	{
        [dbKeysArr addObject:filed.key];
    }
    return dbKeysArr;
}

//获取db的keys
- (NSMutableArray *)allDBKeys
{
    NSMutableArray *dbKeysArr = [[[NSMutableArray alloc] initWithCapacity:20] autorelease];
    for(ObjFieldName * filed in dbFieldArray)
	{
        [dbKeysArr addObject:filed.key];        
    }
    return dbKeysArr;
}

- (void)dealloc
{
    if(fieldArray)
    {
        [fieldArray release];
    }
    
    if(dbFieldArray)
    {
        [dbFieldArray release];
    }
    [super dealloc];
}
@end


