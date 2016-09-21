//
//  indoorAirViewController.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class indoorAirViewController_EN: UIViewController {

    var myCurrentDevice:OznerDevice?
    var mainview:indoorAirXib_EN!
    //台式净化器
    var smallHeadView:indoorHead_SmallXib_EN!
    //立式
    var bigHeadView:indoorHead_BigXib_EN!
    override func viewDidLoad() {
        super.viewDidLoad()

        let ScrollView=UIScrollView(frame: CGRect(x: 0, y: -20, width: Screen_Width, height: Screen_Hight+20))
        ScrollView.backgroundColor=UIColor(red: 238/255, green: 239/255, blue: 240/255, alpha: 1)
        self.view.addSubview(ScrollView)
        mainview=Bundle.main.loadNibNamed("indoorAirXib_EN", owner: nil, options: nil)?.last as! indoorAirXib_EN
        mainview.backButton.addTarget(self, action: #selector(Back), for: .touchUpInside)
        mainview.frame=CGRect(x: 0, y:0, width: Screen_Width, height: 590)
        mainview.toChat.addTarget(self, action: #selector(toChat), for: .touchUpInside)
        mainview.BugLvXinbutton.addTarget(self, action: #selector(bugLvXin), for: .touchUpInside)
        mainview.reSetLvXinButton.addTarget(self, action: #selector(reSetLvXinClick), for: .touchUpInside)
        ScrollView.backgroundColor=mainview.backgroundColor
        ScrollView.addSubview(mainview)
 
        if get_CurrSelectEquip()==4
        {
            //小空气净化器
            smallHeadView=Bundle.main.loadNibNamed("indoorHead_SmallXib_EN", owner: nil, options: nil)?.last as! indoorHead_SmallXib_EN
            smallHeadView.toPM2d5View.addTarget(self, action: #selector(toPM2d5), for: .touchUpInside)
            smallHeadView.Pm2d5Value.text="30"
            mainview.headView.addSubview(smallHeadView)
            smallHeadView.translatesAutoresizingMaskIntoConstraints = false
            mainview.headView.addConstraint(NSLayoutConstraint(item: smallHeadView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: mainview.headView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: smallHeadView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: mainview.headView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: smallHeadView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mainview.headView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: smallHeadView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: mainview.headView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        }
        else
        {
            bigHeadView=Bundle.main.loadNibNamed("indoorHead_BigXib_EN", owner: nil, options: nil)?.last as! indoorHead_BigXib_EN
            bigHeadView.toPM2d5.addTarget(self, action: #selector(toPM2d5), for: .touchUpInside)
            bigHeadView.toVOC.addTarget(self, action: #selector(toVOC), for: .touchUpInside)
            mainview.headView.addSubview(bigHeadView)
            bigHeadView.translatesAutoresizingMaskIntoConstraints = false
            mainview.headView.addConstraint(NSLayoutConstraint(item: bigHeadView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: mainview.headView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: bigHeadView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: mainview.headView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: bigHeadView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mainview.headView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: bigHeadView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: mainview.headView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        }
        
        ScrollView.contentSize=CGSize(width: 0, height: 590)
        
        upDateData()
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(upDateData), name: "updateAirLvXinData", object: nil)
        
        // Do any additional setup after loading the view.
    }

    func reSetLvXinClick()  {
        let airPurifier_Bluetooth = self.myCurrentDevice as? AirPurifier_Bluetooth
        let weakSelf = self
        
        let alertview=SCLAlertView()
        
        _=alertview.addButton(loadLanguage("确定")) {
            if airPurifier_Bluetooth != nil {
                MBProgressHUD.showAdded(to: weakSelf.view, animated: true)
                airPurifier_Bluetooth?.status.resetFilterStatus({ (error) in
                    print(error==nil)
                })
                
                weakSelf.perform(#selector(weakSelf.UpDateDataAndNotice), with: nil, afterDelay: 6);
            }
        }
        _=alertview.addButton(loadLanguage("取消")) {
        }
        _=alertview.showInfo("", subTitle: loadLanguage("重置后将对滤芯使用时间重新计时，这将会影响到空气净化效果。确认是否重置？"))
    }
    func UpDateDataAndNotice()  {
        upDateData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "UpDateLvXinOfSmallAir"), object: nil)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    func toChat()
    {
        let bttons=(CustomTabBarView.sharedCustomTabBar() as AnyObject).btnMuArr as NSMutableArray
        let button=bttons.object(at: 2) as! UIButton
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).touchDownAction(button)
    }
    func bugLvXin()
    {
        let weiXinUrl=weiXinUrlNamezb()
        let tmpURLController=WeiXinURLViewController_EN(nibName: "WeiXinURLViewController_EN", bundle: nil)
        
        tmpURLController.title=weiXinUrl.byAirLX
        self.present(tmpURLController, animated: true, completion: nil)
    }
    func Back()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func toPM2d5()
    {
        let pm2d5controler=PM2d5ViewController_EN(nibName: "PM2d5ViewController_EN", bundle: nil)
        self.navigationController?.pushViewController(pm2d5controler, animated: true)
    }
    func toVOC()
    {
        let voccontroler=VOC_AirViewController_EN(nibName: "VOC_AirViewController_EN", bundle: nil)
        self.navigationController?.pushViewController(voccontroler, animated: true)
    }
    func upDateData()
    {
        if self.myCurrentDevice == nil
        {return}
       
        if get_CurrSelectEquip()==4
        {
            let airPurifier_Bluetooth = self.myCurrentDevice as! AirPurifier_Bluetooth
            smallHeadView.Pm2d5Value.text=airPurifier_Bluetooth.sensor.pm25==65535 ? "-":"\(airPurifier_Bluetooth.sensor.pm25)"
            //airPurifier_Bluetooth.status
            mainview.smallairHidenView.addConstraint(NSLayoutConstraint(item: mainview.smallairHidenView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 0))
            mainview.airTotal.text = loadLanguage("无")
            mainview.smallairHidenView.isHidden=true
            //mainview.airPurifier_Bluetooth=airPurifier_Bluetooth
            //滤芯状态
            if airPurifier_Bluetooth.status.filterStatus.lastTime != nil
            {
                
                
                let tmpTime = min(100, 100-airPurifier_Bluetooth.status.filterStatus.workTime/600)
                let remindTime = max(tmpTime, 0)
 
                mainview.starDatazb=""
               
                mainview.state = Int(remindTime)
            }
        }
        else
        {
            let airPurifier_MxChip = self.myCurrentDevice as! AirPurifier_MxChip
            bigHeadView.PM2d5Value.text=airPurifier_MxChip.sensor.pm25==65535 ? "-":"\(airPurifier_MxChip.sensor.pm25)"
            bigHeadView.VOCValue.text=VOCStantdart(airPurifier_MxChip.sensor.voc)
            mainview.airTotal.text = "\(airPurifier_MxChip.sensor.totalClean/1000)"
            mainview.reSetLvXinButton.isHidden=true
            //滤芯状态
            if airPurifier_MxChip.status.filterStatus != nil
            {
                
                let nowTime:TimeInterval=Date().timeIntervalSince1970
                let stopTime:TimeInterval=airPurifier_MxChip.status.filterStatus.lastTime.timeIntervalSince1970+365*24*3600
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                let starDateStr=dateFormatter.string(from: airPurifier_MxChip.status.filterStatus.lastTime)
                mainview.starDatazb=starDateStr
                let tmpValue = ceil((stopTime-nowTime)/(365*24*3600)*100)
                
                mainview.state=(stopTime-nowTime)>=0 ? Int(tmpValue):0
            }
            else
            {
                return
            }
        }
        
    }
    //VOC Standart
    func VOCStantdart(_ voc:Int32)->String
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
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
        self.navigationController?.isNavigationBarHidden=true
        
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
