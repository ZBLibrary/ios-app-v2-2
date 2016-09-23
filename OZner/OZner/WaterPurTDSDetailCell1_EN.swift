//
//  WaterPurTDSDetailCell1.swift
//  OZner
//
//  Created by 赵兵 on 16/2/18.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class WaterPurTDSDetailCell1_EN: UITableViewCell {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var toWhatTDS: UIButton!
    @IBOutlet var toChat: UIButton!
    //
    @IBOutlet var chatView: UIView!
    @IBOutlet var rankContainer: UIView!

    //
    @IBOutlet var TDS_Before: UILabel!
    @IBOutlet var TDS_After: UILabel!
    @IBOutlet var friendRank: UILabel!
    @IBOutlet var faceImg: UIImageView!
    @IBOutlet var suggestion: UILabel!
    
    //更新视图数据
    func updateCell(tdsBefore:Int,tdsAfter:Int,friendsRank:Int)
    {
        
        //
        if friendsRank != 0
        {
            friendRank.font=UIFont(name: ".SFUIDisplay-Thin", size: 40)
            friendRank.text="\(friendsRank)"
        }
        else
        {
            friendRank.font=UIFont(name: ".SFUIDisplay-Thin", size: 20)
            friendRank.text=loadLanguage("暂无")
        }
        //
        if tdsBefore==0||tdsBefore==65535
        {
            TDS_Before.font=UIFont(name: ".SFUIDisplay-Thin", size: 11)
            TDS_Before.text=loadLanguage("暂无")
        }
        else
        {
            TDS_Before.font=UIFont(name: ".SFUIDisplay-Thin", size: 24)
            TDS_Before.text="\(tdsBefore)"
        }
        //
        if tdsAfter==0||tdsAfter==65535
        {
            TDS_After.font=UIFont(name: ".SFUIDisplay-Thin", size: 11)
            TDS_After.text=loadLanguage("暂无")
        }
        else
        {
            TDS_After.font=UIFont(name: ".SFUIDisplay-Thin", size: 24)
            TDS_After.text="\(tdsAfter)"
            switch tdsAfter
            {
            case 0..<TDS_Good_Int:
                break
            case TDS_Good_Int..<TDS_Bad_Int:
                break
                
            default:
                break
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        chatView.layer.borderColor=UIColor(red: 64/255, green: 140/255, blue: 246/255, alpha: 1).CGColor
        chatView.hidden = IsLoginByPhone()
       
       // rankContainer.hidden = !IsLoginByPhone()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
