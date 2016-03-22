//
//  setCupNameViewController.swift
//  OZner
//
//  Created by test on 15/12/10.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setCupNameViewController: UIViewController,UITextFieldDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience  init() {
        
        var nibNameOrNil = String?("RootViewController")
        
        //考虑到xib文件可能不存在或被删，故加入判断
        
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
            
        {
            
            nibNameOrNil = nil
            
        }
        
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var currentSelected:Int!
    @IBOutlet var CupName: UITextField!
    @IBAction func EditName(sender: UIButton) {
        CupName.enabled=true
        CupName.backgroundColor=UIColor.whiteColor()
    }
    @IBOutlet var mycupimage: UIImageView!
    @IBOutlet var familycupimage: UIImageView!
    @IBOutlet var friendcupimage: UIImageView!
    @IBAction func mycupclick(sender: AnyObject) {
        currentSelected=0
        selectWhitch()
    }
    
    @IBAction func familycupclick(sender: AnyObject) {
        currentSelected=1
        selectWhitch()
    }
    @IBAction func friendcupclick(sender: AnyObject) {
        currentSelected=2
        selectWhitch()
    }
    func selectWhitch()
    {
        mycupimage.hidden=currentSelected==0 ? false:true
        familycupimage.hidden=currentSelected==1 ? false:true
        friendcupimage.hidden=currentSelected==2 ? false:true
    }
    
    @IBOutlet var Attribute: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       Attribute.text=loadLanguage("属性")
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .Plain, target: self, action: Selector("SaveClick"))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: Selector("back"), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
    
        CupName.delegate=self
        CupName.enabled=false
        CupName.text=setCupStructdata["cup_name"] as? String
        if (setCupStructdata["cup_Attrib"] as? String)=="我的水杯"
        {
            currentSelected=0
        }
        else if (setCupStructdata["cup_Attrib"] as? String)=="家人水杯"
        {
            currentSelected=1
        }else
        {
            currentSelected=2
        }
        selectWhitch()
        // Do any additional setup after loading the view.
    }

    //返回
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func SaveClick()
    {
        setCupStructdata["cup_name"]=CupName.text
        if currentSelected==0
        {
            setCupStructdata["cup_Attrib"] = loadLanguage("我的水杯")
        }
        else if currentSelected==1
        {
            setCupStructdata["cup_Attrib"] = loadLanguage("家人水杯")
        }else
        {
            setCupStructdata["cup_Attrib"] = loadLanguage("朋友水杯")
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.enabled=false
        textField.backgroundColor=UIColor(red: 234/255, green: 234/255, blue: 243/255, alpha: 1)
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title="设备名称"
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
    }

}
