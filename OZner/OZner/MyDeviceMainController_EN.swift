//
//  MyDeviceMainController.swift
//  OZner
//
//  Created by test on 16/1/17.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

@objc protocol MyDeviceMainController_ENDelegate
{
    func leftActionCallBack()
}

class MyDeviceMainController_EN: UIViewController,CustomNoDeviceView_ENDelegate,CustomOCCircleView_ENDelegate,OznerDeviceDelegate,UIScrollViewDelegate,UIAlertViewDelegate{
    
    
    //
    //---------------airCleaner------------
    //主滚动视图
    var MainScrollView: UIScrollView!
    var airCurrentdevice:Int=0
    //公共部分
    var headView:headViewView_EN!
    var outAirView:outAirXib_EN!
    //单机设备断网弹出的提示框
    lazy var offLineSuggestView: OffLineSuggestView_EN = {
        let tmpOffLine = NSBundle.mainBundle().loadNibNamed("OffLineSuggestView_EN", owner: nil, options: nil).last as? OffLineSuggestView_EN
        tmpOffLine?.IKnowButton.addTarget(self, action: #selector(IKnow), forControlEvents: .TouchUpInside)
        return tmpOffLine!
        }()
    
    var IAW_TempView:indoorAirWarn_Air_EN!
    //是否开启跑马效果
    var isPaoMa=0 //0未开启过，1开启中，2开启完成
    //var pagecontrol:UIPageControl!
    //台式空气净化器
    //尾部视图
    var smallFooterView:smallFooterViewXib_EN!
    var smallStateView:smallStateXib_EN!
    
    //立式空气净化器
    var bigFooterViews=[bigFooterViewXib_EN]()
    var bigStateView:bigStateXib_EN!
    var bigModelBgView:UIView!//auto点击后视图
    var tmpbigmodel:bigautoModelView_EN!
    //0 auto ,1 三级,2 二级,3一级，4 night，5 day
    var currentSpeedModel:UInt8=0{
        didSet{
            updateSpeedModel(currentSpeedModel)
        }
    }
    //补水仪主视图界面
    var waterReplenishMainView:WaterReplenishMainView_EN?
    //---------------old-----------------
    var delegate:MyDeviceMainController_ENDelegate?
    var tableView:UITableView = UITableView()
    
    var myCircleView:CustomOCCircleView_EN?
    //侧滑黑背景
    var leftSlideBG_gray:UIView!
    //净水器
    var WaterPurfHeadView:WaterPurifierHeadCell_EN?
    //是否隐藏tableBar
    var m_bIsHideTableBar = false
    //当前选中的device
    var myCurrentDevice:OznerDevice?
    //探头
    var myTanTouBgView:MyDeviceCustomFitstView_EN?
    //探头水TDS
    var tanTouDataSource:NSArray?
    //净水器
    var waterPurFooter:WaterPurFooterCell_EN!
    //排名
    var currentRank:Int?
    
    //击败了多少
    var currentDefeat:Int?
    var currentTDS:Int?
    //当前饮水量
    var currentVolumeValue:Int?
    // 目标饮水量
    var currentGoalVolumeValue:Int?
    // 连接状态
    var LoadingView:LoadingXib_EN!
    //新手引导透明view
    var myAlphaBgView:UIView?
    //下面的view
    var noDeviceBottomView:CustomNoDeviceView_EN!
    var noDeviceImgView:UIImageView!
    //滤芯下载是不是第一次
    var isNeedDownLXDate:Bool = false
    //水机设备类型
    var WaterTypeOfService:String = ""
    //水机设备购买地址
    var BuyWaterUrlString:String = ""
    //水机是否显示扫码功能
    var IsShowScanOfWater:Bool = false
    //-------------------new-------------
    //设备名称
    @IBOutlet var titleLabel: UILabel!
    //设备头部主视图
    @IBOutlet var deviceHeadView: UIView!
    //设备尾部主视图
    @IBOutlet var footerBGView: UIView!
    //设备电池，滤芯，设置的容器视图
    @IBOutlet var deviceStateViewBG: UIView!
    //电量容器视图
    @IBOutlet var dianliangContainView: UIView!
    @IBOutlet var dianliangImg: UIImageView!
    @IBOutlet var dianliangValue: UILabel!
    //滤芯容器视图
    @IBOutlet var lvxinContainView: UIView!
    @IBOutlet var lvxinImg: UIImageView!
    @IBOutlet var lvxinValue: UILabel!
    @IBOutlet var lvxinState: UILabel!
    //点击滤芯
    @IBAction func lvxinClick(sender: AnyObject) {
        if ((self.myCurrentDevice?.isKindOfClass(Tap.classForCoder())) == true){
            //探头滤芯详情页
            let controller = TantouLXController_EN()
            controller.myCurrentDevice = self.myCurrentDevice as! Tap
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if ( WaterPurifierManager.isWaterPurifier(self.myCurrentDevice?.type) == true){
            //净水器滤芯详情页
            let controller=TantouLXController_EN()
            controller.buyWaterLVXinUrl=BuyWaterUrlString
            controller.myCurrentDevice = self.myCurrentDevice as! WaterPurifier
            controller.IsShowScanOfWater=IsShowScanOfWater
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //设备尾部主容器视图
    @IBOutlet var deviceFooterView: UIView!
    @IBOutlet var Height_DeviceFooter: NSLayoutConstraint!
    //左侧边栏
    @IBAction func toLeftMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("updateDeviceInfo", object: self)
        delegate?.leftActionCallBack()
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.leftSlideBG_gray.backgroundColor=UIColor(white: 0, alpha: 0.5)
            self.leftSlideBG_gray.hidden=false
        }
    }

    //设备设置
    @IBAction func deviceSetting(sender: AnyObject) {
        if(self.myCurrentDevice == nil)
        {
            let alert = UIAlertView(title:loadLanguage("提示"), message: loadLanguage("请连接设备"), delegate: self, cancelButtonTitle: "ok")
            alert.show()
        }
        else
        {
            if ((self.myCurrentDevice?.isKindOfClass(Cup.classForCoder())) == true)
            {//水杯设置
                let controller=setCUPDeviceViewController_EN()
                controller.myCurrentDevice = self.myCurrentDevice
                
                self.navigationController?.pushViewController(controller, animated: true)
                
            }else if ((self.myCurrentDevice?.isKindOfClass(Tap.classForCoder())) == true){
                //探头设置
                let controller=setTanTouViewController_EN(nibName: "setTanTouViewController_EN", bundle: nil)
                controller.myCurrentDevice = self.myCurrentDevice
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else if ( WaterPurifierManager.isWaterPurifier(self.myCurrentDevice?.type) == true){
                //净水器设置
                let controller=setShuiJiViewController_EN(nibName: "setShuiJiViewController_EN", bundle: nil)
                controller.myCurrentDevice = self.myCurrentDevice
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        OznerDeviceSensorUpdate(self.myCurrentDevice)
        self.navigationController?.navigationBarHidden=true
        
        // 判断登陆方式
       if  (NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_LOGIN_STYLE) as! NSString).isEqualToString(LoginByPhone){
            CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
        }else{
            CustomTabBarView.sharedCustomTabBar().hideOverTabBar();
        }
        
        setBartteryImg()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //加载默认主视图
        loadWhitchView("default")
        //设备切换通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateCurrentDeviceData), name: "currentSelectedDevice", object: nil)
        //删除设备通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveDeleteDevicesNotify), name: "removDeviceByZB", object: nil)
        //侧滑事件通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(leftMenuShouqiClick), name: "leftMenuShouqi_zb", object: nil)
        //滤芯更换通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(downLoadLvXinState), name: "updateLVXinTimeByScan", object: nil)
        //台式空净重置滤芯通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UpDateLvXinOfSmallAir), name: "UpDateLvXinOfSmallAir", object: nil)
        //网络变化通知，在需要知道的地方加上此通知即可
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachabilityChanged), name: kReachabilityChangedNotification, object: nil)
        //查询是否有设备
        let muArr = NSMutableArray(array: OznerManager.instance().getDevices()) as NSMutableArray;
        if muArr.count > 0
        {
            self.myCurrentDevice = muArr.objectAtIndex(0) as? OznerDevice
            self.myCurrentDevice?.delegate = self;
            NSNotificationCenter.defaultCenter().postNotificationName("getDevices", object: nil)
           //当前设备
       NSNotificationCenter.defaultCenter().postNotificationName("currentSelectedDevice", object: self.myCurrentDevice)
        }
    
    }
    //接收到网络变化后处理事件
    func reachabilityChanged(){
        //wifi设备
        if AirPurifierManager.isMXChipAirPurifier(self.myCurrentDevice?.type)||WaterPurifierManager.isWaterPurifier(self.myCurrentDevice?.type) {
            //手机网络状况
            if appDelegate.reachOfNetwork?.currentReachabilityStatus().hashValue==0&&LoadingView != nil {
                LoadingView.state=2//手机网络不可用
            }
            else{
                LoadingView.state = -1//手机网络可用
            }
        }
    }
    //侧边滑动识别区视图
    var leftSlideView:UIView!
    //默认页面视图
    var defaultHeadView:UIImageView!
    var defaultFooterView:Main_FooterView_zb_EN!
    //Cup页面视图
    var cupHeadView:UIView!
    var cupFooterView:CupView_Footer_EN!
    //Tap页面视图
    //净水器页面视图
    //加载哪个设备视图
    func loadWhitchView(type:String)
    {
        self.currentDefeat = 0
        self.currentRank = 0
        self.currentTDS = 0
        self.currentVolumeValue = 0
        //移除空气净化器View
        if(MainScrollView != nil)
        {
            MainScrollView.removeFromSuperview()
        }
        //移除补水仪主界面视图
        if(waterReplenishMainView != nil)
        {
            waterReplenishMainView!.removeFromSuperview()
        }
        
        //移除其它设备界面
        
        for view:UIView in deviceHeadView.subviews
        {
            view.removeFromSuperview()
        }
        
        
        for view:UIView in deviceFooterView.subviews
        {
            view.removeFromSuperview()
        }
        
        
        deviceStateViewBG.hidden=false
        
        
        titleLabel.text=loadLanguage("首页")
        
        isNeedDownLXDate=false
        switch true
        {
        case CupManager.isCup(type):
            //Cup 视图
            dianliangContainView.hidden=false
            lvxinContainView.hidden=true
            set_CurrSelectEquip(1)
            //头部视图
            let circleView = CustomOCCircleView_EN.init(frame: CGRectMake((Screen_Width/375.0)*32, (Screen_Width/375.0)*57, Screen_Width-2*(Screen_Width/375.0)*32, CGFloat((Screen_Width-2*(Screen_Width/375.0)*32)/2)+20*(Screen_Hight/667.0)),tdsValue:0,beatValue:Int32(self.currentDefeat!),rankValue:0)
            self.myCircleView = circleView
            circleView.delegate = self
            circleView.backgroundColor = UIColor.clearColor()
            deviceHeadView.addSubview(circleView)

            //尾部视图
            Height_DeviceFooter.constant=Screen_Hight*160/667
            cupFooterView=NSBundle.mainBundle().loadNibNamed("CupView_Footer_EN", owner: self, options: nil).last as! CupView_Footer_EN
            cupFooterView.drinkButton.addTarget(self, action: #selector(amoutOfWaterAction), forControlEvents: .TouchUpInside)
            cupFooterView.tempButton.addTarget(self, action: #selector(temperatureAction), forControlEvents: .TouchUpInside)
            cupFooterView.translatesAutoresizingMaskIntoConstraints = false
            deviceFooterView.addSubview(cupFooterView)
            deviceFooterView.addConstraint(NSLayoutConstraint(item: cupFooterView, attribute: .Top, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Top, multiplier: 1, constant: 0))
            deviceFooterView.addConstraint(NSLayoutConstraint(item: cupFooterView, attribute: .Bottom, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Bottom, multiplier: 1, constant: 0))
            deviceFooterView.addConstraint(NSLayoutConstraint(item: cupFooterView, attribute: .Leading, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Leading, multiplier: 1, constant: 0))
            deviceFooterView.addConstraint(NSLayoutConstraint(item: cupFooterView, attribute: .Trailing, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Trailing, multiplier: 1, constant: 0))
            
        case TapManager.isTap(type):
            //Tap 视图
            dianliangContainView.hidden=false
            lvxinContainView.hidden=false
            set_CurrSelectEquip(2)
            //头部视图
            let circleView = CustomOCCircleView_EN.init(frame: CGRectMake((Screen_Width/375.0)*32, (Screen_Width/375.0)*30, Screen_Width-2*(Screen_Width/375.0)*32, CGFloat((Screen_Width-2*(Screen_Width/375.0)*32)/2)+20*(Screen_Hight/667.0)),tdsValue:0,beatValue:Int32(self.currentDefeat!),rankValue:0)
            self.myCircleView = circleView
            circleView.delegate = self
            circleView.backgroundColor = UIColor.clearColor()
            deviceHeadView.addSubview(circleView)
            
            //尾部视图
            Height_DeviceFooter.constant=Screen_Hight*210/667
            let tantouFooterView = MyDeviceCustomFitstView_EN.init(frame: CGRectMake(0, 0, Screen_Width, Screen_Hight*210/667))
            self.myTanTouBgView = tantouFooterView
            deviceFooterView.addSubview(self.myTanTouBgView!)
            
        case WaterPurifierManager.isWaterPurifier(type):
            //净水器视图
            self.currentTDS=65535
            dianliangContainView.hidden=true
            lvxinContainView.hidden=true
            set_CurrSelectEquip(3)
            //头部视图
            WaterPurfHeadView=NSBundle.mainBundle().loadNibNamed("WaterPurifierHeadCell_EN", owner: self, options: nil).last as? WaterPurifierHeadCell_EN
            WaterPurfHeadView!.translatesAutoresizingMaskIntoConstraints = false
            WaterPurfHeadView?.toTDSDetailButton.addTarget(self, action: #selector(TDSDetailOfWaterPurf), forControlEvents: .TouchUpInside)
           
            deviceHeadView.addSubview(WaterPurfHeadView!)
            
            deviceHeadView.addConstraint(NSLayoutConstraint(item: WaterPurfHeadView!, attribute: .Trailing, relatedBy: .Equal, toItem: deviceHeadView, attribute: .Trailing, multiplier: 1, constant: 0))
            deviceHeadView.addConstraint(NSLayoutConstraint(item: WaterPurfHeadView!, attribute: .Leading, relatedBy: .Equal, toItem: deviceHeadView, attribute: .Leading, multiplier: 1, constant: 0))
 
            deviceHeadView.addConstraint(NSLayoutConstraint(item: WaterPurfHeadView!, attribute: .Top, relatedBy: .Equal, toItem: deviceHeadView, attribute: .Top, multiplier: 1, constant: 0))
            deviceHeadView.addConstraint(NSLayoutConstraint(item: WaterPurfHeadView!, attribute: .Bottom, relatedBy: .Equal, toItem: deviceHeadView, attribute: .Bottom, multiplier: 1, constant: 0))
            
            //尾部视图
            Height_DeviceFooter.constant=Screen_Hight*160/667
            waterPurFooter=NSBundle.mainBundle().loadNibNamed("WaterPurFooterCell_EN", owner: self, options: nil).last as! WaterPurFooterCell_EN
            waterPurFooter!.translatesAutoresizingMaskIntoConstraints = false
            waterPurFooter.powerButton.addTarget(self, action: #selector(WaterPurSwitchClick), forControlEvents: .TouchUpInside)//tag:0
            waterPurFooter.coolButton.addTarget(self, action: #selector(WaterPurSwitchClick), forControlEvents: .TouchUpInside)//tag:1
            waterPurFooter.hotButton.addTarget(self, action: #selector(WaterPurSwitchClick), forControlEvents: .TouchUpInside)//tag:2
            deviceFooterView.addSubview(waterPurFooter)
            deviceFooterView.addConstraint(NSLayoutConstraint(item: waterPurFooter, attribute: .Trailing, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Trailing, multiplier: 1, constant: 0))
            deviceFooterView.addConstraint(NSLayoutConstraint(item: waterPurFooter, attribute: .Leading, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Leading, multiplier: 1, constant: 0))
            
            deviceFooterView.addConstraint(NSLayoutConstraint(item: waterPurFooter, attribute: .Top, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Top, multiplier: 1, constant: 0))
            deviceFooterView.addConstraint(NSLayoutConstraint(item: waterPurFooter, attribute: .Bottom, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Bottom, multiplier: 1, constant: 0))
            waterPurFooter.waterDevice=myCurrentDevice as? WaterPurifier
            
        case AirPurifierManager.isBluetoothAirPurifier(type):
            //台式空气净化器视图
            set_CurrSelectEquip(4)
            isPaoMa=0
            loadAirCleanerView()
            
        case AirPurifierManager.isMXChipAirPurifier(type):
            //立式空气净化器
            set_CurrSelectEquip(5)
            isPaoMa=0
            loadAirCleanerView()
            currentSpeedModel=0

        case WaterReplenishmentMeterMgr.isWaterReplenishmentMeter(type):
            set_CurrSelectEquip(6)
            MainScrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight-65))
            waterReplenishMainView = NSBundle.mainBundle().loadNibNamed("WaterReplenishMainView_EN", owner: nil, options: nil).last as? WaterReplenishMainView_EN
            waterReplenishMainView?.frame=CGRectMake(0, 0, Screen_Width, Screen_Hight-65)
            waterReplenishMainView?.toLeftMenuButton.addTarget(self, action: #selector(addDeviceAction), forControlEvents: .TouchUpInside)
            waterReplenishMainView?.setButton.addTarget(self, action: #selector(toWaterReplenishOtherController), forControlEvents: .TouchUpInside)
            waterReplenishMainView?.skinButton.addTarget(self, action: #selector(toWaterReplenishOtherController), forControlEvents: .TouchUpInside)
            waterReplenishMainView?.toDetailButton.addTarget(self, action: #selector(toWaterReplenishOtherController), forControlEvents: .TouchUpInside)
            MainScrollView.contentSize=CGSize(width: 0, height: Screen_Hight-65)
            MainScrollView.addSubview(waterReplenishMainView!)
            self.view.addSubview(MainScrollView)
           //
            if myCurrentDevice != nil
            {
                waterReplenishMainView?.initView(myCurrentDevice!)
            }

        default://"default"
            //默认主页视图
            myCurrentDevice=nil
             set_CurrSelectEquip(0)
            
            deviceStateViewBG.hidden=true
            
            Height_DeviceFooter.constant=Screen_Hight*212/667
            defaultFooterView=NSBundle.mainBundle().loadNibNamed("Main_FooterView_zb_EN", owner: self, options: nil).last as! Main_FooterView_zb_EN
            defaultFooterView.toAddDeviceButton.addTarget(self, action: #selector(addDeviceAction), forControlEvents: .TouchUpInside)
            defaultFooterView.translatesAutoresizingMaskIntoConstraints = false
            deviceFooterView.addSubview(defaultFooterView)
            deviceFooterView.addConstraint(NSLayoutConstraint(item: deviceFooterView, attribute: .Top, relatedBy: .Equal, toItem: defaultFooterView, attribute: .Top, multiplier: 1, constant: 0))
            deviceFooterView.addConstraint(NSLayoutConstraint(item: defaultFooterView, attribute: .Bottom, relatedBy: .Equal, toItem: defaultFooterView.superview, attribute: .Bottom, multiplier: 1, constant: 0))
            deviceFooterView.addConstraint(NSLayoutConstraint(item: defaultFooterView, attribute: .Leading, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Leading, multiplier: 1, constant: 0))
            deviceFooterView.addConstraint(NSLayoutConstraint(item: defaultFooterView, attribute: .Trailing, relatedBy: .Equal, toItem: deviceFooterView, attribute: .Trailing, multiplier: 1, constant: 0))
            
            
            
            let defaultImg = UIImage(named: "DeviceHeadImg")
            defaultHeadView=UIImageView(image: defaultImg)
            defaultHeadView.translatesAutoresizingMaskIntoConstraints = false
            deviceHeadView.addSubview(defaultHeadView)
            deviceHeadView.addConstraint(NSLayoutConstraint(item: deviceHeadView, attribute: .CenterX, relatedBy: .Equal, toItem: defaultHeadView, attribute: .CenterX, multiplier: 1, constant: 0))
            deviceHeadView.addConstraint(NSLayoutConstraint(item: deviceHeadView, attribute: .CenterY, relatedBy: .Equal, toItem: defaultHeadView, attribute: .CenterY, multiplier: 1, constant: 0))
            break
        }
        //连接状态视图
        if LoadingView != nil
        {
            LoadingView.removeFromSuperview()
        }
        LoadingView=NSBundle.mainBundle().loadNibNamed("LoadingXib_EN", owner: self, options: nil).last as! LoadingXib_EN
        //LoadingView.backgroundColor=UIColor.redColor()
       // LoadingView.frame = CGRectMake(0,68,Screen_Width,15)
        //0正在连接,1断开,2已连接
        if self.myCurrentDevice==nil
        {
            LoadingView.state = -1
        }
        else
        {
            switch self.myCurrentDevice!.connectStatus()
            {
            case Connected:
                 LoadingView.state = -1
                break
            case Connecting:
                 LoadingView.state=0
                break
            default:
                 LoadingView.state=1
                break
            }
           
        }
        
        self.view.addSubview(LoadingView)
        LoadingView.snp_makeConstraints { (make) in
            make.top.equalTo(LoadingView.superview!).offset(68)
            make.left.equalTo(LoadingView.superview!).offset(0)
            make.height.equalTo(15)
            make.right.equalTo(LoadingView.superview!).offset(0)
        
        }
        reachabilityChanged()//初始化网络状态
        //侧滑感应区视图
        if leftSlideView != nil
        {
            leftSlideView.removeFromSuperview()
        }
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        
        leftSlideView=UIView(frame: CGRect(x: 0, y: 64, width: 30, height: Screen_Hight-64))
        //leftSlideView.backgroundColor=UIColor.redColor()
        leftSlideView.addGestureRecognizer(swipeGesture)
        self.view.addSubview(leftSlideView)
        //侧滑灰色背景
        if leftSlideBG_gray != nil
        {
            leftSlideBG_gray.removeFromSuperview()
        }
        leftSlideBG_gray=UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight))
        leftSlideBG_gray.backgroundColor=UIColor(white: 0, alpha: 0)
        leftSlideBG_gray.hidden=true
        self.view.addSubview(leftSlideBG_gray)
        setBartteryImg()
   
        
    }
    //进入补水仪其他controller，0设置，1肤质查询，2详情
    func toWaterReplenishOtherController(button:UIButton)
    {
        if myCurrentDevice == nil
        {
            return
        }
        switch button.tag
        {
        case 0:
            let setController=setWaterReplenishController_EN()
            setController.myCurrentDevice=myCurrentDevice as? WaterReplenishmentMeter
            self.navigationController?.pushViewController(setController, animated: true)
        case 1:
            let skipController=SkinQueryTableViewController_EN()
            let tmpDevice=myCurrentDevice as! WaterReplenishmentMeter
            let tmpSex=tmpDevice.settings.get("sex", default: loadLanguage("女"))
            skipController.currentSex=(tmpSex as! String)==loadLanguage("女") ? SexType.WoMan:SexType.Man
            if waterReplenishMainView?.avgAndTimesArr.count>0 {
                let tmpArr:[String:HeadOfWaterReplenishStruct]=(waterReplenishMainView?.avgAndTimesArr)!
                let tmpTimes=(tmpArr["0"]?.checkTimes)!+(tmpArr["1"]?.checkTimes)!+(tmpArr["2"]?.checkTimes)!+(tmpArr["3"]?.checkTimes)!
                
                skipController.totalTimes=tmpTimes
            }
            skipController.TimeString=(stringFromDate(NSDate(), format: "yyyy-MM") as String)+"-01  "+(stringFromDate(NSDate(), format: "yyyy-MM-dd") as String)
            let tmpStr=button.titleLabel?.text!
            print(tmpStr)
            if ((tmpStr?.containsString(loadLanguage("无"))) != false)
            {skipController.currentSkinTypeIndex=0}
            else if ((tmpStr?.containsString(loadLanguage("油性"))) != false)
            {skipController.currentSkinTypeIndex=1}
            if ((tmpStr?.containsString(loadLanguage("干性"))) != false)
            {skipController.currentSkinTypeIndex=2}
            else
            {skipController.currentSkinTypeIndex=3}
            //检测次数和检测时间穿进去
            self.navigationController?.pushViewController(skipController, animated: true)
        case 2:
            let detailController=WaterReplenishDetailTableViewController_EN()
            detailController.WaterReplenishDevice=myCurrentDevice as? WaterReplenishmentMeter
            detailController.currentBodyPart=(waterReplenishMainView?.currentBodyPart)!
            
            self.navigationController?.pushViewController(detailController, animated: true)
        default:
            break
        }
    }
    //净水器开关点击事件
    //var isHaveCoolAbility=true
    //var isHaveHotAbility=true
    func WaterPurSwitchClick(button:UIButton)
    {
        if myCurrentDevice == nil
        {
            return
        }
        if  WaterPurifierManager.isWaterPurifier(myCurrentDevice?.type)==false
        {
            return
        }
        let waterPur=myCurrentDevice as! WaterPurifier
        switch button.tag
        {
        case 0://电源
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waterPur.status.setPower(!waterPur.status.power, callback: { (error:NSError!) -> Void in
                self.performSelector(#selector(self.StopLoadAnimal), withObject: nil, afterDelay: 2);
                //MBProgressHUD.hideHUDForView(self.view, animated: true)
            })
            break
        case 1://制冷
            if waterPur.status.power==false
            {
                return
            }
            if waterPurFooter.ishaveCoolAblity==false
            {
                let alert=UIAlertView(title: loadLanguage("提示"), message: loadLanguage("抱歉，该净水器型号没有提供此项功能！"), delegate: self, cancelButtonTitle: loadLanguage("确定"))
                alert.show()
                return
            }
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waterPur.status.setCool(!waterPur.status.cool, callback: { (error:NSError!) -> Void in
                //MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.performSelector(#selector(self.StopLoadAnimal), withObject: nil, afterDelay: 2);
            })
            break
        case 2://加热
            if waterPur.status.power==false
            {
                return
            }
            if waterPurFooter.ishaveHotAblity==false
            {
                let alert=UIAlertView(title: loadLanguage("提示"), message: loadLanguage("抱歉，该净水器型号没有提供此项功能！"), delegate: self, cancelButtonTitle: loadLanguage("确定"))
                alert.show()
                return
            }
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waterPur.status.setHot(!waterPur.status.hot, callback: { (error:NSError!) -> Void in
                self.performSelector(#selector(self.StopLoadAnimal), withObject: nil, afterDelay: 2);
            })
            break
        default:
            break
        }
    }
    // 跳转到净水器TDS详情页
    func TDSDetailOfWaterPurf()
    {
        if (myCurrentDevice as? WaterPurifier)?.isOffline==true {
            DeviceOffLineClick()
        }
        else{
            let tdsController=WaterPurTDSDetailController_EN()
            tdsController.myCurrentDevice = myCurrentDevice as? WaterPurifier
            self.navigationController?.pushViewController(tdsController, animated: true)
        }
    }

    func leftMenuShouqiClick()
    {
        UIView.animateWithDuration(0.5, animations: { () in
            self.leftSlideBG_gray.backgroundColor=UIColor(white: 0, alpha: 0)
            }, completion: {(isok:Bool!) in
                print(isok)
                self.leftSlideBG_gray.hidden=true
        })
        
    }
    //划动手势
    func handleSwipeGesture(sender: UIPanGestureRecognizer){
        
        //划动的方向customPopViewFrame
        let point = sender.locationInView(self.view)
        let  x = point.x
        leftSlideBG_gray?.hidden=false
        leftSlideBG_gray?.backgroundColor=UIColor(white: 0, alpha: 0.5*x/Screen_Width)
        print(x)
        NSNotificationCenter.defaultCenter().postNotificationName("customPopViewFrame", object:x)
        if sender.state==UIGestureRecognizerState.Ended
        {
            if x>Screen_Width/3
            {
                leftSlideBG_gray?.backgroundColor=UIColor(white: 0, alpha: 0.5)
                NSNotificationCenter.defaultCenter().postNotificationName("updateDeviceInfo", object: self)
                NSNotificationCenter.defaultCenter().postNotificationName("customPopViewFrame", object:Screen_Width)
            }
            else
            {
                
                leftSlideBG_gray.hidden=true
                leftSlideBG_gray.backgroundColor=UIColor(white: 0, alpha: 0)
                NSNotificationCenter.defaultCenter().postNotificationName("customPopViewFrame", object:0)
            }
        }
        
    }
    
    //CustomNoDeviceViewDelegate
//    func customNodeviceAddDeviceAction() {
//        self.addDeviceAction()
//    }
    
    //添加设备
    func addDeviceAction()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("updateDeviceInfo", object: self)
        delegate?.leftActionCallBack()
        UIView.animateWithDuration(0.5) { () -> Void in
            self.leftSlideBG_gray.backgroundColor=UIColor(white: 0, alpha: 0.5)
            self.leftSlideBG_gray.hidden=false
        }
    }
    
    
    //下载滤芯状态
    func downLoadLvXinState()
    {
        let werbservice = DeviceWerbservice()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        if TapManager.isTap(myCurrentDevice?.type)==true
        {
            werbservice.filterService(self.myCurrentDevice?.identifier) { (modifyTime:String!, userDay:NSNumber!, status:StatusManager!) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if(status.networkStatus == kSuccessStatus)
                {
                    if(userDay.intValue == 0)
                    {
                        self.lvxinValue.text = "100%";
                        self.lvxinImg.image=UIImage(named: "tantou_dianliang_3")
                        self.lvxinState.text=loadLanguage("滤芯状态")
                    }
                    else
                    {
                        let maxUserDay:Float=TapManager.isTap(self.myCurrentDevice?.type)==true ? 30.0:365.0
                        
                        var value = Int(floor(100.0*(maxUserDay-userDay.floatValue)/Float(maxUserDay))) //Int(100*(maxUserDay-userDay.floatValue)/maxUserDay);
                        switch value
                        {
                        case 0:
                            
                            self.lvxinImg.image=UIImage(named: "tantou_dianliang_0")
                            break
                        case 1...49:
                            self.lvxinImg.image=UIImage(named: "tantou_dianliang_1")
                            break
                        case 50..<100:
                            self.lvxinImg.image=UIImage(named: "tantou_dianliang_2")
                            break
                        case 100:
                            self.lvxinImg.image=UIImage(named: "tantou_dianliang_2")
                            break
                        default:
                            self.lvxinImg.image=UIImage(named: "tantou_dianliang_0")
                            break
                        }
                        self.lvxinState.text=value<=30 ? "请及时更换滤芯":"滤芯状态"
                        value=value<=0 ? 0:value
                        self.lvxinValue.text = "\(value)%"
                        if value==0&&(maxUserDay-userDay.floatValue)>0
                        {
                            self.lvxinValue.text="1%"
                        }
                    }
                }
                else
                {
                    self.lvxinValue.text = "--%"
                }
            }
        }else if WaterPurifierManager.isWaterPurifier(myCurrentDevice?.type)==true
        {
            var AlertDaysOfWater=30
            
            let queue = dispatch_queue_create (loadLanguage("净水机队列"),DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(queue, {
                //获取水机设备制冷是否可用和设备类型
                werbservice.GetMachineType(self.myCurrentDevice?.identifier, returnBlock: { (isshowscan,waterType, hotandcoll,buyUrl,alertDaysOfWater, status:StatusManager!) -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if(status.networkStatus == kSuccessStatus)
                    {
                        self.WaterTypeOfService=waterType
                        self.BuyWaterUrlString=buyUrl
                        self.IsShowScanOfWater=isshowscan=="1"
                        
                        AlertDaysOfWater =  alertDaysOfWater==nil ? AlertDaysOfWater:Int(alertDaysOfWater)!
                        self.waterPurFooter.ishaveCoolAblity=hotandcoll.containsString("cool:true")
                        self.waterPurFooter.ishaveHotAblity=hotandcoll.containsString("hot:true")
                        
                    }
                })
            })
            dispatch_barrier_async(queue, {
                
                //获取滤芯服务时间
                let manager = AFHTTPRequestOperationManager()
                let url = StarURL_New+"/OznerDevice/GetMachineLifeOutTime"
                let params:NSDictionary = ["usertoken":get_UserToken(),"mac":(self.myCurrentDevice?.identifier)!]
                manager.POST(url,
                    parameters: params,
                    success: { (operation: AFHTTPRequestOperation!,
                        responseObject: AnyObject!) in
                        print(responseObject)
                        let state=responseObject.objectForKey("state") as! Int
                        if(state>=0)
                        {
                           
                            
                            if (responseObject.objectForKey("time")!.isKindOfClass(NSNull) == false)&&(responseObject.objectForKey("nowtime")!.isKindOfClass(NSNull) == false)
                            {
                                self.lvxinContainView.hidden=false
                                let format=NSDateFormatter()
                                format.dateFormat="yyyy/MM/dd HH:mm:ss"
                                
                                let endDate=responseObject.objectForKey("time") as! String
                                let nowDate=responseObject.objectForKey("nowtime") as! String
                                let endTime=format.dateFromString(endDate)!.timeIntervalSince1970
                                let nowTime=format.dateFromString(nowDate)!.timeIntervalSince1970
                                print(endTime)
                                print(nowTime)
                                let value =  Int(ceil(100.0*(endTime-nowTime)/(365*24*3600.0)))
                                switch value
                                {
                                case 0:
                                    self.lvxinImg.image=UIImage(named: "tantou_dianliang_0")
                                    break
                                case 1...49:
                                    self.lvxinImg.image=UIImage(named: "tantou_dianliang_1")
                                    break
                                case 50..<100:
                                    self.lvxinImg.image=UIImage(named: "tantou_dianliang_2")
                                    break
                                case 100:
                                    self.lvxinImg.image=UIImage(named: "tantou_dianliang_2")
                                    break
                                default:
                                    self.lvxinImg.image=UIImage(named: "tantou_dianliang_0")
                                    break
                                }
                                self.lvxinState.text=value<=AlertDaysOfWater ? loadLanguage("请及时更换滤芯"):loadLanguage("滤芯状态")
                                
                                self.lvxinValue.text = "\(value<0 ? 0:value)%"
                                if self.lvxinValue.text=="0%"&&(endTime-nowTime)>0
                                {
                                    self.lvxinValue.text="1%"
                                }
                                if value<=AlertDaysOfWater
                                {
                                    let alertView=SCLAlertView()
                                    alertView.addButton(loadLanguage("现在去购买滤芯"), action: {
                                        //提到购买滤芯的页面
                                        let buyLX=WeiXinURLViewController_EN(goUrl: self.BuyWaterUrlString)
                                        let witchUrl=weiXinUrlNamezb()
                                        
                                        buyLX.title=witchUrl.WaterLvXinUrl1//1,2,3
                                        
                                        self.presentViewController(buyLX, animated: true, completion: nil)
                                    })
                                    alertView.addButton(loadLanguage("我知道了"), action:{})
                                    alertView.showNotice(loadLanguage("温馨提示"), subTitle: loadLanguage("你的滤芯即将到期，请及时更换滤芯，以免耽误您的使用"))
                                }
                            }
                            else
                            {
                                self.lvxinValue.text = "--%";
                                
                            }
                            
                        }
                        else
                        {
                            self.lvxinValue.text = "--%"
                        }
                        
                    },
                    failure: { (operation: AFHTTPRequestOperation!,
                        error: NSError!) in
                        print("Error: " + error.localizedDescription)
                })
            })
            
            
        }
    }
    

    //取探头一个月的水纯净值
    func obtainTanTouTDS()
    {
        let firstDate = UToolBox.theMonthFirstDayZero() as NSDate
        
        print(firstDate)
        let tap = self.myCurrentDevice as! Tap
        self.tanTouDataSource = tap.recordList .GetRecordsByDate(firstDate)
        if(self.tanTouDataSource?.count > 0)
        {
            self.tanTouDataSource = CustomCommFunction_EN.customCommFunctionInstance().sortTapListMaxTime(self.tanTouDataSource! as [AnyObject])
        }
        let recordArray = tap.recordList.GetRecordsByDate(firstDate) as NSArray
        //let record:TapRecord? = tap.recordList.GetRecordByDate(firstDate)
        if recordArray.count>0
        {
            print(recordArray)
            self.myTanTouBgView!.layOUtTDSCell(recordArray as [AnyObject])
        }
        
    }
    
    //设置电池电量
    func setBartteryImg()
    {
        
        if(self.myCurrentDevice == nil)
        {
            deviceStateViewBG.hidden=true
            self.titleLabel.text = loadLanguage("首页")
            
        }
        else
        {
            deviceStateViewBG.hidden=false
            if ((self.myCurrentDevice?.isKindOfClass(Cup.classForCoder())) == true)
            {
                let cup = self.myCurrentDevice as! Cup
                self.titleLabel.text = removeAdressOfDeviceName(self.myCurrentDevice!.settings.name)
                
                if(cup.sensor.powerPer() == 0)
                {
                    self.dianliangImg.image = UIImage(named: "dian_liang_0.png")
                }
                else if(cup.sensor.powerPer() <= 0.3)
                {
                    self.dianliangImg.image = UIImage(named: "dian_liang_30.png")
                }
                else if(cup.sensor.powerPer() <= 0.7)
                {
                    self.dianliangImg.image = UIImage(named: "dian_liang_70.png")
                }
                else
                {
                    self.dianliangImg.image = UIImage(named: "dian_liang_100.png")
                }
                
                var baterry = cup.sensor.powerPer()
                if(baterry == 65535)
                {
                    baterry = 0
                }
                baterry = baterry * 100
                self.dianliangValue.text = String(Int(baterry)) + "%"
            }
            else if ((self.myCurrentDevice?.isKindOfClass(Tap.classForCoder())) == true)
            {
                self.titleLabel.text = removeAdressOfDeviceName(self.myCurrentDevice!.settings.name)
                let tap = self.myCurrentDevice as! Tap
                if(tap.sensor.powerPer() == 0)
                {
                    self.dianliangImg.image = UIImage(named: "dian_liang_0.png")
                }
                else if(tap.sensor.powerPer() <= 0.3)
                {
                    self.dianliangImg.image = UIImage(named: "dian_liang_30.png")
                }
                else if(tap.sensor.powerPer() <= 0.7)
                {
                    self.dianliangImg.image = UIImage(named: "dian_liang_70.png")
                }
                else
                {
                    self.dianliangImg.image = UIImage(named: "dian_liang_100.png")
                }
                
                var baterry = tap.sensor.powerPer()
                if(baterry == 65535)
                {
                    baterry = 0
                }
                baterry = baterry * 100
                self.dianliangValue.text = String(Int(baterry)) + "%"
            }
                
            else if WaterPurifierManager.isWaterPurifier(self.myCurrentDevice?.type) == true
            {
                self.titleLabel.text = removeAdressOfDeviceName(self.myCurrentDevice!.settings.name)
            }
            else if AirPurifierManager.isBluetoothAirPurifier(self.myCurrentDevice?.type) == true
            {
                if headView != nil
                {
                    headView.headTitle.text = removeAdressOfDeviceName(self.myCurrentDevice!.settings.name)
                }
            }
            else if AirPurifierManager.isMXChipAirPurifier(self.myCurrentDevice?.type) == true
            {
                if headView != nil
                {
                    headView.headTitle.text = removeAdressOfDeviceName(self.myCurrentDevice!.settings.name)
                }
            }else if WaterReplenishmentMeterMgr.isWaterReplenishmentMeter(self.myCurrentDevice?.type) == true
            {
                if waterReplenishMainView != nil
                {
                    waterReplenishMainView?.TitleOfReplensh.text = removeAdressOfDeviceName(self.myCurrentDevice!.settings.name)
                }
            }
        }
    }
    //去掉名字使用地点
    
    func removeAdressOfDeviceName(tmpName:String)->String
    {
        if tmpName.characters.contains("(")==false
        {
            return tmpName
        }
        else
        {
            let NameStr:NSArray = tmpName.componentsSeparatedByString("(")
            return (NameStr.objectAtIndex(0) as! String)
        }
    }
    //收到删除设备的通知
    func receiveDeleteDevicesNotify()
    {
        //print(nt)
        let muArr = NSMutableArray(array: OznerManager.instance().getDevices()) as NSMutableArray;
        if muArr.count > 0
        {
            self.myCurrentDevice = muArr.objectAtIndex(0) as? OznerDevice
            self.myCurrentDevice?.delegate = self;
            NSNotificationCenter.defaultCenter().postNotificationName("getDevices", object: nil)
        }
        else
        {
            self.myCurrentDevice = nil
            
        }
        NSNotificationCenter.defaultCenter().postNotificationName("currentSelectedDevice", object: self.myCurrentDevice)
    }

    
    //更换设备界面
    func updateCurrentDeviceData(notication:NSNotification)
    {
        self.myCurrentDevice = notication.object as? OznerDevice
        self.myCurrentDevice?.delegate = self
        
        if(self.myCurrentDevice != nil)
        {
            loadWhitchView((self.myCurrentDevice?.type)!)
                        //更新数据
            OznerDeviceSensorUpdate(self.myCurrentDevice)
        }
        else
        {
            //没有设备
            loadWhitchView("default")
        }
        
    }
    

    
    func downLoadTDS(tds:Int,tdsBefore:Int)
    {
        let werbservice = DeviceWerbservice()
        werbservice.tdsSensor(self.myCurrentDevice!.identifier, type: self.myCurrentDevice!.type , tds: "\(tds)", beforetds: "\(tdsBefore)") { (rank:NSNumber!, total:NSNumber!, status:StatusManager!) -> Void in
            if(status.networkStatus == kSuccessStatus)
            {
                self.currentDefeat = Int(total.intValue)
                self.currentRank = Int(rank.intValue)
                //print(self.currentRank)
                //print(self.currentDefeat)
                if((self.myCurrentDevice?.isKindOfClass(Cup.classForCoder())) == true)
                {
                    self.myCircleView?.currentDefeatValue = Int32(self.currentDefeat!)
                    self.myCircleView?.currentRankValue = Int32(self.currentRank!)
                    self.myCircleView?.update()
                }
                else if((self.myCurrentDevice?.isKindOfClass(Tap.classForCoder())) == true)
                {
                    self.myCircleView?.currentDefeatValue = Int32(self.currentDefeat!)
                    self.myCircleView?.currentRankValue = Int32(self.currentRank!)
                    self.myCircleView?.update()
                }
                else if(self.myCurrentDevice?.isKindOfClass(MXChipIO.classForCoder()) == true)
                {
                    //净水器
                }
                
                
            }
        }
    }
    
    //下载饮水量排名
    func downLoadVolume()
    {
        let werbservice = DeviceWerbservice();
        werbservice.volumeSensor(self.myCurrentDevice!.identifier, type: self.myCurrentDevice!.type, volume: "\((self.currentVolumeValue! as Int))") { (rank:NSNumber!, status:StatusManager!) -> Void in
            if(status.networkStatus == kSuccessStatus)
            {
                self.currentVolumeValue = Int(rank)
            }
        }
    }
    
    func OznerDeviceSensorUpdate(device: OznerDevice!) {
        if(self.myCurrentDevice == nil)
        {
            return;
        }
        if(self.myCurrentDevice?.identifier != device.identifier)
        {
            return;
        }
        if(device.isKindOfClass((self.myCurrentDevice?.classForCoder)!) == true)
        {
            var tds = 0
            self.myCurrentDevice = device
            if((self.myCurrentDevice?.isKindOfClass(Cup.classForCoder())) == true)
            {
                let cup = self.myCurrentDevice as! Cup
                tds = Int(cup.sensor.TDS)
                if(cup.sensor.TDS > 0&&cup.sensor.TDS != 65535)
                {
                    self.myCircleView?.currentTDSValue = CGFloat(cup.sensor.TDS)
                }
                else
                {
                    self.myCircleView?.currentTDSValue = 0
                }
                
                
                cupFooterView.temperature=Int(cup.sensor.Temperature)
                let date = UToolBox.todayZero() as NSDate
                //print(cup.volumes.getRecordByDate(date))
                let record:CupRecord? = cup.volumes.getRecordByDate(date)
                if(record != nil)
                {
                    cupFooterView.water=Int(record!.volume)

                    if(Int32(self.currentVolumeValue!) != record!.volume)
                    {
                        self.currentVolumeValue = Int(record!.volume)
                        self.downLoadVolume()
                    }
                    
                }
                let goal:String? = cup.settings.get("my_drinkwater", default: nil) as? String
                if goal?.isEmpty == false
                {
                    cupFooterView.drinkMuBiao.text=loadLanguage( loadLanguage("饮水目标:") ) + goal!+"ml"
                    self.currentGoalVolumeValue = Int(goal!)
                }
                else
                {
                    self.currentGoalVolumeValue = 2000;
                    cupFooterView.drinkMuBiao.text=loadLanguage( loadLanguage("饮水目标:2000ml") )
                }
                
                if(self.currentTDS != tds)
                {
                    self.myCircleView?.update()
                    self.downLoadTDS(tds,tdsBefore: 0)
                    self.currentTDS = tds
                }
            }
            else if((self.myCurrentDevice?.isKindOfClass(Tap.classForCoder())) == true)
            {
                let tap = self.myCurrentDevice as! Tap
                tds = Int(tap.sensor.TDS)
                if(tap.sensor.TDS > 0&&tap.sensor.TDS != 65535)
                {
                    self.myCircleView?.currentTDSValue = CGFloat(tap.sensor.TDS)
                }
                else
                {
                    self.myCircleView?.currentTDSValue = 0
                }
                
                if(isNeedDownLXDate == false)
                {
                    isNeedDownLXDate = true
                    self.downLoadLvXinState()
                }
                
                
                if(self.currentTDS != tds)
                {
                    self.obtainTanTouTDS()
                    self.myCircleView?.update()
                    self.downLoadTDS(tds,tdsBefore: 0)
                    self.currentTDS = tds
                }
            }
            else if(self.myCurrentDevice?.isKindOfClass(WaterPurifier.classForCoder()) == true)
            {
                //净水器
                let waterPurrifier=self.myCurrentDevice! as! WaterPurifier
                if waterPurrifier.status.power==true
                {
                    WaterPurfHeadView?.TdsBefore=Int(max(waterPurrifier.sensor.TDS1, waterPurrifier.sensor.TDS2))
                    WaterPurfHeadView?.TdsAfter=Int(min(waterPurrifier.sensor.TDS1, waterPurrifier.sensor.TDS2))
                    tds=(WaterPurfHeadView?.TdsAfter)!
                }
                if(isNeedDownLXDate == false)
                {
                    isNeedDownLXDate = true
                    self.downLoadLvXinState()
                }
                //print(self.currentTDS)
                if(self.currentTDS > tds&&(tds > 0))
                {
                    
                    self.downLoadTDS(tds,tdsBefore: (WaterPurfHeadView?.TdsBefore)!)
                    self.currentTDS = tds
                }
            }
            else if AirPurifierManager.isBluetoothAirPurifier(self.myCurrentDevice?.type)&&(IAW_TempView != nil)
            {
                let airPurifier_Bluetooth = self.myCurrentDevice as! AirPurifier_Bluetooth
                
                //跑马效果 0没有跑过，1正在跑马，2跑过马了
                if airPurifier_Bluetooth.status.power==true&&airPurifier_Bluetooth.sensor.PM25 != 65535
                {
                    if isPaoMa != 1
                    {
                        if isPaoMa == 0
                        {
                            IAW_TempView.PM25.text="0"
                            
                            IAW_TempView.PM25.tag=Int(airPurifier_Bluetooth.sensor.PM25)
                            if (IAW_TempView.PM25.tag<3)
                            {
                                IAW_TempView.PM25.text="\(airPurifier_Bluetooth.sensor.PM25)"
                            }
                            else
                            {
                                isPaoMa=1
                                tmpPaoMa=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(StarPaoMazb), userInfo: nil, repeats: true)
                            }
                            
                        }
                        else
                        {
                            IAW_TempView.PM25.text="\(airPurifier_Bluetooth.sensor.PM25)"
                        }
                    }
                    smallStateView.temperature.text = "\(airPurifier_Bluetooth.sensor.Temperature)"
                    smallStateView.Humidity.text = "\(airPurifier_Bluetooth.sensor.Humidity)%"
                    setAirStandart(Int(airPurifier_Bluetooth.sensor.PM25))
                    //滤芯状态
                    //当前时间
                    if(isNeedDownLXDate == false)
                    {
                        isNeedDownLXDate = true
                        UpDateLvXinOfSmallAir()
                    }
                    
                }
                else
                {
                    IAW_TempView.PM25.text=loadLanguage("已关机")
                    //IAW_TempView.PM25.font=UIFont(name: ".SFUIDisplay-Thin", size: 40)
                }
                
                
                
                
            }
            else if AirPurifierManager.isMXChipAirPurifier(self.myCurrentDevice?.type)&&(IAW_TempView != nil)
            {
                //initBigClickButton()
                let airPurifier_MxChip = self.myCurrentDevice as! AirPurifier_MxChip
                if airPurifier_MxChip.status.power==true&&airPurifier_MxChip.sensor.PM25 != 65535
                {
//                    if #available(iOS 8.2, *) {
//                        IAW_TempView.PM25.font=UIFont.systemFontOfSize(60, weight: 0.5)
//                    } else {
//                        IAW_TempView.PM25.font=UIFont.systemFontOfSize(50)
//                        // Fallback on earlier versions
//                    }
                    //跑马效果 0没有跑过，1正在跑马，2跑过马了
                    if isPaoMa != 1
                    {
                        if isPaoMa == 0
                        {
                            IAW_TempView.PM25.text="0"
                            IAW_TempView.PM25.tag=Int(airPurifier_MxChip.sensor.PM25)
                            if (IAW_TempView.PM25.tag<3||IAW_TempView.PM25.tag==65535)
                            {
                                IAW_TempView.PM25.text="\(airPurifier_MxChip.sensor.PM25)"
                            }
                            else
                            {
                                isPaoMa=1
                                tmpPaoMa=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(StarPaoMazb), userInfo: nil, repeats: true)
                                //self.StarPaoMazb()
                                
                            }
                            
                        }
                        else
                        {
                            IAW_TempView.PM25.text="\(airPurifier_MxChip.sensor.PM25)"
                        }
                    }
                    bigStateView.VOC.text = VOCStantdart(airPurifier_MxChip.sensor.VOC)
                    bigStateView.teampre.text = "\(airPurifier_MxChip.sensor.Temperature)"
                    bigStateView.himida.text = "\(airPurifier_MxChip.sensor.Humidity)%"
                    setAirStandart(Int(airPurifier_MxChip.sensor.PM25))
                    
                    
                    
                    if airPurifier_MxChip.status.filterStatus == nil
                    {
                        return
                    }
                    if(isNeedDownLXDate == false)
                    {
                        isNeedDownLXDate = true
                        //滤芯状态
                        let nowTime:NSTimeInterval=NSDate().timeIntervalSince1970
                        let stopTime:NSTimeInterval=airPurifier_MxChip.status.filterStatus.lastTime.timeIntervalSince1970+365*24*3600
                        headView.lvxinState.text=(stopTime-nowTime)>=0 ? "\(Int(ceil((stopTime-nowTime)/(365*24*3600)*100)))%":"0%"
                        switch ceil((stopTime-nowTime)/(365*24*3600)*100)
                        {
                        case 0:
                            headView.LvXinStateImage.image=UIImage(named: "airLvxinState0")
                            break
                        case 1..<40:
                            headView.LvXinStateImage.image=UIImage(named: "airLvxinState1")
                            break
                        case 40..<60:
                            headView.LvXinStateImage.image=UIImage(named: "airLvxinState2")
                            break
                        case 60..<100:
                            headView.LvXinStateImage.image=UIImage(named: "airLvxinState3")
                            break
                        default:
                            headView.LvXinStateImage.image=UIImage(named: "airLvxinState4")
                            break
                        }
                        if isNeedDownLXDate==false&&((stopTime-nowTime)<=0)
                        {
                            isNeedDownLXDate=true
                            let alert=UIAlertView(title: loadLanguage("温馨提示"), message:  loadLanguage("你的滤芯即将到期，请及时更换滤芯，以免耽误您的使用"), delegate: self, cancelButtonTitle:loadLanguage("确定"))
                            alert.show()
                        }
                        //NSNotificationCenter.defaultCenter().postNotificationName("updateAirLvXinData", object: nil)
                    }
                    
                    
                }else
                {
                    IAW_TempView.PM25.text=loadLanguage(loadLanguage("已关机"))
                    //IAW_TempView.PM25.font=UIFont(name: ".SFUIDisplay-Thin", size: 40)
                }

            }
            
            
            
            
        }
        
        self.setBartteryImg()
    }
    func UpDateLvXinOfSmallAir()  {
        if myCurrentDevice == nil{
            return
        }
        let airPurifier_Bluetooth = self.myCurrentDevice as! AirPurifier_Bluetooth
        //let nowTime:NSTimeInterval=NSDate().timeIntervalSince1970
        if airPurifier_Bluetooth.status.filterStatus.lastTime != .None
        {
            //let stopTime:NSTimeInterval=airPurifier_Bluetooth.status.filterStatus.lastTime.timeIntervalSince1970+90*24*3600
            //let stopTime:NSTimeInterval=(airPurifier_Bluetooth.status.filterStatus.lastTime+3.months).timeIntervalSince1970
            //let starTime = airPurifier_Bluetooth.status.filterStatus.lastTime.timeIntervalSince1970
            print(airPurifier_Bluetooth.status.filterStatus.workTime)
            let remain=min(100, 100-airPurifier_Bluetooth.status.filterStatus.workTime/600)
            let remain1 = max(remain, 0)
            
            headView.lvxinState.text = "\(remain1)%"
            switch remain1
            {
            case 0..<15:
                headView.LvXinStateImage.image=UIImage(named: "airLvxinState0")
                break
            case 15..<40:
                headView.LvXinStateImage.image=UIImage(named: "airLvxinState1")
                break
            case 40..<60:
                headView.LvXinStateImage.image=UIImage(named: "airLvxinState2")
                break
            case 60..<85:
                headView.LvXinStateImage.image=UIImage(named: "airLvxinState3")
                break
            default:
                headView.LvXinStateImage.image=UIImage(named: "airLvxinState4")
                break
            }
            if (remain1<=0)
            {
                let alert=UIAlertView(title: loadLanguage("温馨提示"), message:  loadLanguage("你的滤芯即将到期，请及时更换滤芯，以免耽误您的使用"), delegate: self, cancelButtonTitle:loadLanguage("确定"))
                alert.show()
            }

            
        }
    }
    //跑马star  赵兵
    var tmpPaoMa:NSTimer!
    //判断是否为整形：
    func StarPaoMazb()
    {
        if let _ = Int(IAW_TempView.PM25.text!)
        {
            if IAW_TempView.PM25.tag <= Int(IAW_TempView.PM25.text!)!
            {
                isPaoMa=2
                tmpPaoMa.invalidate()
                
            }else
            {
                IAW_TempView.PM25.text=String(Int(IAW_TempView.PM25.text!)!+1)
                print("\(IAW_TempView.PM25.text),\(IAW_TempView.PM25.tag)")
            }
        }
        else
        {
            isPaoMa=2
            tmpPaoMa.invalidate()
            return
        }
        
        
    }
    
    //跑马end  赵兵
    func OznerDeviceStatusUpdate(device: OznerDevice!) {
        if myCurrentDevice==nil||device==nil||device.identifier != myCurrentDevice?.identifier
        {
            return
        }
        //wifi设备
        if AirPurifierManager.isMXChipAirPurifier(self.myCurrentDevice?.type)||WaterPurifierManager.isWaterPurifier(self.myCurrentDevice?.type) {
            //空净
             StopLoadAnimal()
            if headView != nil&&(AirPurifierManager.isMXChipAirPurifier(self.myCurrentDevice?.type))
            {
                let airPurifier = self.myCurrentDevice as! AirPurifier_MxChip
                if airPurifier.isOffline==true{
                    IAW_TempView.PM25.text=loadLanguage("设备已断开")
                    IAW_TempView.PM25.font=UIFont(name: ".SFUIDisplay-Thin", size: 24)
                    print(IAW_TempView.PM25.font)
                }
                else{
                    IAW_TempView.PM25.font=UIFont(name: ".SFUIDisplay-Thin", size: 45)
                    initBigClickButton()
                    
                }
               
            }else if waterPurFooter != nil&&(WaterPurifierManager.isWaterPurifier(self.myCurrentDevice?.type))
            {
                let waterPurifier = self.myCurrentDevice as! WaterPurifier
                WaterPurfHeadView?.deviceStateLabel.hidden = !waterPurifier.isOffline
                WaterPurfHeadView?.deviceValueContainer.hidden=waterPurifier.isOffline
                if waterPurifier.isOffline==false {
                    waterPurFooter.updateSwitchState()
                    if (self.myCurrentDevice as! WaterPurifier).status.power==false
                    {
                        WaterPurfHeadView?.TdsBefore=0
                        WaterPurfHeadView?.TdsAfter=0
                    }
                    
                }
                
            }
            
            //设备网络状况
            
        }else{ //蓝牙设备
            if(device.connectStatus() == Connected)
            {
                LoadingView.state = -1//已连接
            }
            else if (device.connectStatus() == Connecting)
            {
                LoadingView.state=0
            }
            else
            {
                LoadingView.state=1
            }
            //补水仪设备检测中，检测完成回掉
            if WaterReplenishmentMeterMgr.isWaterReplenishmentMeter(myCurrentDevice?.type)
            {
                if waterReplenishMainView != nil
                {
                    waterReplenishMainView?.updateViewState()
                }
            }
        }
        
    }
    
    //Cup点击温度
    func temperatureAction()
    {
        self.m_bIsHideTableBar = true
        let controller = AmountOfDrinkingWaterViewController_EN(nibName: "AmountOfDrinkingWaterViewController_EN", bundle: nil)
        controller.currentType = 1
        controller.myCurrentDevice = self.myCurrentDevice as! Cup
        controller.defeatValue = Int32(self.currentDefeat!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //朋友圈内饮水量排名
    func FriendVolumeRank()
    {
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.m_bIsHideTableBar = true
        let controller = AmountOfDrinkingWaterViewController_EN(nibName: "AmountOfDrinkingWaterViewController_EN", bundle: nil)
        controller.currentType = 0
        controller.myCurrentDevice = self.myCurrentDevice as! Cup
        let cup = self.myCurrentDevice as! Cup
        let date = UToolBox.todayZero() as NSDate
        //controller.todayRank = Int32(self.currentVolumeValue!)
        //controller.defeatValue = Int32(self.currentDefeat!)
        //controller.defeatRank=Int32(self.currentRank!)
        let record:CupRecord? = cup.volumes.getRecordByDate(date)
        if(record != nil)
        {
            if(self.currentGoalVolumeValue == 0)
            {
                controller.todayVolume = 100 ;
            }
            else
            {
                controller.todayVolume = Int32((CGFloat(record!.volume)/CGFloat(self.currentGoalVolumeValue!)) * CGFloat(100));
            }
            
        }
        controller.currentType = 0
//        let werbservice = DeviceWerbservice();
//        werbservice.volumeFriendRank { (rank:NSNumber!, arr:NSMutableArray!, status:StatusManager!) -> Void in
//            if(status.networkStatus == kSuccessStatus)
//            {
//                self.currentVolumeValue = Int(rank)
//                controller.todayRank=Int32(self.currentVolumeValue!)
//            }
//            else
//            {
//                self.currentVolumeValue=0
//                controller.todayRank=Int32(0)
//                
//            }
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
//            self.navigationController?.pushViewController(controller, animated: true)
//            
//        }
 
        self.navigationController?.pushViewController(controller, animated: true)

    }
    //Cup点击引水量
    func amoutOfWaterAction()
    {
        FriendVolumeRank()
    }
    

    /**
    水杯TDS详情页----CustomOCCircleViewDelegate
    */
    func seeTdsDetail()
    {
        self.m_bIsHideTableBar = true
        if((self.myCurrentDevice?.isKindOfClass(Cup.classForCoder())) == true)
        {
            let controller = TDSDetailViewController_EN(nibName: "TDSDetailViewController_EN", bundle: nil)
            controller.myCurrentDevice = self.myCurrentDevice
            let cup = self.myCurrentDevice as! Cup
            controller.tdsValue = cup.sensor.TDS
            //controller.defeatRank = Int32(self.currentRank!)
            //controller.tdsRankValue = 1
            
            //controller.defeatValue = Int32(self.currentDefeat!)
            self.navigationController?.pushViewController(controller, animated: true)
//            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            let werbservice = DeviceWerbservice()
//            werbservice.TdsFriendRank(myCurrentDevice?.type, returnBlock: { (rank:NSNumber!, total:NSMutableArray!, status:StatusManager!) -> Void in
//                MBProgressHUD.hideHUDForView(self.view, animated: true)
//                if(status.networkStatus == kSuccessStatus)
//                {
//                    controller.tdsRankValue = rank.intValue
//                    
//                }
//                else
//                {
//                    controller.tdsRankValue = 1
//                }
//                self.navigationController?.pushViewController(controller, animated: true)
//            })

        }
   
    }
    
    
    //--------------------airCleaner----------------
    func loadAirCleanerView()
    {
        MainScrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight-65))
        MainScrollView.backgroundColor=UIColor(red: 238/255, green: 239/255, blue: 240/255, alpha: 1)
        headView=NSBundle.mainBundle().loadNibNamed("headViewView_EN", owner: nil, options: nil).last as! headViewView_EN
        headView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: headView.bounds.size.height*(Screen_Hight/667))
        headView.initView()
        headView.bgColorIndex=1
        headView.toLeftMenu.addTarget(self, action: #selector(addDeviceAction), forControlEvents: .TouchUpInside)
        //查看室内空气质量
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(toSeeIndoor))
        headView.LvXinState.addTarget(self, action: #selector(toSeeIndoor), forControlEvents: .TouchUpInside)
        tapGesture.numberOfTapsRequired=1//设置点按次数
        headView.seeIndoorAir.addGestureRecognizer(tapGesture)
        headView.toSetting.addTarget(self, action: #selector(toSettingClick), forControlEvents: .TouchUpInside)
        headView.seeOutAir.addTarget(self, action: #selector(seeOutAirClick), forControlEvents: .TouchUpInside)
        MainScrollView.addSubview(headView)
        updateOutAirData()
        //室内空气提醒
        IAW_TempView=NSBundle.mainBundle().loadNibNamed("indoorAirWarn_Air_EN", owner: nil, options: nil).last as! indoorAirWarn_Air_EN
        
        headView.seeIndoorAir.addSubview(IAW_TempView)
        IAW_TempView.translatesAutoresizingMaskIntoConstraints = false
        headView.seeIndoorAir.addConstraint(NSLayoutConstraint(item: IAW_TempView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: headView.seeIndoorAir, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        headView.seeIndoorAir.addConstraint(NSLayoutConstraint(item: IAW_TempView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: headView.seeIndoorAir, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        headView.seeIndoorAir.addConstraint(NSLayoutConstraint(item: IAW_TempView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: headView.seeIndoorAir, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        headView.seeIndoorAir.addConstraint(NSLayoutConstraint(item: IAW_TempView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: headView.seeIndoorAir, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        if AirPurifierManager.isBluetoothAirPurifier(self.myCurrentDevice?.type) == true
        {
            //stateView
            smallStateView=NSBundle.mainBundle().loadNibNamed("smallStateXib_EN", owner: nil, options: nil).last as! smallStateXib_EN
            smallStateView.frame=CGRect(x: 0, y: 10, width: Screen_Width, height: smallStateView.bounds.size.height)
            
            headView.centerViewzb.addSubview(smallStateView)
            
            //footerView
            
            smallFooterView=NSBundle.mainBundle().loadNibNamed("smallFooterViewXib_EN", owner: nil, options: nil).last as! smallFooterViewXib_EN
            smallFooterView.frame=CGRect(x: 0, y: headView.bounds.size.height, width: Screen_Width, height: smallFooterView.bounds.size.height*(Screen_Hight/667))
            smallFooterView.blueTooth = self.myCurrentDevice as! AirPurifier_Bluetooth
            smallFooterView.initView()
            
            MainScrollView.addSubview(smallFooterView)
            
            
        }
        else
        {
            bigStateView=NSBundle.mainBundle().loadNibNamed("bigStateXib_EN", owner: nil, options: nil).last as! bigStateXib_EN
            bigStateView.frame=CGRect(x: 0, y: 10, width: Screen_Width, height: bigStateView.bounds.size.height)
            headView.centerViewzb.addSubview(bigStateView)
            headView.FuLiZiOfSmallAir.hidden=true
            //滚动视图
            let footerScroll=UIScrollView(frame: CGRect(x: 0, y: headView.bounds.size.height, width: Screen_Width, height: Screen_Hight-65-headView.height))
            footerScroll.pagingEnabled = true
            footerScroll.delegate=self
            footerScroll.showsHorizontalScrollIndicator=false
            footerScroll.showsVerticalScrollIndicator=false
            footerScroll.contentSize=CGSize(width: 0, height: 0)
            
            let bigViewWidth:CGFloat=60/375*Screen_Width>60 ? 60:60/375*Screen_Width
            let spaceValue:CGFloat=(Screen_Width-bigViewWidth*3)/4            //auto点击视图加载
            bigModelBgView=UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: (Screen_Hight>(667-65-20) ? Screen_Hight:(667-65-20))))
            bigModelBgView.backgroundColor=UIColor(white: 0, alpha: 0.5)
            tmpbigmodel=NSBundle.mainBundle().loadNibNamed("bigautoModelView_EN", owner: nil, options: nil).last as! bigautoModelView_EN
            let tmpOrigin_y=154-33+headView.bounds.size.height-tmpbigmodel.frame.height
            let tmpOrigin_x=bigViewWidth*3/2+2*spaceValue-tmpbigmodel.frame.width/2
            tmpbigmodel.frame=CGRect(x: tmpOrigin_x, y: tmpOrigin_y, width: tmpbigmodel.frame.width, height: tmpbigmodel.frame.height)
            tmpbigmodel.leftButton.addTarget(self, action: #selector(selectWhichModelbig), forControlEvents: .TouchUpInside)
            tmpbigmodel.rightButton.addTarget(self, action: #selector(selectWhichModelbig), forControlEvents: .TouchUpInside)
            tmpbigmodel.bottomButton.addTarget(self, action: #selector(selectWhichModelbig), forControlEvents: .TouchUpInside)
            bigModelBgView.addSubview(tmpbigmodel)
            bigFooterViews.removeAll()
            for i in 1...3 //7
            {
                let tmpbigFooter=NSBundle.mainBundle().loadNibNamed("bigFooterViewXib_EN", owner: nil, options: nil).last as! bigFooterViewXib_EN
                //if i<=4
                //{
                tmpbigFooter.frame=CGRect(x:spaceValue*CGFloat(i)+bigViewWidth*CGFloat(i-1), y: 0, width: bigViewWidth + 5, height: footerScroll.bounds.height)
                //                }
                //                else
                //                {
                //                    tmpbigFooter.frame=CGRect(x:spaceValue*CGFloat(i+1)+bigViewWidth*CGFloat(i-1), y: 0, width: bigViewWidth, height: tmpbigFooter.bounds.size.height)
                //
                //                }
                tmpbigFooter.switchButton.tag=i
                tmpbigFooter.switchButton.addTarget(self, action: #selector(switchButtonClick), forControlEvents: .TouchUpInside)
                tmpbigFooter.index=i
                
                tmpbigFooter.ison=false
                tmpbigFooter.switchButton.layer.cornerRadius=(bigViewWidth + 5.0)/2
                bigFooterViews.append(tmpbigFooter)
                footerScroll.addSubview(tmpbigFooter)
            }
            footerScroll.backgroundColor=UIColor.whiteColor()
            
            MainScrollView.addSubview(footerScroll)
//            footerScroll.updateConstraintsIfNeeded()
//            headView.updateConstraints()
//            headView.updateConstraintsIfNeeded()
            //pageView
            //pagecontrol=UIPageControl(frame: CGRect(x: SCREEN_WIDTH/2-30, y: headView.bounds.size.height+140, width: 60, height: 6))
            //pagecontrol.numberOfPages=2
            //pagecontrol.currentPage=0
            //pagecontrol.currentPageIndicatorTintColor=color_sblue
            //pagecontrol.pageIndicatorTintColor=color_gray
            //MainScrollView.addSubview(pagecontrol)
            
            //let tmpbigDevice1=self.myCurrentDevice as! AirPurifier_MxChip
            //bigFooterViews[0].ison=tmpbigDevice1.status.power
            initBigClickButton()
            
        }
        
        MainScrollView.contentSize=CGSize(width: 0, height: Screen_Hight-65)
        self.view.addSubview(MainScrollView)
        
    }
    //
//    func toLeftMenuClick()
//    {
//        NSNotificationCenter.defaultCenter().postNotificationName("updateDeviceInfo", object: self)
//        delegate?.leftActionCallBack()
//        UIView.animateWithDuration(0.5) { () -> Void in
//            self.leftSlideBG_gray.backgroundColor=UIColor(white: 0, alpha: 0.5)
//            self.leftSlideBG_gray.hidden=false
//        }
//        
//    }
    //室内空气
    func toSeeIndoor()
    {
        if myCurrentDevice==nil {
            return
        }
        if AirPurifierManager.isMXChipAirPurifier((myCurrentDevice! as OznerDevice).type)==true {
            if (self.myCurrentDevice as! AirPurifier_MxChip).isOffline==true {
                DeviceOffLineClick()
                return
            }
        }else if AirPurifierManager.isBluetoothAirPurifier(myCurrentDevice?.type)==true&&(myCurrentDevice as! AirPurifier_Bluetooth).status.power==false
        {
            return
        }
        
        let indoorAir=indoorAirViewController_EN()
        indoorAir.myCurrentDevice=self.myCurrentDevice
        self.navigationController?.pushViewController(indoorAir, animated: true)
        
    }
    //air设置
    func toSettingClick()
    {
        if self.myCurrentDevice==nil
        {
             let alert=UIAlertView(title: loadLanguage("温馨提示"), message:  loadLanguage("设备没有连接上"), delegate: self, cancelButtonTitle:loadLanguage("确定"))
            alert.show()
            return
        }
        let airsetting=setAirViewController_EN()
        airsetting.myCurrentDevice=self.myCurrentDevice
        self.navigationController?.pushViewController(airsetting, animated: true)
    }
    
    //室外空气
    var bgairView:UIView!
    var outAirDataArray:NSDictionary!
    func seeOutAirClick()
    {
        bgairView=UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight))
        bgairView.backgroundColor=UIColor(white: 0, alpha: 0.3)
        outAirView=NSBundle.mainBundle().loadNibNamed("outAirXib_EN", owner: nil, options: nil).last as! outAirXib_EN
        outAirView.frame=CGRect(x: 0, y: Screen_Hight-outAirView.bounds.size.height, width: Screen_Width, height: outAirView.bounds.size.height)
        outAirView.initView()
        outAirView.IKnowButton.addTarget(self, action: #selector(IKnow), forControlEvents: .TouchUpInside)
        bgairView.addSubview(outAirView)
        //添加点击手势
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(IKnow))
        tapGesture.numberOfTapsRequired=1//设置点按次数
        bgairView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(bgairView)
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
        updateOutAirData()
    }
    func updateOutAirData()
    {
        
        let werbservice = DeviceWerbservice()
        werbservice.getWeather(""){[weak self](pollution:String!,cityname:String!,PM25:String!,AQI:String!,temperature:String!,humidity:String!,dataFrom:String!,status:StatusManager!) -> Void in
            if(status.networkStatus == kSuccessStatus)
            {
                if let StrongSelf=self
                {
                    if StrongSelf.outAirView != nil
                    {
                        StrongSelf.outAirView.cityname.text=cityname
                        StrongSelf.outAirView.PM25.text=PM25+"ug/m3"
                        StrongSelf.outAirView.AQI.text=AQI
                        StrongSelf.outAirView.teampret.text=temperature+"℃"
                        StrongSelf.outAirView.hubit.text=humidity+"%"
                   //     print("jlsjlkjlksjfkl\(dataFrom)") ---  并不是英文
                        StrongSelf.outAirView.datafrom.text=loadLanguage("数据来源:")+dataFrom
                    }
                    StrongSelf.headView.cityName.text=cityname
                    StrongSelf.headView.polution.text=pollution
                    StrongSelf.headView.PM25.text=PM25
                }
            }
        }
    }
    func IKnow()
    {
        bgairView.removeFromSuperview()
        if (NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_LOGIN_STYLE) as! NSString).isEqualToString(LoginByPhone) {
            CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
        }
    }
    
    //设备未联网信息显示
    func DeviceOffLineClick()
    {
        bgairView=UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight))
        bgairView.backgroundColor=UIColor(white: 0, alpha: 0.3)    
        offLineSuggestView.frame=CGRect(x: 0, y: Screen_Hight-330, width: Screen_Width, height: 330)
        if  AirPurifierManager.isMXChipAirPurifier(myCurrentDevice?.type)==true {
            offLineSuggestView.isAir=true
        }
        if  WaterPurifierManager.isWaterPurifier(myCurrentDevice?.type)==true {
            offLineSuggestView.isAir=false
        }
        bgairView.addSubview(offLineSuggestView)
        //添加点击手势
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(IKnow))
        tapGesture.numberOfTapsRequired=1//设置点按次数
        bgairView.addGestureRecognizer(tapGesture)
        self.view.addSubview(bgairView)
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
        
    }
    //0 auto ,1 三级,2 二级,3一级，4 night，5 day
    let imgOn_0_5_4=["0":"air01002","5":"airdayOn","4":"airnightOn"]//0,5,4在on状态下对应的图片
    func  updateSpeedModel(tmpSpeed:UInt8)
    {
        if myCurrentDevice==nil
        {
            return
        }
        bigFooterViews[1].ison = (tmpSpeed==0||tmpSpeed==4||tmpSpeed==5) ? true :false
        bigFooterViews[1].ison = bigFooterViews[0].ison==true ? bigFooterViews[1].ison:false
        
        if bigFooterViews[1].ison==true
        {
            bigFooterViews[1].switchImage.image=UIImage(named: imgOn_0_5_4["\(tmpSpeed)"]!)
        }
        let airPurifier_MxChip = self.myCurrentDevice as! AirPurifier_MxChip
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        airPurifier_MxChip.status.setSpeed(tmpSpeed, callback: {
            (error:NSError!) in
            if error==nil
            {
                self.performSelector(#selector(self.StopLoadAnimal), withObject: nil, afterDelay: 3);
            }
            else
            {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        })
    }
    //初始化按钮状态
    func initBigClickButton()
    {
        
        if myCurrentDevice==nil
        {
            return
        }
        let tmpbigDevice=self.myCurrentDevice as! AirPurifier_MxChip
        
        bigFooterViews[0].ison = tmpbigDevice.status.power
        print(tmpbigDevice.status.power)
        if bigFooterViews[0].ison==false
        {
            print(IAW_TempView.PM25.font)
            IAW_TempView.PM25.text=loadLanguage("已关机")
            //IAW_TempView.PM25.font=UIFont(name: ".SFUIDisplay-Thin", size: 40)
            bigFooterViews[1].ison=false
            bigFooterViews[2].ison=false
            //bigFooterViews[3].ison=false
            //bigFooterViews[4].ison=false
            //bigFooterViews[5].ison=false
            //bigFooterViews[6].ison=false
            
            //return
        }else
        {
            IAW_TempView.PM25.text="\(tmpbigDevice.sensor.PM25)"
//            if #available(iOS 8.2, *) {
//                IAW_TempView.PM25.font=UIFont.systemFontOfSize(60, weight: 0.5)
//            } else {
//                IAW_TempView.PM25.font=UIFont.systemFontOfSize(50)
//                // Fallback on earlier versions
//            }
            if currentSpeedModel != tmpbigDevice.status.speed
            {
                currentSpeedModel=tmpbigDevice.status.speed
            }
            bigFooterViews[2].ison=tmpbigDevice.status.lock
        }
    }
    //七个开关单机事件
    func switchButtonClick(button:UIButton)
    {
        if self.myCurrentDevice==nil||AirPurifierManager.isMXChipAirPurifier(self.myCurrentDevice?.type) == false
        {
            return
        }
        
        let airPurifier_MxChip = self.myCurrentDevice as! AirPurifier_MxChip
        if bigFooterViews[0].ison==false && button.tag != 1
        {
            return
        }
        switch button.tag
        {
        case 1:
            //电源开关
            //bigFooterViews[0].ison = !bigFooterViews[0].ison
            print(!bigFooterViews[0].ison)
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            airPurifier_MxChip.status.setPower(!bigFooterViews[0].ison, callback: { (error:NSError!) -> Void in
//                if error==nil
//                {
               self.performSelector(#selector(self.StopLoadAnimal), withObject: nil, afterDelay: 2);
//                }
//                else
//                {
//                    MBProgressHUD.hideHUDForView(self.view, animated: true)
//                }
            })
            
            
            
            
            break
        case 2:
            //设置模式
            //0:0,5:1,4:2
            if airPurifier_MxChip.status.speed==5
            {
                tmpbigmodel.setWhitchIsBottom(1)
            }
            else if airPurifier_MxChip.status.speed==4
            {
                tmpbigmodel.setWhitchIsBottom(2)
            }
            else
            {
                tmpbigmodel.setWhitchIsBottom(0)
            }
            
            MainScrollView.addSubview(bigModelBgView)
            break
            //        case 3:
            //            //定时
            //            let setTimingController=setTimingViewController()
            //            setTimingController.myCurrentDevice=self.myCurrentDevice
            //            self.navigationController?.pushViewController(setTimingController, animated: true)
            //            break
        case 3:
            //童锁
            print(!bigFooterViews[2].ison)
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            airPurifier_MxChip.status.setLock(!bigFooterViews[2].ison, callback: {
                (error:NSError!) in
//                if error==nil
//                {
                
                    self.performSelector(#selector(self.StopLoadAnimal), withObject: nil, afterDelay: 2);
                    
//                }
//                else
//                {
//                    MBProgressHUD.hideHUDForView(self.view, animated: true)
//                }
            })
            //bigFooterViews[2].ison = !bigFooterViews[2].ison
            break
            
            //        case 5:
            //
            //            currentSpeedModel=3
            //            break
            //        case 6:
            //
            //            currentSpeedModel=2
            //            break
            //        case 7:
            //            currentSpeedModel=1
            //            break
        default:
            break
            
        }
        
    }
    func StopLoadAnimal()
    {
        MBProgressHUD.hideHUDForView(self.view, animated: false)
    }
    //风速模式选择函数
    func selectWhichModelbig(button:UIButton)
    {
        //0点击bottom ,1 left ，2 right
        switch button.tag
        {
        case 0:
            currentSpeedModel=0
            break
        case 1:
            currentSpeedModel=5
            break
        case 2:
            currentSpeedModel=4
            break
        default:
            break
        }
        bigModelBgView.removeFromSuperview()
        
    }
    
    
    //pm2.5国家污染分级标准
    func setAirStandart(pm25:Int)
    {
        /*
        一级：空气污染指数≤75优级
        二级：空气污染指数≤150良好
        三级：空气污染指数>150差
        */
        switch pm25
        {
        case 0..<75 :
            IAW_TempView.airText.text=loadLanguage("优")
            headView.bgColorIndex = 1
            break
        case 75..<150:
            IAW_TempView.airText.text=loadLanguage("良")
            headView.bgColorIndex = 2
            break
        case 150...100000000:
            IAW_TempView.airText.text=loadLanguage("差")
            headView.bgColorIndex = 3
            break
        default:
            IAW_TempView.airText.text=loadLanguage("优")
            headView.bgColorIndex = 1
            break
            
        }
        
    }
    //VOC Standart
    func VOCStantdart(voc:Int32)->String
    {
        var vocStr=""
        switch voc
        {
        case 0:
            vocStr=loadLanguage("优")
            break
        case 1:
            vocStr=loadLanguage("良")
            break
        case 2:
            vocStr=loadLanguage("一般")
            break
        case 3:
            vocStr=loadLanguage("差")
            break
        default:
            vocStr=loadLanguage("检测")
            break
            
        }
        return vocStr
    }
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
