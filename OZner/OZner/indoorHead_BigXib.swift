//
//  indoorHead_BigXib.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class indoorHead_BigXib: UIView {

    @IBOutlet var toPM2d5: UIButton!
    @IBOutlet var toVOC: UIButton!
    @IBOutlet var PM2d5Value: UILabel!
    @IBOutlet var VOCValue: UILabel!
    @IBOutlet weak var FineAir: UILabel!
  
    @IBOutlet weak var Airmattter: UILabel!
    
    
    
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        //VOCValue.text = loadLanguage("检测中");
        FineAir.text = loadLanguage("为空气中细微颗粒");
        Airmattter.text = loadLanguage("为空气中挥发性有机化合物");
    
        
    
    }
   
        

}
