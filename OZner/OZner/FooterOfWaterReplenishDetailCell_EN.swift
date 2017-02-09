//
//  FooterOfWaterReplenishDetailCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
//key:"0",脸，key:"1",眼，key:"2",手，key:"3",颈
class FooterOfWaterReplenishDetailCell_EN: UITableViewCell,HeadOfWaterReplenishDetailCell_ENDelegate {

    @IBOutlet weak var organLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var chartContainerView: UIView!
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        drawChartView(sender.selectedSegmentIndex)
    }
    @IBOutlet weak var toWhatWater: UIButton!
    @IBOutlet weak var toWhatYoufen: UIButton!
    
    @IBOutlet weak var toChatButton: UIButton!
    @IBOutlet weak var toBuyEssence: UIButton!
    
    @IBOutlet weak var tixingLb: UILabel!
    @IBOutlet weak var biaozhunLb: UILabel!
    @IBOutlet weak var shuifenlb: UILabel!
    @IBOutlet weak var youfenLb: UILabel!
    
    @IBOutlet weak var goumaiLb: UILabel!
    @IBOutlet weak var zixunlb: UILabel!
    @IBOutlet weak var zixunHideView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        segmentControl.setTitle(loadLanguage("周"), forSegmentAtIndex: 0)
        segmentControl.setTitle(loadLanguage("月"), forSegmentAtIndex: 1)
        youfenLb.text = loadLanguage("油分")
        shuifenlb.text = loadLanguage("水分")
        biaozhunLb.text = loadLanguage("水润标准")
        tixingLb.text = loadLanguage("您本周的皮肤水分偏离正常，请及时保湿补水。")
        zixunlb.text = loadLanguage("咨询")
        goumaiLb.text = loadLanguage("购买精华水")
        
        if  !(loadLanguage("CurrentLanguage") == "CN"){
            zixunlb.font = UIFont.systemFontOfSize(11)
            goumaiLb.font = UIFont.systemFontOfSize(11)
            goumaiLb.numberOfLines = 0
        } else {
            zixunlb.font=UIFont.systemFontOfSize(17)
            goumaiLb.font=UIFont.systemFontOfSize(17)
        }
        
        if  (NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_LOGIN_STYLE) as! NSString).isEqualToString(LoginByPhone){
            zixunHideView.hidden = false
        } else {
            zixunHideView.hidden = true

        }
        
    }
    
    /**
     HeadOfWaterReplenishDetailCellDelegate代理方法
     设置当前选中器官
     - parameter organ: 当前器官
     */
    
    func setCurrentOrgan(organ: Int) {
        currentOrgan=organ
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
//    /**
//    器官部位切换用这个方法
//    
//    - parameter Organ: 器官对应得数字
//    */
//    func updateCellData(Organ:Int)
//    {
//        currentOrgan=Organ
//    }
    private var currentOrgan = -1 {
        didSet{
            
            if currentOrgan==oldValue||currentOrgan<0||currentOrgan>3
            {
                return
            }
            organLabel.text=[loadLanguage("脸部"),loadLanguage("眼部"),loadLanguage("手部"),loadLanguage("颈部")][currentOrgan]
   
            drawChartView(segmentControl.selectedSegmentIndex)
            
        }
    }
    //key:"0",脸，key:"1",眼，key:"2",手，key:"3",颈
    private var weekArray=NSMutableDictionary()
    private var monthArray=NSMutableDictionary()
    /**
     初始化时，传入器官和周月数据
     
     - parameter weekArr:  周数据
     - parameter monthArr: 月数据
     - parameter Organ:    器官对应得数字
     */
    func updateCellData(weekArr:NSMutableDictionary,monthArr:NSMutableDictionary,Organ:Int)
    {
        weekArray=weekArr
        monthArray=monthArr
        currentOrgan=Organ
    }
    
    
    /**
     绘制折线图
     - parameter dateType: 0 周，1 月
     */
    private func drawChartView(dateType:Int)
    {
        for view in chartContainerView.subviews
        {
            view.removeFromSuperview()
        }
        let tmpWeek = weekArray.objectForKey("\(currentOrgan)") ?? [AnyObject]()
        let tmpMonth = monthArray.objectForKey("\(currentOrgan)") ?? [AnyObject]()
        let tmpArr =  dateType==0 ? tmpWeek:tmpMonth
        
        let lineView=waterReplenishChartView_EN()
        lineView.drawLineView(Int32(dateType), dataArr: tmpArr as! [AnyObject])
        chartContainerView.addSubview(lineView)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    
}
