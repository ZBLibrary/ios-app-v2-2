//
//  CDatabase.h
//  Persistence
//
//  Created by hupo on 3/29/11.
//  Copyright 2011 deirlym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DBResultSet.h"
#import "TypeDef.h"
#import "GlobalDef.h"

//////////////////////////////////////////////////////////////
#define DT_INT			0x01					//32位整型
#define DT_INT64		0x02					//64位整型
#define DT_DOUBLE		0x03					//double型
#define DT_TEXT			0x04					//字符串型
#define DT_BLOB			0x05					//二进制型

//////////////////////////////////////////////////////////////
@interface ColumnDesc : NSObject
{
	BOOL			bIsKey;
	int				nColumType;
	NSString		*nsColumName;
}

@property (nonatomic) BOOL bIsKey;
@property (nonatomic) int nColumType;
@property (nonatomic,retain) NSString *nsColumName;

@end
//////////////////////////////////////////////////////////////

@interface TabelDesc : NSObject
{
	NSMutableArray		*columnArray;			//列数组
	NSString			*nsTableName;			//表名
}

@property(nonatomic,retain) NSMutableArray *columnArray;
@property(nonatomic,retain) NSString *nsTableName;

//添加列
- (void) AddColumn:(int) nType colName:(NSString *) nsColName primary:(BOOL) bKey;

@end
//////////////////////////////////////////////////////////////

@interface ParamInfo : NSObject
{
@private
	int					paramType;				//参数类型
	sqlite_int64		nValue64;				//64位整型参数
	double				dbValue;				//double型
	char				*szValue;				//字符串型
}

@property (nonatomic) int paramType;
@property (nonatomic) sqlite_int64 nValue64;
@property (nonatomic) double dbValue;
@property (nonatomic) char * szValue;

@end


@interface DataBaseParam : NSObject
{
	NSMutableArray		*paramArray;
	
@private
	NSString			*nsSqlText;				//sql脚本
    
}

@property (nonatomic,retain) NSString *nsSqlText;
@property (nonatomic,retain) NSMutableArray *paramArray;

- (void) AddParamText:(NSString *) nsParam;
- (void) AddParamString:(const char *) szParam;
- (void) AddParamInt:(int) nParam;
- (void) AddParamDouble:(double) dbParam;
- (void) AddParamInt64:(sqlite_int64) n64Param;
- (void) AddBlobParameter:(void *) pData datalen:(int) nDataLenght;


@end

typedef struct tagStatement
{
	void	*statement;
	int		nColIndex;
}STATEMENT;

@interface Statement : NSObject {
    sqlite3_stmt *_statement;
    NSString *_query;
    long _useCount;
}
@property (atomic, assign) long useCount;
@property (atomic, retain) NSString *query;
@property (atomic, assign) sqlite3_stmt *statement;

- (void)close;
- (void)reset;

@end

//////////////////////////////////////////////////////////////
@interface CDatabase : NSObject
{
	NSString				*nsDBName;
	sqlite3					*database;
}

@property (nonatomic,retain) NSString *nsDBName;

//打开数据库
- (BOOL) OpenDatabase:(NSString *) dbName;
//关闭数据库
- (void) CloseDataBase;
//执行命令脚本
- (BOOL) ExecCmd:(NSString *) nsSql;
//执行带参数命令脚本
- (BOOL) ExecCmdByParam:(DataBaseParam *) params;
//创建表
- (BOOL) CreateTable:(TabelDesc *) tableDesc;
//准备语句
- (STATEMENT *) PrepareSQL:(NSString *) sqlText;
//准备语句
- (STATEMENT *) PrepareSQLByParam:(DataBaseParam *) params;
//获下一行
- (BOOL) GetNextColumn:(STATEMENT *) statement;
//获取数据
- (int) GetColumnInt:(STATEMENT *) statement;
- (sqlite_int64) GetColumnInt64:(STATEMENT *) statement;
- (char *) GetColumnString:(STATEMENT *) statement;
- (NSString *) GetColumnText:(STATEMENT *) statement;
- (double) GetColumnDouble:(STATEMENT *) statement;
- (int) GetColumnBlod:(STATEMENT *) statement blobBuffer:(void *)dataBuffer bufLen:(int) buffLen;
- (int) GetColumnBlod:(STATEMENT *) statement blobBuffer:(void **)dataBuffer;
- (void) FinishColumn:(STATEMENT *) statement;
- (sqlite_int64) GetLastInsertID;
- (UNDWORD)GetColumnUNDOWD:(NSString*)name;

- (BOOL) PrepareSdw:(NSString *)sql;

//----------------------------------------Addtion------------------------------------------
//不定参数增、删、改
- (BOOL)executeUpdate:(NSString*)sql, ...;
//参数数组增、删、改
- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
//参数字典增、删、改
- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;
//不定参数查
- (DBResultSet *)executeQuery:(NSString*)sql, ...;
//参数数组查
- (DBResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;
//参数字典查
- (DBResultSet *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;
//从数组中获取参数格式组包
- (NSString *)dbParmStr:(NSArray *)keyArr;
//从数组中获取列格式组包
- (NSString *)dbColumnStr:(NSArray *)keyArr;
//从数组中获取列和参数格式组包
- (NSString *)dbParmColumnStr:(NSArray *)keyArr;

@end


