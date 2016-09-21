//
//  setCuoTimeViewController_EN.swift
//  OZner
//
//  Created by test on 15/12/10.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setCuoTimeViewController_EN: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
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
    @IBAction func starbutton(_ sender: AnyObject) {
        setselect(0)
        CurrentSelect=0
    }
    @IBAction func endbutton(_ sender: AnyObject) {
        setselect(1)
        CurrentSelect=1
    }
    
    
    func setselect(_ Select:Int)
    {
        if Select==0
        {
            leftImage.isHidden=false
            starTime.textColor=selectcolor
            endimage.isHidden=true
            endtime.textColor=norcolor
            datePicker.date=curLabelTime(startimelabel.text!)
        }
        else
        {
            leftImage.isHidden=true
            starTime.textColor=norcolor
            endimage.isHidden=false
            endtime.textColor=selectcolor
            datePicker.date=curLabelTime(endtimelabel.text!)
        }
    }
    func curLabelTime(_ timeStr:String)->Date
    {
        if timeStr.characters.count != 5{
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="YYYY-MM-DD"
        var nowStr=dateFormatter.string(from: Date())
        nowStr=nowStr+" "+timeStr+":00"
        dateFormatter.dateFormat="YYYY-MM-DD hh:mm:ss"
        //print(nowStr)
        if let tmpDate=dateFormatter.date(from: nowStr)
        {
            return tmpDate
        }
        //print(tmpDate)
        
        return Date()
    }
    func getpikerdate()->String
    {
        let select = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateAndTime =  dateFormatter.string(from: select)
        return dateAndTime
    }
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starTime.text=loadLanguage("开启时间")
        endtime.text=loadLanguage("结束时间")
        let savebutton=UIBarButtonItem(title:loadLanguage("保存") , style: .plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        datePicker.addTarget(self, action: #selector(dateValueChanged), for: UIControlEvents.valueChanged)
        let tmpstar=setCupStructdata["remindStart"] as! Int
        let tmpend=setCupStructdata["remindEnd"] as! Int
        startimelabel.text=(tmpstar/3600<10 ? "0\(tmpstar/3600)":"\(tmpstar/3600)")+":"+(tmpstar%3600/60<10 ? "0\(tmpstar%3600/60)":"\(tmpstar%3600/60)")
        endtimelabel.text=(tmpend/3600<10 ? "0\(tmpend/3600)":"\(tmpend/3600)")+":"+(tmpend%3600/60<10 ? "0\(tmpend%3600/60)":"\(tmpend%3600/60)")
        setselect(0)
        
    }

    //返回
    func back(){
        _ = navigationController?.popViewController(animated: true)
    }
    func SaveClick()
    {
        let startmp=startimelabel.text! as NSString
        let enttmp=endtimelabel.text! as NSString
        setCupStructdata["remindStart"]=(Int(startmp.substring(to: 2))!*3600+Int(startmp.substring(from: 3))!*60)
        setCupStructdata["remindEnd"]=(Int(enttmp.substring(to: 2))!*3600+Int(enttmp.substring(from: 3))!*60)
        _ = navigationController?.popViewController(animated: true)
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
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title=loadLanguage("设置定时")
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
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
