//
//  TDSDetailCellzb.swift
//  OZner
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class TDSDetailCellzb: UITableViewCell {
    
    @IBOutlet var BackClick: UIButton!
    @IBOutlet var headTitle: UILabel!
    @IBOutlet var shareCick: UIButton!
    @IBOutlet var TDSValue: UILabel!
    @IBOutlet var RankValue: UILabel!
    @IBOutlet var faceIcon: UIImageView!
    @IBOutlet var faceState: UILabel!
    @IBOutlet var toTDSState: UIButton!
    @IBOutlet var toZiXun: UIButton!
    @IBOutlet var zixunViewzb: UIView!
    
    @IBOutlet weak var hideImage: UIImageView!
    var TDSValueChange:Int=0{
        didSet{

            TDSValue.text=TDSValueChange==0||TDSValueChange==65535 ? loadLanguage("暂无1"):"\(TDSValueChange)"
            if TDSValue.text==loadLanguage("暂无1")
            {
                TDSValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 20)
            }
            else
            {
                TDSValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 40)
            }
            switch TDSValueChange
            {
            case 0..<TDS_Good_Int:
                faceIcon.image=UIImage(named: "waterState1")
                faceState.text=loadLanguage("完美水质，体内每个细胞都说好！")
                break
            case TDS_Good_Int..<TDS_Bad_Int:
                faceIcon.image=UIImage(named: "waterState2")
                faceState.text=loadLanguage("饮水安全需谨慎，你值得拥有更好的。")
                break
            case TDS_Bad_Int..<65535:
                faceIcon.image=UIImage(named: "waterState3")
                faceState.text=loadLanguage("当前杂质较多，请放心给对手饮用")
                break
            default:
                faceState.text=loadLanguage("暂无")
                break
            }
            
        }
        
    }
    var rankValueChange:Int=0{
        didSet{
            RankValue.text=rankValueChange==0 ? loadLanguage("暂无1"):"\(rankValueChange)"
            if RankValue.text==loadLanguage("暂无1")
            {
                RankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 20)
            }
            else
            {
                RankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 40)
                print(rankValueChange)
                switch  RankValue.text!.characters.count
                {
                case 0...2:
                    RankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 40)
                    break
                    
                    
                case 3...4:
                    RankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 22)
                    break
                case 5:
                    RankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 16)
                    break
                default:
                    RankValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 10)
                    break
                    
                }
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        zixunViewzb.layer.borderColor=UIColor(red: 48/255, green: 127/255, blue: 245/255, alpha: 1).cgColor
        hideImage.isHidden = !IsLoginByPhone()
        shareCick.isEnabled = IsLoginByPhone()
        zixunViewzb.isHidden = !IsLoginByPhone()

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
