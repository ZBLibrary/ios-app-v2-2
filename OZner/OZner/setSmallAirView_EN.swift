//
//  setSmallAirView.swift
//  OZner
//
//  Created by test on 15/12/20.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setSmallAirView_EN: UIView {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameValue: UILabel!
    @IBOutlet var toSetNameButton: UIButton!
    @IBOutlet var operatingIntroducButton: UIButton!
    
    @IBOutlet var commonQestion: UIButton!
    @IBOutlet var clearButton: UIButton!
   // @IBOutlet var Attention: UILabel!
    @IBOutlet var WRZLable: UILabel!
    @IBOutlet var WuRanShao: UILabel!
    @IBOutlet var You: UILabel!
    @IBOutlet var TiXing: UILabel!
    @IBOutlet var color: UILabel!
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
         //nameLabel.text=loadLanguage("立式空气净化器")
        color.text=loadLanguage("显示灯带颜色")
        TiXing.text=loadLanguage("空气质量灯光提醒")
        You.text=loadLanguage("优")
        WuRanShao.text=loadLanguage("污染较少")
        WRZLable.text=loadLanguage("污染严重")
         //operatingIntroducButton.setTitle(loadLanguage("空气净化器使用说明"), forState: .Normal)
         //operatingDemoButton.setTitle(loadLanguage("空气净化器使用演示"), forState: .Normal)
         //commonQestion.setTitle(loadLanguage("常见问题"), forState: .Normal)
        clearButton.setTitle(loadLanguage("删除此设备"), forState: .Normal)
        //Attention.text=loadLanguage("注意:电量低于10%时,光圈双闪。")
    }


}
