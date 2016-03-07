//
//  MatchTanTouFinishdView.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/13.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit
protocol MatchTanTouFinisedViewDelegate
{
    func finishedTanTouAction()
}

class MatchTanTouFinishdView: UIView,UITextFieldDelegate {

    var myTanTouNameTextField:UITextField?
    var myWeightTextField:UITextField?
    var delegate:MatchTanTouFinisedViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        let sanjiaoImg = UIImage(named: "match_finish_sanjiao.png")
        let sanjiaoImgView = UIImageView(frame: CGRectMake(85*(width/375.0), 0, (sanjiaoImg?.size.width)!, (sanjiaoImg?.size.height)!))
        sanjiaoImgView.image = UIImage(named: "match_finish_sanjiao.png")
        self .addSubview(sanjiaoImgView)
        sanjiaoImgView.backgroundColor = UIColor.clearColor()
        
        let bgView = UIView(frame: CGRectMake(0,sanjiaoImgView.frame.size.height-2,width,self.frame.size.height-sanjiaoImgView.frame.size.height+2))
        bgView.backgroundColor = UIColor.whiteColor()
        self .addSubview(bgView)
        
        let scrollView = UIScrollView(frame: CGRectMake(0,sanjiaoImgView.frame.size.height,bgView.frame.size.width,bgView.frame.size.height))
        self.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.clearColor()
        
        self.backgroundColor = UIColor(red: 110.0, green: 206.0, blue: 250.0, alpha: 1.0)
        self.backgroundColor = UIColor.clearColor()
        
        let cupNameTextField = UITextField(frame: CGRectMake((width-150*(width/375.0))/2,55*(height/667.0),150*(width/375.0),17*(height/667.0)))
        cupNameTextField.placeholder = "输入设备名称"
        cupNameTextField.delegate = self
        cupNameTextField.font = UIFont.systemFontOfSize(17*(height/667.0))
        cupNameTextField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cupNameTextField.textAlignment = NSTextAlignment.Center
        self.myTanTouNameTextField = cupNameTextField
        scrollView.addSubview(cupNameTextField)
        
        let leftSeparatorView = UIView(frame: CGRectMake(cupNameTextField.frame.origin.x,cupNameTextField.frame.size.height+cupNameTextField.frame.origin.y+10*(height/667.0),150*(width/375.0),1))
        leftSeparatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scrollView.addSubview(leftSeparatorView)
        
        let contentStr:String = loadLanguage("办公室")
        let contentDic = [NSFontAttributeName:UIFont.systemFontOfSize(17*(height/667.0))];
        let contentSize = contentStr.boundingRectWithSize(CGSizeMake(width, 17*(height/667.0)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: contentDic, context: nil).size;
        let label:UILabel = UILabel(frame: CGRectMake((width-150*(width/375.0))/2,29*(height/667.0)+leftSeparatorView.frame.size.height+leftSeparatorView.frame.origin.y,contentSize.width,17*(height/667.0)))
        label.text = loadLanguage("办公室")
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(17*(height/667.0))
        label.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        scrollView .addSubview(label)
        
        let rowImg = UIImage(named: "pull_down_row.png")
        
        let pullDownImgView = UIImageView(frame: CGRectMake(label.frame.size.width+label.frame.origin.x+31*(width/375.0), (label.frame.size.height-(rowImg?.size.height)!)/2+label.frame.origin.y, (rowImg?.size.width)!, (rowImg?.size.height)!))
        //pullDownImgView.backgroundColor=UIColor.greenColor()
        pullDownImgView.image = UIImage(named: "pull_down_row.png")
        //scrollView .addSubview(pullDownImgView)
        
        let button = UIButton(frame: CGRectMake(16*(width/375.0),180*(height/667.0),width-16*(width/375.0)*2,40*(height/667.0)))
        button.backgroundColor = UIColor(red: 60.0/255, green: 137.0/255, blue: 242.0/255, alpha: 1.0)
        button.setTitle(loadLanguage("完成"), forState: UIControlState.Normal)
        button.addTarget(self, action: "finishedAction", forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.masksToBounds = true;
        button.layer.cornerRadius = 20;
        scrollView .addSubview(button)
        
        scrollView.contentSize = CGSizeMake(width, button.frame.size.height+button.frame.origin.y+40*(height/667.0)+20)
        //如果是空气净化器 1水杯 2探头 3:净水器 4:smallair 5:bigair
        if get_CurrSelectEquip()==4
        {
            label.text=loadLanguage("客厅")
        }
    }
    
    func finishedAction()
    {
        
        delegate?.finishedTanTouAction()
        
    }

    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
