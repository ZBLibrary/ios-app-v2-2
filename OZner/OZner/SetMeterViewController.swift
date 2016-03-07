//
//  SetMeterViewController.swift
//  My
//
//  Created by test on 15/11/27.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class SetMeterViewController: UIViewController {

    var Temperature=0
    var WaterMeter=0
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func Save(sender: AnyObject) {
        set_MyInfoSet(Temperature, WaterMeter: WaterMeter)
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    
    @IBOutlet var DanWe1: UIImageView!
    @IBOutlet var DanWei2: UIImageView!
    @IBOutlet var DanWei3: UIImageView!
    @IBOutlet var DanWei4: UIImageView!
    @IBOutlet var DanWei5: UIImageView!
    
    @IBAction func DanWeiClick(sender: AnyObject) {
        DanWe1.hidden=false
        DanWei2.hidden=true
        Temperature=0
    }
    @IBAction func DanWei2Click(sender: AnyObject) {
        DanWe1.hidden=true
        DanWei2.hidden=false
        Temperature=1
    }
    @IBAction func DanWei3Click(sender: AnyObject) {
        DanWei3.hidden=false
        DanWei4.hidden=true
        DanWei5.hidden=true
        WaterMeter=0
    }
    @IBAction func DanWei4Click(sender: AnyObject) {
        DanWei3.hidden=true
        DanWei4.hidden=false
        DanWei5.hidden=true
        WaterMeter=1
    }
    @IBAction func DanWei5Click(sender: AnyObject) {
        DanWei3.hidden=true
        DanWei4.hidden=true
        DanWei5.hidden=false
        WaterMeter=2
    }
    
    @IBOutlet var TemperatureLable: UILabel!
    @IBOutlet var CelsiusLable: UILabel!
    @IBOutlet var FahrenheitLable: UILabel!
    @IBOutlet var WaterLable: UILabel!
    @IBOutlet var MLLable: UILabel!
    @IBOutlet var DLLable: UILabel!
    @IBOutlet var OZLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title=loadLanguage("计量单位")
      TemperatureLable.text=loadLanguage("温度")
      CelsiusLable.text=loadLanguage("摄氏度")
      FahrenheitLable.text=loadLanguage("华氏度" )
      WaterLable.text=loadLanguage("水量")
      MLLable.text=loadLanguage("毫升")
      DLLable.text=loadLanguage("分升")
      OZLable.text=loadLanguage("盅司" )
        
        DanWe1.hidden=true
        DanWei2.hidden=true
        DanWei3.hidden=true
        DanWei4.hidden=true
        DanWei5.hidden=true
        (Temperature,WaterMeter)=get_MyInfoSet()
        if Temperature==0
        {
            DanWe1.hidden=false
        }
        else
        {
            DanWei2.hidden=false
        }
        if WaterMeter==0
        {
            DanWei3.hidden=false
        }
        else if WaterMeter==1
        {
            DanWei4.hidden=false
        }
        else
        {
            DanWei5.hidden=false
        }
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
