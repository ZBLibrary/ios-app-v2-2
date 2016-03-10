//
//  MatchFinishedView.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/3.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

protocol CupMatchFinishedViewDelegate
{
    
    func cupFinishedAction()
}

class CupMatchFinishedView: UIView,UITextFieldDelegate,UIScrollViewDelegate {
    
    var myCupNameTextField:UITextField?
    var myWeightTextField:UITextField?

    var delegate:CupMatchFinishedViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        let sanjiaoImg = UIImage(named: "match_finish_sanjiao.png")
        let sanjiaoImgView = UIImageView(frame: CGRectMake(width/2.0, 0, (sanjiaoImg?.size.width)!, (sanjiaoImg?.size.height)!))
        sanjiaoImgView.image = UIImage(named: "match_finish_sanjiao.png")
        self .addSubview(sanjiaoImgView)
        sanjiaoImgView.backgroundColor = UIColor.clearColor()
        
        let bgView = UIView(frame: CGRectMake(0,sanjiaoImgView.frame.size.height-2,width,self.frame.size.height-sanjiaoImgView.frame.size.height+2))
        bgView.backgroundColor = UIColor.whiteColor()
        self .addSubview(bgView)
        
        let scrollView = UIScrollView(frame: CGRectMake(0,sanjiaoImgView.frame.size.height,bgView.frame.size.width,bgView.frame.size.height))
        self.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        
        self.backgroundColor = UIColor(red: 110.0, green: 206.0, blue: 250.0, alpha: 1.0)
        self.backgroundColor = UIColor.clearColor()
        
        let cupNameTextField = UITextField(frame: CGRectMake(30*(width/375.0),40*(height/667.0),150*(width/375.0),17*(height/667.0)))
        cupNameTextField.placeholder = loadLanguage("输入智能杯名称")
        cupNameTextField.delegate = self
        cupNameTextField.font = UIFont.systemFontOfSize(17*(height/667.0))
        cupNameTextField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cupNameTextField.textAlignment = NSTextAlignment.Center
        self.myCupNameTextField = cupNameTextField
        scrollView.addSubview(cupNameTextField)
        
        let leftSeparatorView = UIView(frame: CGRectMake(30*(width/375.0),cupNameTextField.frame.size.height+cupNameTextField.frame.origin.y+10*(height/667.0),150*(width/375.0),1))
        leftSeparatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scrollView.addSubview(leftSeparatorView)
        
        let contentStr:String = loadLanguage("我的水杯")
        let contentDic = [NSFontAttributeName:UIFont.systemFontOfSize(17*(height/667.0))];
        let contentSize = contentStr.boundingRectWithSize(CGSizeMake(width, 17*(height/667.0)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: contentDic, context: nil).size;
        let label:UILabel = UILabel(frame: CGRectMake(leftSeparatorView.frame.size.width+leftSeparatorView.frame.origin.x+23*(width/375.0)+16*(width/375.0),cupNameTextField.frame.origin.y,contentSize.width,17*(height/667.0)))
        label.text = loadLanguage("我的水杯")
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(17*(height/667.0))
        label.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        scrollView.addSubview(label)
        
        //let rowImg = UIImage(named: "pull_down_row.png")
        
        //let pullDownImgView = UIImageView(frame: CGRectMake(label.frame.size.width+label.frame.origin.x+31*(width/375.0), (label.frame.size.height-(rowImg?.size.height)!)/2+label.frame.origin.y, (rowImg?.size.width)!, (rowImg?.size.height)!))
        //pullDownImgView.image = UIImage(named: "pull_down_row.png")
        //scrollView .addSubview(pullDownImgView)
        
        let rightSeparatorView = UIView(frame: CGRectMake(leftSeparatorView.frame.size.width+leftSeparatorView.frame.origin.x+23*(width/375.0),leftSeparatorView.frame.origin.y,150*(width/375.0),1))
        rightSeparatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scrollView.addSubview(rightSeparatorView)
        
        let weightTextField = UITextField(frame: CGRectMake((width-150*(width/375.0))/2,29*(height/667.0)+leftSeparatorView.frame.size.height+leftSeparatorView.frame.origin.y,150*(width/375.0),17*(height/667.0)))
        weightTextField.placeholder = loadLanguage("输入体重")
        weightTextField.delegate = self
        self.myWeightTextField = weightTextField
        weightTextField.keyboardType = UIKeyboardType.NumberPad
        weightTextField.font = UIFont.systemFontOfSize(17*(height/667.0))
        weightTextField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        weightTextField.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(weightTextField)
        
        let weightStr:String = "KG"
        let weightDic = [NSFontAttributeName:UIFont.systemFontOfSize(17*(height/667.0))];
        let weightSize = weightStr.boundingRectWithSize(CGSizeMake(width, 17*(height/667.0)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: weightDic, context: nil).size;
        let weightLabel:UILabel = UILabel(frame: CGRectMake(weightTextField.frame.size.width+weightTextField.frame.origin.x-weightSize.width-5,weightTextField.frame.origin.y,weightSize.width,17*(height/667.0)))
        weightLabel.text = "KG"
        weightLabel.textAlignment = NSTextAlignment.Center
        weightLabel.font = UIFont.systemFontOfSize(17*(height/667.0))
        weightLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        scrollView .addSubview(weightLabel)
        
        let weightSeparatorView = UIView(frame: CGRectMake(weightTextField.frame.origin.x,weightTextField.frame.size.height+weightTextField.frame.origin.y+10*(height/667.0),150*(width/375.0),1))
        weightSeparatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scrollView.addSubview(weightSeparatorView)

        
        let tiplabel:UILabel = UILabel(frame: CGRectMake(0,weightSeparatorView.frame.origin.y+weightSeparatorView.frame.size.height+5*(height/667.0),width,14*(height/667.0)))
        tiplabel.text = loadLanguage("填写体重获得更健康的饮水量建议")
        tiplabel.textAlignment = NSTextAlignment.Center
        tiplabel.font = UIFont.systemFontOfSize(14*(height/667.0))
        tiplabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        scrollView .addSubview(tiplabel)
        
        //let button = UIButton(frame: CGRectMake(16*(width/375.0),tiplabel.frame.origin.y+tiplabel.frame.size.height+40*(height/667.0),width-16*(width/375.0)*2,40*(height/667.0)))
        let button = UIButton(frame: CGRectMake(16*(width/375.0),180*(height/667.0),width-16*(width/375.0)*2,40*(height/667.0)))
        button.backgroundColor = UIColor(red: 60.0/255, green: 137.0/255, blue: 242.0/255, alpha: 1.0)
        button.setTitle(loadLanguage("完成"), forState: UIControlState.Normal)
        button.addTarget(self, action: "finishedAction", forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.masksToBounds = true;
        button.layer.cornerRadius = 20;
        scrollView .addSubview(button)
        
        scrollView.contentSize = CGSizeMake(width, button.frame.size.height+button.frame.origin.y+40*(height/667.0)+20)
        
        let gesture = UITapGestureRecognizer.init(target: self, action: "handle")
        self.addGestureRecognizer(gesture)
    }
    
    func handle()
    {
         self .endEditing(true);
    }
    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self .endEditing(true);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.endEditing(true)
    }
    
    func finishedAction()
    {
        delegate?.cupFinishedAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
