//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef Bridging_Header_h
#define Bridging_Header_h

#import "GlobalInfo.h"
#import "GlobalSizeDef.h"
#import "TypeDef.h"
#import "GlobalDef.h"
#import "UToolBox.h"
#import "NetworkManager.h"
#import "GlobalClass.h"
#import "SwitchViewController.h"
#import "CustomTabBarController.h"
#import "CustomTabBarView.h"
#import "AmountOfDrinkingWaterViewController.h"
#import "TDSDetailViewController.h"
#import "OznerManager.h"
#import "iCarousel.h"
#import "UITool.h"
#import "TapManager.h"
#import "CupManager.h"
#import "Tap.h"
#import "Cup.h"
#import "LogInOut.h"
#import "MyDeviceCustomFitstView.h"
//#import "TanTouDetailViewController.h"
#import "JingShuiWifiViewController.h"
#import "CustomCommFunction.h"
#import "LoginManager.h"
#import "WaterReplenishmentMeterMgr.h"
#import "AirPurifierManager.h"
#import "AirPurifier_Bluetooth.h"
#import "AirPurifier_MxChip.h"
#import "WaterPurifier.h"
#import "WaterPurifierManager.h"
#import "WaterReplenishmentMeter.h"
#import "WaterReplenishmentMeterMgr.h"
//#import "MyDeviceCsutomSecondView.h"
#import "DeviceWerbservice.h"
#import "StatusManager.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "MyInfoWerbservice.h"
#import "UserInfoActionWerbService.h"
//#import "DeviceStateView.h"
#import "PubDatabase.h"
#import "ImageUtil.h"
//#import "JingShuiqiDetailviewController.h"
//#import "JingshuiqiTDSDetailViewController.h"
#import "CustomNoDeviceView.h"
#import "CustomOCCircleView.h"
//zhao
#import "ShareManager.h"
#import "WXApi.h"
#import "AFNetworking.h"
//#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "ChatViewController.h"
#import "BPush.h"
#import "NSStringAdditions.h"
//#import "ScanViewController.h"
#import "lineChartViewzb.h"
#import "WaterineChartView.h"
#import "waterReplenishChartView.h"

//bug记录第三方库
#import "Bugly/CrashReporter.h"
//#import <Bugly/CrashReporter.h>
//取色板
#import "YJHColorPickerHSWheel2.h"
#import "YJHColorPickerHSWheel.h"
#import "DeviceSetting.h"

//扫码
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXScanView.h"
#import "SubLBXScanViewController.h"

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)

#define CellColor [UIColor colorWithRed:247 green:247 blue:247 alpha:0.70]//cell的半透明颜色

#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//Safe Release An Object
#define SAFE_RELEASE(x)  do{if(x){[x release];x=nil;}}while(0)

//#define ZN_DEBUG

#ifdef ZN_DEBUG
#define ZNLog(format,...) NSLog([NSString stringWithFormat:@"(%s-%d)%s:"format,string_reverse_position((char*)__FILE__,strlen((char*)__FILE__)),__LINE__,__FUNCTION__,##__VA_ARGS__],nil)
#else
#define ZNLog(format,...)
#endif

#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IOS7_Y_DELTA(Y) if(IOS_7){Y+=20.f;}
#define IOS7_RECT_DEALTA(RECT,X,Y,W,H) if(IOS_7) {CGRect f = RECT;f.origin.x += X;f.origin.y += Y;f.size.width +=W;f.size.height += H;RECT=f;}
#define IOS7_Y_H_DELTA(Y,H) if(IOS_7){Y+=20.f;H-=20.f;}
#define IOS6_7_DELTA(V,X,Y,W,H) if(IOS_7) {CGRect f = V.frame;f.origin.x += X;f.origin.y += Y;f.size.width +=W;f.size.height += H;V.frame=f;}

#endif