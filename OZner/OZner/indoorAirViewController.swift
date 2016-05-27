//
//  indoorAirViewController.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class indoorAirViewController: UIViewController {

    var myCurrentDevice:OznerDevice?
    var mainview:indoorAirXib!
    //台式净化器
    var smallHeadView:indoorHead_SmallXib!
    //立式
    var bigHeadView:indoorHead_BigXib!
    override func viewDidLoad() {
        super.viewDidLoad()

        let ScrollView=UIScrollView(frame: CGRect(x: 0, y: -20, width: Screen_Width, height: Screen_Hight+20))
        ScrollView.backgroundColor=UIColor(red: 238/255, green: 239/255, blue: 240/255, alpha: 1)
        self.view.addSubview(ScrollView)
        mainview=NSBundle.mainBundle().loadNibNamed("indoorAirXib", owner: nil, options: nil).last as! indoorAirXib
        mainview.backButton.addTarget(self, action: #selector(Back), forControlEvents: .TouchUpInside)
        mainview.frame=CGRect(x: 0, y:0, width: Screen_Width, height: 590)
        mainview.toChat.addTarget(self, action: #selector(toChat), forControlEvents: .TouchUpInside)
        mainview.BugLvXinbutton.addTarget(self, action: #selector(bugLvXin), forControlEvents: .TouchUpInside)
        ScrollView.backgroundColor=mainview.backgroundColor
        ScrollView.addSubview(mainview)
 
        if get_CurrSelectEquip()==4
        {
            //小空气净化器
            smallHeadView=NSBundle.mainBundle().loadNibNamed("indoorHead_SmallXib", owner: nil, options: nil).last as! indoorHead_SmallXib
            smallHeadView.toPM2d5View.addTarget(self, action: #selector(toPM2d5), forControlEvents: .TouchUpInside)
            smallHeadView.Pm2d5Value.text="30"
            mainview.headView.addSubview(smallHeadView)
            smallHeadView.translatesAutoresizingMaskIntoConstraints = false
            mainview.headView.addConstraint(NSLayoutConstraint(item: smallHeadView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: mainview.headView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: smallHeadView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: mainview.headView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: smallHeadView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainview.headView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: smallHeadView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainview.headView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        }
        else
        {
            bigHeadView=NSBundle.mainBundle().loadNibNamed("indoorHead_BigXib", owner: nil, options: nil).last as! indoorHead_BigXib
            bigHeadView.toPM2d5.addTarget(self, action: #selector(toPM2d5), forControlEvents: .TouchUpInside)
            bigHeadView.toVOC.addTarget(self, action: #selector(toVOC), forControlEvents: .TouchUpInside)
            mainview.headView.addSubview(bigHeadView)
            bigHeadView.translatesAutoresizingMaskIntoConstraints = false
            mainview.headView.addConstraint(NSLayoutConstraint(item: bigHeadView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: mainview.headView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: bigHeadView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: mainview.headView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: bigHeadView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainview.headView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
            mainview.headView.addConstraint(NSLayoutConstraint(item: bigHeadView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainview.headView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        }
        
        ScrollView.contentSize=CGSize(width: 0, height: 590)
        
        upDateData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(upDateData), name: "updateAirLvXinData", object: nil)
        
        // Do any additional setup after loading the view.
    }

    func toChat()
    {
        let bttons=CustomTabBarView.sharedCustomTabBar().btnMuArr as NSMutableArray
        let button=bttons.objectAtIndex(2) as! UIButton
        CustomTabBarView.sharedCustomTabBar().touchDownAction(button)
    }
    func bugLvXin()
    {
        let weiXinUrl=weiXinUrlNamezb()
        let tmpURLController=WeiXinURLViewController(nibName: "WeiXinURLViewController", bundle: nil)
        
        tmpURLController.title=weiXinUrl.byAirLX
        self.presentViewController(tmpURLController, animated: true, completion: nil)
    }
    func Back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func toPM2d5()
    {
        let pm2d5controler=PM2d5ViewController(nibName: "PM2d5ViewController", bundle: nil)
        self.navigationController?.pushViewController(pm2d5controler, animated: true)
    }
    func toVOC()
    {
        let voccontroler=VOC_AirViewController(nibName: "VOC_AirViewController", bundle: nil)
        self.navigationController?.pushViewController(voccontroler, animated: true)
    }
    func upDateData()
    {
        if self.myCurrentDevice == nil
        {return}
        
        if get_CurrSelectEquip()==4
        {
            let airPurifier_Bluetooth = self.myCurrentDevice as! AirPurifier_Bluetooth
            smallHeadView.Pm2d5Value.text="\(airPurifier_Bluetooth.sensor.PM25)"
            //airPurifier_Bluetooth.status
            mainview.smallairHidenView.addConstraint(NSLayoutConstraint(item: mainview.smallairHidenView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 0, constant: 0))
            mainview.airTotal.text = "无"
            mainview.smallairHidenView.hidden=true
            mainview.airPurifier_Bluetooth=airPurifier_Bluetooth
            //滤芯状态
            if airPurifier_Bluetooth.status.filterStatus.lastTime != nil
            {
                
                let nowTime:NSTimeInterval=NSDate().timeIntervalSince1970
                let stopTime:NSTimeInterval=airPurifier_Bluetooth.status.filterStatus.lastTime.timeIntervalSince1970+365*24*3600
               
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                let starDateStr=dateFormatter.stringFromDate(airPurifier_Bluetooth.status.filterStatus.lastTime)
                mainview.starDatazb=starDateStr
                mainview.state=(stopTime-nowTime)>=0 ? Int(ceil((stopTime-nowTime)/(365*24*3600)*100)) : 0
            }
        }
        else
        {
            let airPurifier_MxChip = self.myCurrentDevice as! AirPurifier_MxChip
            bigHeadView.PM2d5Value.text="\(airPurifier_MxChip.sensor.PM25)"
            bigHeadView.VOCValue.text=VOCStantdart(airPurifier_MxChip.sensor.VOC)
            mainview.airTotal.text = "\(airPurifier_MxChip.sensor.TotalClean/1000)"
            mainview.reSetLvXinButton.hidden=true
            //滤芯状态
            if airPurifier_MxChip.status.filterStatus != nil
            {
                
                let nowTime:NSTimeInterval=NSDate().timeIntervalSince1970
                let stopTime:NSTimeInterval=airPurifier_MxChip.status.filterStatus.lastTime.timeIntervalSince1970+365*24*3600
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                let starDateStr=dateFormatter.stringFromDate(airPurifier_MxChip.status.filterStatus.lastTime)
                mainview.starDatazb=starDateStr
                mainview.state=(stopTime-nowTime)>=0 ? Int(ceil((stopTime-nowTime)/(365*24*3600)*100)):0
            }
            else
            {
                return
            }
        }
        
    }
    //VOC Standart
    func VOCStantdart(voc:Int32)->String
    {
        var vocStr=""
        switch voc
        {
        case 0:
            vocStr="优"
            break
        case 1:
            vocStr="良"
            break
        case 2:
            vocStr="一般"
            break
        case 3:
            vocStr="差"
            break
        default:
            vocStr="检测"
            break
            
        }
        return vocStr
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
        self.navigationController?.navigationBarHidden=true
        
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
