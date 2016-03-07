//
//  NetworkEntrance.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "NetworkEntrance.h"


@interface NetworkEntrance()
{
@private    
    NSMutableDictionary *mPostBodyDic;
    NSMutableArray *mPostFileArray;
    NSMutableDictionary *mPostHeadDic;
    NSMutableDictionary *mPostDic;
    NSString *mURLStr;
}
@end


@implementation NetworkEntrance

//初始化
- (id)init
{
	self=[super init];
    
	if(self)
	{
        mPostBodyDic = [[NSMutableDictionary alloc] init];
        mPostFileArray = [[NSMutableArray alloc] initWithCapacity:10];
        mPostHeadDic = [[NSMutableDictionary alloc] init];
        mPostDic = [[NSMutableDictionary alloc] init];
        [mPostHeadDic setValue:[[NetworkManager sharedInstance] aid] forKey:@"aid"];
	}	
	return self;
}

- (void)dealloc
{
    [mPostBodyDic release];
    [mPostFileArray release];
    [mPostHeadDic release];
    [mPostDic release];
    [mURLStr release];
    
    [super dealloc];
}

//生成post字典
- (void)addObject:(id)object forKey:(NSString *)key
{
    if (object != nil) {
        [mPostBodyDic setValue:object forKey:key];
    }
}

- (void)addFilePath:(NSString *)object forKey:(NSString *)key
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:object,key, nil];
    [mPostFileArray addObject:dic];
}

- (void)addBodyDic:(NSDictionary *)dic
{
    if (dic != nil) {
        [mPostBodyDic addEntriesFromDictionary:dic];
    }
}

//指定url
- (void)addURLString:(NSString *)urlString
{
    [urlString retain];
    [mURLStr release];
    mURLStr = [[NSString stringWithFormat:@"%@%@",[[NetworkManager sharedInstance] httpAdress],urlString] retain];
    [urlString release];
       
}

//指定cmd
- (void)addCmd:(NSString *)cmd
{
    [mPostHeadDic setValue:cmd forKey:@"cmd"];
   

}

//指定时间
- (void)addCreateDate:(NSString *)createDate
{
    [mPostHeadDic setValue:createDate forKey:@"de"];
}



//返回body字典
- (NSMutableDictionary *)bodyDicFromEntrance
{
    return mPostBodyDic;
}

//返回file数组
- (NSMutableArray *)fileArrFromEntrance
{
    return mPostFileArray;
}

//返回head字典
- (NSMutableDictionary *)headDicFromEntrance
{
    return mPostHeadDic;
}
//返回post字典
- (NSMutableDictionary *)postDicFromEntrance
{
    [mPostDic setValue:mPostHeadDic forKey:@"head"];
    [mPostDic setValue:mPostBodyDic forKey:@"con"];
    
    return mPostDic;
}

//返回data
- (NSData *)postDataFromEntrance
{
    return [mPostBodyDic NSJSONData];
}

//返回string
- (NSString *)postStringFromEntrance
{
    return [mPostBodyDic NSJSONString];
}


//返回url
- (NSString *)urlStringFromEntrance
{
    return mURLStr;
}

@end
