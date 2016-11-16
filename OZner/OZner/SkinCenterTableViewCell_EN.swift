//
//  SkinCenterTableViewCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SkinCenterTableViewCell_EN: UITableViewCell {

    @IBOutlet weak var timesOfTest: UILabel!
    @IBOutlet weak var stateOfTest: UILabel!
    @IBOutlet weak var dateOfTest: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /**
     更新数据
     
     - parameter times: 检测次数
     - parameter Date:  统计时间
     */
    func updateData(times:Int,Date:String)
    {
        print(times)
        timesOfTest.text = times<45 ? "\(times)":"\(times)"
        stateOfTest.text = loadLanguage("温馨提示：肤质评估仅供参考，涂抹化妆品及其他护理后会影响检测结果")
        dateOfTest.text="\("统计时间"):"+Date
    }
}
