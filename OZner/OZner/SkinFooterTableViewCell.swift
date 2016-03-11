//
//  SkinFooterTableViewCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SkinFooterTableViewCell: UITableViewCell {

    //五个按钮背景view的宽度
    @IBOutlet weak var widthOfButtonBG1: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG2: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG3: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG4: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG5: NSLayoutConstraint!
    private let buttonContainWidth=(375-24)*Screen_Width/375
    //五个按钮
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    //肤质图片及说明
    @IBOutlet weak var skinImg: UIImageView!
    @IBOutlet weak var skinState: UITextView!
    //购买精华液
    @IBOutlet weak var bugEssenceButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()

        widthOfButtonBG1.constant=buttonContainWidth/5
        widthOfButtonBG2.constant=buttonContainWidth/5
        widthOfButtonBG3.constant=buttonContainWidth/5
        widthOfButtonBG4.constant=buttonContainWidth/5
        widthOfButtonBG5.constant=buttonContainWidth/5
        for button in [button1,button2,button3,button4,button5]
        {
            button.addTarget(self, action: Selector("skinButtonClick:"), forControlEvents: .TouchUpInside)
        }
    }
    private let selectColor=UIColor(red: 64/255.0, green: 140/255.0, blue: 241/255.0, alpha: 1)
    private var sexImgHeadStr="woman"
    private var skinStateArr=[
        "干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱，定期使用适量精华补水也能改善您的干性特质哦！",
        "皮肤通道是先吸收水，再吸收油。当肌底极度缺水干燥的时候，为保护皮肤，油脂才会分泌过盛。水油已严重失衡啦，请注意控油补水！",
        "干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱！",
        "干性肌需要进行深层补水，水油已严重失衡啦，请注意控油补水！",
        "干性肌需要进行深层补水！"
    ]
    func skinButtonClick(button:UIButton)
    {
        //设置按钮背景色
        for tmpButton in [button1,button2,button3,button4,button5]
        {
            tmpButton.backgroundColor=UIColor.clearColor()
        }
        button.backgroundColor=selectColor
        //设置选中按钮对应图片
        skinImg.image=UIImage(named: sexImgHeadStr+"SkinOfChaXun\(button.tag)")
        skinState.text=skinStateArr[button.tag-1]
        skinState.textColor=UIColor.whiteColor()
    }
    
    /**
     传入我的肤质来设置其他皮肤有哪几种
     
     - parameter myFuZhi: 0：无，1油，2干，3中，4混合，5敏感
     */
    func MyCurrentFuZhi(myFuZhi:Int)
    {
        let tmpwidth = myFuZhi==0 ? buttonContainWidth/5:buttonContainWidth/4
        widthOfButtonBG1.constant=tmpwidth
        widthOfButtonBG2.constant=tmpwidth
        widthOfButtonBG3.constant=tmpwidth
        widthOfButtonBG4.constant=tmpwidth
        widthOfButtonBG5.constant=tmpwidth
        if myFuZhi != 0
        {
            [widthOfButtonBG1,widthOfButtonBG2,widthOfButtonBG3,widthOfButtonBG4,widthOfButtonBG5][myFuZhi-1].constant=0
            
        }
        //设置首次进入选中
        skinButtonClick(myFuZhi==1 ? button2:button1)
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
