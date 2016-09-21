//
//  MXChipIO.h
//  MxChip
//
//  Created by Zhiyongxu on 15/12/8.
//  Copyright © 2015年 Zhiyongxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDeviceIO.h"
#import "MQTTProxy.h"

@class MXChipIO;
@protocol MXChipIOStatusDelegate <NSObject>
@required
-(void)IOClosed:(nullable MXChipIO*)io;
@end

@interface MXChipIO : BaseDeviceIO
{

    MQTTProxy* proxy;
    NSString* outKey;
    NSString* inKey;
    NSThread* runThread;
}
@property (weak,nonatomic) id<MXChipIOStatusDelegate> statusDelegate;
-(void)setSecureCode:(nullable NSString*)secureCode;
-(instancetype)init:(nullable NSString *)identifier MQTT:(MQTTProxy*)proxy Type:(nullable NSString *)type;
-(BOOL)runJob:(nonnull SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait;
@end
