//
//  drinKWaterCell.swift
//  OZner
//
//  Created by test on 16/1/16.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class drinKWaterCell: UITableViewCell {
    
    @IBOutlet var back: UIButton!
    @IBOutlet var share: UIButton!
    
    @IBOutlet var shareImg: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var waterValueTitle: UILabel!
    @IBOutlet var rankValue: UILabel!
    @IBOutlet var zixunButton: UIButton!
    @IBOutlet var zixunView: UIView!
    @IBOutlet var faceImg: UIImageView!
    @IBOutlet var faceState: UILabel!
    //饮水量需要的
    @IBOutlet var waterValue: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var rankView: UIView!
    
    @IBOutlet weak var rankingLabel: UILabel!
    //温度需要的
    @IBOutlet var TempValue: UILabel!
    var rank=0{
        didSet{
            rankValue.text=rank==0 ? loadLanguage("无"):"\(rank)"
            switch  rankValue.text!.characters.count
            {
            case 0...2:
                rankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 40)
                break
                
            case 3...4:
                rankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 22)
                break
            case 5:
                rankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 16)
                break
            default:
                rankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 10)
                break
                
            }
        }
    }
    var waterValueChange:Int=0{
        didSet{
            if celltype==loadLanguage("饮水量")
            {
                waterValue.text=loadLanguage("暂无")
                switch waterValueChange
                {
                case 0...50:
                    waterValue.text="\(waterValueChange)"
                    faceImg.image=UIImage(named: "waterState3")
                    faceState.text=loadLanguage("当前喝水量还不够，离“水货”还有一段距离")
                    break
                case 51..<100:
                    waterValue.text="\(waterValueChange)"
                    faceImg.image=UIImage(named: "waterState2")
                    faceState.text=loadLanguage("健康的身体，需要配合良好的饮水习惯，加油哦！")
                    break
                case 100...1000000:
                    waterValue.text="\(100)"
                    faceImg.image=UIImage(named: "waterState1")
                    faceState.text=loadLanguage("今日水量已达标，休息，休息一会儿！")
                    break
                default:
                    break
                }
            }
            else
            {
                TempValue.text=loadLanguage("暂无")
                switch waterValueChange
                {
                case 0...25:
                    TempValue.text=loadLanguage("偏凉")
                    faceImg.image=UIImage(named: "waterState2")
                    faceState.text=loadLanguage("水温太凉啦！让胃暖起来，心才会暖！")
                    break
                case 26...50:
                    TempValue.text=loadLanguage("适中")
                    faceImg.image=UIImage(named: "waterState1")
                    faceState.text=loadLanguage("不凉不烫，要的就是刚刚好！")
                    break
                case 51...100:
                    TempValue.text=loadLanguage("偏烫")
                    faceImg.image=UIImage(named: "waterState3")
                    faceState.text=loadLanguage("水温偏烫再凉一凉吧，心急可是会受伤的哦！")
                    break
                default:
                    break
                }
            }
        }
    }
    var celltype=""{
        didSet{
            title.text=celltype
            if celltype==loadLanguage("饮水量")
            {
                waterValueTitle.text=loadLanguage("今日已完成")
                TempValue.hidden=true
                waterValue.hidden=false
                symbolLabel.hidden=false
                rankView.hidden=false
                shareImg.hidden=false
                share.enabled=true
            }
            else
            {
                //水温
                waterValueTitle.text=loadLanguage("水温")
                TempValue.hidden=false
                waterValue.hidden=true
                symbolLabel.hidden=true
                rankView.hidden=true
                shareImg.hidden=true
                share.enabled=false
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        zixunView.layer.borderColor=UIColor(red: 48/255, green: 127/255, blue: 245/255, alpha: 1).CGColor
        // Initialization code
        rankingLabel.text = loadLanguage("好友排名")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
