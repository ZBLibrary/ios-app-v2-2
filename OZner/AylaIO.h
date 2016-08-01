//
//  AylaIO.h
//  OznerLibraryDemo
//
//  Created by 赵兵 on 16/7/13.
//  Copyright © 2016年 Ozner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDeviceIO.h"

//#import <AylaDevice.h>

//#import "AylaIO.h"

@class AylaDevice;


//@protocol AylaIOStatusDelegate <NSObject>
//@required
//-(void)IOClosed:(AylaIO*)io;
//@end
@interface AylaIO : BaseDeviceIO
{
    NSThread* runThread;
    
    enum ConnectStatus connectStatus;
    NSString* address;
    NSMutableDictionary* properties;
    //AylaDevice* privatAylaDevice;
}

@property (weak,nonatomic) AylaDevice* aylaDevice;

-(instancetype)init:(AylaDevice*)device;
//-(BOOL)runJob:(nonnull SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait;
-(NSString*)getAddress;
-(void)updateProperty;
-(NSString*) getProperty:(NSString*) name;
@end
