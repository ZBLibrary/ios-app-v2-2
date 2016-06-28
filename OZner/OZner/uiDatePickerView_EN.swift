//
//  uiDatePickerView_EN.swift
//  OZner
//
//  Created by test on 15/12/19.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class uiDatePickerView_EN: UIView {

    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var OKButton: UIButton!
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        datePicker.backgroundColor=UIColor.whiteColor()
        cancelButton.setTitle(loadLanguage("取消"), forState: .Normal)
        OKButton.setTitle(loadLanguage("确定"), forState: .Normal)
    }
    

}
