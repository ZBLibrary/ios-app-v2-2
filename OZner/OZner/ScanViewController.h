//
//  ScanViewController.h
//  UU
//
//  Created by sunlinlin on 14-1-13.
//  Copyright (c) 2014年 王 家振. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import "NSStringAdditions.h"
#import "UIImageAdditions.h"
#import <QuartzCore/QuartzCore.h>

#define EMPTY_WIDTH             200.
#define EMPTY_HEIGHT            200.
#define EMPTY_TOP_MARGIN        100.
#define EMPTY_LEFT_MARGIN       (([UIScreen mainScreen].bounds.size.width-EMPTY_WIDTH)/2.)

#define SCAN_LINE_HEIGHT        2.

@interface OverlayView : UIView
//@property(nonatomic,retain)NSString* mac;
@end

@interface ScanViewController : UIViewController<UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate,UIAlertViewDelegate>
{
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *prevLayer;
    AVCaptureVideoDataOutput *captureOutput;
    
    CGFloat             offset;
    UIImageView *flagImageView;
    dispatch_source_t   timer;
    NSString* mac;
    BOOL isNeedWebService;
    BOOL isDecoding;
}
@property (nonatomic,strong) NSString* deviceType;
@property (nonatomic,strong) NSString* deviceMac;
@end
