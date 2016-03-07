//
//  NSData+NSDictionary+JSON.h
//
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (JSON_Parser)

//json转obj
- (id)JSONObject;

@end

@interface NSData (JSON_Parser)

//json转obj
- (id)JSONObject;

@end

@interface NSDictionary (JSON_Parser)

//json转obj
- (NSData *)NSJSONData;

//json转string
- (NSString *)NSJSONString;

@end

@interface NSArray (JSON_Parser)

//json转string
- (NSString *)NSArrayJSONString;

@end