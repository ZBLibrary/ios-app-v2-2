//
//  MySetViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class MySetViewController: UIViewController,UIAlertViewDelegate {

    @IBAction func BackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func SetMeter(sender: AnyObject) {
        self.performSegueWithIdentifier("showsetmeter", sender: self)
    }
    
    @IBAction func AboutUs(sender: AnyObject) {
        self.performSegueWithIdentifier("showaboutus", sender: self)
    }
    @IBAction func loginOut(sender: AnyObject) {
        let alert=UIAlertView(title: "", message:loadLanguage("是否退出登录？"), delegate: self, cancelButtonTitle:loadLanguage( "否"), otherButtonTitles: loadLanguage("是"))
        alert.show()
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.message==loadLanguage("是否退出登录？")&&buttonIndex==1
        {
            LogInOut.loginInOutInstance().loginOutUser()
        }
    }
    @IBOutlet var allowTS: UISwitch!
    
    @IBOutlet var AllowedpushLable: UILabel!
    @IBAction func allowPushClick(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(allowTS.on, forKey: "IsAlowTuiSong")
    }
    @IBOutlet var AboutLable: UILabel!
    @IBOutlet var UnitLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=loadLanguage("设置")
         AllowedpushLable.text=loadLanguage("允许推送消息")
        AboutLable.text=loadLanguage("关于伊泉净品")
        UnitLable.text=loadLanguage("计量单位")
        let userDef=NSUserDefaults.standardUserDefaults().objectForKey("IsAlowTuiSong")
        allowTS.on=userDef==nil ? true:(userDef as! Bool)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden=false
        //allowTS.on=get_allowTS()
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //set_allowTS(allowTS.on)
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
