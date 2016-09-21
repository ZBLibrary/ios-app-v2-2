//
//  bigFooterViewXib.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class bigFooterViewXib_EN: UIView {

    @IBOutlet var switchName: UILabel!
    @IBOutlet var switchButton: UIButton!
    
    @IBOutlet var switchImage: UIImageView!
    var index:Int=1
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var ison:Bool=false{
        didSet{
            updateView(ison)
        }
    }
//    let OnImage=["1":"air01001","2":"air01002","3":"air01003","4":"air01004","5":"air01005","6":"air01006","7":"air01007"]
//    let OffImage=["1":"air22011","2":"air22012","3":"air22013","4":"air22014","5":"air0013","6":"air22010","7":"air22016"]
//    let OnName=["1":"开","2":"模式","3":"定时","4":"童锁","5":"低速","6":"中速","7":"高速"]
//    let OffName=["1":"关","2":"模式","3":"定时","4":"童锁","5":"低速","6":"中速","7":"高速"]
    let OnImage=["1":"air01001","2":"air01002","3":"air01004"]
    let OffImage=["1":"air22011","2":"air22012","3":"air22014"]
    let OnName=["1":loadLanguage("开"),"2":loadLanguage("模式"),"3":loadLanguage("童锁")]
    let OffName=["1":loadLanguage("关"),"2":loadLanguage("模式"),"3":loadLanguage("童锁")]
    let OnColor=UIColor(red: 0, green: 111/255, blue: 246/255, alpha: 1)
    let OffColor=UIColor(red: 159/255, green: 160/255, blue: 162/255, alpha: 1)
    func updateView(_ isOn:Bool)
    {
        if isOn==true
        {
            switchName.text=OnName["\(index)"]
            switchName.textColor=OnColor
            switchImage.image=UIImage(named: OnImage["\(index)"]!)
            switchButton.layer.borderColor=OnColor.cgColor
            switchButton.layer.masksToBounds=false
            switchButton.layer.shadowOffset=CGSize(width: 0, height: 0)//阴影偏移量
            switchButton.layer.shadowRadius=3//阴影半径
            switchButton.layer.shadowOpacity=0.8//透明度
            switchButton.layer.shadowColor=OnColor.cgColor
        }
        else
        {
            switchButton.layer.shadowRadius=0
            switchName.text=OffName["\(index)"]
            switchName.textColor=OffColor
            switchImage.image=UIImage(named: OffImage["\(index)"]!)
            switchButton.layer.borderColor=OffColor.cgColor
        }
    }
}
