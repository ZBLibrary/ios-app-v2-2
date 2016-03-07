//
//  SwitchViewController.m
//  OZner
//
//  Created by test on 15/11/30.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "SwitchViewController.h"
#import "LeftViewController.h"
#import "HomeViewController.h"
#import "CustomTabBarController.h"
#import "LoginManager.h"
#import "LogInOut.h"
#import "OZner-swift.h"
#import "MyInfoWerbservice.h"
#import "ChatViewController.h"
#import "MBProgressHUD.h"
#import "NewUserHelpViewController.h"
@interface SwitchViewController ()<HomeControllerDelegate,LoginOutDelegate,NewUserHelpViewDelegate>
{
    LeftViewController*         mLeftController;
    HomeViewController*         mHomeController;
    CustomTabBarController*     myTabController;
    LoginViewController*        mLoginController;
    UINavigationController*     mLoginNavController;
    //添加设备
    AddDeviceViewController*   mAddDeviceViewController;
    UINavigationController*    mAddDeviceNavController;
    NewUserHelpViewController*  mNewUserHelpController;
    UINavigationController*     mNewUserHelpNavController;
}

@end

@implementation SwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initTabController];
    }
    return self;
}

- (void)initTabController
{
    
    //设备
    MyDeviceMainController* deviceController = [[MyDeviceMainController alloc]init];
    UINavigationController* nav0 = [[UINavigationController alloc]initWithRootViewController:deviceController];
    [nav0.navigationBar loadNavigationBar];
    
    //商城
    MyStoreViewController* storeController = [[MyStoreViewController alloc] init];
    UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:storeController];
    [nav1.navigationBar loadNavigationBar];
    //聊天ChatViewController.h
    ChatViewController* communicationContr0ller = [[ChatViewController alloc] init];
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:communicationContr0ller];
    [nav2.navigationBar loadNavigationBar];
    
    //我的信息
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyInfoViewController* infoController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyinfoViewController"];
    UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:infoController];
    [nav3.navigationBar loadNavigationBar];
    
    NSArray* array = [[NSArray alloc] initWithObjects:nav0,nav1,nav2,nav3, nil];
    
    myTabController = [[CustomTabBarController alloc] initWithControllers:array];
    NSArray* items = [NSArray arrayWithObjects:myTabController, nil];
    mHomeController = [[HomeViewController alloc] initWithNibName:nil bundle:nil items:items];
    mHomeController.delegate = self;
    
    deviceController.delegate = mHomeController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mLeftController = [[LeftViewController alloc] init];
    mLeftController.iDelegate = mHomeController;
    mLeftController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:mLeftController.view];
    
    [LogInOut loginInOutInstance].logInoutDelegate = self;

    //[self loadFirstView];
    [self isFirstOpenApp];
    
}

- (void)isFirstOpenApp
{
    //找到plist文件中得到版本号所对应的键
    NSString* key = (NSString*)kCFBundleVersionKey;
    //从plist中取出版本号
    NSString* version = [NSBundle mainBundle].infoDictionary[key];
    //从沙盒中取出上次存储的版本号
    NSString* saveVerSion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    
    if([version isEqualToString:saveVerSion])
    {
        //不是第一次使用这个版本
        [self loadFirstView];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        mNewUserHelpController = [[NewUserHelpViewController alloc] init];
        mNewUserHelpController.userHelpViewDelegate = self;
        mNewUserHelpNavController = [[UINavigationController alloc] initWithRootViewController:mNewUserHelpController];
        mNewUserHelpNavController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [mNewUserHelpNavController.navigationBar loadNavigationBar];
        //mNewUserHelpNavController.navigationBarHidden = YES;

        [self.view addSubview:mNewUserHelpNavController.view];
    }
}

#pragma mark- NewUserHelpViewDelegate
- (void)onClickNewUserViewExperience
{
    [mNewUserHelpNavController.view removeFromSuperview];
    mNewUserHelpNavController = nil;
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    mLoginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    mLoginNavController = [[UINavigationController alloc] initWithRootViewController:mLoginController];
    mLoginNavController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [mLoginNavController.navigationBar loadNavigationBar];
    
    [self.view addSubview:mLoginNavController.view];
}

- (void)loadFirstView
{
    [[LoginManager loginInstance]decodeParamObject];
    if([[LoginManager loginInstance]loginInfo].sessionToken && [[[LoginManager loginInstance]loginInfo].sessionToken length] > 0)
    {
        NSLog(@"%@",[[LoginManager loginInstance]loginInfo].sessionToken);
        mHomeController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:mHomeController.view];
        [[OznerManager instance]setOwner:[[LoginManager loginInstance]loginInfo].loginName];
        [[NetworkManager sharedInstance] startWithAid:nil sesToken:[[LoginManager loginInstance]loginInfo].sessionToken httpAdress:HTTP_ADDRESS];
        //创建数据库，如果存在就直接打开，如果不存在就关闭
        [[LoginManager loginInstance]decodeParamObject];
        [[UserDatabase sharedUserDatabase]createDBFileInDocument:[kDatabase stringByAppendingString:[NSString stringWithFormat:@"%@.db",[[[LoginManager loginInstance]loginInfo]loginName]]] srcDBFile:kDatabase_uid versionId:0];
        [[UserDatabase sharedUserDatabase] startDBEngineWithDB:[kDatabase stringByAppendingString:[NSString stringWithFormat:@"%@.db",[[[LoginManager loginInstance]loginInfo]loginName]]]];
        
    }
    else
    {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        mLoginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        mLoginNavController = [[UINavigationController alloc] initWithRootViewController:mLoginController];
        mLoginNavController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [mLoginNavController.navigationBar loadNavigationBar];
            
        [self.view addSubview:mLoginNavController.view];
    }
}

