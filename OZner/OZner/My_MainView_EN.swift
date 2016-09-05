//
//  My_MainView_EN.swift
//  OZner
//
//  Created by zhuguangyang on 16/7/25.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class My_MainView_EN: UIView {
    
    @IBOutlet weak var My_head: UIImageView!
    
    @IBOutlet weak var My_login: UIButton!
    @IBOutlet weak var My_Equids_button: UIButton!
    @IBOutlet weak var SuggestButton: UIButton!
    @IBOutlet weak var Set: UIButton!
    
    @IBOutlet weak var MyEquidsLable: UILabel!
    
    @IBOutlet weak var SuggestLable: UILabel!
    
    @IBOutlet weak var SetLable: UILabel!
    

    @IBOutlet weak var deviceNumLabel: UILabel!
    @IBOutlet weak var deviceBtn: UIButton!
    
    override func drawRect(rect: CGRect) {
        
        
        MyEquidsLable .text=loadLanguage("我的好友")
        
        SuggestLable .text=loadLanguage ("我要提意见")
        SetLable .text=loadLanguage ("设置")
        
    }
    
    
    
}
