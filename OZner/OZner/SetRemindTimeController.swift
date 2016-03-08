//
//  SetRemindTimeController.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SetRemindTimeController: UIViewController,UIAlertViewDelegate {

    var backClosure:((NSMutableDictionary) -> Void)?
    var dicData:NSMutableDictionary?
    //var colorOfSelected=UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    //var colorOfNormal=UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    //-1没有选中，1表示选中时间一，2 。。。，3 。。。
    var currentSelected = -1{
        didSet{
        }
    }
    //时间一
    @IBOutlet weak var timeTitleLabel1: UILabel!
    @IBOutlet weak var timeLabel1: UILabel!
    @IBOutlet weak var timeIcon1: UIImageView!
    @IBAction func timeClick1(sender: AnyObject) {
        datePicker.hidden=false
        currentSelected=1
    }
    //时间二
    @IBOutlet weak var timeTitleLabel2: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var timeIcon2: UIImageView!
    @IBAction func timeClick2(sender: AnyObject) {
        datePicker.hidden=false
        currentSelected=2
    }
    //时间三
    @IBOutlet weak var timeTitleLabel3: UILabel!
    @IBOutlet weak var timeLabel3: UILabel!
    @IBOutlet weak var timeIcon3: UIImageView!
    @IBAction func timeClick3(sender: AnyObject) {
        datePicker.hidden=false
        currentSelected=3
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        print(sender.date)
    }
    private var tmpDicData:NSMutableDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        tmpDicData=dicData
        self.title="智能补水仪"
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .Plain, target: self, action: Selector("SaveClick"))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: Selector("back"), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        datePicker.hidden=true
        //初始化数据
        timeLabel1.text = StringFromDateNumber(dicData?.objectForKey("checktime1") as! Int)
        timeLabel2.text = StringFromDateNumber(dicData?.objectForKey("checktime2") as! Int)
        timeLabel3.text = StringFromDateNumber(dicData?.objectForKey("checktime3") as! Int)
        // Do any additional setup after loading the view.
    }

    func StringFromDateNumber(tempTime:Int)->String
    {
        print(tempTime)
        let tmpstr=(tempTime/3600<10 ? "0\(tempTime/3600)":"\(tempTime/3600)")+":"+(tempTime%3600/60<10 ? "0\(tempTime%3600/60)":"\(tempTime%3600/60)")
        print(tmpstr)
        return tmpstr
    }
    //返回
    func back(){
        if tmpDicData !== dicData
        {
            let alert=UIAlertView(title: "", message: "是否保存？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "保存")
            alert.show()
        }
        else
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    func SaveClick()
    {
        if backClosure != nil
        {
            backClosure!(dicData!)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    //alert 点击事件
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.message=="是否保存？"
        {
            if buttonIndex==0
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                SaveClick()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        self.navigationController?.navigationBarHidden=false
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
