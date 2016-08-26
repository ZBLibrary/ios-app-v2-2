//
//  OffLineSuggestView.swift
//  OZner
//
//  Created by 赵兵 on 16/5/6.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class OffLineSuggestView_EN: UIView {

    @IBOutlet weak var thirdItem: UIView!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var IKnowButton: UIButton!
    @IBOutlet var thirdLabel: UILabel!
    
    @IBOutlet weak var thirdItem_Height: NSLayoutConstraint!
    
    var isAir = true{
        didSet{
            if isAir==false {
                thirdItem_Height.constant=0
                fourthLabel.text=loadLanguage("3.如仍无法连接设备，请在设置中删除此设备，重新配对")
            }
            else{
                thirdItem_Height.constant=44
                fourthLabel.text=loadLanguage("4.如仍无法连接设备，请在设置中删除此设备，重新配对")
            }
        }
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // 创建一个富文本
        //同时按下电源和风速，WIFI指示灯闪烁，重新配对
        
        let attri1 = NSMutableAttributedString(string: loadLanguage("3.同时按下"))
        let attri2 = NSAttributedString(string: loadLanguage("，WIFI指示灯闪烁，重新配对"))
        let attri3 = NSAttributedString(string: loadLanguage("和"))
        let image1 = NSTextAttachment()
        image1.image=UIImage(named: "airPowerIcon")
        image1.bounds=CGRectMake(0, -6, 22, 22)
        let str1=NSAttributedString(attachment: image1)
        let image2 = NSTextAttachment()
        image2.image=UIImage(named: "airSpeedIcon")
        image2.bounds=CGRectMake(0, -6, 22, 22)
        let str2=NSAttributedString(attachment: image2)
        attri1.appendAttributedString(str1)
        attri1.appendAttributedString(attri3)
        attri1.appendAttributedString(str2)
        attri1.appendAttributedString(attri2)
        thirdLabel.attributedText=attri1
    }
 

}
