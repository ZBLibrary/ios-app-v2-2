//
//  indoorAirXib.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class indoorAirXib: UIView {

    
    @IBOutlet weak var indoorAir: UILabel!
    
    @IBOutlet weak var airpuifiler: UILabel!
    
    @IBOutlet weak var filter: UILabel!
    
    @IBOutlet weak var Tips: UILabel!
   
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headView: UIView!
    
    @IBOutlet var airTotal: UILabel!
    @IBOutlet var lvxinState: UILabel!
    
    @IBOutlet var stateImage_0: UIImageView!
    @IBOutlet var curDateViewtoLeft: NSLayoutConstraint!//20
    //starDate
    @IBOutlet var starYear: UILabel!
    @IBOutlet var starDate: UILabel!
    
    //endDate
    @IBOutlet var endYear: UILabel!
    @IBOutlet var endDate: UILabel!
    
    //curDate
    @IBOutlet var curYear: UILabel!
    @IBOutlet var curDate: UILabel!
    
    
    @IBOutlet var state_down: UIImageView!
    
    @IBOutlet var BugLvXinbutton: UIButton!
    
    @IBOutlet var toChat: UIButton!
    var starDatazb=""{
        didSet{
            if starDatazb != ""
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.dateFromString(starDatazb)! as NSDate
                let tmpTime=date.timeIntervalSince1970+3600*24*365
                let endDateTime = NSDate(timeIntervalSince1970: tmpTime)
                dateFormatter.dateFormat="yyyy-MM-dd"
                
                let starStr=dateFormatter.stringFromDate(date)
                var tmparray = starStr.componentsSeparatedByString("-") as NSArray
                starYear.text=tmparray.objectAtIndex(0) as? String
                starDate.text=(tmparray.objectAtIndex(1) as? String)!+"-"+(tmparray.objectAtIndex(2) as! String)
                let endDateStr = dateFormatter.stringFromDate(endDateTime)
                
                tmparray = endDateStr.componentsSeparatedByString("-") as NSArray
                endYear.text=tmparray.objectAtIndex(0) as? String
                endDate.text=(tmparray.objectAtIndex(1) as? String)!+"-"+(tmparray.objectAtIndex(2) as! String)
                
            }
        }
    }


    var state=0 {
        didSet{
            lvxinState.text="\(state)"
            print(state)
            let tmpframe=stateImage_0.frame
            stateImage_0.frame=CGRect(x: tmpframe.origin.x, y: tmpframe.origin.y, width: (Screen_Width-80)*CGFloat(100-state)/100, height: tmpframe.size.height)
            print(stateImage_0.frame.width)
            state_down.frame=CGRect(x: 36+(Screen_Width-80)*CGFloat(100-state)/100, y: state_down.frame.origin.y, width: state_down.frame.size.width, height: state_down.frame.size.height)
            curDateViewtoLeft.constant=(Screen_Width-80)*CGFloat(100-state)/100+20
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
        //当前日期
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        let nowStr=dateFormatter.stringFromDate(NSDate())
        let tmparray = nowStr.componentsSeparatedByString("-") as NSArray
        curYear.text=tmparray.objectAtIndex(0) as? String
        curDate.text=(tmparray.objectAtIndex(1) as? String)!+"-"+(tmparray.objectAtIndex(2) as! String)
        
    }
   

}
