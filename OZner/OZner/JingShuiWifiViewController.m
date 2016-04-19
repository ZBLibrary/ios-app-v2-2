//
//  JingShuiWifiViewController.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/20.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "JingShuiWifiViewController.h"
#import "VersionSettingDBManager.h"
#import "MXChipPair.h"
#import "OZner-swift.h"
@interface JingShuiWifiViewController ()<MxChipPairDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)  MXChipPair* currentPair;
@property (nonatomic,strong)  peiDuiOutTimeCell* failViewzb;
@end

@implementation JingShuiWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_bIsAgree = YES;
    m_bIsShow = FALSE;
    MXChipPair* pair = [[MXChipPair alloc]init];
    self.currentPair = pair;
    pair.delegate = self;
    
    [self layOutWifiView];
    [self createLeftAndRightBtn];
    [self addKeyboardNotification];
}

- (void)layOutWifiView
{
    self.wifiImgView.frame = CGRectMake((SCREEN_WIDTH-130*(SCREEN_WIDTH/375.0))/2, (64+94)*(SCREEN_HEIGHT/667.0), 130*(SCREEN_WIDTH/375.0), 130*(SCREEN_WIDTH/375.0));
    self.titleLabel1.frame = CGRectMake(0, self.wifiImgView.frame.size.height+self.wifiImgView.frame.origin.y+14*(SCREEN_HEIGHT/667.0), self.titleLabel1.frame.size.width, self.titleLabel1.frame.size.height);
    self.titleLabel2.frame = CGRectMake(0, self.titleLabel1.frame.size.height+self.titleLabel1.frame.origin.y+15*(SCREEN_HEIGHT/667.0), self.titleLabel2.frame.size.width, self.titleLabel2.frame.size.height);
    self.accountBgView.layer.masksToBounds = YES;
    self.accountBgView.layer.cornerRadius = 10;
    self.accountBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.accountBgView.layer.borderWidth = 1;
    self.accountBgView.frame = CGRectMake(30*(SCREEN_WIDTH/375.0), 67*(SCREEN_HEIGHT/667.0)+self.titleLabel2.frame.size.height+self.titleLabel2.frame.origin.y, SCREEN_WIDTH-30*(SCREEN_WIDTH/375.0)*2, 81);
    //设置眼睛用来显示或隐藏密码 zb
    self.pswTF.frame=CGRectMake(self.pswTF.frame.origin.x, self.pswTF.frame.origin.y, self.accountBgView.frame.size.width-60, self.pswTF.frame.size.height);
    //self.pswTF.backgroundColor=[UIColor redColor];
    self.eyeImg.frame=CGRectMake(self.pswTF.frame.origin.x+self.pswTF.frame.size.width+(60-self.eyeImg.frame.size.width)/2, self.pswTF.frame.origin.y+(self.pswTF.frame.size.height-self.eyeImg.frame.size.height)/2, self.eyeImg.frame.size.width, self.eyeImg.frame.size.height);
    //点击事件
    UIButton* eyeButton=[[UIButton alloc] initWithFrame:CGRectMake(self.pswTF.frame.origin.x+self.pswTF.frame.size.width, self.pswTF.frame.origin.y, 60, self.pswTF.frame.size.height)];
    [eyeButton addTarget:self action:@selector(eyeClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    eyeButton.tag=0;
    //eyeButton.backgroundColor=[UIColor blueColor];
    [self.accountBgView addSubview:eyeButton];
    //end zb
    self.agreeBgView.frame = CGRectMake(30*(SCREEN_WIDTH/375.0), self.accountBgView.frame.size.height+self.accountBgView.frame.origin.y+18*(SCREEN_HEIGHT/667.0), self.agreeBgView.frame.size.width, self.agreeBgView.frame.size.height);
    
    self.nextBtn.backgroundColor = [UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:1.0];
    self.nextBtn.layer.masksToBounds = true;
    self.nextBtn.layer.cornerRadius = 20;
    
    NSString* ssid = [MXChipPair  getWifiSSID];
    if(ssid.length > 0)
    {
        self.accountTF.text = ssid;
        //记住密码
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString* mimaTmp=[user objectForKey:ssid];
        if (mimaTmp!=nil) {
            self.pswTF.text=mimaTmp;
            
        }
    }

    VersionSettingDBManager* dbManager = [[VersionSettingDBManager alloc]init];
    UNDWORD value = [dbManager querySettingValueBySettingId:SET_ID_REMERB_PSW];
    if(value == 0)
    {
        m_bIsAgree = FALSE;
    }
    else
    {
        m_bIsAgree = YES;
        if(ssid.length > 0)
        {
            NSString* psw = [dbManager queryPswByName:ssid];
            if(psw.length > 0)
            {
                self.pswTF.text = psw;
                //self.pswTF.secureTextEntry = YES;
            }
        }
    }
    if(m_bIsAgree == YES)
    {
        self.agreeImgView.image = [UIImage imageNamed:@"icon_agree_select.png"];
    }
    else
    {
        self.agreeImgView.image = [UIImage imageNamed:@"icon_agree_normal.png"];
    }
    
    self.leftImgView.frame = CGRectMake((SCREEN_WIDTH-51-45-18*(SCREEN_WIDTH/375.0)*6-55)/2, 0, self.leftImgView.frame.size.width, self.leftImgView.frame.size.height);
    
    self.circleImgView1.frame = CGRectMake(self.leftImgView.frame.size.width+self.leftImgView.frame.origin.x+18*(SCREEN_WIDTH/375.0), (self.leftImgView.frame.size.height-11)/2, 11, 11);
    self.circleImgView1.layer.masksToBounds = YES;
    self.circleImgView1.layer.cornerRadius = self.circleImgView1.frame.size.width/2;
    self.circleImgView1.backgroundColor = [UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1.0];
    
    self.circleImgView2.frame = CGRectMake(self.circleImgView1.frame.size.width+self.circleImgView1.frame.origin.x+18*(SCREEN_WIDTH/375.0), (self.leftImgView.frame.size.height-11)/2, 11, 11);
    self.circleImgView2.layer.masksToBounds = YES;
    self.circleImgView2.layer.cornerRadius = self.circleImgView1.frame.size.width/2;
    self.circleImgView2.backgroundColor = [UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1.0];
    
    self.circleImgView3.frame = CGRectMake(self.circleImgView2.frame.size.width+self.circleImgView2.frame.origin.x+18*(SCREEN_WIDTH/375.0), (self.leftImgView.frame.size.height-11)/2, 11, 11);
    self.circleImgView3.layer.masksToBounds = YES;
    self.circleImgView3.layer.cornerRadius = self.circleImgView1.frame.size.width/2;
    self.circleImgView3.backgroundColor = [UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1.0];
    
    self.circleImgView4.frame = CGRectMake(self.circleImgView3.frame.size.width+self.circleImgView3.frame.origin.x+18*(SCREEN_WIDTH/375.0), (self.leftImgView.frame.size.height-11)/2, 11, 11);
    self.circleImgView4.layer.masksToBounds = YES;
    self.circleImgView4.layer.cornerRadius = self.circleImgView1.frame.size.width/2;
    self.circleImgView4.backgroundColor = [UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1.0];
    
    self.circleImgView5.frame = CGRectMake(self.circleImgView4.frame.size.width+self.circleImgView4.frame.origin.x+18*(SCREEN_WIDTH/375.0), (self.leftImgView.frame.size.height-11)/2, 11, 11);
    self.circleImgView5.layer.masksToBounds = YES;
    self.circleImgView5.layer.cornerRadius = self.circleImgView1.frame.size.width/2;
    self.circleImgView5.backgroundColor = [UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1.0];
    
    
    self.rightImgView.frame = CGRectMake(self.circleImgView5.frame.size.width+self.circleImgView5.frame.origin.x+18*(SCREEN_WIDTH/375.0), (self.leftImgView.frame.size.height-self.rightImgView.frame.size.height)/2, self.rightImgView.frame.size.width, self.rightImgView.frame.size.height);
    //配网失败视图加载 zb
    _failViewzb=(peiDuiOutTimeCell*)[[[NSBundle mainBundle] loadNibNamed:@"peiDuiOutTimeCell" owner:self options:nil] lastObject];
    _failViewzb.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_failViewzb.Back addTarget:self action:@selector(leftBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [_failViewzb.ReSetPeiDuiButton addTarget:self action:@selector(ReSetPeiDuiClick) forControlEvents:UIControlEventTouchUpInside];
    //
    [self setCircle];
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    [muArr addObject:self.circleImgView1];
    [muArr addObject:self.circleImgView2];
    [muArr addObject:self.circleImgView3];
    [muArr addObject:self.circleImgView4];
    [muArr addObject:self.circleImgView5];
    
    self.iconArrs = muArr;
}
//显示或隐藏密码
- (void)eyeClickEvent:(UIButton*)button
{
    button.tag=button.tag==0?1:0;
    self.pswTF.secureTextEntry=button.tag==0?true:false;
}
//重新配对
- (void)ReSetPeiDuiClick
{
    [_failViewzb removeFromSuperview];
    self.navigationController.navigationBarHidden=false;
    [self.currentPair start:self.accountTF.text Password:self.pswTF.text];
}
- (void)startTimer
{
    if(mTimer == nil)
    {
        mTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}

- (void)onTimer
{
    for(int i=0;i<self.iconArrs.count;i++)
    {
        UIImageView* imgView = [self.iconArrs objectAtIndex:i];
        if(i == mIndex)
        {
            imgView.backgroundColor = [UIColor colorWithRed:245/255.0 green:63/255.0 blue:119/255.0 alpha:1.0];
        }
        else
        {
            imgView.backgroundColor = [UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1.0];
        }
    }
    
    mIndex++;
    if(mIndex > 4)
    {
        mIndex = 0;
    }
}

- (void)endTimer
{
    if(mTimer)
    {
        mTimer = nil;
        [mTimer invalidate];
    }
}

//设置连接圆
- (void)setCircle
{
    if(m_bIsShow)
    {
        self.accountBgView.hidden = YES;
        self.agreeBgView.hidden = YES;
        self.connectBgView.hidden = FALSE;
        self.nextBtn.hidden = YES;
        self.titleLabel1.hidden = YES;
        self.titleLabel2.hidden = YES;
    }
    else
    {
        self.accountBgView.hidden = FALSE;
        self.agreeBgView.hidden = FALSE;
        self.connectBgView.hidden = YES;
        self.nextBtn.hidden = FALSE;
        self.titleLabel1.hidden = FALSE;
        self.titleLabel2.hidden = FALSE;
    }
    
    self.connectBgView.frame = CGRectMake(0, self.accountBgView.frame.origin.y, self.connectBgView.frame.size.width, self.connectBgView.frame.size.height);
}

- (void)createLeftAndRightBtn
{
    UIImage* image = [UIImage imageNamed:@"icon_back.png"];
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:image forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [leftBtn addTarget:self action:@selector(leftBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [UITool customizeNavBar:self withTitle:@"设备配对" buttonImgL:leftBtn buttonImgR:nil];
}

-(void)complete:(MXChipIO *)io
{
    
}


/*!
 @function 开始发送Wifi信息
 */
-(void)mxChipPairSendConfiguration
{
    
}

/*!
 @function 等待设备连接
 */
-(void)mxChipPairWaitConnectWifi
{
    
}

/*!
 @function 等待设备激活
 */
-(void)mxChipPairActivate
{
    
}

//配网完成
-(void)mxChipComplete:(MXChipIO*)io
{
    [self endTimer];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(m_bIsAgree)
        {
            VersionSettingDBManager* dbManager = [[VersionSettingDBManager alloc]init];
            [dbManager addWifi:self.accountTF.text psw:self.pswTF.text];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(jinshuiqiConnectComplete:)])
            {
                NSMutableArray* muArr = [[NSMutableArray alloc]init];
                [muArr addObject:io];
                [self.delegate jinshuiqiConnectComplete:muArr];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        });
        
    });
}

//配网失败
-(void)mxChipFailure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endTimer];
        self.navigationController.navigationBarHidden=true;
        [self.view addSubview:_failViewzb];
    });
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//是否同意
- (IBAction)isAgreeAction:(id)sender
{
    m_bIsAgree = !m_bIsAgree;
    VersionSettingDBManager* dbManager = [[VersionSettingDBManager alloc]init];
    if(m_bIsAgree == YES)
    {
        self.agreeImgView.image = [UIImage imageNamed:@"icon_agree_select.png"];
        [dbManager addSettingValue:SET_ID_REMERB_PSW vaue:1];
    }
    else
    {
        self.agreeImgView.image = [UIImage imageNamed:@"icon_agree_normal.png"];
        [dbManager addSettingValue:SET_ID_REMERB_PSW vaue:0];
    }
}

