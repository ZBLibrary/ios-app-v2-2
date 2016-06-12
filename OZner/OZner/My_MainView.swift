//
//  My_MainView.swift
//  TmpOnzer
//
//  Created by test on 15/11/23.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class My_MainView: UIView {

    @IBOutlet var My_head: UIImageView!
    @IBOutlet var My_login: UIButton!
    @IBOutlet var My_job: UILabel!
    @IBOutlet var My_Equids_button: UIButton!
    @IBOutlet var My_Money_button: UIButton!
    @IBOutlet var My_EquipCount: UILabel!
    @IBOutlet var My_Money: UILabel!
    @IBOutlet var ShareButton: UIButton!
    @IBOutlet var AgentButton: UIButton!
    @IBOutlet var AwardButton: UIButton!
    @IBOutlet var My_Friends: UIButton!
    @IBOutlet var NewsCount: UILabel!
    @IBOutlet var BaogaoButton: UIButton!
    @IBOutlet var SuggestButton: UIButton!
    @IBOutlet var Set: UIButton!
    
    
    @IBOutlet var MyEquidsLable: UILabel!
    @IBOutlet var MyMoneyLable: UILabel!
    @IBOutlet var ShareLable: UILabel!
    @IBOutlet var AgentLable: UILabel!
    @IBOutlet var AwardLable: UILabel!
    @IBOutlet var MyFriendLable: UILabel!
    @IBOutlet var BaogaoLable: UILabel!
    @IBOutlet var SuggestLable: UILabel!
    @IBOutlet var SetLable: UILabel!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
         //My_login.setTitle(loadLanguage ("点击登录"), forState: .Normal)
        
          //My_job.text=loadLanguage("银行卡代理会员" )
         MyMoneyLable .text=loadLanguage ("我的小金库")
         MyEquidsLable .text=loadLanguage("我的设备")
         ShareLable .text=loadLanguage("我的订单")
         AgentLable .text=loadLanguage("领红包")
         AwardLable .text=loadLanguage("我的券")
         MyFriendLable.text=loadLanguage ("我的好友")
         BaogaoLable.text=loadLanguage ("查看水质检测报告")
         SuggestLable .text=loadLanguage ("我要提意见")
          SetLable .text=loadLanguage ("设置")
        
    }
    
    func update()
    {
        
    }
    
}
