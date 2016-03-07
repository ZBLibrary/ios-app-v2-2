//
//  ScanViewController.m
//  UU
//
//  Created by sunlinlin on 14-1-13.
//  Copyright (c) 2014年 王 家振. All rights reserved.
//

#import "ScanViewController.h"
#import "DisCode.h"
#import "MBProgressHUD.h"
#import "DeviceWerbservice.h"
#import "AFNetworking.h"
#import "LoginManager.h"
@implementation OverlayView

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode=UIViewContentModeRedraw;
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=NO;
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];
    
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, EMPTY_TOP_MARGIN));
    CGContextFillRect(context, CGRectMake(0, EMPTY_TOP_MARGIN, EMPTY_LEFT_MARGIN, EMPTY_HEIGHT));
    CGContextFillRect(context, CGRectMake(EMPTY_LEFT_MARGIN+EMPTY_WIDTH, EMPTY_TOP_MARGIN, EMPTY_LEFT_MARGIN, EMPTY_HEIGHT));
    CGContextFillRect(context, CGRectMake(0, EMPTY_TOP_MARGIN+EMPTY_HEIGHT, rect.size.width, rect.size.height-EMPTY_TOP_MARGIN-EMPTY_HEIGHT));
    
    [[UIImage imageNamed:@"scanboarder.png"] drawInRect:CGRectMake(EMPTY_LEFT_MARGIN, EMPTY_TOP_MARGIN, EMPTY_WIDTH, EMPTY_HEIGHT)];
}


@end

@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)dealloc
{
    if (isDecoding) {
        [self destroyCapture];
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //mac=self.title;
    NSLog(@"%@",[self deviceMac]);
    NSLog(@"%@",[self deviceType]);
	// Do any additional setup after loading the view.
    self.title=@"扫一扫";
    UIButton* leftbutton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,10,21)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(leftBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    //leftbutton.addTarget(self, action: Selector("back"), forControlEvents: .TouchUpInside)
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftbutton]; //(customView: leftbutton)
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImage* image = [UIImage imageNamed:@"icon_back.png"];
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:image forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
    [leftBtn addTarget:self action:@selector(leftBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //[UITool customizeNavBar:self withTitle:@"扫一扫" buttonImgL:leftBtn buttonImgR:nil];
    [self initCapture];
    
    //overlayView
    OverlayView *overlayView=[[OverlayView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:overlayView];
    [overlayView release];
    
    offset=0;
    flagImageView=[[UIImageView alloc] initWithFrame:CGRectMake(EMPTY_LEFT_MARGIN, offset+EMPTY_TOP_MARGIN, EMPTY_WIDTH, SCAN_LINE_HEIGHT)];
    flagImageView.image=[UIImage imageNamed:@"scanline.png"];
    [self.view addSubview:flagImageView];
    [flagImageView release];
    
    timer=[self createIndicateTimer];
    isNeedWebService=YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
    // ysy if stop running will restart
    if (captureSession.running == NO) {
        [self reStartCapture];
    }
}

- (void)leftBtnMethod
{
    if (isDecoding) {
        [self destroyCapture];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initCapture
{
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;

    dispatch_queue_t captureQueue = dispatch_queue_create("Capture Queue", DISPATCH_QUEUE_SERIAL);
    [captureOutput setSampleBufferDelegate:self queue:captureQueue];
    dispatch_release(captureQueue);
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    captureSession = [[[AVCaptureSession alloc] init] autorelease];
    
    NSString *preset = AVCaptureSessionPresetMedium;
    captureSession.sessionPreset = preset;
    
    [captureSession addInput:captureInput];
    [captureSession addOutput:captureOutput];
    
    [captureOutput release];
    
    if (!prevLayer) {
        prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    }
    
    prevLayer.frame = self.view.bounds;
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:prevLayer];
    
    isDecoding=YES;
    [captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (!isDecoding) {
        return;
    }
    
    NSString *value;
    
    @autoreleasepool {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        /*Lock the image buffer*/
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        /*Get information about the image*/
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        uint8_t* baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(imageBuffer);
        void* free_me = 0;
        uint8_t* tmp = baseAddress;
        int bytes = (int)(bytesPerRow*height);
        free_me = baseAddress = (uint8_t*)malloc(bytes);
        baseAddress[0] = 0xdb;
        memcpy(baseAddress,tmp,bytes);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext =
        CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
        
        CGImageRef capture = CGBitmapContextCreateImage(newContext);
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        free(free_me);
        
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
        UIImage* screen = [[[UIImage alloc] initWithCGImage:capture] autorelease];
        
        CGImageRelease(capture);
        
        DisCode* code = [[[DisCode alloc]init] autorelease];
        
        value=[code decodeImage:screen];
    }
    
    if (value) {
        NSLog(@"扫描结果是：%@",value);
        //url
        //NSString *regexStr = @"^[a-zA-z]+://[^\\s\\u4e00-\\u9fa5]*$";
//        if (![value matchRegularExp:regexStr]) {
//            return ;
//        }
        //
        if (isNeedWebService) {
            isNeedWebService=NO;
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
            // 2.封装请求参数
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"usertoken"] = [LoginManager loginInstance].loginInfo.sessionToken;
            params[@"mac"] = [self deviceMac];
            params[@"devicetype"] = [self deviceType];
            params[@"code"] = value;
            NSString *url = @"http://app.ozner.net:888/OznerDevice/RenewFilterTime";
            [mgr POST:url parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  //[MBProgressHUD hideHUDForView:self.view animated:YES];
                  NSLog(@"%@",responseObject);
                  int state=  [(NSString*)[responseObject objectForKey:@"state"] intValue];
                  NSString* mesStr=@"";
                  if (state>0) {
                      mesStr=@"更换滤芯成功！";
                  }else if (state == -10019)
                  {
                      mesStr=@"二维码无效";
                  }
                  else if (state == -10020)
                  {
                      mesStr=@"二维码已经使用过了";
                  }
                  else if (state == -10021)
                  {
                      mesStr=@"设备未绑定";
                  }else
                  {
                      mesStr=@"扫码失败";
                  }
                  [UITool showSampleMsg:@"" message:mesStr];
                  //UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:mesStr delegate:self cancelButtonTitle:@"确定" , nil];
                  //alert.tag=111;
                  //[alert show];
                  
                  [self stopCapture];
                  __block ScanViewController* THIS = self;
                  CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(){
                      [THIS destroyCapture];
                  });
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLVXinTimeByScan" object:nil userInfo:responseObject];
                  [self.navigationController popViewControllerAnimated:YES];
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"%@",error);
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  [UITool showSampleMsg:@"" message:@"网络连接失败！请重试"];
                  [self stopCapture];
                  __block ScanViewController* THIS = self;
                  CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(){
                      [THIS destroyCapture];
                  });
                  [self.navigationController popViewControllerAnimated:YES];
              }];
 
        }
        
        
       
        
    }
}
-  (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0&&alertView.tag==111) {
        isNeedWebService=NO;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        isNeedWebService=YES;
    }
}


