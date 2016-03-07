//
//  WebAssistant.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.

#import "ConnectUtil.h"
#import "StatusManager.h"

@interface WebAssistant : NSObject

+ (ASIFormDataRequest*) execRequest:(NetworkEntrance*)entrance bodyBlock:(void(^)(NSDictionary* dicBody, StatusManager* status))bodyHandler failedBlock:(void(^)(StatusManager* status))failedHandler;
+ (ASIFormDataRequest*) execNormalkRequest:(NetworkEntrance*)entrance bodyBlock:(void(^)(NSDictionary* dicBody, StatusManager* status))bodyHandler failedBlock:(void(^)(StatusManager* status))failedHandler;
+ (ASIFormDataRequest*) execErrorRequest:(NetworkEntrance*)entrance bodyBlock:(void(^)(NSDictionary* dicBody, StatusManager* status))bodyHandler failedBlock:(void(^)(NSDictionary* dicBody, StatusManager* status))failedHandler;

@end
