//
//  RoWaterPuefierLvXinController.swift
//  OZner
//
//  Created by 赵兵 on 2016/11/24.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class RoWaterPuefierLvXinController: UIViewController {

    var currentDevice:ROWaterPurufier!
    @IBOutlet var fuweiButton: UIButton!
    @IBAction func fuweiClick(sender: UIButton) {
        currentDevice.resetFilter()
        let alert = SCLAlertView()
        alert.addButton("我知道了") {
        }
        alert.addButton("购买滤芯") {
        }
        alert.showInfo("", subTitle: "为了您和您家人的健康，请及时更换滤芯")
    }
    
    
    @IBOutlet var lvxinAlertLabel: UILabel!
    @IBOutlet var lvxinValueLabelA: UILabel!
    @IBOutlet var lvxinValueLabelB: UILabel!
    @IBOutlet var lvxinValueLabelC: UILabel!
    @IBAction func zixunClick(sender: AnyObject) {
        let array=CustomTabBarView.sharedCustomTabBar().btnMuArr as NSMutableArray
        let button=array.objectAtIndex(2) as! UIButton
        CustomTabBarView.sharedCustomTabBar().touchDownAction(button)
    }
    
    @IBAction func buyLvXinClick(sender: AnyObject) {
        let array=CustomTabBarView.sharedCustomTabBar().btnMuArr as NSMutableArray
        let button=array.objectAtIndex(1) as! UIButton
        CustomTabBarView.sharedCustomTabBar().touchDownAction(button)
    }
    @IBAction func buyDeviceClick(sender: UIButton) {
        let weiXinUrl=weiXinUrlNamezb()
        let UrlControl=WeiXinURLViewController_EN(nibName: "WeiXinURLViewController_EN", bundle: nil)
        switch sender.tag
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title="当前滤芯状态"
        lvxinValueLabelA.text="\(currentDevice.filterInfo.Filter_A_Percentage)%"
        lvxinValueLabelB.text="\(currentDevice.filterInfo.Filter_B_Percentage)%"
        lvxinValueLabelC.text="\(currentDevice.filterInfo.Filter_C_Percentage)%"
        
        timer=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(alertLabelShanShuo), userInfo: nil, repeats: true)
        fuweiButton.hidden = !currentDevice.isEnableFilterReset()
        // Do any additional setup after loading the view.
    }
    var istrue = true
    
    func alertLabelShanShuo() {
        istrue = !istrue
        lvxinAlertLabel.text = istrue ? "清\n洗\n水\n路\n保\n护\n器":""
        
        if false {
            timer.invalidate()
            timer=nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
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
