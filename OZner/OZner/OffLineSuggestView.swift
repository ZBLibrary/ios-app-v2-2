//
//  OffLineSuggestView.swift
//  OZner
//
//  Created by 赵兵 on 16/5/6.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class OffLineSuggestView: UIView {

    @IBOutlet weak var thirdItem: UIView!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var IKnowButton: UIButton!
    
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
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