#pragma mark - capture start\stop\destroy
- (void)reStartCapture
{
    if (captureSession)
    {
        [captureSession startRunning];
    }
}

- (void)stopCapture
{
    if (captureSession)
    {
        [captureSession stopRunning];
    }
}

- (void)destroyCapture {
    [captureOutput setSampleBufferDelegate:nil queue:nil];
    [captureSession stopRunning];
    AVCaptureInput* input = [captureSession.inputs objectAtIndex:0];
    [captureSession removeInput:input];
    AVCaptureVideoDataOutput* output = (AVCaptureVideoDataOutput*)[captureSession.outputs objectAtIndex:0];
    [captureSession removeOutput:output];
    [prevLayer removeFromSuperlayer];
    
    prevLayer = nil;
    captureSession = nil;
    
    if (timer) {
        dispatch_suspend(timer);
        dispatch_source_cancel(timer);
        timer=nil;
    }
    
    isDecoding = NO;
}

static dispatch_source_t CreateDispatchTimer(uint64_t interval,
                                             uint64_t leeway,
                                             dispatch_queue_t queue,
                                             dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
    
}

-(dispatch_source_t)createIndicateTimer
{
    __block ScanViewController *scanController=self;
    dispatch_source_t aTimer = CreateDispatchTimer(10000000,
                                                   0,
                                                   dispatch_get_main_queue(),
                                                   ^{ [scanController timerTick]; });
    return aTimer;
}

-(void)timerTick
{
    if (offset++>EMPTY_HEIGHT)
        offset = 0;
    
    flagImageView.frame=CGRectMake(flagImageView.frame.origin.x, offset+EMPTY_TOP_MARGIN, flagImageView.frame.size.width, flagImageView.frame.size.height);
}

#pragma mark- parse url data
- (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[[NSScanner alloc] initWithString:query] autorelease];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
