//
//  CDatabase.m
//  Persistence
//
//  Created by hupo on 3/29/11.
//  Copyright 2011 deirlym. All rights reserved.
//

#import "Database.h"
#import "AppShare.h"
#import "unistd.h"

////////////////////////////////////////////////////////////////////
@implementation ColumnDesc

@synthesize bIsKey;
@synthesize nColumType;
@synthesize nsColumName;

- (void)dealloc
{
	[nsColumName release];
    [super dealloc];
}

@end

////////////////////////////////////////////////////
@implementation TabelDesc

@synthesize columnArray;
@synthesize nsTableName;

- (id) init
{
	if(self=[super init])
	{
		NSMutableArray *array=[[NSMutableArray alloc] init];
		self.columnArray=array;
		[array release];
	}
	return self;
}

//添加列
- (void) AddColumn:(int) nType colName:(NSString *) nsColName primary:(BOOL) bKey
{
	ColumnDesc * colDesc=[[ColumnDesc alloc] init];
	colDesc.nColumType=nType;
	colDesc.nsColumName=nsColName;
	colDesc.bIsKey=bKey;
	[self.columnArray addObject:colDesc];
    [colDesc release];
}

- (void)dealloc
{
	[columnArray release];
	[nsTableName release];
    [super dealloc];
}

@end


///////////////////////////////////////////////////

@implementation ParamInfo

@synthesize paramType;
@synthesize nValue64;
@synthesize dbValue;
@synthesize szValue;

- (id) init
{
	if(self=[super init])
	{
		paramType=0;
		nValue64=0;
		dbValue=0.0f;
		szValue=NULL;
	}
	return self;
}

- (void)dealloc
{
	if(szValue!=NULL)
		free(szValue);
	
    [super dealloc];
}

@end

///////////////////////////////////////////////////////
@implementation DataBaseParam

@synthesize paramArray;
@synthesize nsSqlText;

- (id) init
{
	if(self=[super init])
	{
		NSMutableArray *array=[[NSMutableArray alloc] init];
		self.paramArray=array;
		[array release];
	}
	return self;
}

- (void) AddParamText:(NSString *) nsParam
{
	const char * pValue=[nsParam UTF8String];
	[self AddParamString:pValue];
}

- (void) AddParamString:(const char *) szParam
{
	ParamInfo * param=[[ParamInfo alloc] init];
    if (szParam == nil) //cxm 2012-07-02 添加判断
    {
        param.szValue=0;
        param.nValue64=0;
        param.paramType=DT_TEXT;
        [paramArray addObject:param];
        [param release];
        return;
    }
	int nLen=(int)strlen(szParam);
	char * pNew=(char*)malloc(nLen+1);
	memcpy(pNew,szParam,nLen);
	pNew[nLen]=0;
	param.szValue=pNew;
	param.nValue64=nLen;
	param.paramType=DT_TEXT;
	[paramArray addObject:param];
    [param release];
}

- (void) AddParamInt:(int) nParam
{
	ParamInfo * param=[[ParamInfo alloc] init];
	
	param.nValue64=nParam;
	param.paramType=DT_INT;
	[paramArray addObject:param];
    [param release];
}

- (void) AddParamDouble:(double) dbParam
{
	ParamInfo * param=[[ParamInfo alloc] init];
	param.dbValue=dbParam;
	param.paramType=DT_DOUBLE;
	[paramArray addObject:param];
    [param release];
}

- (void) AddParamInt64:(sqlite_int64) n64Param
{
	ParamInfo * param=[[ParamInfo alloc] init];
	param.nValue64=n64Param;
	param.paramType=DT_INT64;
	[paramArray addObject:param];
    [param release];
}

- (void) AddBlobParameter:(void *) pData datalen:(int) nDataLenght
{
	ParamInfo * param=[[ParamInfo alloc] init];
	
	char * pNew=(char *)malloc(nDataLenght);
	memcpy(pNew,pData,nDataLenght);
	param.szValue=pNew;
	param.nValue64=nDataLenght;
	param.paramType=DT_BLOB;
	[paramArray addObject:param];
	[param release];
}

- (void) dealloc
{
	[paramArray release];
	[nsSqlText release];
    [super dealloc];
}

