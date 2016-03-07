//
//  chatBarViewLiuyan.swift
//  OZner
//
//  Created by test on 15/12/31.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class chatBarViewLiuyan: UIView {

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var inputTextfiled: UITextField!
    @IBOutlet var ReplyLable: UILabel!
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        sendButton.setTitle(loadLanguage("发送"), forState: .Normal)
        ReplyLable.text=loadLanguage("回复")
        
    }


}
