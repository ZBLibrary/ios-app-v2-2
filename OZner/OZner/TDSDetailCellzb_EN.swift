//
//  TDSDetailCellzb.swift
//  OZner
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class TDSDetailCellzb_EN: UITableViewCell {

    @IBOutlet var BackClick: UIButton!
    @IBOutlet var headTitle: UILabel!
   
    @IBOutlet var TDSValue: UILabel!
    
    @IBOutlet var faceIcon: UIImageView!
    @IBOutlet var faceState: UILabel!
    @IBOutlet var toTDSState: UIButton!
    //@IBOutlet var toZiXun: UIButton!
    //@IBOutlet var zixunViewzb: UIView!
    
    var TDSValueChange:Int=0{
        didSet{
            TDSValue.text=TDSValueChange==0||TDSValueChange==65535 ? "-":"\(TDSValueChange)"
//            if TDSValue.text=="-"
//            {
//                TDSValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 25)
//            }
//            else
//            {
//                TDSValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 40)
//            }
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //zixunViewzb.layer.borderColor=UIColor(red: 48/255, green: 127/255, blue: 245/255, alpha: 1).CGColor
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
