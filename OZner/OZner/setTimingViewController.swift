//
//  setTimingViewController.swift
//  OZner
//
//  Created by test on 15/12/21.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setTimingViewController: UIViewController {

    var myCurrentDevice:OznerDevice?
    
    @IBOutlet var star_hour: UILabel!
    @IBOutlet var star_mins: UILabel!
    @IBOutlet var APorPM: UILabel!
 
    @IBOutlet weak var Trunon: UILabel!
    
    @IBOutlet weak var shutdown: UILabel!
    
    @IBOutlet weak var selecttime: UILabel!
 
    
    
    
    
    
    
    @IBAction func leftUPbutton(sender: AnyObject) {
        var tmp=Int(star_hour.text!)!+1
        if tmp==24
        {
            tmp=0
          star_hour.text="0\(tmp)"
        }else if tmp<10
        {
            star_hour.text="0\(tmp)"
        }
        else
        {
            star_hour.text="\(tmp)"
        }
        if tmp<=12
        {
            APorPM.text="AM"
        }
        else
        {
            APorPM.text="PM"
        }
    }
    @IBAction func rightUPButton(sender: AnyObject) {
        var tmp=Int(star_mins.text!)!+1
        if tmp==60
        {
            tmp=0
            star_mins.text="00"
        }else if tmp<10
        {
            star_mins.text="0\(tmp)"
        }
        else
        {
            star_mins.text="\(tmp)"
        }
      
    }
    @IBAction func leftDownButton(sender: AnyObject) {
        var tmp=Int(star_hour.text!)!-1
        if tmp == -1
        {
            tmp=23
            star_hour.text="23"
        }else if tmp<10
        {
            star_hour.text="0\(tmp)"
        }
        else
        {
            star_hour.text="\(tmp)"
        }
        if tmp<=12
        {
            APorPM.text="AM"
        }
        else
        {
            APorPM.text="PM"
        }
    }
    
    @IBAction func rightDownButton(sender: AnyObject) {
        var tmp=Int(star_mins.text!)!-1
        if tmp == -1
        {
            tmp=59
            star_mins.text="59"
        }else if tmp<10
        {
            star_mins.text="0\(tmp)"
        }
        else
        {
            star_mins.text="\(tmp)"
        }
    }
    @IBOutlet var end_hour: UILabel!
    @IBOutlet var end_mins: UILabel!
    @IBOutlet var endAPorPM: UILabel!
    
    @IBAction func endleftUPbutton(sender: AnyObject) {

        var tmp=Int(end_hour.text!)!+1
        if tmp==24
        {
            tmp=0
            end_hour.text="00"
        }else if tmp<10
        {
            end_hour.text="0\(tmp)"
        }
        else
        {
            end_hour.text="\(tmp)"
        }
        if tmp<=12
        {
            endAPorPM.text="AM"
        }
        else
        {
            endAPorPM.text="PM"
        }
    }
    @IBAction func endrightUPbutton(sender: AnyObject) {
        var tmp=Int(end_mins.text!)!+1
        if tmp==60
        {
            tmp=0
            end_mins.text="00"
        }else if tmp<10
        {
            end_mins.text="0\(tmp)"
        }
        else
        {
            end_mins.text="\(tmp)"
        }
    }
    @IBAction func endleftDownbutton(sender: AnyObject) {
        var tmp=Int(end_hour.text!)!-1
        if tmp == -1
        {
            tmp=23
            end_hour.text="23"
        }else if tmp<10
        {
            end_hour.text="0\(tmp)"
        }
        else
        {
            end_hour.text="\(tmp)"
        }
        if tmp<=12
        {
            endAPorPM.text="AM"
        }
        else
        {
            endAPorPM.text="PM"
        }
    }
    @IBAction func endrightDownbutton(sender: AnyObject) {
        var tmp=Int(end_mins.text!)!-1
        if tmp == -1
        {
            tmp=59
            end_mins.text="59"
        }else if tmp<10
        {
            end_mins.text="0\(tmp)"
        }
        else
        {
            end_mins.text="\(tmp)"
        }
    }
    
    @IBOutlet var weakView: UIView!
    let arrayWeek=["1":"一","2":"二","3":"三","4":"四","5":"五","6":"六","7":"日"]
    let sendairWeekValue:NSDictionary=["1":1,"2":2,"3":4,"4":8,"5":16,"6":32,"7":64]
    var weakbuttons=[UIButton]()
    let color_select=UIColor(red: 76/255, green: 152/255, blue: 1, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title="定时"
        Trunon.text = loadLanguage("开机时间");
        
        shutdown.text = loadLanguage("关机时间");
        
        selecttime.text = loadLanguage("选择周重复时间");
        
        
        let savebutton=UIBarButtonItem(title: "保存", style: .Plain, target: self, action: Selector("SaveClick"))
        self.navigationItem.rightBarButtonItem=savebutton
        var viewwidth:CGFloat=Screen_Width*36/375
        if viewwidth>36
        {
            viewwidth=36
        }
        let spacewidth:CGFloat=(Screen_Width-viewwidth*7)/8
        for i in 1...7
        {
            let  tmpbutton=UIButton(frame: CGRect(x: spacewidth*CGFloat(i)+viewwidth*CGFloat(i-1), y: (36-viewwidth)/2, width: viewwidth, height: viewwidth))
            tmpbutton.setTitle(arrayWeek["\(i)"], forState: .Normal)
            tmpbutton.setTitleColor(color_select, forState: .Normal)
            tmpbutton.backgroundColor=UIColor.whiteColor()
            tmpbutton.layer.borderWidth=1
            tmpbutton.layer.cornerRadius=viewwidth/2
            
            tmpbutton.tag=0//0未选中 1选中
            tmpbutton.layer.borderColor=color_select.CGColor
            tmpbutton.addTarget(self, action: Selector("weakClick:"), forControlEvents: .TouchUpInside)
            weakView.addSubview(tmpbutton)
            weakbuttons.append(tmpbutton)
        }
        loadDataFromLocal()
        // Do any additional setup after loading the view.
    }

    func SaveClick(){
     
        if self.myCurrentDevice==nil&&AirPurifierManager.isMXChipAirPurifier(self.myCurrentDevice?.type)==false
        {
            let alert=UIAlertView(title: "", message: "保存失败，未连接设备!", delegate: self, cancelButtonTitle: "ok")
            alert.show()
            return
        }
        let airPurifier_MxChip = self.myCurrentDevice as! AirPurifier_MxChip
        airPurifier_MxChip.powerTimer.powerOnTime=Int32(star_hour.text!)!*3600+Int32(star_mins.text!)!*60
        airPurifier_MxChip.powerTimer.powerOffTime=Int32(end_hour.text!)!*3600+Int32(end_mins.text!)!*60
        print(airPurifier_MxChip.powerTimer.powerOnTime)
        print(airPurifier_MxChip.powerTimer.powerOffTime)
        var tmpweek:Int=0
        for i in 1...7
        {
            if weakbuttons[i-1].tag==1
            {
                tmpweek+=sendairWeekValue.objectForKey("\(i)") as! Int
                
            }
        }
        airPurifier_MxChip.powerTimer.week=Int32(tmpweek)
        airPurifier_MxChip.powerTimer.enable=true
        OznerManager.instance().save(myCurrentDevice) { (error:NSError!) -> Void in
            print("保存失败！")
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func weakClick(button:UIButton){
        button.tag=button.tag==0 ? 1:0
        button.setTitleColor(button.tag==0 ? color_select:UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor=button.tag==0 ? UIColor.whiteColor():color_select
    }
    
    func loadDataFromLocal() {
        if self.myCurrentDevice==nil
        {
            return
        }
        let airPurifier_MxChip = self.myCurrentDevice as! AirPurifier_MxChip
        var startimetmp=airPurifier_MxChip.powerTimer.powerOnTime
        star_hour.text = (startimetmp/3600)<10 ? "0\(startimetmp/3600)":"\(startimetmp/3600)"
        startimetmp=airPurifier_MxChip.powerTimer.powerOnTime%3600/60
        star_mins.text = startimetmp<10 ? "0\(startimetmp)":"\(startimetmp)"
        startimetmp=airPurifier_MxChip.powerTimer.powerOffTime
        end_hour.text = (startimetmp/3600)<10 ? "0\(startimetmp/3600)":"\(startimetmp/3600)"
        startimetmp=airPurifier_MxChip.powerTimer.powerOffTime%3600/60
        end_mins.text = startimetmp<10 ? "0\(startimetmp)":"\(startimetmp)"
        let weekon:Int32=airPurifier_MxChip.powerTimer.week
        for i in 1...7
        {
           
            if (Int((sendairWeekValue.objectForKey("\(i)") as! Int)^Int(weekon))) < Int(weekon)
            {
                weakClick(weakbuttons[i-1])
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
