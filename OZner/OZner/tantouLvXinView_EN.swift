//
//  tantouLvXinView.swift
//  OZner
//
//  Created by test on 16/1/19.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class tantouLvXinView_EN: UIView {

    @IBOutlet var lvXinImg: UIImageView!
    @IBOutlet var LvXinDay: UILabel!
    @IBOutlet var LvXinBaiFen: UILabel!
    @IBOutlet var starYear: UILabel!
    @IBOutlet var starMonDay: UILabel!
    @IBOutlet var endYear: UILabel!
    @IBOutlet var endMonDay: UILabel!
    @IBOutlet var jindu100JuLeft: NSLayoutConstraint!
    @IBOutlet var currentDateJuLeft: NSLayoutConstraint!
    @IBOutlet var curYear: UILabel!
    @IBOutlet var curMonDay: UILabel!
    @IBOutlet var zixunView: UIView!
    @IBOutlet var zixunButton: UIButton!
    @IBOutlet var buyLXView: UIView!
    @IBOutlet var buyLXButton: UIButton!
    @IBOutlet var saoMaView: UIView!
    @IBOutlet var saoMaButton: UIButton!
    //更多产品
    @IBOutlet var MoreDeviceButton1: UIButton!
    @IBOutlet var MoreDeviceButton2: UIButton!
    @IBOutlet var MoreDeviceButton3: UIButton!
    
    @IBOutlet var ErWeiMaContainView: UIView!
    //滤芯使用开始时间
    @IBOutlet var chatAndBuyContainer: UIView!
    var maxUserDay:Int=365//净水器365，探头30
    var starDate=""{
        didSet{
            
            if starDate != ""
            {
                print(starDate)
                //let tmp=starDate.characters.split(" ") as NSArray
                //print(tmp.ob)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.dateFromString(starDate)! as NSDate
                let tmpTime=date.timeIntervalSince1970+3600*24*Double(maxUserDay)
                let endDate = NSDate(timeIntervalSince1970: tmpTime)
                dateFormatter.dateFormat="yyyy-MM-dd"
                let nowStr=dateFormatter.stringFromDate(NSDate())
                var tmparray = nowStr.componentsSeparatedByString("-") as NSArray
                curYear.text=tmparray.objectAtIndex(0) as? String
                curMonDay.text=(tmparray.objectAtIndex(1) as? String)!+"-"+(tmparray.objectAtIndex(2) as! String)
                
                let starStr=dateFormatter.stringFromDate(date)
                tmparray = starStr.componentsSeparatedByString("-") as NSArray
                starYear.text=tmparray.objectAtIndex(0) as? String
                starMonDay.text=(tmparray.objectAtIndex(1) as? String)!+"-"+(tmparray.objectAtIndex(2) as! String)
                let endDateStr = dateFormatter.stringFromDate(endDate)
       
                tmparray = endDateStr.componentsSeparatedByString("-") as NSArray
                endYear.text=tmparray.objectAtIndex(0) as? String
                endMonDay.text=(tmparray.objectAtIndex(1) as? String)!+"-"+(tmparray.objectAtIndex(2) as! String)
                
            }
        }
    }
    var useDay=0{
        didSet{
            let remindDay=(maxUserDay-useDay)>0 ? (maxUserDay-useDay):0
            LvXinDay.text="\(remindDay)"
            LvXinBaiFen.text="\(Int(ceil(100.0*Float(remindDay)/Float(maxUserDay))))"
            jindu100JuLeft.constant=CGFloat(maxUserDay-remindDay)/CGFloat(maxUserDay)*(Screen_Width-84)+42
            currentDateJuLeft.constant=CGFloat(maxUserDay-remindDay)/CGFloat(maxUserDay)*(Screen_Width-84)+28
            if LvXinBaiFen.text=="0"&&(maxUserDay-useDay)>0
            {
                LvXinBaiFen.text="1"
            }

        }
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        MoreDeviceButton1.tag=1
        MoreDeviceButton2.tag=2
        MoreDeviceButton3.tag=3
        // Drawing code
        
        print("kkkkkkkkkkkk:\(IsLoginByPhone())")
       // chatAndBuyContainer.hidden = !IsLoginByPhone()
        MoreDeviceButton1.enabled = IsLoginByPhone()
        MoreDeviceButton2.enabled = IsLoginByPhone()
        MoreDeviceButton3.enabled = IsLoginByPhone()


        zixunView.layer.borderWidth=0.5
        zixunView.layer.borderColor=UIColor(red: 0, green: 119/255, blue: 247/255, alpha: 1).CGColor
        buyLXView.layer.cornerRadius=20
        buyLXView.layer.borderWidth=0.5
        buyLXView.layer.borderColor=UIColor(red: 0, green: 119/255, blue: 247/255, alpha: 1).CGColor
        saoMaView.layer.borderWidth=0.5
        saoMaView.layer.borderColor=UIColor(red: 0, green: 119/255, blue: 247/255, alpha: 1).CGColor
        
    }
    

}
