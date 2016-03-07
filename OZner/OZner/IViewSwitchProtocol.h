//
//  IViewSwitchProtocol.h
//  StarShow
//
//  Created by 常 贤明 on 5/3/14.
//  Copyright (c) 2014 常 贤明. All rights reserved.
//

#import <Foundation/Foundation.h>

// HomeViewController 和 子视图之间协议
@protocol HomeDelegate <NSObject>

//
- (void)homeSinkEvent;

@end

@protocol IViewSwitchProtocol <NSObject>

@end
