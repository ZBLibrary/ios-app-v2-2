//
//  HeadOfWaterReplenishDetailCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
protocol HeadOfWaterReplenishDetailCellDelegate
{
    func setCurrentOrgan(organ:Int)
}
struct HeadOfWaterReplenishStruct {
    var skinValueOfToday:Int=0
    var lastSkinValue:Double=0
    var averageSkinValue:Double=0
    var checkTimes=0
}
class HeadOfWaterReplenishDetailCell: UITableViewCell {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var organImg1: UIImageView!
    @IBOutlet weak var organImg2: UIImageView!
    @IBOutlet weak var organImg3: UIImageView!
    @IBOutlet weak var organImg4: UIImageView!
    
    
    @IBAction func organButton1(sender: UIButton) {
        currentOrgan=0
    }
    @IBAction func organButton2(sender: UIButton) {
        currentOrgan=1
    }
    @IBAction func organButton3(sender: UIButton) {
        currentOrgan=2
    }
    @IBAction func organButton4(sender: UIButton) {
        currentOrgan=3
    }
   
    @IBOutlet weak var skinStateOfToday: UILabel!
    @IBOutlet weak var descOfSkinState: UILabel!
    
    @IBOutlet weak var lastCheckValue: UILabel!
    @IBOutlet weak var averageCheckValue: UILabel!
    
    // delege
    var delegate:HeadOfWaterReplenishDetailCellDelegate?
    //当前选中器官
    private var currentOrgan = -1{
        didSet{
            
            if currentOrgan==oldValue
            {
                return
            }
            let tmpName=NSString(format: "WaterReplDetail%d", currentOrgan+1) as String
            //print(tmpName)
            //print(currentOrgan)
            //print(oldValue)
            //organImg1.image=UIImage(named: "WaterReplDetail1.1")
            [organImg1,organImg2,organImg3,organImg4][currentOrgan].image=UIImage(named: "\(tmpName)_1")
    
            if oldValue != -1
            {
                let tmpNameOld=NSString(format: "WaterReplDetail%d", oldValue+1) as String
                [organImg1,organImg2,organImg3,organImg4][oldValue].image=UIImage(named: tmpNameOld)
            }
            let tmpStru=dataDic["\(currentOrgan)"]
            skinStateOfToday.text=NSString(format: "%d", (tmpStru?.skinValueOfToday)!) as String
            descOfSkinState.text="今日肌肤状态  "+["干燥","正常","水润","水润"][(tmpStru?.skinValueOfToday)!/33]
            lastCheckValue.text="上次检测"+(NSString(format: "%.1f", (tmpStru?.lastSkinValue)!) as String)+"%"
            averageCheckValue.text="平均值"+(NSString(format: "%.1f", (tmpStru?.averageSkinValue)!) as String)+"%("+(NSString(format: "%d", (tmpStru?.checkTimes)!) as String)+"次)"
            delegate?.setCurrentOrgan(currentOrgan)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    //key:"0"
    var dataDic=[String:HeadOfWaterReplenishStruct]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //测试数据
        for i in 0...3
        {
            let tmpStru=HeadOfWaterReplenishStruct(skinValueOfToday: 30*i, lastSkinValue: Double(71*i*i*i%100), averageSkinValue: Double(71*i*i*i%100), checkTimes: i*i*12+i*5)
            dataDic["\(i)"]=tmpStru
        }
        print(dataDic.count)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
