//
//  DBResultSet.h
//  DatabaseDemo
//
//  Created by 张 斌 on 13-11-13.
//  Copyright (c) 2013年 张 斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Database;
@class Statement;

@interface DBResultSet : NSObject {

    Statement         *_statement;    
    NSString            *_query;
    NSMutableDictionary *_columnNameToIndexMap;
}

@property (atomic, retain) NSString *query;
@property (readonly) NSMutableDictionary *columnNameToIndexMap;
@property (atomic, retain) Statement *statement;

+ (instancetype)resultSetWithStatement:(Statement *)statement;

- (void)close;
- (NSString*)stringForColumn:(NSString*)columnName;
- (NSString*)stringForColumnIndex:(int)columnIdx;
- (BOOL)next;
- (int)columnCount;

//other
- (int)columnIndexForName:(NSString*)columnName;
- (NSString*)columnNameForIndex:(int)columnIdx;
- (int)intForColumn:(NSString*)columnName;
- (int)intForColumnIndex:(int)columnIdx;
- (long)longForColumn:(NSString*)columnName;
- (long)longForColumnIndex:(int)columnIdx;
- (long long int)longLongIntForColumn:(NSString*)columnName;
- (long long int)longLongIntForColumnIndex:(int)columnIdx;
- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName;
- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx;
- (BOOL)boolForColumn:(NSString*)columnName;
- (BOOL)boolForColumnIndex:(int)columnIdx;
- (double)doubleForColumn:(NSString*)columnName;
- (double)doubleForColumnIndex:(int)columnIdx;
- (id)objectForColumnName:(NSString*)columnName;
- (id)objectForColumnIndex:(int)columnIdx;
- (NSDate*)dateForColumn:(NSString*)columnName;
- (NSDate*)dateForColumnIndex:(int)columnIdx;
- (NSData*)dataForColumn:(NSString*)columnName;
- (NSData*)dataForColumnIndex:(int)columnIdx;
- (const unsigned char *)UTF8StringForColumnName:(NSString*)columnName;
- (const unsigned char *)UTF8StringForColumnIndex:(int)columnIdx;
- (NSData*)dataNoCopyForColumn:(NSString*)columnName NS_RETURNS_NOT_RETAINED;
- (NSData*)dataNoCopyForColumnIndex:(int)columnIdx NS_RETURNS_NOT_RETAINED;
- (BOOL)columnIndexIsNull:(int)columnIdx;
- (BOOL)columnIsNull:(NSString*)columnName;

@end
