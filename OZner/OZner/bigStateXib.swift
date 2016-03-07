//
//  bigStateXib.swift
//  OZner
//
//  Created by test on 15/12/24.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class bigStateXib: UIView {

    @IBOutlet var VOC: UILabel!//voc
    @IBOutlet var teampre: UILabel!//温度
    @IBOutlet var himida: UILabel!//湿度
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    func updatelayout()
    {
        setNeedsLayout()
        layoutIfNeeded()
    }

}
