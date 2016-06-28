//
//  WaterPurTDSDetailCell2.swift
//  OZner
//
//  Created by 赵兵 on 16/2/18.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class WaterPurTDSDetailCell2_EN: UITableViewCell {

    @IBOutlet var segmentControl: UISegmentedControl!
    @IBAction func segmentClick(sender: UISegmentedControl) {
        updateChartView(sender.selectedSegmentIndex)
    }
    //折线图容器
    @IBOutlet var lineChartContainerView: UIView!
    var weekArray=NSArray()
    var monthArray=NSArray()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        segmentControl.layer.cornerRadius=12.5
        segmentControl.layer.borderWidth=1
        segmentControl.layer.borderColor=UIColor(red: 56/255, green: 127/255, blue: 247/255, alpha: 1).CGColor
        segmentControl.layer.masksToBounds=true
        updateChartView(0)
    }
    
    //dateType:0 week,1 month
    func updateChartView(dateType:Int)
    {
        for view in lineChartContainerView.subviews
        {
            view.removeFromSuperview()
        }
        let lineView=WaterineChartView_EN()
        print(weekArray)
        print(monthArray)
        lineView.drawLineView(Int32(dateType), dataArr: (dateType==0 ? weekArray:monthArray) as [AnyObject])
        lineChartContainerView.addSubview(lineView)
        setNeedsLayout()
        layoutIfNeeded()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
