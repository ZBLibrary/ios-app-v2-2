//
//  setCuoTimeViewController.swift
//  OZner
//
//  Created by test on 15/12/10.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setCuoTimeViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var CurrentSelect=0
    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var starTime: UILabel!
    @IBOutlet var startimelabel: UILabel!
    @IBOutlet var endimage: UIImageView!
    @IBOutlet var endtime: UILabel!
    @IBOutlet var endtimelabel: UILabel!
    let selectcolor=UIColor(red: 93/255, green: 153/255, blue: 250/255, alpha: 1)
    let norcolor=UIColor(red: 97/255, green: 98/255, blue: 99/255, alpha: 1)
    @IBAction func starbutton(sender: AnyObject) {
        setselect(0)
        CurrentSelect=0
    }
    @IBAction func endbutton(sender: AnyObject) {
        setselect(1)
        CurrentSelect=1
    }
    
    
    func setselect(Select:Int)
    {
        if Select==0
        {
            leftImage.hidden=false
            starTime.textColor=selectcolor
            endimage.hidden=true
            endtime.textColor=norcolor
            datePicker.date=curLabelTime(startimelabel.text!)
        }
        else
        {
            leftImage.hidden=true
            starTime.textColor=norcolor
            endimage.hidden=false
            endtime.textColor=selectcolor
            datePicker.date=curLabelTime(endtimelabel.text!)
        }
    }
    func curLabelTime(timeStr:String)->NSDate
    {
        if timeStr.characters.count != 5{
            return NSDate()
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat="YYYY-MM-DD"
        var nowStr=dateFormatter.stringFromDate(NSDate())
        nowStr=nowStr+" "+timeStr+":00"
        dateFormatter.dateFormat="YYYY-MM-DD hh:mm:ss"
        //print(nowStr)
        let tmpDate=dateFormatter.dateFromString(nowStr)! as NSDate
        //print(tmpDate)
        
        return tmpDate
    }
    func getpikerdate()->String
    {
        let select = datePicker.date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateAndTime =  dateFormatter.stringFromDate(select)
        return dateAndTime
    }
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starTime.text=loadLanguage("开启时间")
        endtime.text=loadLanguage("结束时间")
        let savebutton=UIBarButtonItem(title:loadLanguage("保存") , style: .Plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        datePicker.addTarget(self, action: #selector(dateValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        let tmpstar=setCupStructdata["remindStart"] as! Int
        let tmpend=setCupStructdata["remindEnd"] as! Int
        startimelabel.text=(tmpstar/3600<10 ? "0\(tmpstar/3600)":"\(tmpstar/3600)")+":"+(tmpstar%3600/60<10 ? "0\(tmpstar%3600/60)":"\(tmpstar%3600/60)")
        endtimelabel.text=(tmpend/3600<10 ? "0\(tmpend/3600)":"\(tmpend/3600)")+":"+(tmpend%3600/60<10 ? "0\(tmpend%3600/60)":"\(tmpend%3600/60)")
        setselect(0)
        
    }

    //返回
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func SaveClick()
    {
        let startmp=startimelabel.text! as NSString
        let enttmp=endtimelabel.text! as NSString
        setCupStructdata["remindStart"]=(Int(startmp.substringToIndex(2))!*3600+Int(startmp.substringFromIndex(3))!*60)
        setCupStructdata["remindEnd"]=(Int(enttmp.substringToIndex(2))!*3600+Int(enttmp.substringFromIndex(3))!*60)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dateValueChanged()
    {
        if CurrentSelect==0
        {
            startimelabel.text=getpikerdate()
        }
        else
        {
            endtimelabel.text=getpikerdate()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title="设置定时"
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
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
