//
//  TantouLXController.swift
//  OZner
//
//  Created by test on 16/1/19.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class TantouLXController_EN: UIViewController {
    
    //当前选中的device
    var myCurrentDevice:OznerDevice?
    var mainView:tantouLvXinView_EN!
    var buyWaterLVXinUrl:String?
    var IsShowScanOfWater=false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title=loadLanguage("当前滤芯状态")
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        let ScrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight-65))
        ScrollView.backgroundColor=UIColor.whiteColor()
        mainView=NSBundle.mainBundle().loadNibNamed("tantouLvXinView_EN", owner: nil, options: nil).last as! tantouLvXinView_EN
        mainView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: mainView.bounds.size.height)
        //
        mainView.zixunButton.addTarget(self, action: #selector(zixun), forControlEvents: .TouchUpInside)
        mainView.buyLXButton.addTarget(self, action: #selector(buyLX), forControlEvents: .TouchUpInside)
        mainView.saoMaButton.addTarget(self, action: #selector(saoMa), forControlEvents: .TouchUpInside)
        //更多产品
        mainView.MoreDeviceButton1.addTarget(self, action: #selector(MoreDeviceClick), forControlEvents: .TouchUpInside)
        mainView.MoreDeviceButton2.addTarget(self, action: #selector(MoreDeviceClick), forControlEvents: .TouchUpInside)
        mainView.MoreDeviceButton3.addTarget(self, action: #selector(MoreDeviceClick), forControlEvents: .TouchUpInside)
        //设置滤芯状态
        setLvXinState()
        if WaterPurifierManager.isWaterPurifier(self.myCurrentDevice?.type) == true
        {
            
//            let tmpImg=UIImage(named: "WaterPurLvXinService")
//            let serviceImg=UIImageView(frame: CGRect(x: 0, y: mainView.bounds.size.height-140, width: Screen_Width, height: (tmpImg?.size.height)!*Screen_Width/(tmpImg?.size.width)!))
//            serviceImg.image=tmpImg
//            ScrollView.addSubview(serviceImg)
            
            ScrollView.contentSize=CGSize(width: 0, height: mainView.bounds.size.height)
            mainView.maxUserDay=365
            
//            mainView.ErWeiMaContainView.hidden = !IsShowScanOfWater
//            mainView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: IsShowScanOfWater ? mainView.bounds.size.height:(mainView.bounds.size.height-140))
//            ScrollView.contentSize=CGSize(width: 0, height: mainView.bounds.size.height+(tmpImg?.size.height)!*Screen_Width/(tmpImg?.size.width)!)
        }else
        {
            ScrollView.contentSize=CGSize(width: 0, height: mainView.bounds.size.height)
            mainView.maxUserDay=30
        }
        
        ScrollView.addSubview(mainView)
        self.view.addSubview(ScrollView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setLvXinState), name: "updateLVXinTimeByScan", object: nil)
        // Do any additional setup after loading the view.
    }
    
    func MoreDeviceClick(button:UIButton)
    {
        let weiXinUrl=weiXinUrlNamezb()
        let UrlControl=WeiXinURLViewController_EN(nibName: "WeiXinURLViewController_EN", bundle: nil)
        switch button.tag
        {
        case 1:
            UrlControl.title=weiXinUrl.moreDevice_Tap
            break
        case 2:
            UrlControl.title=weiXinUrl.moreDevice_Water
            break
        default:
            UrlControl.title=weiXinUrl.moreDevice_Cup
            break
        }
        self.presentViewController(UrlControl, animated: true, completion: nil)
    }
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func zixun()
    {
        //        let array=CustomTabBarView.sharedCustomTabBar().btnMuArr as NSMutableArray
        //        let button=array.objectAtIndex(2) as! UIButton
        //        CustomTabBarView.sharedCustomTabBar().touchDownAction(button)
        let phoneNum = NSMutableString.init(string: "tel:4008209667")
        
        let callWebView = UIWebView()
        
        callWebView.loadRequest(NSURLRequest(URL: NSURL.init(string: phoneNum as String)!))
        
        self.view.addSubview(callWebView)
        
        
    }
    func buyLX()
    {
        if buyWaterLVXinUrl==nil {
            return
        }
        
        let buyLX=WeiXinURLViewController_EN(goUrl: buyWaterLVXinUrl!)
        let witchUrl=weiXinUrlNamezb()
        buyLX.title=witchUrl.byTapLX
        if myCurrentDevice != nil
        {
            if WaterPurifierManager.isWaterPurifier(self.myCurrentDevice?.type) == true
            {
                buyLX.title=witchUrl.WaterLvXinUrl1//1,2,3
            }
            
        }
        
        self.presentViewController(buyLX, animated: true, completion: nil)
    }
    func saoMa()
    {
        //设置扫码区域参数
        let style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner
        style.photoframeLineW = 3
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove
        //qq里面的线条图片
        let imgLine = UIImage(named: "qrcode_scan_light_green")
        style.animationImage = imgLine
        
        let scan = SubLBXScanViewController()
        scan.style = style
        scan.deviceMac=myCurrentDevice?.identifier
        scan.deviceType=myCurrentDevice?.type
        self.navigationController?.pushViewController(scan, animated: true)
        
    }
    
    func setLvXinStateWater()
    {
        //获取滤芯服务时间
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerDevice/GetMachineLifeOutTime"
        let params:NSDictionary = ["usertoken":get_UserToken(),"mac":(myCurrentDevice?.identifier)!]
        print(url)
        print(params)
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
                                let format=NSDateFormatter()
                                format.dateFormat="yyyy/MM/dd HH:mm:ss"
                                
                                let endDate=responseObject.objectForKey("time") as! String
                                let nowDate=responseObject.objectForKey("nowtime") as! String
                                let endTime=format.dateFromString(endDate)!.timeIntervalSince1970
                                let nowTime=format.dateFromString(nowDate)!.timeIntervalSince1970
                                let value = Int((endTime-nowTime)/(24*3600))
                                format.dateFormat="yyyy-MM-dd HH:mm:ss"
                                let stardate = NSDate(timeIntervalSince1970: (endTime-365*24*3600))
                                self.mainView.starDate=format.stringFromDate(stardate)
                                self.mainView.useDay=(value<0 ? 365:(365-value))
                            }
                        }
            },
                     failure: { (operation: AFHTTPRequestOperation!,
                        error: NSError!) in
                        print("Error: " + error.localizedDescription)
        })
        
        
        
        
        
    }
    //下载滤芯状态
    func setLvXinState()
    {
        if myCurrentDevice == nil
        {
            return
        }
        if TapManager.isTap(myCurrentDevice?.type)
        {
            setLvXinStateTap()
        }
        else
        {
            setLvXinStateWater()
        }
    }
    func setLvXinStateTap()
    {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let werbservice = DeviceWerbservice()
        werbservice.filterService(self.myCurrentDevice?.identifier) { (modifyTime:String!, userDay:NSNumber!, status:StatusManager!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if(status.networkStatus == kSuccessStatus)
            {
                print(modifyTime)
                print(userDay)
                
                self.mainView.starDate=modifyTime
                self.mainView.useDay=Int(userDay.intValue)
            }
            else
            {
                let alert=UIAlertView(title: loadLanguage("提示"), message: loadLanguage("获取滤芯服务时间失败！"), delegate: self, cancelButtonTitle: loadLanguage("确定"))
                alert.show()
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
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
