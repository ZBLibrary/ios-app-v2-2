//
//  WebAssistant.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.

#import "WebAssistant.h"
#import "LogInOut.h"
@implementation WebAssistant

+ (ASIFormDataRequest*) execRequest:(NetworkEntrance*)entrance bodyBlock:(void(^)(NSDictionary* dicBody, StatusManager* status))bodyHandler failedBlock:(void(^)(StatusManager* status))failedHandler
{
//    ASIFormDataRequest* request = [ConnectUtil request:kCustomRequest NetworkEntrance:entrance returnBlock:^(NSData *data, BOOL bISsuccess) {
//
//        HHTP_NetworkStatus status;
//        if(bISsuccess)
//        {
//            NSDictionary* dic = [data JSONObject];
//            if(dic != nil)
//            {
//                if([[dic objectForKey:@"state"] intValue] >0)
//                {
//                    status = kSuccessStatus;
//                    bodyHandler(dic,[StatusManager statusHead:[dic objectForKey:@"msg"] networkStatus:status errorCode:[[dic objectForKey:@"state"] intValue]]);
//                    NSLog(@"webservice success!");
//                    NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//                    NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//                    
//                }
//                else
//                {
//                    NSLog(@"webservice error!");
//                    NSLog(@"st error msg:%@",[dic objectForKey:@"msg"]);
//                    NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//                    NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//                    status =kHeadStError;
//                    failedHandler([StatusManager statusHead:[dic objectForKey:@"msg"] networkStatus:status errorCode:[[dic objectForKey:@"state"] intValue]]);
//                }
//                
//            }
//            else
//            {
//                NSLog(@"webservice error!");
//                NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//                NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//                status = kParseFailedStatus;
//                
//                failedHandler([StatusManager statusHead:[dic objectForKey:@"ResultDescription"] networkStatus:status errorCode:[[dic objectForKey:@"ResultNo"] intValue]]);
//            }
//        }
//        else
//        {
//            NSLog(@"webservice error!");
//            NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//            NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//            status = kResponseFailedStatus;
//            
//            failedHandler([StatusManager statusHead:@"当前网络不好，请稍后重试！" networkStatus:status errorCode:-100000]);
//        }
//        
//    }];
    
    return nil;
}

+ (ASIFormDataRequest*) execErrorRequest:(NetworkEntrance*)entrance bodyBlock:(void(^)(NSDictionary* dicBody, StatusManager* status))bodyHandler failedBlock:(void(^)(NSDictionary* dicBody, StatusManager* status))failedHandler
{
//    ASIFormDataRequest* request = [ConnectUtil request:kCustomRequest NetworkEntrance:entrance returnBlock:^(NSData *data, BOOL bISsuccess) {
//        
//        HHTP_NetworkStatus status;
//        if(bISsuccess)
//        {
//            NSDictionary* dic = [data JSONObject];
//            if(dic != nil)
//            {
//                if (![[dic objectForKey:@"body"] isKindOfClass:[NSNull class]])
//                {
//                    if([[dic objectForKey:@"ResultNo"] intValue] == 0)
//                    {
//                        status = kSuccessStatus;
//                        bodyHandler(dic,[StatusManager statusHead:[dic objectForKey:@"ResultDescription"] networkStatus:status errorCode:[[dic objectForKey:@"ResultNo"] intValue]]);
//                        NSLog(@"webservice success!");
//                        NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//                        NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//                        
//                    }
//                    
//                    else
//                    {
//                        NSLog(@"webservice error!");
//                        NSLog(@"st error msg:%@",[dic objectForKey:@"ResultDescription"]);
//                        NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//                        NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//                        status =kHeadStError;
//                        failedHandler(dic,[StatusManager statusHead:[dic objectForKey:@"ResultDescription"] networkStatus:status errorCode:[[dic objectForKey:@"ResultNo"] intValue]]);
//                    }
//                    
//                    
//                }
//                
//            }
//            else
//            {
//                NSLog(@"webservice error!");
//                NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//                NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//                status = kParseFailedStatus;
//                
//                failedHandler(nil,[StatusManager statusHead:[dic objectForKey:@"ResultDescription"] networkStatus:status errorCode:[[dic objectForKey:@"ResultNo"] intValue]]);
//            }
//        }
//        else
//        {
//            NSLog(@"webservice error!");
//            NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//            NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//            status = kResponseFailedStatus;
//            
//            failedHandler(nil,[StatusManager statusHead:@"当前网络不好，请稍后重试！" networkStatus:status errorCode:-100000]);
//        }
//        
//    }];
    
    return nil;
}


