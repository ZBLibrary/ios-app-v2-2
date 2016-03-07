//
//  Main_FooterView_zb.swift
//  OZner
//
//  Created by test on 16/1/9.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class Main_FooterView_zb: UIView {
    
    @IBOutlet var toAddDeviceButton: UIButton!

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        toAddDeviceButton.layer.borderColor=UIColor(red: 56/255, green: 127/255, blue: 248/255, alpha: 1).CGColor
        toAddDeviceButton.layer.borderWidth=1
        toAddDeviceButton.layer.cornerRadius=20
        // Drawing code
    }
    

}
