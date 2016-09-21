//
//  DeviceMatchedViewController.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/2.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class DeviceMatchedViewController_EN: SwiftFatherViewController,iCarouselDataSource,iCarouselDelegate,CupMatchFinishedView_ENDelegate,OtherMatchFinishdView_ENDelegate,JinShuiqiWIFIController_ENDelegate,UIAlertViewDelegate,UITextFieldDelegate,OznerManagerDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience  init() {
        
        var nibNameOrNil = String?("DeviceMatchedViewController_EN")
        
        //考虑到xib文件可能不存在或被删，故加入判断
        
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "xib") == nil
            
        {
            
            nibNameOrNil = nil
            
        }
        
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var angle = 0.0
    var myIcarousel:iCarousel?
    var dataSourceArr:NSMutableArray?
    var mIndex = 0
    var cupFinishedBgView:CupMatchFinishedView_EN?
    //水探头
    var otherDeviceFinishedView:OtherMatchFinishdView_EN?
    
    var isShowFinishedView = false
    var deveiceDataList:NSArray?
    //30秒如果还没有配对成功提醒用户重现配对
    var mSecond = 30//设备容许最大配对时间：蓝牙30秒，WIFI设备90秒
    var mTimer:Timer?
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
    
    var PeiduiFailed:peiDuiOutTimeCell_EN!
    override func viewDidLoad() {
        super.viewDidLoad()
        PeiduiFailed=Bundle.main.loadNibNamed("peiDuiOutTimeCell_EN", owner: self, options: nil)?.last as! peiDuiOutTimeCell_EN
        PeiduiFailed.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight)
        PeiduiFailed.Back.addTarget(self, action: #selector(BackAfterPeiDuiFailed), for: .touchUpInside)
        PeiduiFailed.ReSetPeiDuiButton.addTarget(self, action: #selector(RePeiDuiAfterPeiDuiFailed), for: .touchUpInside)
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
        print(deveiceDataList)
    }
    
    func BackAfterPeiDuiFailed()
    {
        self.navigationController?.isNavigationBarHidden=false
        PeiduiFailed.removeFromSuperview()
        self.endTimer()
        self.angle = 0
        self.navigationController!.popViewController(animated: true)
    }
    func RePeiDuiAfterPeiDuiFailed()
    {
        self.navigationController?.isNavigationBarHidden=false
        PeiduiFailed.removeFromSuperview()
        self.startAnimation()
        self.createTimer()
    }
    //拿到未配对的设备之后还得判断是否可配对
    func canMatchDevices()->NSArray
    {
        let arr = OznerManager.instance().getNotBindDevices() as NSArray
        let muArr = NSMutableArray()
        for i in 0 ..< arr.count
        {
            let deviceIo = arr.object(at: i) as! BaseDeviceIO
            if OznerManager.instance().checkisBindMode(deviceIo) == true
            {
                if(deviceCuttentType == 0&&CupManager.isCup(deviceIo.type)) ||
                (deviceCuttentType == 1&&TapManager.isTap(deviceIo.type)) ||
                (deviceCuttentType == 2&&WaterPurifierManager.isWaterPurifier(deviceIo.type)) ||
                (deviceCuttentType == 3&&AirPurifierManager.isBluetoothAirPurifier(deviceIo.type)) ||
                (deviceCuttentType == 4&&AirPurifierManager.isMXChipAirPurifier(deviceIo.type)) ||
                    (deviceCuttentType == 5&&TapManager.isTap(deviceIo.type)) ||
                (deviceCuttentType == 6&&WaterReplenishmentMeterMgr.isWaterReplenishmentMeter(deviceIo.type))
                {
                        muArr .add(deviceIo)
                }
            }
        }
        return muArr
    }
    
    func layOUtView()
    {
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        self.circleBottomBgView.frame = CGRect(x: (width-130*(width/375.0))/2, y: (122-64)*(height/667.0), width: 130*(width/375.0), height: 130*(width/375.0))
        self.circleBottomBgView.layer.masksToBounds = true;
        self.circleBottomBgView.layer.cornerRadius = self.circleBottomBgView.frame.size.width/2;
        self.circleBottomBgView.alpha = 0
        //circleBottomBgView.backgroundColor=UIColor.blackColor()
        let animationTransForm = self.circleBgVIew.transform.scaledBy(x: 0.1, y: 0.1);
        self.animationImgView.transform = animationTransForm;
        let kSize = self.animationImgView.frame.size.width/self.animationImgView.frame.size.height
        
        self.animationImgView.frame = CGRect(x: (self.circleBottomBgView.frame.size.width-self.animationImgView.frame.size.width)/2-1*kSize, y: (self.circleBottomBgView.frame.size.height-self.animationImgView.frame.size.height)/2-1, width: self.animationImgView.frame.size.width+2*kSize, height: self.animationImgView.frame.size.height+2)
        //animationImgView.backgroundColor=UIColor.redColor()
        self.circleBgVIew.frame = CGRect(x: (width-130*(width/375.0))/2, y: (122-64)*(height/667.0), width: 130*(width/375.0), height: 130*(width/375.0))
        
        let newTransForm = self.circleBgVIew.transform.scaledBy(x: 1.0, y: 1.0);
        self.circleBgVIew.transform = newTransForm;
        
        self.circleIconImgView.frame = CGRect(x: (self.circleBottomBgView.frame.size.width-self.circleIconImgView.frame.size.width)/2, y: (self.circleBottomBgView.frame.size.height-self.circleIconImgView.frame.size.height)/2, width: self.circleIconImgView.frame.size.width, height: self.circleIconImgView.frame.size.height)
        
        self.firstLabel.frame = CGRect(x: 0, y: self.circleBottomBgView.frame.size.height+self.circleBottomBgView.frame.origin.y+20, width: width, height: 60)
        self.firstLabel.numberOfLines = 0
        self.secondLabel.frame = CGRect(x: 0, y: self.firstLabel.frame.size.height+self.firstLabel.frame.origin.y+10, width: width, height: 20)
        
        self.deviceBgView.isHidden = true
        

        let view = CupMatchFinishedView_EN(frame: CGRect(x: 0,y: height,width: width,height: height-407*(height/667.0)))
        self.cupFinishedBgView = view
        self.cupFinishedBgView?.delegate = self;
        self.view.addSubview(view)
        
        let view1 = OtherMatchFinishdView_EN()
        view1.initView(CGRect(x: 0,y: height,width: width,height: height-407*(height/667.0)), deviceType: deviceCuttentType)
        self.otherDeviceFinishedView = view1
        self.otherDeviceFinishedView?.delegate = self
        self.view.addSubview(view1)
        
        //
        cupFinishedBgView?.isHidden = true
        otherDeviceFinishedView?.isHidden = false
        switch deviceCuttentType
        {
        case 0:
            self.firstLabel.text = loadLanguage("请将智能水杯倒置")
            self.circleIconImgView.image = UIImage(named: "icon_peidui_watting.png")
            animationImgView.image=UIImage(named: "yin_shui_liang_0.png")
            self.cupFinishedBgView?.isHidden = false
            self.otherDeviceFinishedView?.isHidden = true
        case 1:
            self.firstLabel.text = loadLanguage("长按下start按钮")
            self.circleIconImgView.image = UIImage(named: "icon_peidui_tantou_watting.png")
            animationImgView.image=UIImage(named: "icon_peidui_complete_tan_tou.png")
            self.otherDeviceFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("输入水探头名称")
        case 2://如果是净水器弹出输入Wi-Fi密码的界面
            self.firstLabel.text = loadLanguage("请同时按下净水器加热与制冷两个按钮")
            self.secondLabel.text = loadLanguage("正在进行WIFI配对")
            self.firstLabel.font=UIFont.systemFont(ofSize: 15)
            self.circleIconImgView.image = UIImage(named: "icon_jingshuiqi_peidui_waitting.png")
            animationImgView.image=UIImage(named: "icon_peidui_complete_jingshuiqi.png")
            self.otherDeviceFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("输入净水器名称")
            let controller = JingShuiWifiViewController_EN(nibName: "JingShuiWifiViewController_EN", bundle: nil)
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        case 3:
            self.secondLabel.isHidden=true
            self.firstLabel.text = loadLanguage("正在进行蓝牙配对")
            self.circleIconImgView.image = UIImage(named: "icon_smallair_peidui_waitting.png")
            animationImgView.image=UIImage(named: "icon_peidui_complete_smallair.png")
            
            self.otherDeviceFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("台式空净名称")
        case 4://如果是空气净化器，弹出输入Wi-Fi密码的界面
            self.secondLabel.isHidden=false
            self.firstLabel.text = loadLanguage("同时按下电源和风速键，WIFI指示灯闪烁。")
            self.firstLabel.font=UIFont.systemFont(ofSize: 15)
            self.secondLabel.text=loadLanguage("正在进行WIFI配对")
            self.circleIconImgView.image = UIImage(named: "icon_bigair_peidui_waitting.png")
            animationImgView.image=UIImage(named: "icon_peidui_complete_bigair.png")
            self.otherDeviceFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("立式空净名称")
            let controller = JingShuiWifiViewController_EN(nibName: "JingShuiWifiViewController_EN", bundle: nil)
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        case 5:
            self.firstLabel.text = loadLanguage("长按下start按钮")
            self.circleIconImgView.image = UIImage(named: "icon_peidui_TDSPAN_watting.png")
            animationImgView.image=UIImage(named: "icon_peidui_complete_TDSPAN.png")
            self.otherDeviceFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("输入检测笔名称")
        case 6:
            self.secondLabel.isHidden=true
            self.firstLabel.text = loadLanguage("正在进行蓝牙配对")
            self.circleIconImgView.image = UIImage(named: "WaterReplenish3")
            animationImgView.image=UIImage(named: "WaterReplenishComplete")
            self.otherDeviceFinishedView?.myTanTouNameTextField?.placeholder = loadLanguage("补水仪名称")
        default:
            break
        }
        self.startAnimation()
    }
    //创建定时器
    func createTimer()
    {
        if(self.mTimer == nil)
        {
            self.mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
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
        UIView.setAnimationDidStop(#selector(endAnimation))
        let roleAngle = self.angle * (M_PI/180.0)
        self.circleImgView.transform = CGAffineTransform(rotationAngle: CGFloat(roleAngle))
        UIView.commitAnimations()
    }
    
    func onTimer()
    {
        mSecond -= 1
        if mSecond == 0
        {
            switch deviceCuttentType
            {
            case 0,1,3,5://蓝牙设备
                self.navigationController?.isNavigationBarHidden=true
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
    private func jinshuiqiConnectComplete(_ arr: [AnyObject]!)
    {
        self.deveiceDataList = arr as NSArray
        if(self.myIcarousel != nil)
        {
            self.myIcarousel!.reloadData()
        }
        
        if(self.deveiceDataList?.count == 1)
        {
            self.leftRowImgView.isHidden = true;
            self.rightRowImgView.isHidden = true;
            self.leftBtn.isHidden = true;
            self.rightBtn.isHidden = true;
        }
        else
        {
            self.leftRowImgView.isHidden = false;
            self.rightRowImgView.isHidden = false;
            self.leftBtn.isHidden = false;
            self.rightBtn.isHidden = false;
        }
    }
    
    func update()
    {
        if deveiceDataList?.count>0
        {
            return
        }
        
        if(self.deviceCuttentType != 2 && self.deviceCuttentType != 4)
        {
            let muArr = self.canMatchDevices()
            
            if(self.deveiceDataList?.count > 0)
            {
                let muArr1:NSMutableArray = NSMutableArray(array: self.deveiceDataList!)
                if(muArr.count > 0 && deveiceDataList?.count > 0)
                {
                    for  tmpio  in  deveiceDataList!
                    {
                        let io = tmpio as! BaseDeviceIO
                        var isEqual = false
                        for tmpio1 in  muArr
                        {
                            let io1 = tmpio1 as! BaseDeviceIO
                            if(io.identifier == io1.identifier)
                            {
                                isEqual = true;
                                break;
                            }
                        }
                        if(isEqual == false)
                        {
                            muArr1 .add(io)
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
                    muArr1.addObjects(from: muArr as [AnyObject])
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
                    self.leftRowImgView.isHidden = true;
                    self.rightRowImgView.isHidden = true;
                    self.leftBtn.isHidden = true;
                    self.rightBtn.isHidden = true;
                }
                else
                {
                    self.leftRowImgView.isHidden = false;
                    self.rightRowImgView.isHidden = false;
                    self.leftBtn.isHidden = false;
                    self.rightBtn.isHidden = false;
                }
            }
            
        }
        
    }
    
    func oznerManagerDidAdd(_ device: OznerDevice!) {
        self.update()
    }
    
    func oznerManagerDidFoundDevice(_ io: BaseDeviceIO!) {
        self.update()
    }
    
    func oznerManagerDidOwnerChanged(_ owner: String!) {
        self.update()
    }
    
    func oznerManagerDidRemove(_ device: OznerDevice!) {
        self.update()
    }
    
    func oznerManagerDidUpdate(_ device: OznerDevice!) {
        self.update()
    }
    
    
    @IBAction func leftIcarouseBtnAction(_ sender: AnyObject){
        if(self.mIndex > 0)
        {
            self.myIcarousel!.scrollToItem(at: self.mIndex-1, animated: true)
            self.mIndex = self.mIndex-1
        }
    }
    @IBAction func rightIcarouseBtnAction(_ sender: AnyObject) {
        if(self.mIndex < (self.deveiceDataList!.count-1))
        {
            self.myIcarousel!.scrollToItem(at: self.mIndex+1, animated: true)
            self.mIndex = self.mIndex+1
        }
    }
    //搜索到设备
    func searchSuccessed()
    {
        UIView.beginAnimations("ImageViewBlg", context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(transfromEndAnimation))
        let newTransForm = CGAffineTransform(scaleX: 0.1, y: 0.1);
        self.circleBgVIew.transform = newTransForm
        self.circleBgVIew.alpha = 0;
        self.circleBottomBgView.alpha = 1.0
        UIView.commitAnimations()
    }

    //除了水杯的配对完成回掉事件
    var deviceNameArr=["智能水杯","水探头","净水机","台式空气净化器","立式空气净化器","水质检测笔","智能补水仪"]
    func otherFinishedAction()
    {
        if ((self.otherDeviceFinishedView?.myTanTouNameTextField?.text?.isEmpty) == true)
        {
            let alertControl = UIAlertController(title: loadLanguage("温馨提示"), message: loadLanguage("请填写设备名称"), preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: loadLanguage("确定"), style: UIAlertActionStyle.destructive, handler: nil)
            alertControl.addAction(cancelAction)
            self.present(alertControl, animated: true, completion: nil)
            
            return
        }
        
        let deviceIo = self.deveiceDataList?.object(at: self.mIndex) as! BaseDeviceIO
        let device = OznerManager.instance().getDeviceBy(deviceIo) as OznerDevice
        //添加到服务器
        //let strongSelf = self
        
        //let werservice = DeviceWerbservice()
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        //werservice.addDevice(device.identifier, name:otherDeviceFinishedView?.myTanTouNameTextField!.text!,deviceType: device.type,deviceAddress:"我的"+deviceNameArr[deviceCuttentType],weight:self.otherDeviceFinishedView?.myWeightTextField?.text ,return:{(status) -> Void in
            //MBProgressHUD.hide(for: self.view, animated: true)
            //if(status?.networkStatus == kSuccessStatus)
            //{
                device.settings.name = self.otherDeviceFinishedView?.myTanTouNameTextField?.text
                device.settings.put("type", value: self.deviceNameArr[self.deviceCuttentType])
                //智能笔和水探头区分
                print(self.deviceCuttentType)
                
                switch self.deviceCuttentType
                {
                case 1,5://智能笔或水探头
                    device.settings.put("istap", value: self.deviceCuttentType==1 ? 1:0)
                case 6://补水仪
                    device.settings.put("sex", value: self.otherDeviceFinishedView?.segmentControl?.selectedSegmentIndex==0 ? "女":"男")
                default:
                    break
                }
                OznerManager.instance().save(device)
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getDevices"), object: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "currentSelectedDevice"), object:device)
                self.navigationController!.view .removeFromSuperview()
            //}
            //else
//            {
//                let str:NSString = status!.errDesc as NSString
//                if(str.length > 0)
//                {
//                    UITool.showSampleMsg(loadLanguage("错误"), message: str as String)
//                }
//                else
//                {
//                    UITool.showSampleMsg(loadLanguage("错误"), message: loadLanguage("添加设备失败"))
//                }
//            }
//        })
    }
    //水杯配完对后的回掉事件
    func cupFinishedAction() {
        if((self.cupFinishedBgView?.myCupNameTextField?.text?.isEmpty) == true || (self.cupFinishedBgView?.myWeightTextField?.text?.isEmpty) == true)
        {
            let alertControl = UIAlertController(title: loadLanguage("温馨提示"), message: loadLanguage("请填写智能杯名称或者体重"), preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: loadLanguage("确定"), style: UIAlertActionStyle.destructive, handler: nil)
            alertControl.addAction(cancelAction)
            self.present(alertControl, animated: true, completion: nil)
            
            return
        }
        
        let deviceIo = self.deveiceDataList?.object(at: self.mIndex) as! BaseDeviceIO
        let device = OznerManager.instance().getDeviceBy(deviceIo) as OznerDevice
        //添加到服务器
        let werservice = DeviceWerbservice()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        werservice.addDevice(device.identifier, name:self.cupFinishedBgView?.myCupNameTextField?.text,deviceType: device.type,deviceAddress:"我的杯子",weight:self.cupFinishedBgView?.myWeightTextField?.text ,return:{(status) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(status?.networkStatus == kSuccessStatus)
            {
                device.settings.name = self.cupFinishedBgView?.myCupNameTextField?.text
                device.settings.put("type", value: "我的杯子")
                device.settings.put("weight", value: self.cupFinishedBgView?.myWeightTextField?.text!)
                
                OznerManager.instance().save(device)
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getDevices"), object: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "currentSelectedDevice"), object:device)
                self.navigationController!.view .removeFromSuperview()
            }
            else
            {
                let str:NSString = status!.errDesc as NSString
                if(str.length > 0)
                {
                    UITool.showSampleMsg(loadLanguage("错误"), message: str as String)
                }
                else
                {
                    UITool.showSampleMsg(loadLanguage("错误"), message: loadLanguage("添加设备失败"))
                }
            }
        })
        
    }
    
    func transfromEndAnimation()
    {
        UIView.beginAnimations("animationImageViewBlg", context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(animationEndCreateIcarouseView))
        let newTransForm = CGAffineTransform(scaleX: 1.0, y: 1.0);
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
                self.angle -= 15
                self.startAnimation()
            }
        }
    }
    
    func createLeftAndRight()
    {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftMethod))
        self.navigationItem.leftBarButtonItem = leftButton;
        self.navigationItem.title = loadLanguage("设备配对")
    }
    
    func leftMethod()
    {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view .endEditing(true)
    }
    
    //创建icarouseview
    func createIcarouseView()
    {
        self.deviceBgView.isHidden = false
        let width = UIScreen.main.bounds.width
        
        self.firstLabel.isHidden = true
        self.secondLabel.isHidden = true
        self.deviceBgView.frame = CGRect(x: 0, y: (405-64)*(width/375.0), width: width, height: 137)
        self.thirdLabel.frame = CGRect(x: 0, y: 0, width: width, height: 20)
        
        self.leftRowImgView.frame = CGRect(x: 30*(width/375.0), y: 39+(98-21)/2, width: 11, height: 21)
        self.rightRowImgView.frame = CGRect(x: width-30*(width/375.0)-11, y: 39+(98-21)/2, width: 11, height: 21)
        
        self.leftBtn.frame = CGRect(x: 0,  y: 19+(98-21)/2, width: 40*(width/375.0), height: 61)
        self.rightBtn.frame = CGRect(x: width-40*(width/375.0), y: 19+(98-21)/2, width: 40*(width/375.0), height: 61)
        
        let icarousel = iCarousel.init(frame: CGRect(x: 40*(width/375.0), y: self.thirdLabel.frame.size.height+self.thirdLabel.frame.origin.y+19, width: width-40*(width/375.0)*2, height: 98*(width/375.0)))
        icarousel.delegate=self;
        icarousel.dataSource=self;
        icarousel.type = iCarouselTypeCoverFlow;
        icarousel.backgroundColor=UIColor.clear;
        self.deviceBgView.addSubview(icarousel)
        icarousel.clipsToBounds = true;
        self.myIcarousel = icarousel;
        //暂时设置为1
        if(self.deveiceDataList?.count >= 2)
        {
            self.mIndex = 1
            icarousel.scrollToItem(at: 1, animated: true)
        }
        else
        {
            self.mIndex = 0
            icarousel.scrollToItem(at: 0, animated: true)
        }
        
    }
    
    //设置每个cellview
    func setDeviceMatchCellView(_ cellView:DeviceMatchCellView_EN, index:UInt)
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
            imageName = mIndex == row ? "icon_peidui_select_TDSPan.png":"icon_peidui_select_TDSPan.png"
        case 6:
            imageName = mIndex == row ? "WaterReplenish4":"WaterReplenish5"
            break
        default:
            break
        }
        cellView.iconImgView?.image = UIImage(named: imageName)
        
    }
    

    func numberOfItems(in carousel: iCarousel!) -> UInt {
        
        //return UInt(self.dataSourceArr!.count);
        return UInt((self.deveiceDataList?.count)!)
    }
    
    func carousel(_ carousel: iCarousel!, viewForItemAt index: UInt, reusing view: UIView!) -> UIView! {
        
        if(view == nil)
        {
            let width = UIScreen.main.bounds.width
            //98*(width/375.0)
            let wCellView = DeviceMatchCellView_EN.init(frame: CGRect(x: 0, y: 0, width: width, height: 98*(width/375.0)))
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
                wCellView.iconImgView?.image = UIImage(named: "icon_peidui_select_TDSPan.png")
                wCellView.titleLabel?.text = loadLanguage("水质检测笔")
            case 6:
                wCellView.iconImgView?.image = UIImage(named: "WaterReplenish4")
                wCellView.titleLabel?.text = loadLanguage("补水仪")
            default:
                break
            }
            self .setDeviceMatchCellView(wCellView, index: index)
            return wCellView
        }

        let wCellView = view as! DeviceMatchCellView_EN
        self .setDeviceMatchCellView(wCellView, index: index)
        return wCellView
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel!) {
        self.mIndex = carousel.currentItemIndex

        for  i in 0..<(self.deveiceDataList?.count ?? 0)
        {
            if carousel==nil
            {
                continue
            }
            
            if let cellView1 = carousel.itemView(at: i) {
                let cellView = cellView1 as! DeviceMatchCellView_EN
                var imageName=""
                switch deviceCuttentType
                {
                case 0:
                    imageName = mIndex == i ? "icon_peidui_select_cup.png":"icon_peidui_normal_cup.png"
                    
                case 1:
                    imageName = mIndex == i ? "icon_peidui_select_tan_tou.png":"icon_peidui_normal_tan_tou.png"
                    
                case 2:
                    imageName = mIndex == i ? "icon_peidui_select_jingshuiqi.png":"icon_peidui_normal_jingshuiqi.png"
                    
                case 3:
                    imageName = mIndex == i ? "icon_peidui_select_smallair.png":"icon_peidui_normal_smallair.png"
                    
                case 4:
                    imageName = mIndex == i ? "icon_peidui_select_bigair.png":"icon_peidui_normal_bigair.png"
                    
                case 5:
                    imageName = mIndex == i ? "icon_peidui_select_TDSPan.png":"icon_peidui_select_TDSPan.png"
                case 6:
                    imageName = mIndex == i ? "WaterReplenish4":"WaterReplenish5"
                    
                default:
                    break
                }
                cellView.iconImgView?.image = UIImage(named: imageName)
            }
            
            
            
        }
        if self.isShowFinishedView == false
        {
            self.isShowFinishedView = true;
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                
                if(self.deviceCuttentType == 0)//水杯
                {
                    self.deviceBgView.frame = CGRect(x: 0, y: self.view.frame.size.height-self.cupFinishedBgView!.frame.size.height-self.deviceBgView.frame.size.height, width: self.deviceBgView.frame.size.width, height: self.deviceBgView.frame.size.height)
                    self.cupFinishedBgView?.frame = CGRect(x: 0, y: self.view.frame.size.height-self.cupFinishedBgView!.frame.size.height, width: self.cupFinishedBgView!.frame.size.width, height: self.cupFinishedBgView!.frame.size.height)
                }
                else
                {
                    self.deviceBgView.frame = CGRect(x: 0, y: self.view.frame.size.height-self.otherDeviceFinishedView!.frame.size.height-self.deviceBgView.frame.size.height, width: self.deviceBgView.frame.size.width, height: self.deviceBgView.frame.size.height)
                    self.otherDeviceFinishedView?.frame = CGRect(x: 0, y: self.view.frame.size.height-self.otherDeviceFinishedView!.frame.size.height, width: self.otherDeviceFinishedView!.frame.size.width, height: self.otherDeviceFinishedView!.frame.size.height)
                }
                
            
                let width = UIScreen.main.bounds.width
                let orginy = self.deviceBgView.frame.origin.y - 15 * (UIScreen.main.bounds.height/667.0)-130*(width/375.0)
                self.circleBottomBgView.frame = CGRect(x: (width-130*(width/375.0))/2, y: orginy, width: 130*(width/375.0), height: 130*(width/375.0))
                
            })
        }
    }
    
    func carousel(_ carousel: iCarousel!, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
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
    
    func carouselDidScroll(_ carousel: iCarousel!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
