//
//  SkinHeadTableViewCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SkinHeadTableViewCell_EN: UITableViewCell {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skinLabel: UILabel!
    @IBOutlet weak var skinStateLabel: UILabel!
    @IBOutlet weak var skinImg: UIImageView!
    @IBOutlet weak var skinDescripe: UITextView!
    
    @IBOutlet weak var selfglb: UILabel!
    @IBOutlet weak var tishilb: UILabel!
    @IBOutlet weak var fuzhiLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fuzhiLb.text = loadLanguage("肤质查询")
        tishilb.text = loadLanguage("温馨提示")
        selfglb.text = loadLanguage("您的肤质")
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        skinDescripe.textColor=UIColor.whiteColor()
        //updateCell(0, sexImgHeadStr: "woman")
        // Configure the view for the selected state
    }
    
    private let skinTextArr=[loadLanguage("暂无"),loadLanguage("干性皮肤"),loadLanguage("油性皮肤"),loadLanguage("中性皮肤")]
    private let skinDescripeText=[
       loadLanguage("数据累计不足，无法查询到您的肤质类型，请再接再厉"),
        loadLanguage("干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱，定期使用适量精华补水也能改善您的干性特质哦！"),
        loadLanguage("皮肤通道是先吸收水，再吸收油。当肌底极度缺水干燥的时候，为保护皮肤，油脂才会分泌过盛。水油已严重失衡啦，请注意控油补水！"),
        loadLanguage("干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱！")
    ]
    /**
     传入皮肤类型更新视图
     
     - parameter currentSkin: 0 无类型，1 干，2 油，3 中     - parameter sexImgHeadStr:"man" 或"woman"
     */
    func updateCell(currentSkin:Int,sex:SexType)
    {
        skinLabel.text=skinTextArr[currentSkin]
        skinStateLabel.text = currentSkin==0 ? loadLanguage("您还从未检测过哦"):loadLanguage("通过数据累计统计，仅供参考。")
        skinImg.image=UIImage(named: (sex==SexType.Man ? "man":"woman")+"SkinOfChaXun\(currentSkin)")
        skinDescripe.text=skinDescripeText[currentSkin]
       // skinStateLabel.adjustsFontSizeToFitWidth
        
    }
}
