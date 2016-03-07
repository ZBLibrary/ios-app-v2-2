//
//  indoorAirWarn_Temp.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class indoorAirWarn_Temp: UIView {

    @IBOutlet weak var temp: UILabel!
 
    @IBOutlet weak var moreDrink: UILabel!
    
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
 
        temp.text = loadLanguage("温度较低，容易冻伤、风寒。请打开暖气，减少外出活动。");
        moreDrink.text = loadLanguage("多喝水");
    
        
    }
   

}
