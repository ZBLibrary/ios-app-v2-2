//
//  SetRemindTimeController_EN.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SetRemindTimeController_EN: UIViewController,UIAlertViewDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var backClosure:((NSMutableDictionary) -> Void)?//回掉函数
    var dicData:NSMutableDictionary?
    var colorOfSelected=UIColor(red: 0, green: 124/255, blue: 251/255, alpha: 1)
    var colorOfNormal=UIColor(red: 201/255, green: 202/255, blue: 203/255, alpha: 1)
    var colorOfBlack=UIColor.black
    //-1没有选中，1表示选中时间一，2 。。。，3 。。。
    var currentSelected = -1{
        didSet{
            timeTitleLabel1.textColor = currentSelected==1 ? colorOfSelected:colorOfBlack
            timeTitleLabel2.textColor = currentSelected==2 ? colorOfSelected:colorOfBlack
            timeTitleLabel3.textColor = currentSelected==3 ? colorOfSelected:colorOfBlack
            timeLabel1.textColor = currentSelected==1 ? colorOfSelected:colorOfNormal
            timeLabel2.textColor = currentSelected==2 ? colorOfSelected:colorOfNormal
            timeLabel3.textColor = currentSelected==3 ? colorOfSelected:colorOfNormal
            timeIcon1.isHidden = !(currentSelected==1)
            timeIcon2.isHidden = !(currentSelected==2)
            timeIcon3.isHidden = !(currentSelected==3)
        }
    }
    //时间一
    @IBOutlet weak var timeTitleLabel1: UILabel!
    @IBOutlet weak var timeLabel1: UILabel!
    @IBOutlet weak var timeIcon1: UIImageView!
    @IBAction func timeClick1(_ sender: AnyObject) {
        datePicker.isHidden=false
        currentSelected=1
        datePicker.date=dateFromTimeString(timeLabel1.text!)
    }
    //时间二
    @IBOutlet weak var timeTitleLabel2: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var timeIcon2: UIImageView!
    @IBAction func timeClick2(_ sender: AnyObject) {
        datePicker.isHidden=false
        currentSelected=2
        datePicker.date=dateFromTimeString(timeLabel2.text!)
    }
    //时间三
    @IBOutlet weak var timeTitleLabel3: UILabel!
    @IBOutlet weak var timeLabel3: UILabel!
    @IBOutlet weak var timeIcon3: UIImageView!
    @IBAction func timeClick3(_ sender: AnyObject) {
        datePicker.isHidden=false
        currentSelected=3
        datePicker.date=dateFromTimeString(timeLabel3.text!)
    }
    /**
     "21:30"->NSDate
     
     - parameter timeStr: "21:30"
     
     - returns:NSDate
     */
    func dateFromTimeString(_ timeStr:String)->Date
    {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat="HH:mm"
        return inputFormatter.date(from: timeStr)!
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        //print(sender.date)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat="HH:mm"
        let inputDate = inputFormatter.string(from: sender.date)
        let timeInt=IntFromTimeStr(inputDate as NSString)
        switch currentSelected
        {
        case 1:
            dicData?.setValue(timeInt, forKey: "checktime1")
            timeLabel1.text=inputDate
        case 2:
            dicData?.setValue(timeInt, forKey: "checktime2")
            timeLabel2.text=inputDate
        case 3:
            dicData?.setValue(timeInt, forKey: "checktime3")
            timeLabel3.text=inputDate
        default:
            break
        }
        
        //print(inputDate)
    }
    /**
     "01:30"->1*3600+30*60
     
     - parameter tempTime: "01:30"
     
     - returns: 1*3600+30*60
     */
    func IntFromTimeStr(_ tempTime:NSString)->Int
    {
        let timeArr=tempTime.components(separatedBy: ":")
        return (timeArr[0] as NSString).integerValue*3600+(timeArr[1] as NSString).integerValue*60
    }
    fileprivate var tmpDicData:NSMutableDictionary?//留作备案，最后要不要提示保存用
    override func viewDidLoad() {
        super.viewDidLoad()
        tmpDicData=dicData
        self.title=loadLanguage("智能补水仪")
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        datePicker.isHidden=true
        currentSelected = -1
        //初始化数据
        timeLabel1.text = StringFromDateNumber(dicData?.object(forKey: "checktime1") as! Int)
        timeLabel2.text = StringFromDateNumber(dicData?.object(forKey: "checktime2") as! Int)
        timeLabel3.text = StringFromDateNumber(dicData?.object(forKey: "checktime3") as! Int)
        // Do any additional setup after loading the view.
    }

    func StringFromDateNumber(_ tempTime:Int)->String
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
            let alert=UIAlertView(title: "", message: loadLanguage("是否保存？"), delegate: self, cancelButtonTitle: loadLanguage("取消"), otherButtonTitles: loadLanguage("保存"))
            alert.show()
        }
        else
        {
            _ = navigationController?.popViewController(animated: true)
        }
        
    }
    func SaveClick()
    {
        if backClosure != nil
        {
            backClosure!(dicData!)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    //alert 点击事件
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.message==loadLanguage("是否保存？")
        {
            if buttonIndex==0
            {
                _ = navigationController?.popViewController(animated: true)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        self.navigationController?.isNavigationBarHidden=false
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
