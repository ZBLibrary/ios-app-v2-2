//
//  FriendsNavRight.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class FriendsNavRight: UIView {

    @IBOutlet var AddFriend: UIButton!
    @IBOutlet var TongzhiButton: UIButton!
   
    @IBOutlet var smallTongzhiView: UIView!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        smallTongzhiView.layer.cornerRadius=6
        smallTongzhiView.layer.masksToBounds=true
        
    }
    

}
