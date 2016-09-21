//
//  indoorHead_SmallXib.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class indoorHead_SmallXib_EN: UIView {

    @IBOutlet var toPM2d5View: UIButton!
    @IBOutlet var Pm2d5Value: UILabel!
 
    @IBOutlet weak var AirFine: UILabel!
    
    
    
    
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
 
        AirFine.text = loadLanguage("为空气中细微颗粒");
    
    
    
    
    
    
    
    }
   

}
