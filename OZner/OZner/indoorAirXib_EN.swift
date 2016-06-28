//
//  indoorAirXib.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class indoorAirXib_EN: UIView {

    
    @IBOutlet weak var indoorAir: UILabel!
    
    @IBOutlet weak var airpuifiler: UILabel!
    
    @IBOutlet weak var filter: UILabel!
    
    @IBOutlet weak var Tips: UILabel!
   
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headView: UIView!
    
    @IBOutlet var airTotal: UILabel!
    @IBOutlet var lvxinState: UILabel!
    
    
    @IBOutlet weak var downImgLeft: NSLayoutConstraint!
    @IBOutlet var curDateViewtoLeft: NSLayoutConstraint!//20
    @IBOutlet weak var Image0Width: NSLayoutConstraint!
    //starDate
    @IBOutlet var starYear: UILabel!
    @IBOutlet var starDate: UILabel!
    
    //endDate
    @IBOutlet var endYear: UILabel!
    @IBOutlet var endDate: UILabel!
    
    //curDate
    @IBOutlet var curYear: UILabel!
    @IBOutlet var curDate: UILabel!
    
    //台式空净需要的
    //var airPurifier_Bluetooth:AirPurifier_Bluetooth?
    
    @IBOutlet weak var reSetLvXinButton: UIButton!
    
    
    @IBOutlet var BugLvXinbutton: UIButton!
    
    @IBOutlet var toChat: UIButton!
    var starDatazb=""{
        didSet{
            if starDatazb != ""
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.dateFromString(starDatazb)! as NSDate
                //let tmpTime=date.timeIntervalSince1970+3600*24*90
                let endDateTime = date+3.months//NSDate(timeIntervalSince1970: tmpTime)
                dateFormatter.dateFormat="yyyy-MM-dd"
                
                let starStr=dateFormatter.stringFromDate(date)
                var tmparray = starStr.componentsSeparatedByString("-") as NSArray
                starYear.text=tmparray.objectAtIndex(0) as? String
                starDate.text=(tmparray.objectAtIndex(1) as? String)!+"-"+(tmparray.objectAtIndex(2) as! String)
                let endDateStr = dateFormatter.stringFromDate(endDateTime)
                
                tmparray = endDateStr.componentsSeparatedByString("-") as NSArray
                endYear.text=tmparray.objectAtIndex(0) as? String
                endDate.text=(tmparray.objectAtIndex(1) as? String)!+"-"+(tmparray.objectAtIndex(2) as! String)
                //当前日期
                let nowStr=dateFormatter.stringFromDate(NSDate())
                let tmpNowArray = nowStr.componentsSeparatedByString("-") as NSArray
                curYear.text=tmpNowArray.objectAtIndex(0) as? String
                curDate.text=(tmpNowArray.objectAtIndex(1) as? String)!+"-"+(tmpNowArray.objectAtIndex(2) as! String)
                setNeedsLayout()
                layoutIfNeeded()
                
            }
            else
            {
                starYear.text=""
                starDate.text=""
                endYear.text=""
                endDate.text=""
                curYear.text=""
                curDate.text=""
            }
        }
    }


    var state=0 {
        didSet{
            
            lvxinState.text="\(min(state, 100))"
            print(state)
            Image0Width.constant=(Screen_Width-80)*CGFloat(100-min(state, 100))/100
            downImgLeft.constant=36+(Screen_Width-80)*CGFloat(100-min(state, 100))/100
            
            curDateViewtoLeft.constant=(Screen_Width-80)*CGFloat(100-min(state, 100))/100+20
            setNeedsLayout()
            layoutIfNeeded()
        }
    } //0-100
    @IBOutlet var smallairHidenView: UIView!
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        indoorAir.text = loadLanguage("室内空气质量详情");
        
        airpuifiler.text = loadLanguage("空气净化器当前总净化量");
        filter.text = loadLanguage("滤芯还剩");
        Tips.text = loadLanguage("温馨提示:及时更换滤芯,享纯净空气");
        
        
    }
   

}