@end

///////////////////////////////////////////////////////////////////
@implementation CDatabase

@synthesize nsDBName;


- (BOOL) OpenDatabase:(NSString *) dbName
{
	self.nsDBName=dbName;
    
    sqlite3_shutdown();
    NSLog(@"sqlite3 lib version: %s", sqlite3_libversion());
    int err=sqlite3_config(SQLITE_CONFIG_SERIALIZED);
    if (err == SQLITE_OK) {
        NSLog(@"Can now use sqlite on multiple threads, using the same connection");
    } else {
        NSLog(@"setting sqlite thread safe mode to serialized failed!!! return code: %d", err);
    }
    err = sqlite3_open([self.nsDBName UTF8String], &database);
    if(err != SQLITE_OK) {
        NSLog(@"datebase open error: %d", err);
        return NO;
    }
	
//	if(sqlite3_open([self.nsDBName UTF8String],&database)!=SQLITE_OK)
//	{
//		sqlite3_close(database);
//		NSAssert(0,@"Failed to open database");
//		return NO;
//	}
	return YES;
}

- (void) CloseDataBase
{
	sqlite3_close(database);
}

//执行命令脚本
- (BOOL) ExecCmd:(NSString *) nsSql
{
	char * errorMsg;
	if(sqlite3_exec(database, [nsSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSAssert1(0,@"Error creating table:%s",errorMsg);
		return NO;
	}
	return YES;
}

//执行带参数命令脚本
- (BOOL) ExecCmdByParam:(DataBaseParam *) params
{
	sqlite3_stmt * stmt;
    
	if(sqlite3_prepare_v2(database,[params.nsSqlText UTF8String],-1,&stmt,nil)!=SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(database));
        
        NSString* logStr = [NSString stringWithFormat:@"sqlite3_prepare_v2 Err:%s  time:%@\n",sqlite3_errmsg(database),[UToolBox stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"]];
        [AppShare writeLogWithString:logStr];
		return NO;
    }
    
	NSMutableArray *array=params.paramArray;
	NSInteger nCount=[array count];
	for(int i=0;i<nCount;i++)
	{
		ParamInfo * pInfo =[array objectAtIndex:i];
		switch (pInfo.paramType) {
            case DT_INT:
			{
				int nValue=(int)pInfo.nValue64;
				sqlite3_bind_int(stmt,i+1,nValue);
			}
                break;
            case DT_INT64:
                sqlite3_bind_int64(stmt,i+1,pInfo.nValue64);
                break;
            case DT_TEXT:
                sqlite3_bind_text(stmt,i+1,pInfo.szValue,-1,NULL);
                break;
            case DT_DOUBLE:
                sqlite3_bind_double(stmt,i+1,pInfo.dbValue);
                break;
            case DT_BLOB:
			{
				int nLen=(int)pInfo.nValue64;
				sqlite3_bind_blob(stmt,i+1,pInfo.szValue, nLen,NULL);
			}
                break;
            default:
                break;
		}
	}
	
	//char * errorMsg;
	BOOL bSuccess=YES;
	if(sqlite3_step(stmt) !=SQLITE_DONE)
	{
		bSuccess=NO;
        NSLog(@"error: %s", sqlite3_errmsg(database));
        NSString* logStr = [NSString stringWithFormat:@"sqlite3_step Err:%s  time:%@\n",sqlite3_errmsg(database),[UToolBox stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"]];
        [AppShare writeLogWithString:logStr];
	}
	sqlite3_finalize(stmt);
	
	return bSuccess;
}

//创建表
- (BOOL) CreateTable:(TabelDesc *) tableDesc
{
	if(tableDesc==nil)
		return NO;
	if(tableDesc.nsTableName==nil)
		return NO;
	
	NSMutableArray *colArray=tableDesc.columnArray;
	NSInteger nColCount=[colArray count];
	if(nColCount==0)
		return NO;
	
	NSMutableString * createSql=[[NSMutableString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@(",tableDesc.nsTableName];
	for(NSInteger i=0;i<nColCount;i++)
	{
		ColumnDesc * col=[colArray objectAtIndex:i];
		[createSql appendString:col.nsColumName];
		switch (col.nColumType) {
			case DT_INT:
				[createSql appendString:@" INTEGER"];
				break;
			case DT_INT64:
				[createSql appendString:@" NUMERIC"];
				break;
			case DT_TEXT:
				[createSql appendString:@" TEXT"];
				break;
			case DT_DOUBLE:
				[createSql appendString:@" REAL"];
				break;
			case DT_BLOB:
				[createSql appendString:@" NONE"];
				break;
			default:
				break;
		}
		if(col.bIsKey)
		{
			[createSql appendString:@" PRIMARY KEY"];
		}
		if(i<nColCount-1)
		{
			[createSql appendString:@","];
		}
	}
	[createSql appendString:@");"];
	
	//NSLog(createSql);
	char * errorMsg;
	if(sqlite3_exec(database, [createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		NSAssert1(0,@"Error creating table:%s",errorMsg);
        [createSql release];
		return NO;
	}
	[createSql release];
	return YES;
}

//准备语句
- (STATEMENT *) PrepareSQL:(NSString *) sqlText
{
	STATEMENT * pstateInfo = NULL;
	sqlite3_stmt * statement;
	if(sqlite3_prepare_v2(database, [sqlText UTF8String], -1, &statement, nil)==SQLITE_OK)
	{
		pstateInfo = (STATEMENT *)malloc(sizeof(STATEMENT));
		if(pstateInfo==NULL)
		{
			sqlite3_finalize(statement);
			return nil;
		}
		pstateInfo->statement=statement;
		pstateInfo->nColIndex=0;
	}
	return pstateInfo;
}

- (BOOL) PrepareSdw:(NSString *)sql
{
    const char *sql_stmt = [sql UTF8String];
    char* err;
    if(sqlite3_exec(database, sql_stmt, NULL, NULL, &err) == SQLITE_OK){
        
        if(sqlite3_exec(database,[@"drop table 'label_info_table'" UTF8String], NULL, NULL, &err) == SQLITE_OK)
        {
            
            if(sqlite3_exec(database,[@"CREATE TABLE IF NOT EXISTS 'label_info_table' (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)" UTF8String], NULL, NULL, &err) == SQLITE_OK)
            {
                
                return YES;
                
            }
            else
            {
                
                return NO;
                
            };
            
        }
        else
        {
            
            return NO;
            
        };
        
    }
    else
    {
        return NO;
    }
}

//准备语句
- (STATEMENT *) PrepareSQLByParam:(DataBaseParam *) params
{
	if(params==nil)
		return NULL;
    
	STATEMENT * pstateInfo=NULL;
	sqlite3_stmt * statement;
	if(sqlite3_prepare_v2(database, [params.nsSqlText UTF8String], -1, &statement, nil)!=SQLITE_OK)
	{
		return nil;
	}
	
	NSMutableArray *array=params.paramArray;
	NSInteger nCount=[array count];
	for(int i=0;i<nCount;i++)
	{
		ParamInfo * pInfo =[array objectAtIndex:i];
		switch (pInfo.paramType) {
			case DT_INT:
            {
                int nValue=(int)pInfo.nValue64;
                sqlite3_bind_int(statement,i+1,nValue);
            }
				break;
			case DT_INT64:
				sqlite3_bind_int64(statement,i+1,pInfo.nValue64);
				break;
			case DT_TEXT:
				sqlite3_bind_text(statement,i+1,pInfo.szValue,-1,NULL);
				break;
			case DT_DOUBLE:
				sqlite3_bind_double(statement,i+1,pInfo.dbValue);
				break;
			case DT_BLOB:
            {
                int nLen=(int)pInfo.nValue64;
                sqlite3_bind_blob(statement,i+1,pInfo.szValue, nLen,NULL);
            }
				break;
			default:
				break;
		}
	}
	
	pstateInfo=(STATEMENT *)malloc(sizeof(STATEMENT));
	if(pstateInfo==NULL)
	{
		sqlite3_finalize(statement);
		return nil;
	}
	pstateInfo->statement=statement;
	pstateInfo->nColIndex=0;
	
	return pstateInfo;
}

//获下一行
- (BOOL) GetNextColumn:(STATEMENT *) statement
{
	sqlite3_stmt * stmt=(sqlite3_stmt *)statement->statement;
	if(sqlite3_step(stmt)==SQLITE_ROW)
	{
		statement->nColIndex=0;
		return YES;
	}
    
	return NO;
}

//获取数据
- (UNDWORD)GetColumnUNDOWD:(NSString*)name
{
  UNDWORD value=  sqlite3_value_int64((sqlite3_value*)@"id");
    return value;

}
//获取数据
- (int) GetColumnInt:(STATEMENT *) statement
{
	sqlite3_stmt * stmt=(sqlite3_stmt *)statement->statement;
	int nValue=sqlite3_column_int(stmt, statement->nColIndex++);
	return nValue;
}

- (sqlite_int64) GetColumnInt64:(STATEMENT *) statement
{
	sqlite3_stmt * stmt=(sqlite3_stmt *)statement->statement;
	sqlite_int64 nValue=sqlite3_column_int64(stmt, statement->nColIndex++);
	return nValue;
}

- (char *) GetColumnString:(STATEMENT *) statement
{
	sqlite3_stmt * stmt=(sqlite3_stmt *)statement->statement;
	char * rowData=(char*)sqlite3_column_text(stmt,statement->nColIndex++);
	return rowData;
}

- (NSString *) GetColumnText:(STATEMENT *) statement
{
	sqlite3_stmt * stmt=(sqlite3_stmt *)statement->statement;
	char * rowData=(char*)sqlite3_column_text(stmt,statement->nColIndex++);
	if(rowData==NULL)
		return nil;
	NSString * fieldValue=[[[NSString alloc] initWithUTF8String:rowData] autorelease];
	return fieldValue;
}

- (double) GetColumnDouble:(STATEMENT *) statement
{
	sqlite3_stmt * stmt=(sqlite3_stmt *)statement->statement;
	double nValue=sqlite3_column_double(stmt, statement->nColIndex++);
	return nValue;
}

- (int) GetColumnBlod:(STATEMENT *) statement blobBuffer:(void *)dataBuffer bufLen:(int) buffLen
{
	sqlite3_stmt * stmt=(sqlite3_stmt *)statement->statement;
	int nDataLen=sqlite3_column_bytes(stmt,statement->nColIndex);
	const void * colData=sqlite3_column_blob(stmt, statement->nColIndex++);
	if(buffLen>nDataLen)
		buffLen=nDataLen;
	memcpy(dataBuffer, colData, buffLen);
	return nDataLen;
}

- (int) GetColumnBlod:(STATEMENT *) statement blobBuffer:(void **)dataBuffer
{
	assert(*dataBuffer==NULL);
	sqlite3_stmt * stmt=(sqlite3_stmt *)statement->statement;
	int nDataLen=sqlite3_column_bytes(stmt,statement->nColIndex);
	*dataBuffer=malloc(nDataLen);
	if(*dataBuffer==NULL)
		return 0;
	const void * colData=sqlite3_column_blob(stmt, statement->nColIndex++);
	memcpy(*dataBuffer, colData, nDataLen);
	return nDataLen;
}

- (void) FinishColumn:(STATEMENT *) statement
{
	sqlite3_stmt * stmt=(sqlite3_stmt *)statement->statement;
	sqlite3_finalize(stmt);	
	free(statement);
}

- (sqlite_int64) GetLastInsertID
{
	return sqlite3_last_insert_rowid(database);
}

- (void)dealloc 
{
	[nsDBName release];	
    [super dealloc];
}


//----------------------------------------Addtion------------------------------------------
- (BOOL)executeUpdate:(NSString*)sql, ...{
    va_list args;
    va_start(args, sql);
    
    BOOL result = [self executeUpdate:sql withArgumentsInArray:nil orDictionary:nil orVAList:args];
    
    va_end(args);
    return result;
}

- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments {
    return [self executeUpdate:sql withArgumentsInArray:arguments orDictionary:nil orVAList:nil];
}

- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments {
    return [self executeUpdate:sql withArgumentsInArray:nil orDictionary:arguments orVAList:nil];
}

- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray*)arrayArgs orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args {     

    int rc                   = 0x00;
    sqlite3_stmt *pStmt      = 0x00;
    
    if (!pStmt)
    {
        rc = sqlite3_prepare_v2(database, [sql UTF8String], -1, &pStmt, 0);
        if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc)
        {
            NSLog(@"database busy");
            sqlite3_finalize(pStmt);
            return NO;
        }
        else if (SQLITE_OK != rc) {
            NSLog(@"sql error");
            sqlite3_finalize(pStmt);
            return NO;
        }
    }
    
    id obj;
    int idx = 0;
    int queryCount = sqlite3_bind_parameter_count(pStmt);
    
    if (dictionaryArgs) {
        for (NSString *dictionaryKey in [dictionaryArgs allKeys]) {
            NSString *parameterName = [[NSString alloc] initWithFormat:@":%@", dictionaryKey];
            int namedIdx = sqlite3_bind_parameter_index(pStmt, [parameterName UTF8String]);
            [parameterName release];
            if (namedIdx > 0) {
                [self bindObject:[dictionaryArgs objectForKey:dictionaryKey] toColumn:namedIdx inStatement:pStmt];
                idx++;
            }
            else {
                NSLog(@"Could not find index for %@", dictionaryKey);
            }
        }
    }
    else
    {
        while (idx < queryCount) {
            if (arrayArgs && idx < (int)[arrayArgs count]) {
                obj = [arrayArgs objectAtIndex:(NSUInteger)idx];
            }
            else if (args) {
                obj = va_arg(args, id);
            }
			else {
				break;
			}
            idx++;
            [self bindObject:obj toColumn:idx inStatement:pStmt];
        }
    }

    
    if (idx != queryCount) {
        NSLog(@"Error: the bind count (%d) is not correct for the # of variables in the query (%d) (%@) (executeUpdate)", idx, queryCount, sql);
        sqlite3_finalize(pStmt);
        return NO;
    }
    rc  = sqlite3_step(pStmt);
    int closeErrorCode;
    closeErrorCode = sqlite3_finalize(pStmt);  
    if (closeErrorCode != SQLITE_OK) {
        NSLog(@"Unknown error finalizing or resetting statement (%d: %s)", closeErrorCode, sqlite3_errmsg(database));
        NSLog(@"DB Query: %@", sql);
    }
    return (rc == SQLITE_DONE || rc == SQLITE_OK);
}

- (void)bindObject:(id)obj toColumn:(int)idx inStatement:(sqlite3_stmt*)pStmt {
    
    if ((!obj) || ((NSNull *)obj == [NSNull null])) {
        sqlite3_bind_null(pStmt, idx);
    }   
    else if ([obj isKindOfClass:[NSData class]]) {
        const void *bytes = [obj bytes];
        if (!bytes) {
            bytes = "";
        }
        sqlite3_bind_blob(pStmt, idx, bytes, (int)[obj length], SQLITE_STATIC);
    }
    else if ([obj isKindOfClass:[NSDate class]]) {
            sqlite3_bind_double(pStmt, idx, [obj timeIntervalSince1970]);
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        
        if (strcmp([obj objCType], @encode(BOOL)) == 0) {
            sqlite3_bind_int(pStmt, idx, ([obj boolValue] ? 1 : 0));
        }
        else if (strcmp([obj objCType], @encode(int)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        }
        else if (strcmp([obj objCType], @encode(long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        }
        else if (strcmp([obj objCType], @encode(long long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longLongValue]);
        }
        else if (strcmp([obj objCType], @encode(unsigned long long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, (long long)[obj unsignedLongLongValue]);
        }
        else if (strcmp([obj objCType], @encode(float)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj floatValue]);
        }
        else if (strcmp([obj objCType], @encode(double)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj doubleValue]);
        }
        else {
            sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
        }
    }
    else {
        sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
    }
}

- (DBResultSet *)executeQuery:(NSString*)sql, ... {
    va_list args;
    va_start(args, sql);
    
    id result = [self executeQuery:sql withArgumentsInArray:nil orDictionary:nil orVAList:args];
    
    va_end(args);
    return result;
}

- (DBResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments {
    return [self executeQuery:sql withArgumentsInArray:arguments orDictionary:nil orVAList:nil];
}

- (DBResultSet *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments {
    return [self executeQuery:sql withArgumentsInArray:nil orDictionary:arguments orVAList:nil];
}

- (DBResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray*)arrayArgs orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args {
    
    int rc                  = 0x00;
    sqlite3_stmt *pStmt     = 0x00;
    Statement *statement    = 0x00;
    DBResultSet *rs         = 0x00;
    
    if (!pStmt) {
        rc = sqlite3_prepare_v2(database, [sql UTF8String], -1, &pStmt, 0);
        if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
            NSLog(@"database busy");
            sqlite3_finalize(pStmt);
            return nil;
        }
        else if (SQLITE_OK != rc) {
            NSLog(@"sql error!!!\nsql description:%@",sql);
            sqlite3_finalize(pStmt);
            return nil;
        }
    }
    
    id obj;
    int idx = 0;
    int queryCount = sqlite3_bind_parameter_count(pStmt);
    
    if (dictionaryArgs) {
        
        for (NSString *dictionaryKey in [dictionaryArgs allKeys]) {
            
            NSString *parameterName = [[NSString alloc] initWithFormat:@":%@", dictionaryKey];
            
            int namedIdx = sqlite3_bind_parameter_index(pStmt, [parameterName UTF8String]);
            [parameterName release];
            
            
            if (namedIdx > 0) {
                [self bindObject:[dictionaryArgs objectForKey:dictionaryKey] toColumn:namedIdx inStatement:pStmt];
                idx++;
            }
            else {
                NSLog(@"Could not find index for %@", dictionaryKey);
            }
        }
    }
    else {
        
        while (idx < queryCount) {
            
            if (arrayArgs && idx < (int)[arrayArgs count]) {
                obj = [arrayArgs objectAtIndex:(NSUInteger)idx];
            }
            else if (args) {
                obj = va_arg(args, id);
            }
			else {
                
				break;
			}
            
            
            
            idx++;
            
            [self bindObject:obj toColumn:idx inStatement:pStmt];
        }
    }
    
    if (idx != queryCount) {
        NSLog(@"Error: the bind count is not correct for the # of variables (executeQuery)");
        sqlite3_finalize(pStmt);
        
        return nil;
    }
    [statement retain];
    
    
    if (!statement) {
        statement = [[Statement alloc] init];
        [statement setStatement:pStmt];
    }
    
    rs = [DBResultSet resultSetWithStatement:statement];
    [rs setQuery:sql];
    
    
    [statement setUseCount:[statement useCount] + 1];
    [statement release];
    
    return rs;
}


- (NSString *)dbParmStr:(NSArray *)keyArr
{
    NSString *dbParmStr = [NSString string];
    for (NSString *str in keyArr) {
        dbParmStr = [dbParmStr stringByAppendingString:[NSString stringWithFormat:@",:%@",str]];
    }
    return [dbParmStr substringFromIndex:1];
}

- (NSString *)dbColumnStr:(NSArray *)keyArr
{
    NSString *dbColumnStr = [NSString string];
    for (NSString *str in keyArr) {
        dbColumnStr = [dbColumnStr stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
    }
    return [dbColumnStr substringFromIndex:1];
}


- (NSString *)dbParmColumnStr:(NSArray *)keyArr
{
    NSString *dbParmColumnStr = [NSString string];
    for (NSString *str in keyArr) {
        dbParmColumnStr = [dbParmColumnStr stringByAppendingString:[NSString stringWithFormat:@",%@ = :%@",str,str]];
    }
    return [dbParmColumnStr substringFromIndex:1];
}

@end

@implementation Statement
@synthesize statement=_statement;
@synthesize query=_query;
@synthesize useCount=_useCount;

- (void)finalize {
    [self close];
    [super finalize];
}

- (void)dealloc {
    [self close];
    [_query release];
    [super dealloc];
    
}

- (void)close {
    if (_statement) {
        sqlite3_finalize(_statement);
        _statement = 0x00;
    }
}

- (void)reset {
    if (_statement) {
        sqlite3_reset(_statement);
    }
}

@end
