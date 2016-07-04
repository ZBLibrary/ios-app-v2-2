//
//  outAirXib.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class outAirXib_EN: UIView {

    @IBOutlet var IKnowButton: UIButton!
    @IBOutlet var cityname: UILabel!
    @IBOutlet var PM25: UILabel!
    @IBOutlet var AQI: UILabel!
    @IBOutlet var teampret: UILabel!
    @IBOutlet var hubit: UILabel!
    @IBOutlet var datafrom: UILabel!
    
    @IBOutlet weak var city: UILabel!
   
    
    @IBOutlet weak var Finematter: UILabel!
    
    @IBOutlet weak var AirQs: UILabel!
    
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var datasource: UILabel!
    
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
       
     city.text = loadLanguage("城市");
        
        Finematter.text = loadLanguage("细颗粒物");
  
        AirQs.text = loadLanguage("空气质量指数");
        
        temp.text = loadLanguage("温度");
        
        humidity.text = loadLanguage("湿度");
        
        //datasource.text = loadLanguage("数据来源,中国环境监测总站");
        IKnowButton.titleLabel?.text = loadLanguage("我知道了");
    
        
    
    
    
    }
    
    func initView()
    {
        IKnowButton.backgroundColor=UIColor.whiteColor()
        IKnowButton.layer.cornerRadius=20
        IKnowButton.layer.masksToBounds=true
        IKnowButton.layer.borderColor=UIColor(red: 109/255, green: 156/255, blue: 246/255, alpha: 1).CGColor
        IKnowButton.layer.borderWidth=1
        
    }
    
}