- (IBAction)OnNextAction:(id)sender
{
    NSString* tmpName=[NSString stringWithFormat:@"%@",self.accountTF.text];
    NSString* tmpPass=[NSString stringWithFormat:@"%@",self.pswTF.text];
    if(tmpName.length == 0 )//|| self.pswTF.text.length == 0
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入网络名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
        //记住密码
        if (m_bIsAgree==true) {
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:tmpPass forKey:tmpName];
        }
        m_bIsShow = !m_bIsShow;
        [self setCircle];
        [self startTimer];
        [self.currentPair start:tmpName Password:tmpPass];
    }
}

- (IBAction)leftBtnMethod
{
    [self.currentPair cancel];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
 *监测键盘
 */
- (void)addKeyboardNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification          object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification          object:nil];
}
- (void)keyboardWillHide:(NSNotification *)note
{
    [self viewAnmiatonMethod:2];
}
- (void)keyboardWillShow:(NSNotification *)note
{
    [self viewAnmiatonMethod:1];
}

/*
 *键盘显示隐藏状态
 *index : 方式
 */
-(void)viewAnmiatonMethod:(int )index
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.05];
    
    switch (index)
    {
        case 1:
        {
            if (self.view.frame.origin.y == 0)
            {
                self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - 100,self.view.frame.size.width,self.view.frame.size.height);
            }
            break;
        }
        case 2:
        {
            if (self.view.frame.origin.y != 0)
            {
                self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y + 100,self.view.frame.size.width,self.view.frame.size.height);
            }
            break;
        }
        default:
            break;
    }
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