#pragma mark-HomeControllerDelegate
- (void)customViewAddCallBack
{
    mAddDeviceViewController = [[AddDeviceViewController alloc] init];
    mAddDeviceNavController = [[UINavigationController alloc] initWithRootViewController:mAddDeviceViewController];
    mAddDeviceNavController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [mAddDeviceNavController.navigationBar loadNavigationBar];
    
    [self.view addSubview:mAddDeviceNavController.view];
    
}

#pragma mark- LoginOutDelegate
- (void)onLoginSuccess:(LoginUserInfo *)loginUserInfo currentView:(UIView *)currentView
{
    [MBProgressHUD hideHUDForView:currentView animated:YES];
    
    [[NetworkManager sharedInstance] startWithAid:nil sesToken:loginUserInfo.sessionToken httpAdress:HTTP_ADDRESS];
    //创建数据库
    [[UserDatabase sharedUserDatabase]createDBFileInDocument:[kDatabase stringByAppendingString:[NSString stringWithFormat:@"%@.db",[[[LoginManager loginInstance]loginInfo]loginName]]] srcDBFile:kDatabase_uid versionId:0];
    [[UserDatabase sharedUserDatabase] startDBEngineWithDB:[kDatabase stringByAppendingString:[NSString stringWithFormat:@"%@.db",[[[LoginManager loginInstance]loginInfo]loginName]]]];
    //大头库初始化
    NSLog(@"%@",[[[LoginManager loginInstance]loginInfo]loginName]);
    [[OznerManager instance] setOwner:[[[LoginManager loginInstance]loginInfo]loginName]];
    if(mLoginNavController && [mLoginNavController.view superview])
    {
        if (mHomeController==nil) {
            [self initTabController];
            mHomeController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:mHomeController.view];
           
            mLoginNavController = nil;
        }
        else
        {
            mHomeController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:mHomeController.view];
            [mLoginNavController.view removeFromSuperview];
            mLoginNavController = nil;
        }
        
    }
}

- (void)onLoginFailed:(NSString *)errorStr currentView:(UIView *)currentView
{
    [MBProgressHUD hideHUDForView:currentView animated:YES];
    
    
}

- (void)onNoNeedLogin:(UIView *)currentView
{
    if(mLoginNavController && [mLoginNavController.view superview])
    {
        [mLoginNavController.view removeFromSuperview];
        mLoginNavController = nil;
    }
}

- (void)onLogout
{
    // 退出登录，置空密码，置空除用户名外所有信息，下次登录时候重新下载防止信息重复
    [[LoginManager loginInstance]loginInfo].sessionToken = nil; //session标识
    [[LoginManager loginInstance]loginInfo].displayName = nil;  //昵称
    [[LoginManager loginInstance]loginInfo].userID = nil;      //用户id
    [[LoginManager loginInstance]loginInfo].loginName = nil;   //用户姓名
    [[LoginManager loginInstance]loginInfo].password = nil;    //密码
    [[LoginManager loginInstance]loginInfo].avatarUrl = nil;   //上传文件的随机值
    [[LoginManager loginInstance]loginInfo].gender = nil;
    [[OznerManager instance]setOwner:@"LoginOut"];
//    [[LoginManager loginInstance]loginInfo].version = nil;
//    [[LoginManager loginInstance]loginInfo].longitude = nil;
//    [[LoginManager loginInstance]loginInfo].latitude = nil;
//    [[LoginManager loginInstance]loginInfo].targetGender = nil;
//    [[LoginManager loginInstance]loginInfo].updateTime = nil;
//    [[LoginManager loginInstance]loginInfo].profileUpdateTime = nil;
//    [[LoginManager loginInstance]loginInfo].easePassWord = nil;
//    [[LoginManager loginInstance]loginInfo].signature = nil;
//    [[LoginManager loginInstance]loginInfo].birthday = nil;
//    [[LoginManager loginInstance]loginInfo].location = nil;
//    [[LoginManager loginInstance]loginInfo].tags = nil;
//    [[LoginManager loginInstance]loginInfo].userHeight = nil;
//    [[LoginManager loginInstance]loginInfo].identifierState = nil;
//    [[LoginManager loginInstance]loginInfo].identifier = nil;
//    [[LoginManager loginInstance]loginInfo].stature = nil;
//    [[LoginManager loginInstance]loginInfo].age = nil;
//    [[LoginManager loginInstance]loginInfo].constellation = nil;
//    [[LoginManager loginInstance]loginInfo].commentLevel = nil;
//    [[LoginManager loginInstance]loginInfo].balance = nil;
//    [[LoginManager loginInstance]loginInfo].officialUserId = nil;
    
    [[LoginManager loginInstance]encodeParamObject];
    
    //聊天登出
    //[self easeLoginOut:YES];
    //清空view
    NSArray* views = [self.view subviews];
    for (UIView* view in views)
    {
        [view removeFromSuperview];
    }
    
//    // 释放控制器
    if (mHomeController)
    {
        //[mHomeController release];
        mHomeController = nil;
    }
    
    //[self deallocTimer];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    mLoginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    mLoginNavController = [[UINavigationController alloc] initWithRootViewController:mLoginController];
    mLoginNavController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [mLoginNavController.navigationBar loadNavigationBar];
    
    [self.view addSubview:mLoginNavController.view];
//    mLoginController = [[LoginViewController alloc] init];
//    mLoginNavController = [[UINavigationController alloc] initWithRootViewController:mLoginController];
//    mLoginNavController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [mLoginNavController.navigationBar loadNavigationBar];
//    //[mLoginController release];
//    
//    [self.view addSubview:mLoginNavController.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
