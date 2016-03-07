//
//  FriendsNav.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class FriendsNav: UIView {

    @IBOutlet var MyRankButton: UIButton!
    
    @IBOutlet var bottomLeft: UIView!
    @IBOutlet var MyFriendsButton: UIButton!
    @IBOutlet var bottomRight: UIView!
    let color_normol=UIColor(red: 49/255, green: 49/255, blue: 49/255, alpha: 1)
    let color_select=UIColor(red: 0, green: 111/255, blue: 246/255, alpha: 1)
    
    @IBOutlet var friendBadge: UIView!

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        friendBadge.hidden=true

        MyRankButton.titleLabel?.text = loadLanguage("我的排名");
        
        MyFriendsButton.titleLabel?.text = loadLanguage("我的好友");
    }
   

}




































