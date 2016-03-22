//
//  uiDatePickerView.swift
//  OZner
//
//  Created by test on 15/12/19.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class uiDatePickerView: UIView {

    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var OKButton: UIButton!
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        datePicker.backgroundColor=UIColor.whiteColor()
        cancelButton.setTitle("取消", forState: .Normal)
        OKButton.setTitle("确定", forState: .Normal)
    }
    

}
