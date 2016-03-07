//
//  RawRecord.h
//  OznerBluetooth
//
//  Created by zhiyongxu on 15/3/16.
//  Copyright (c) 2015年 zhiyongxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CupRawRecord : NSObject
{
    
}
-(instancetype)init:(BytePtr)bytes;
@property (copy,nonatomic) NSDate* time;
@property (nonatomic) int Vol;
@property (nonatomic) int Temperature;
@property (nonatomic) int TDS;
@property (nonatomic) int Count;
@property (nonatomic) int Index;
@end