+ (ASIFormDataRequest*) execNormalkRequest:(NetworkEntrance*)entrance bodyBlock:(void(^)(NSDictionary* dicBody, StatusManager* status))bodyHandler failedBlock:(void(^)(StatusManager* status))failedHandler
{
//    ASIFormDataRequest* request = [ConnectUtil request:kNormalRequest NetworkEntrance:entrance returnBlock:^(NSData *data, BOOL bISsuccess) {
//        HHTP_NetworkStatus status;
//        if(bISsuccess)
//        {
//            NSDictionary* dic = [data JSONObject];
//            NSLog(@"%@",dic);
//            if(dic != nil)
//            {
//                if([[dic objectForKey:@"state"] intValue] > 0)
//                {
//                    status = kSuccessStatus;
//                    bodyHandler(dic,[StatusManager statusHead:[dic objectForKey:@"msg"] networkStatus:status errorCode:[[dic objectForKey:@"state"] intValue]]);
//                    NSLog(@"webservice success!");
//                    NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//                    NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//                    
//                }else if (([[dic objectForKey:@"state"] intValue] == -10007)||([[dic objectForKey:@"state"] intValue] == -10006))
//                {
//                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"账号已被登录，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                    [alert show];
//                    [[LogInOut loginInOutInstance] loginOutUser];
//                }
//                else
//                {
//                    NSLog(@"error code:%d",[[dic objectForKey:@"state"] intValue]);
//                    NSLog(@"webservice error!");
//                    NSLog(@"st error msg:%@",[dic objectForKey:@"msg"]);
//                    NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//                    NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//                    status =kHeadStError;
//                    if([[dic objectForKey:@"msg"] isKindOfClass:[NSNull class]])
//                    {
//                        failedHandler([StatusManager statusHead:@"请求失败" networkStatus:status errorCode:[[dic objectForKey:@"state"] intValue]]);
//                    }
//                    else
//                    {
//                        failedHandler([StatusManager statusHead:[dic objectForKey:@"msg"] networkStatus:status errorCode:[[dic objectForKey:@"state"] intValue]]);
//                    }
//                    
//                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                              [NSString stringWithFormat:@"%d",[[dic objectForKey:@"state"] intValue]],@"errorCode",
//                                              nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkFailedInfoNotice" object:nil userInfo:userInfo];
//                    
//                }
//                
//            }
//            else
//            {
//                NSLog(@"webservice error!");
//                NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//                NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//                status = kParseFailedStatus;
//                
//                failedHandler([StatusManager statusHead:[dic objectForKey:@"ResultDescription"] networkStatus:status errorCode:[[dic objectForKey:@"ResultNo"] intValue]]);
//                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                           @"-10004",@"errorCode",
//                                          nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"networkFailedInfoNotice" object:nil userInfo:userInfo];
//            }
//        }
//        else
//        {
//            NSLog(@"webservice error!");
//            NSLog(@"url:%@",[entrance urlStringFromEntrance]);
//            NSLog(@"post body:%@",[entrance postStringFromEntrance]);
//            status = kResponseFailedStatus;
//            
//            failedHandler([StatusManager statusHead:@"当前网络不好，请稍后重试！" networkStatus:status errorCode:-10000000]);
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  @"-10004",@"errorCode", 
//                                  nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"networkFailedInfoNotice" object:nil userInfo:userInfo];
//        }
        
    //}];
    
    return nil;
}



@end
