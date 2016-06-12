//
//  CenterChartCell.swift
//  OZner
//
//  Created by test on 16/1/20.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class CenterChartCell: UITableViewCell {

    
    var myCurrentDevice:Cup!
    //0代表TDS，1代表水温
    var cellType=0{
        didSet{
            cellTitle.text=cellType==0 ? TDSTitle[segmentSelectIndex]:TempTitle[segmentSelectIndex]
        }
    }
    //0代表圆环视图，1代表折线视图
    var ChartType=0{
        didSet{
            
            cicleChartView.hidden=ChartType==0 ? false:true
            lineChartView.hidden=ChartType==1 ? false:true
            segmentSelectIndex=segmentControl.selectedSegmentIndex
        }
    }
    //折线图View
    var lineChartView:UIView!
    //圆环View
    @IBOutlet var cicleChartView: UIView!
    //圆图，折线图容器
    @IBOutlet var chartContainBG: UIView!
    //cell标题
    @IBOutlet var cellTitle: UILabel!
    //SegmentedControl
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBAction func segmentClick(sender: AnyObject) {
        segmentSelectIndex=segmentControl.selectedSegmentIndex
    }
    
    @IBOutlet var circleBGViewzb: drawCircleView!
    @IBOutlet var state1Label: UILabel!
    @IBOutlet var state2Label: UILabel!
    @IBOutlet var state3Label: UILabel!
    @IBOutlet var leftButton: UIButton!
    //圆环左按钮事件
    @IBAction func circleLeftClick(sender: AnyObject) {
        segmentSelectIndex=segmentControl.selectedSegmentIndex-1;
    }
    
    @IBOutlet var leftImg: UIImageView!
    @IBOutlet var chartButton: UIButton!
    //点击圆环事件
    @IBAction func circleClick(sender: AnyObject) {
        ChartType=1
    }
    @IBOutlet var rightButton: UIButton!
    //圆环右边按钮事件
    @IBAction func circleRightClick(sender: AnyObject) {
        
        segmentSelectIndex=segmentControl.selectedSegmentIndex+1;
    }
    @IBOutlet var rightImg: UIImageView!
    let TDSTitle=[loadLanguage("今日饮水纯净指数分布"),loadLanguage("本周饮水纯净指数分布"),loadLanguage("本月饮水纯净指数分布")]
    var TempTitle=[loadLanguage("今日饮水水温分布"),loadLanguage("本周饮水水温分布"),loadLanguage("本月饮水水温分布")]
    var segmentSelectIndex=0{
        didSet{
            
            let tmp=segmentSelectIndex<0 ? 0:segmentSelectIndex
            segmentControl.selectedSegmentIndex=tmp>2 ? 2:tmp
            cellTitle.text=cellType==0 ? TDSTitle[segmentControl.selectedSegmentIndex]:TempTitle[segmentControl.selectedSegmentIndex]
            let rmpData=getDataSource(segmentControl.selectedSegmentIndex)
            
            if ChartType==0
            {
                
                leftImg.hidden=false
                leftButton.enabled=true
                rightImg.hidden=false
                rightButton.enabled=true
                if segmentSelectIndex<=0
                {
                    leftImg.hidden=true
                    leftButton.enabled=false
                }
                if segmentSelectIndex>=2
                {
                    rightImg.hidden=true
                    rightButton.enabled=false
                }
                //重绘圆环
                if rmpData.record.Count>0
                {
                    let totalCount=Float(rmpData.record.Count)
                    let tmp1=cellType==0 ? Float(rmpData.record.TDS_Good)/totalCount:Float(rmpData.record.Temperature_Low)/totalCount
                    var tmp2=cellType==0 ? Float(rmpData.record.TDS_Mid)/totalCount:Float(rmpData.record.Temperature_Mid)/totalCount
                    
                    let tmp3=cellType==0 ? Float(rmpData.record.TDS_Bad)/totalCount:Float(rmpData.record.Temperature_High)/totalCount
                    var tmp3need=0
                    if (100-Int(tmp1*100)-Int(tmp2*100))==1&&tmp3==0
                    {
                        tmp3need=0
                        tmp2+=0.01
                    }
                    else
                    {
                        tmp3need=100-Int(tmp1*100)-Int(tmp2*100)
                    }
                   updateCircleView(tmp3need, state2: Int(tmp2*100), state3: Int(tmp1*100))
                }
                else
                {
                    updateCircleView(0, state2: 0, state3: 0)
                }
            }
            else
            {
                //重绘折线
                updateLineView(segmentControl.selectedSegmentIndex, array: rmpData.arr, Record: rmpData.record)
            }
            
        }
    }
    //cell初始化
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentControl.layer.cornerRadius=12.5
        segmentControl.layer.borderWidth=1
        segmentControl.layer.borderColor=UIColor(red: 56/255, green: 127/255, blue: 247/255, alpha: 1).CGColor
        segmentControl.layer.masksToBounds=true
        
        
        //折线图点击事件
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(lineChartClick))
        lineChartView=UIView(frame: CGRect(x: 0, y: (chartContainBG.height-150)/2, width: Screen_Width, height: 150))
        //lineChartView.backgroundColor=UIColor.redColor()
        lineChartView.addGestureRecognizer(tapGest)
        chartContainBG.addSubview(lineChartView)
        
        ChartType=0
        
        
    }
    //折线图点击事件
    func lineChartClick()
    {
        ChartType=0
    }
    //圆环更新方法
    func updateCircleView(state1:Int,state2:Int,state3:Int)
    {//type 0 TDS,1 温度
        state1Label.text=cellType==0 ? "\(loadLanguage("较差")) \(state1)%":"\(loadLanguage("偏烫")) \(state1)%"
        state2Label.text=cellType==0 ? "\(loadLanguage("一般")) \(state2)%":"\(loadLanguage("适中")) \(state2)%"
        state3Label.text=cellType==0 ? "\(loadLanguage("健康")) \(state3)%":"\(loadLanguage("偏凉")) \(state3)%"
        
        state2Label.textColor=cellType==0 ? UIColor.init(red: 128/255, green: 94/255, blue: 230/255, alpha: 1):UIColor(red: 242/255, green: 134/255, blue: 82/255, alpha: 1)
        
        circleBGViewzb.type=cellType
        circleBGViewzb.state1=state1
        circleBGViewzb.state2=state2
        circleBGViewzb.state3=state3
        circleBGViewzb.setCircle()
    }
    //折线更新方法 type:0 日,1 周,2 月
    func updateLineView(type:Int,array:NSArray,Record:CupRecord)
    {
        
        for view in lineChartView.subviews
        {
            view.removeFromSuperview()
        }
        let lineView=lineChartViewzb()
        lineView.drawLineView(Int32(cellType),dateType: Int32(type), dataArrzb: array as [AnyObject], recordzb: Record)
        lineChartView.addSubview(lineView)
    }
    //dateType：0天,1周,2月
    func getDataSource(dateType:Int)->(arr:NSArray,record:CupRecord)
    {
        if(self.myCurrentDevice != nil&&(self.myCurrentDevice?.isKindOfClass(Cup.classForCoder())) != false)
        {
            let cup = self.myCurrentDevice
            //取今天的零点
            //去今天的0点时间
            let date1 = NSDate()
            
            let zone = NSTimeZone.systemTimeZone()
            
            let interval = NSTimeInterval(zone.secondsFromGMTForDate(date1))
            let localeDate = date1.dateByAddingTimeInterval(interval)
            
            let date=NSDate(timeIntervalSince1970: NSTimeInterval(Int(localeDate.timeIntervalSince1970)/86400*86400)) as NSDate
            
             if cup.volumes.isKindOfClass(NSNull)||cup.volumes==nil
             {
                return (NSArray(),CupRecord())
            }
                if dateType==0
                {
                    //取这个天的
                    let dataArr = sortUpdateTime(cup.volumes.getRecordByDate(date, interval: Hour)) as NSArray
                    
                    let todayRecord =   cup.volumes.getRecordByDate(date) //as CupRecord
                    if todayRecord==nil
                    {
                        return (NSArray(),CupRecord())
                    }
                    return (dataArr,todayRecord)       
                    
                }
                else if dateType==1
                {
                    //取这个星期
                    var weekFirstDay = UToolBox.dateStartOfWeek(NSDate()) as NSDate
                    let dayZeor = (Int(weekFirstDay.timeIntervalSince1970))/86400*86400
                    weekFirstDay = NSDate(timeIntervalSince1970: NSTimeInterval(dayZeor))
                    let weekArr = sortUpdateTime(cup.volumes.getRecordByDate(weekFirstDay, interval: Day))
                    let weekRecord = cup.volumes.getRecordByDate(weekFirstDay)

                    if weekRecord==nil
                    {
                        return (NSArray(),CupRecord())
                    }
                    return (weekArr,weekRecord)
                    
                }else
                {
                    //取这个月的
                    var monthFirstDay = UToolBox.dateStartOfMonth(NSDate())  as NSDate
                    let monthZeor = Int(monthFirstDay.timeIntervalSince1970)/86400*86400
                    monthFirstDay = NSDate(timeIntervalSince1970: NSTimeInterval(monthZeor))
                    let monthArr = sortUpdateTime(cup.volumes.getRecordByDate(monthFirstDay, interval: Day))
                    let monthRecord = cup.volumes.getRecordByDate(monthFirstDay)
                    if monthRecord==nil
                    {
                        return (NSArray(),CupRecord())
                    }
                    return (monthArr,monthRecord)
                    
                }
            
            
        
        }else
        {
            return (NSArray(),CupRecord())
        }
    
    }
    
    //找出最大的updatetime
    func sortUpdateTime(arr:NSArray)->NSArray
    {
        //NSComparator
        let cmptr=(arr as! [CupRecord]).sort({ (obj1: CupRecord!, obj2: CupRecord!) -> Bool in
            return obj1.start.timeIntervalSince1970 < obj2.start.timeIntervalSince1970
        })
//        let cmptr:NSComparator = {(obj1:CupRecord!,obj2:CupRecord!)->(NSComparisonResult!) in
//            if ([obj1.start timeIntervalSince1970] > [obj2.start timeIntervalSince1970])
//            {
//                return (NSComparisonResult)NSOrderedDescending;
//            }
//            
//            if ([obj1.start timeIntervalSince1970] < [obj2.start timeIntervalSince1970])
//            {
//                return (NSComparisonResult)NSOrderedAscending;
//            }
//            return (NSComparisonResult)NSOrderedSame;
//        }
        
        //NSArray* muArr = [arr sortedArrayUsingComparator:cmptr];
        //return muArr;
        return cmptr
    
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
