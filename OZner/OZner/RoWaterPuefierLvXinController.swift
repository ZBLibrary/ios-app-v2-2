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
    }
    
    
    @IBOutlet var lvxinAlertLabel: UILabel!
    @IBOutlet var lvxinValueLabelA: UILabel!
    @IBOutlet var lvxinValueLabelB: UILabel!
    @IBOutlet var lvxinValueLabelC: UILabel!
    @IBAction func zixunClick(sender: AnyObject) {
    }
    
    @IBAction func buyLvXinClick(sender: AnyObject) {
    }
    @IBAction func buyDeviceClick(sender: UIButton) {
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title="当前滤芯状态"
        lvxinValueLabelA.text="\(currentDevice.filterInfo.Filter_A_Percentage)%"
        lvxinValueLabelB.text="\(currentDevice.filterInfo.Filter_B_Percentage)%"
        lvxinValueLabelC.text="\(currentDevice.filterInfo.Filter_C_Percentage)%"
        // Do any additional setup after loading the view.
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
