//
//  CupView_Footer.swift
//  OZner
//
//  Created by test on 16/1/17.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class CupView_Footer: UIView {

    
    @IBOutlet var haveDrink: UILabel!
    @IBOutlet var drinkImg: UIImageView!
    @IBOutlet var drinkMuBiao: UILabel!
    @IBOutlet var drinkButton: UIButton!
    var water:Int=0{
        didSet{
            //var str = "0"
            var value=water
            if(value <= 0)
            {
                value = 0
            }
            self.haveDrink.text = "\(value)ml"
        
            if(value > 0)
            {
                let scale = CGFloat(value)/2200.0
                if(scale <= 0.33)
                {
                    self.drinkImg.image = UIImage(named:"yin_shui_liang_1.png")
                }
                else if(scale <= 0.66)
                {
                    self.drinkImg.image = UIImage(named:"yin_shui_liang_2.png")
                }
                else
                {
                    self.drinkImg.image = UIImage(named:"yin_shui_liang_3.png")
                }
            }
            else
            {
                self.drinkImg.image = UIImage(named:"yin_shui_liang_0.png")
            }

        }
    }
    @IBOutlet var tempValue: UILabel!
    @IBOutlet var tempImg: UIImageView!
    @IBOutlet var tempState: UILabel!
    @IBOutlet var tempButton: UIButton!
    var temperature:Int=0{
        didSet{
            var value=temperature
            if(temperature == 65535)
            {
                value = 0
            }
            if(value > 0)
            {
                if(value <= 25)
                {
                    self.tempImg.image = UIImage(named: "wen_du_1.png")
                    self.tempValue.text = loadLanguage("偏凉");
                    self.tempState.text = loadLanguage ("当前水温偏凉");
                }
                else if(value <= 50)
                {
                    self.tempImg.image = UIImage(named: "wen_du_2.png")
                    self.tempValue.text =  loadLanguage("适中");
                    self.tempState.text =  loadLanguage("当前水温适宜饮用");
                }
                else
                {
                    self.tempImg.image = UIImage(named: "wen_du_3.png")
                    self.tempValue.text = loadLanguage( "偏烫");
                    self.tempState.text =  loadLanguage("当前水温偏烫");
                }
            }
            else
            {
                self.tempImg.image = UIImage(named: "wen_du_1.png")
                self.tempValue.text =  loadLanguage("暂无");
                self.tempState.text =  loadLanguage("当前水温暂无");
            }
            
            
        }
    }
    override func draw(_ rect: CGRect) {
        
    }
    

}
