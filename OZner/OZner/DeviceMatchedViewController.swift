//
//  DeviceMatchedViewController.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/2.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class DeviceMatchedViewController: SwiftFatherViewController,iCarouselDataSource,iCarouselDelegate,MatchFinishedViewDelegate,MatchTanTouFinisedViewDelegate,JinShuiqiWIFIControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,OznerManagerDelegate {

    var angle = 0.0
    var myIcarousel:iCarousel?
    var dataSourceArr:NSMutableArray?
    var mIndex = 0
    var finishedBgView:MatchFinishedView?
    //水探头
    var tanTouFinishedView:MatchTanTouFinishdView?
    
    var isShowFinishedView = false
    var deveiceDataList:NSArray?
    //20秒如果还没有配对成功提醒用户重现配对
    var mSecond = 30//设备容许最大配对时间：蓝牙30秒，WIFI设备90秒
    var mTimer:NSTimer?
    //0 水杯 1 水探头 2 净水器 3 air蓝牙 4 air wifi,5 补水仪
    var deviceCuttentType = 0
    
    @IBOutlet weak var circleImgView: UIImageView!
    @IBOutlet weak var circleBgVIew: UIView!
    @IBOutlet weak var circleIconImgView: UIImageView!
    @IBOutlet weak var circleBottomBgView: UIView!
    @IBOutlet weak var animationImgView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet var deviceBgView: UIView!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var leftRowImgView: UIImageView!
    @IBOutlet var rightRowImgView: UIImageView!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    
    var PeiduiFailed:peiDuiOutTimeCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        PeiduiFailed=NSBundle.mainBundle().loadNibNamed("peiDuiOutTimeCell", owner: self, options: nil).last as! peiDuiOutTimeCell
        PeiduiFailed.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight)
        PeiduiFailed.Back.addTarget(self, action: Selector("BackAfterPeiDuiFailed"), forControlEvents: .TouchUpInside)
        PeiduiFailed.ReSetPeiDuiButton.addTarget(self, action: Selector("RePeiDuiAfterPeiDuiFailed"), forControlEvents: .TouchUpInside)
        PeiduiFailed.isBlueToothDevice=true
        // Do any additional setup after loading the view.
        self.createTimer()
        let muArr:NSMutableArray = NSMutableArray()
        self.dataSourceArr = muArr
        
        self.layOUtView()
        self.createLeftAndRight()
        
        //初始化蓝牙管理
        OznerManager.instance().delegate = self
        //获取周围可配对的设备
        self.deveiceDataList = self.canMatchDevices()
    }
    
    func BackAfterPeiDuiFailed()
    {
        self.navigationController?.navigationBarHidden=false
        PeiduiFailed.removeFromSuperview()
        self.endTimer()
        self.angle = 0
        self.navigationController!.popViewControllerAnimated(true)
    }
    func RePeiDuiAfterPeiDuiFailed()
    {
        self.navigationController?.navigationBarHidden=false
        PeiduiFailed.removeFromSuperview()
        self.startAnimation()
        self.createTimer()
    }
    //拿到未配对的设备之后还得判断是否可配对
    func canMatchDevices()->NSArray
    {
        let arr = OznerManager.instance().getNotBindDevices() as NSArray
        let muArr = NSMutableArray()
        for var i = 0; i < arr.count;i++
        {
            let deviceIo = arr.objectAtIndex(i) as! BaseDeviceIO
            if OznerManager.instance().checkisBindMode(deviceIo) == true
            {
                if(deviceCuttentType == 0&&CupManager.isCup(deviceIo.type)) ||
                (deviceCuttentType == 1&&TapManager.isTap(deviceIo.type)) ||
                (deviceCuttentType == 2&&WaterPurifierManager.isWaterPurifier(deviceIo.type)) ||
                (deviceCuttentType == 3&&AirPurifierManager.isBluetoothAirPurifier(deviceIo.type)) ||
                (deviceCuttentType == 4&&AirPurifierManager.isMXChipAirPurifier(deviceIo.type)) ||
                (deviceCuttentType == 5&&WaterReplenishmentMeterMgr.isWaterReplenishmentMeter(deviceIo.type))
                {
                        muArr .addObject(deviceIo)
                }
            }
        }
        return muArr
    }
    
    func layOUtView()
    {
        let height = UIScreen.mainScreen().bounds.height
        let width = UIScreen.mainScreen().bounds.width
        self.circleBottomBgView.frame = CGRectMake((width-130*(width/375.0))/2, (122-64)*(height/667.0), 130*(width/375.0), 130*(width/375.0))
        self.circleBottomBgView.layer.masksToBounds = true;
        self.circleBottomBgView.layer.cornerRadius = self.circleBottomBgView.frame.size.width/2;
        self.circleBottomBgView.alpha = 0
        //circleBottomBgView.backgroundColor=UIColor.blackColor()
        let animationTransForm = CGAffineTransformScale(self.circleBgVIew.transform,0.1, 0.1);
        self.animationImgView.transform = animationTransForm;
        self.animationImgView.frame = CGRectMake((self.circleBottomBgView.frame.size.width-self.animationImgView.frame.size.width)/2, (self.circleBottomBgView.frame.size.height-self.animationImgView.frame.size.height)/2, self.animationImgView.frame.size.width, self.animationImgView.frame.size.height)
        //animationImgView.backgroundColor=UIColor.redColor()
        self.circleBgVIew.frame = CGRectMake((width-130*(width/375.0))/2, (122-64)*(height/667.0), 130*(width/375.0), 130*(width/375.0))
        
        let newTransForm = CGAffineTransformScale(self.circleBgVIew.transform,1.0, 1.0);
        self.circleBgVIew.transform = newTransForm;
        
        self.circleIconImgView.frame = CGRectMake((self.circleBottomBgView.frame.size.width-self.circleIconImgView.frame.size.width)/2, (self.circleBottomBgView.frame.size.height-self.circleIconImgView.frame.size.height)/2, self.circleIconImgView.frame.size.width, self.circleIconImgView.frame.size.height)
        
        self.firstLabel.frame = CGRectMake(0, self.circleBottomBgView.frame.size.height+self.circleBottomBgView.frame.origin.y+20, width, 20)
        self.secondLabel.frame = CGRectMake(0, self.firstLabel.frame.size.height+self.firstLabel.frame.origin.y+10, width, 20)
        
        self.deviceBgView.hidden = true
        

        let view = MatchFinishedView(frame: CGRectMake(0,height,width,height-407*(height/667.0)))
        self.finishedBgView = view
        self.finishedBgView?.delegate = self;
        self.view.addSubview(view)
        
        let view1 = MatchTanTouFinishdView(frame: CGRectMake(0,height,width,height-407*(height/667.0)))
        self.tanTouFinishedView = view1;
        self.tanTouFinishedView?.delegate = self;
        self.view.addSubview(view1)
        
        //
        finishedBgView?.hidden = true
        tanTouFinishedView?.hidden = false
        switch deviceCuttentType
        {
        case 0:
            self.firstLabel.text = loadLanguage("请将智能水杯倒置")
            self.circleIconImgView.image = UIImage(named: "icon_peidui_watting.png")
            animationImgView.image=UIImage(named: "yin_shui_liang_0.png")
            self.finishedBgView?.hidden = false
            self.tanTouFinishedView?.hidden = true
        case 1:
            self.firstLabel.text = loadLanguage("长按下start按钮")
            self.circleIconImgView.image = UIImage(named: "icon_peidui_tantou_watting.png")
            animationImgView.image=UIImage(named: "icon_peidui_complete_tan_tou.png")
            self.tanTouFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("输入水探头名称")
        case 2://如果是净水器弹出输入Wi-Fi密码的界面
            self.firstLabel.text = loadLanguage("请同时按下净水器加热与制冷两个按钮")
            self.secondLabel.text = loadLanguage("正在进行WIFI配对")
            self.firstLabel.font=UIFont.systemFontOfSize(15)
            self.circleIconImgView.image = UIImage(named: "icon_jingshuiqi_peidui_waitting.png")
            animationImgView.image=UIImage(named: "icon_peidui_complete_jingshuiqi.png")
            self.tanTouFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("输入净水器名称")
            let controller = JingShuiWifiViewController()
            controller.delegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        case 3:
            self.secondLabel.hidden=true
            self.firstLabel.text = loadLanguage("正在进行蓝牙配对")
            self.circleIconImgView.image = UIImage(named: "icon_smallair_peidui_waitting.png")
            animationImgView.image=UIImage(named: "icon_peidui_complete_smallair.png")
            
            self.tanTouFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("台式空净名称")
        case 4://如果是空气净化器，弹出输入Wi-Fi密码的界面
            self.secondLabel.hidden=false
            self.firstLabel.text = "同时按下电源和风速键，WIFI指示灯闪烁。"
            self.firstLabel.font=UIFont.systemFontOfSize(15)
            self.secondLabel.text=loadLanguage("正在进行WIFI配对")
            self.circleIconImgView.image = UIImage(named: "icon_bigair_peidui_waitting.png")
            animationImgView.image=UIImage(named: "icon_peidui_complete_bigair.png")
            self.tanTouFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("立式空净名称")
            let controller = JingShuiWifiViewController()
            controller.delegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        case 5:
            self.secondLabel.hidden=true
            self.firstLabel.text = loadLanguage("正在进行蓝牙配对")
            self.circleIconImgView.image = UIImage(named: "WaterReplenish3")
            animationImgView.image=UIImage(named: "WaterReplenish4")
            self.tanTouFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("补水仪名称")
        default: break
        }
        self.startAnimation()
    }
    //创建定时器
    func createTimer()
    {
        if(self.mTimer == nil)
        {
            self.mTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        }
        mSecond = 30//蓝牙设备容许最大配对时间
        if deviceCuttentType==2||deviceCuttentType==4
        {
            mSecond = 90//WIFI设备容许最大配对时间
        }
        
        
    }
    //结束定时器
    func endTimer()
    {
        self.mTimer?.invalidate()
        self.mTimer = nil
    }
    //配对时候，转圈的动画
    func startAnimation()
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.03)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStopSelector("endAnimation")
        let roleAngle = self.angle * (M_PI/180.0)
        self.circleImgView.transform = CGAffineTransformMakeRotation(CGFloat(roleAngle))
        UIView.commitAnimations()
    }
    
    func onTimer()
    {
        mSecond--
        if mSecond == 0
        {
            switch deviceCuttentType
            {
            case 0,1,3,5://蓝牙设备
                self.navigationController?.navigationBarHidden=true
                self.view.addSubview(PeiduiFailed)
                break
            case 2,4://Wifi设备
                self.endTimer()
                self.angle = 0
                break
            default:
                break
            }
        }
    }
    
    //JinShuiqiWIFIControllerDelegate
    func jinshuiqiConnectComplete(arr: [AnyObject]!)
    {
        self.deveiceDataList = arr as NSArray
        if(self.myIcarousel != nil)
        {
            self.myIcarousel!.reloadData()
        }
        
        if(self.deveiceDataList?.count == 1)
        {
            self.leftRowImgView.hidden = true;
            self.rightRowImgView.hidden = true;
            self.leftBtn.hidden = true;
            self.rightBtn.hidden = true;
        }
        else
        {
            self.leftRowImgView.hidden = false;
            self.rightRowImgView.hidden = false;
            self.leftBtn.hidden = false;
            self.rightBtn.hidden = false;
        }
    }
    
    func update()
    {
        if(self.deviceCuttentType != 2 && self.deviceCuttentType != 4)
        {
            let muArr = self.canMatchDevices()
            
            if(self.deveiceDataList?.count > 0)
            {
                let muArr1:NSMutableArray = NSMutableArray(array: self.deveiceDataList!)
                if(muArr.count > 0)
                {
                    for var index = 0; index < self.deveiceDataList?.count; ++index
                    {
                        let io = self.deveiceDataList?.objectAtIndex(index) as! BaseDeviceIO
                        var isEqual = false;
                        for var index = 0; index < muArr.count; ++index
                        {
                            let io1 = muArr.objectAtIndex(index) as! BaseDeviceIO
                            if(io == io1)
                            {
                                isEqual = true;
                                break;
                            }
                        }
                        if(isEqual == false)
                        {
                            muArr1 .addObject(io)
                        }
                    }
                }
                
                self.deveiceDataList = muArr1
            }
            else
            {
                let muArr1:NSMutableArray = NSMutableArray()
                if(muArr.count > 0)
                {
                    muArr1.addObjectsFromArray(muArr as [AnyObject])
                }
                self.deveiceDataList = muArr1
            }
            if self.deveiceDataList?.count > 0
            {
                if(self.myIcarousel != nil)
                {
                    self.myIcarousel!.reloadData()
                }
                
                if(self.deveiceDataList?.count == 1)
                {
                    self.leftRowImgView.hidden = true;
                    self.rightRowImgView.hidden = true;
                    self.leftBtn.hidden = true;
                    self.rightBtn.hidden = true;
                }
                else
                {
                    self.leftRowImgView.hidden = false;
                    self.rightRowImgView.hidden = false;
                    self.leftBtn.hidden = false;
                    self.rightBtn.hidden = false;
                }
            }

        }
    }
    
    func OznerManagerDidAddDevice(device: OznerDevice!) {
        self.update()
    }
    
    func OznerManagerDidFoundDevice(io: BaseDeviceIO!) {
        self.update()
    }
    
    func OznerManagerDidOwnerChanged(owner: String!) {
        self.update()
    }
    
    func OznerManagerDidRemoveDevice(device: OznerDevice!) {
        self.update()
    }
    
    func OznerManagerDidUpdateDevice(device: OznerDevice!) {
        self.update()
    }
    
    
    @IBAction func leftIcarouseBtnAction(sender: AnyObject){
        if(self.mIndex > 0)
        {
            self.myIcarousel!.scrollToItemAtIndex(self.mIndex-1, animated: true)
            self.mIndex = self.mIndex-1
        }
    }
    @IBAction func rightIcarouseBtnAction(sender: AnyObject) {
        if(self.mIndex < (self.deveiceDataList!.count-1))
        {
            self.myIcarousel!.scrollToItemAtIndex(self.mIndex+1, animated: true)
            self.mIndex = self.mIndex+1
        }
    }
    //搜索到设备
    func searchSuccessed()
    {
        UIView.beginAnimations("ImageViewBlg", context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStopSelector("transfromEndAnimation")
        let newTransForm = CGAffineTransformMakeScale(0.1, 0.1);
        self.circleBgVIew.transform = newTransForm
        self.circleBgVIew.alpha = 0;
        self.circleBottomBgView.alpha = 1.0
        UIView.commitAnimations()
    }
    //OznerManagerDelegate
    //MatchTanTouFinisedViewDelegate
//    func saveTanTou()
//    {
//        if((self.tanTouFinishedView?.myTanTouNameTextField?.text?.isEmpty) == true)
//        {
//            let alertControl = UIAlertController(title: loadLanguage("温馨提示"), message: loadLanguage("请填写探头名称"), preferredStyle: UIAlertControllerStyle.Alert)
//            let cancelAction = UIAlertAction(title: loadLanguage("确定"), style: UIAlertActionStyle.Destructive, handler: nil)
//            alertControl.addAction(cancelAction)
//            self.presentViewController(alertControl, animated: true, completion: nil)
//            
//            return
//        }
//        
//        let deviceIo = self.deveiceDataList?.objectAtIndex(self.mIndex) as! BaseDeviceIO
//        let device = OznerManager.instance().getDeviceByIO(deviceIo) as OznerDevice
//        
//        //添加到服务器
//        let werservice = DeviceWerbservice()
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        werservice.addDevice(device.identifier, name:self.finishedBgView?.myCupNameTextField?.text,deviceType: device.type,deviceAddress:loadLanguage("我的探头"),weight:self.finishedBgView?.myWeightTextField?.text ,returnBlock:{(status:StatusManager!) -> Void in
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
//            if(status.networkStatus == kSuccessStatus)
//            {
//                device.settings.name = self.tanTouFinishedView?.myTanTouNameTextField?.text
//                device.settings.put("type", value: loadLanguage("探头"))
//                OznerManager.instance().save(device)
//                
//                NSNotificationCenter.defaultCenter().postNotificationName("getDevices", object: nil)
//                
//                self.navigationController!.view .removeFromSuperview()
//            }
//            else
//            {
//                let str:NSString = status.errDesc
//                if(str.length > 0)
//                {
//                    UITool.showSampleMsg("错误", message: str as String)
//                }
//                else
//                {
//                    UITool.showSampleMsg("错误", message: loadLanguage("添加设备失败"))
//                }
//            }
//        })
//    }
    
//    func saveJingShuiqi()
//    {
//        if((self.tanTouFinishedView?.myTanTouNameTextField?.text?.isEmpty) == true)
//        {
//            let alertControl = UIAlertController(title: loadLanguage("温馨提示"), message: loadLanguage("请填写净水器名称"), preferredStyle: UIAlertControllerStyle.Alert)
//            let cancelAction = UIAlertAction(title: loadLanguage("确定"), style: UIAlertActionStyle.Destructive, handler: nil)
//            alertControl.addAction(cancelAction)
//            self.presentViewController(alertControl, animated: true, completion: nil)
//            
//            return
//        }
//        
//        let deviceIo = self.deveiceDataList?.objectAtIndex(self.mIndex) as! MXChipIO
//        let device = OznerManager.instance().getDeviceByIO(deviceIo) as OznerDevice
//        
//        //添加到服务器
//        let werservice = DeviceWerbservice()
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        werservice.addDevice(device.identifier, name:self.finishedBgView?.myCupNameTextField?.text,deviceType: device.type,deviceAddress:"我的净水器",weight:self.finishedBgView?.myWeightTextField?.text ,returnBlock:{(status:StatusManager!) -> Void in
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
//            if(status.networkStatus == kSuccessStatus)
//            {
//                device.settings.name = self.tanTouFinishedView?.myTanTouNameTextField?.text
//                device.settings.put("type", value: loadLanguage("净水器"))
//                OznerManager.instance().save(device)
//                
//                NSNotificationCenter.defaultCenter().postNotificationName("getDevices", object: nil)
//                
//                self.navigationController!.view .removeFromSuperview()
//            }
//            else
//            {
//                let str:NSString = status.errDesc
//                if(str.length > 0)
//                {
//                    UITool.showSampleMsg("错误", message: str as String)
//                }
//                else
//                {
//                    UITool.showSampleMsg("错误", message: "添加设备失败")
//                }
//            }
//        })
//
//    }
//    func saveSmallAir()
//    {
//        if((self.tanTouFinishedView?.myTanTouNameTextField?.text?.isEmpty) == true)
//        {
//            let alertControl = UIAlertController(title: loadLanguage("温馨提示"), message: loadLanguage("请填写台式空气净化器名称"), preferredStyle: UIAlertControllerStyle.Alert)
//            let cancelAction = UIAlertAction(title: loadLanguage("确定"), style: UIAlertActionStyle.Destructive, handler: nil)
//            alertControl.addAction(cancelAction)
//            self.presentViewController(alertControl, animated: true, completion: nil)
//            
//            return
//        }
//        
//        let deviceIo = self.deveiceDataList?.objectAtIndex(self.mIndex) as! BaseDeviceIO
//        let device = OznerManager.instance().getDeviceByIO(deviceIo) as OznerDevice
//        //添加到服务器
//        let werservice = DeviceWerbservice()
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        werservice.addDevice(device.identifier, name:self.finishedBgView?.myCupNameTextField?.text,deviceType: device.type,deviceAddress:"我的净水器",weight:self.finishedBgView?.myWeightTextField?.text ,returnBlock:{(status:StatusManager!) -> Void in
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
//            if(status.networkStatus == kSuccessStatus)
//            {
//                device.settings.name = self.tanTouFinishedView?.myTanTouNameTextField?.text
//                device.settings.put("type", value: loadLanguage("台式空气净化器"))
//                OznerManager.instance().save(device)
//                
//                NSNotificationCenter.defaultCenter().postNotificationName("getDevices", object: nil)
//                
//                self.navigationController!.view .removeFromSuperview()
//            }
//            else
//            {
//                let str:NSString = status.errDesc
//                if(str.length > 0)
//                {
//                    UITool.showSampleMsg("错误", message: str as String)
//                }
//                else
//                {
//                    UITool.showSampleMsg("错误", message: "添加设备失败")
//                }
//            }
//        })
//    }
//    func saveBigAir()
//    {
//        if((self.tanTouFinishedView?.myTanTouNameTextField?.text?.isEmpty) == true)
//        {
//            let alertControl = UIAlertController(title: loadLanguage("温馨提示"), message: loadLanguage("请填写立式空气净化器名称"), preferredStyle: UIAlertControllerStyle.Alert)
//            let cancelAction = UIAlertAction(title: loadLanguage("确定"), style: UIAlertActionStyle.Destructive, handler: nil)
//            alertControl.addAction(cancelAction)
//            self.presentViewController(alertControl, animated: true, completion: nil)
//            
//            return
//        }
//        
//        let deviceIo = self.deveiceDataList?.objectAtIndex(self.mIndex) as! MXChipIO
//        let device = OznerManager.instance().getDeviceByIO(deviceIo) as OznerDevice
//        //添加到服务器
//        let werservice = DeviceWerbservice()
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        werservice.addDevice(device.identifier, name:self.finishedBgView?.myCupNameTextField?.text,deviceType: device.type,deviceAddress:"我的立式空气净化器",weight:self.finishedBgView?.myWeightTextField?.text ,returnBlock:{(status:StatusManager!) -> Void in
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
//            if(status.networkStatus == kSuccessStatus)
//            {
//                device.settings.name = self.tanTouFinishedView?.myTanTouNameTextField?.text
//                device.settings.put("type", value: loadLanguage("立式空气净化器"))
//                OznerManager.instance().save(device)
//                
//                NSNotificationCenter.defaultCenter().postNotificationName("getDevices", object: nil)
//                
//                self.navigationController!.view .removeFromSuperview()
//            }
//            else
//            {
//                let str:NSString = status.errDesc
//                if(str.length > 0)
//                {
//                    UITool.showSampleMsg("错误", message: str as String)
//                }
//                else
//                {
//                    UITool.showSampleMsg("错误", message: "添加设备失败")
//                }
//            }
//        })
//    }
    //除了水杯的配对完成回掉事件
    func finishedTanTouAction() {
        saveDevice()
//        if(self.deviceCuttentType == 1)
//        {
//            self.saveTanTou()
//        }
//        else if(self.deviceCuttentType == 2)
//        {
//            self.saveJingShuiqi()
//        }
//        else if(self.deviceCuttentType == 3)
//        {
//            self.saveSmallAir()
//        }
//        else if(self.deviceCuttentType == 4)
//        {
//            self.saveBigAir()
//        }else if(deviceCuttentType == 5)
//        {
//            saveDevice()
//        }
    }
    var deviceNameArr=["智能水杯","水探头","净水机","台式空气净化器","立式空气净化器","智能补水仪"]
    func saveDevice()
    {
        if ((self.tanTouFinishedView?.myTanTouNameTextField?.text?.isEmpty) == true)
        {
            let alertControl = UIAlertController(title: loadLanguage("温馨提示"), message: "请填写设备名称", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: loadLanguage("确定"), style: UIAlertActionStyle.Destructive, handler: nil)
            alertControl.addAction(cancelAction)
            self.presentViewController(alertControl, animated: true, completion: nil)
            
            return
        }
        
        let deviceIo = self.deveiceDataList?.objectAtIndex(self.mIndex)
        let device = OznerManager.instance().getDeviceByIO(deviceIo! as! BaseDeviceIO) as OznerDevice
        //添加到服务器
        let werservice = DeviceWerbservice()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werservice.addDevice(device.identifier, name:self.finishedBgView?.myCupNameTextField?.text,deviceType: device.type,deviceAddress:"我的"+deviceNameArr[deviceCuttentType],weight:self.finishedBgView?.myWeightTextField?.text ,returnBlock:{(status:StatusManager!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if(status.networkStatus == kSuccessStatus)
            {
                device.settings.name = self.tanTouFinishedView?.myTanTouNameTextField?.text
                device.settings.put("type", value: self.deviceNameArr[self.deviceCuttentType])
                OznerManager.instance().save(device)
                
                NSNotificationCenter.defaultCenter().postNotificationName("getDevices", object: nil)
                
                self.navigationController!.view .removeFromSuperview()
            }
            else
            {
                let str:NSString = status.errDesc
                if(str.length > 0)
                {
                    UITool.showSampleMsg("错误", message: str as String)
                }
                else
                {
                    UITool.showSampleMsg("错误", message: "添加设备失败")
                }
            }
        })
    }
    //水杯配完对后的回掉事件
    func finishedAction() {
        if((self.finishedBgView?.myCupNameTextField?.text?.isEmpty) == true || (self.finishedBgView?.myWeightTextField?.text?.isEmpty) == true)
        {
            let alertControl = UIAlertController(title: loadLanguage("温馨提示"), message: loadLanguage("请填写智能杯名称或者体重"), preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: loadLanguage("确定"), style: UIAlertActionStyle.Destructive, handler: nil)
            alertControl.addAction(cancelAction)
            self.presentViewController(alertControl, animated: true, completion: nil)
            
            return
        }
        
        let deviceIo = self.deveiceDataList?.objectAtIndex(self.mIndex) as! BaseDeviceIO
        let device = OznerManager.instance().getDeviceByIO(deviceIo) as OznerDevice
        //添加到服务器
        let werservice = DeviceWerbservice() 
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werservice.addDevice(device.identifier, name:self.finishedBgView?.myCupNameTextField?.text,deviceType: device.type,deviceAddress:"我的杯子",weight:self.finishedBgView?.myWeightTextField?.text ,returnBlock:{(status:StatusManager!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if(status.networkStatus == kSuccessStatus)
            {
                device.settings.name = self.finishedBgView?.myCupNameTextField?.text
                device.settings.put("type", value: loadLanguage("我的杯子"))
                device.settings.put("weight", value: self.finishedBgView?.myWeightTextField?.text!)
                
                OznerManager.instance().save(device)
                
                NSNotificationCenter.defaultCenter().postNotificationName("getDevices", object: nil)
                
                self.navigationController!.view .removeFromSuperview()
            }
            else
            {
                let str:NSString = status.errDesc
                if(str.length > 0)
                {
                    UITool.showSampleMsg("错误", message: str as String)
                }
                else
                {
                    UITool.showSampleMsg("错误", message: "添加设备失败")
                }
            }
        })
        
    }
    
    func transfromEndAnimation()
    {
        UIView.beginAnimations("animationImageViewBlg", context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStopSelector("animationEndCreateIcarouseView")
        let newTransForm = CGAffineTransformMakeScale(1.0, 1.0);
        self.animationImgView.transform = newTransForm
        UIView.commitAnimations()
    }
    
    //结束
    func animationEndCreateIcarouseView()
    {
        self .createIcarouseView()
    }
    
    func endAnimation()
    {
        //搜索到设备停止转圈
        if self.deveiceDataList?.count > 0
        {
            self.endTimer()
            self.mSecond = 0;
            self.angle = 0
            self.searchSuccessed()
        }
        else
        {
            if self.mSecond != 0
            {
                self.angle += 15
                self.startAnimation()
            }
        }
    }
    
    func createLeftAndRight()
    {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: UIBarButtonItemStyle.Plain, target: self, action: "leftMethod")
        self.navigationItem.leftBarButtonItem = leftButton;
        self.navigationItem.title = loadLanguage("设备配对")
    }
    
    func leftMethod()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view .endEditing(true)
    }
    
    //创建icarouseview
    func createIcarouseView()
    {
        self.deviceBgView.hidden = false
        let width = UIScreen.mainScreen().bounds.width
        
        self.firstLabel.hidden = true
        self.secondLabel.hidden = true
        self.deviceBgView.frame = CGRectMake(0, (405-64)*(width/375.0), width, 137)
        self.thirdLabel.frame = CGRectMake(0, 0, width, 20)
        
        self.leftRowImgView.frame = CGRectMake(30*(width/375.0), 39+(98-21)/2, 11, 21)
        self.rightRowImgView.frame = CGRectMake(width-30*(width/375.0)-11, 39+(98-21)/2, 11, 21)
        
        self.leftBtn.frame = CGRectMake(0,  19+(98-21)/2, 40*(width/375.0), 61)
        self.rightBtn.frame = CGRectMake(width-40*(width/375.0), 19+(98-21)/2, 40*(width/375.0), 61)
        
        let icarousel = iCarousel.init(frame: CGRectMake(40*(width/375.0), self.thirdLabel.frame.size.height+self.thirdLabel.frame.origin.y+19, width-40*(width/375.0)*2, 98*(width/375.0)))
        icarousel.delegate=self;
        icarousel.dataSource=self;
        icarousel.type = iCarouselTypeCoverFlow;
        icarousel.backgroundColor=UIColor.clearColor();
        self.deviceBgView.addSubview(icarousel)
        icarousel.clipsToBounds = true;
        self.myIcarousel = icarousel;
        //暂时设置为1
        if(self.deveiceDataList?.count >= 2)
        {
            self.mIndex = 1
            icarousel.scrollToItemAtIndex(1, animated: true)
        }
        else
        {
            self.mIndex = 0
            icarousel.scrollToItemAtIndex(0, animated: true)
        }
        
    }
    
    //设置每个cellview
    func setDeviceMatchCellView(cellView:DeviceMatchCellView, index:UInt)
    {
        let row = Int(index)
        var imageName=""
        switch deviceCuttentType
        {
        case 0:
            imageName = mIndex == row ? "icon_peidui_select_cup.png":"icon_peidui_normal_cup.png"
            break
        case 1:
            imageName = mIndex == row ? "icon_peidui_select_tan_tou.png":"icon_peidui_normal_tan_tou.png"
            break
        case 2:
            imageName = mIndex == row ? "icon_peidui_select_jingshuiqi.png":"icon_peidui_normal_jingshuiqi.png"
            break
        case 3:
            imageName = mIndex == row ? "icon_peidui_select_smallair.png":"icon_peidui_normal_smallair.png"
            break
        case 4:
            imageName = mIndex == row ? "icon_peidui_select_bigair.png":"icon_peidui_normal_bigair.png"
            break
        case 5:
            imageName = mIndex == row ? "WaterReplenish4":"WaterReplenish5"
            break
        default:
            break
        }
        cellView.iconImgView?.image = UIImage(named: imageName)
        
    }
    

    func numberOfItemsInCarousel(carousel: iCarousel!) -> UInt {
        
        //return UInt(self.dataSourceArr!.count);
        return UInt((self.deveiceDataList?.count)!)
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: UInt, reusingView view: UIView!) -> UIView! {
        
        if(view == nil)
        {
            let width = UIScreen.mainScreen().bounds.width
            let wCellView = DeviceMatchCellView.init(frame: CGRectMake(0, 0, 98*(width/375.0), 98*(width/375.0)))
            switch deviceCuttentType
            {
            case 0:
                wCellView.iconImgView?.image = UIImage(named: "icon_peidui_select_cup.png")
                wCellView.titleLabel?.text = loadLanguage("智能水杯")
            case 1:
                wCellView.iconImgView?.image = UIImage(named: "icon_peidui_select_tan_tou.png")
                wCellView.titleLabel?.text = loadLanguage("水探头")
            case 2:
                wCellView.iconImgView?.image = UIImage(named: "icon_peidui_select_jingshuiqi.png")
                wCellView.titleLabel?.text = loadLanguage("净水器")
            case 3:
                wCellView.iconImgView?.image = UIImage(named: "icon_peidui_select_smallAir.png")
                wCellView.titleLabel?.text = loadLanguage("台式空净")
            case 4:
                wCellView.iconImgView?.image = UIImage(named: "icon_peidui_select_bigAir.png")
                wCellView.titleLabel?.text = loadLanguage("立式空净")
            case 5:
                wCellView.iconImgView?.image = UIImage(named: "WaterReplenish4")
                wCellView.titleLabel?.text = "补水仪"
            default:
                break
            }
            self .setDeviceMatchCellView(wCellView, index: index)
            return wCellView
        }

        let wCellView = view as! DeviceMatchCellView
        self .setDeviceMatchCellView(wCellView, index: index)
        return wCellView
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel!) {
        self.mIndex = carousel.currentItemIndex
        for var i = 0;i < self.deveiceDataList?.count;i++
        {
            if carousel==nil
            {
                continue
            }
            let cellView = carousel.itemViewAtIndex(i) as! DeviceMatchCellView
            var imageName=""
            switch deviceCuttentType
            {
            case 0:
                imageName = mIndex == i ? "icon_peidui_select_cup.png":"icon_peidui_normal_cup.png"
                break
            case 1:
                imageName = mIndex == i ? "icon_peidui_select_tan_tou.png":"icon_peidui_normal_tan_tou.png"
                break
            case 2:
                imageName = mIndex == i ? "icon_peidui_select_jingshuiqi.png":"icon_peidui_normal_jingshuiqi.png"
                break
            case 3:
                imageName = mIndex == i ? "icon_peidui_select_smallair.png":"icon_peidui_normal_smallair.png"
                break
            case 4:
                imageName = mIndex == i ? "icon_peidui_select_bigair.png":"icon_peidui_normal_bigair.png"
                break
            case 5:
                imageName = mIndex == i ? "WaterReplenish4":"WaterReplenish5"
                break
            default:
                break
            }
            cellView.iconImgView?.image = UIImage(named: imageName)
            
        }
        if self.isShowFinishedView == false
        {
            self.isShowFinishedView = true;
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                
                if(self.deviceCuttentType == 0)//水杯
                {
                    self.deviceBgView.frame = CGRectMake(0, self.view.frame.size.height-self.finishedBgView!.frame.size.height-self.deviceBgView.frame.size.height, self.deviceBgView.frame.size.width, self.deviceBgView.frame.size.height)
                    self.finishedBgView?.frame = CGRectMake(0, self.view.frame.size.height-self.finishedBgView!.frame.size.height, self.finishedBgView!.frame.size.width, self.finishedBgView!.frame.size.height)
                }
                else
                {
                    self.deviceBgView.frame = CGRectMake(0, self.view.frame.size.height-self.tanTouFinishedView!.frame.size.height-self.deviceBgView.frame.size.height, self.deviceBgView.frame.size.width, self.deviceBgView.frame.size.height)
                    self.tanTouFinishedView?.frame = CGRectMake(0, self.view.frame.size.height-self.tanTouFinishedView!.frame.size.height, self.tanTouFinishedView!.frame.size.width, self.tanTouFinishedView!.frame.size.height)
                }
                
            
                let width = UIScreen.mainScreen().bounds.width
                self.circleBottomBgView.frame = CGRectMake((width-130*(width/375.0))/2, self.deviceBgView.frame.origin.y - 15 * (UIScreen.mainScreen().bounds.height/667.0)-130*(width/375.0), 130*(width/375.0), 130*(width/375.0))
                
            })
        }
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option
        {
        case iCarouselOptionWrap:
            return 0
        case iCarouselOptionFadeMax:
            if carousel.type == iCarouselTypeCustom
            {
                return 0.0
            }
            
            return value
            
        case iCarouselOptionTilt:
            return 0.0;
        case iCarouselOptionSpacing:
            return 1.15;
        default:
            return value;
        }
    }
    
    func carouselDidScroll(carousel: iCarousel!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
