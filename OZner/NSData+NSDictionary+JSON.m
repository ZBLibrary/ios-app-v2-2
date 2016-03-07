//
//  NSData+NSDictionary+JSON.m
//
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//
//

#import "NSData+NSDictionary+JSON.h"

@implementation NSString (JSON_Parser)

- (id)JSONObject
{
    NSError * error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    return error ? nil : jsonObj;
}

@end

@implementation NSData (JSON_Parser)

- (id)JSONObject
{    
    NSError * error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:self options:0 error:&error];
    return error ? nil : jsonObj;
}

@end


@implementation NSDictionary (JSON_Parser)

//obj转json
- (NSData *)NSJSONData
{
    NSError * error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    return error ? nil : data;
}

//json转string
- (NSString *)NSJSONString
{
    NSError * error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    NSString *debugStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return error ? nil : debugStr;
}

@end

@implementation NSArray (JSON_Parser)

//json转string
- (NSString *)NSArrayJSONString
{
    NSError * error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    NSString *debugStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return error ? nil : debugStr;
}

@end

