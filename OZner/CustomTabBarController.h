//
//  MyTabBarController.h
//  CustomTab
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import "ExtendViewController.h"

@interface CustomTabBarController : ExtendViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) NSArray* mItems;
@property (nonatomic, retain) NSString* lastChosenMediaType;
@property (nonatomic,strong) NSURL* movieURL;
@property (nonatomic,retain) NSString* videoPath;

- (id)initWithControllers:(NSArray* )controllers;

@end
