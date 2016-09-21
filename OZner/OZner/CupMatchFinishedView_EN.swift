//
//  MatchFinishedView.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/3.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

protocol CupMatchFinishedView_ENDelegate
{
    
    func cupFinishedAction()
}

class CupMatchFinishedView_EN: UIView,UITextFieldDelegate,UIScrollViewDelegate {
    
    var myCupNameTextField:UITextField?
    var myWeightTextField:UITextField?

    var delegate:CupMatchFinishedView_ENDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let sanjiaoImg = UIImage(named: "match_finish_sanjiao.png")
        let sanjiaoImgView = UIImageView(frame: CGRect(x: width/2.0, y: 0, width: (sanjiaoImg?.size.width)!, height: (sanjiaoImg?.size.height)!))
        sanjiaoImgView.image = UIImage(named: "match_finish_sanjiao.png")
        self .addSubview(sanjiaoImgView)
        sanjiaoImgView.backgroundColor = UIColor.clear
        
        let bgView = UIView(frame: CGRect(x: 0,y: sanjiaoImgView.frame.size.height-2,width: width,height: self.frame.size.height-sanjiaoImgView.frame.size.height+2))
        bgView.backgroundColor = UIColor.white
        self .addSubview(bgView)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0,y: sanjiaoImgView.frame.size.height,width: bgView.frame.size.width,height: bgView.frame.size.height))
        self.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clear
        
        self.backgroundColor = UIColor(red: 110.0, green: 206.0, blue: 250.0, alpha: 1.0)
        self.backgroundColor = UIColor.clear
        
        let cupNameTextField = UITextField(frame: CGRect(x: 30*(width/375.0),y: 40*(height/667.0),width: 150*(width/375.0),height: 17*(height/667.0)))
        cupNameTextField.placeholder = loadLanguage("输入智能杯名称")
        cupNameTextField.delegate = self
        cupNameTextField.font = UIFont.systemFont(ofSize: 14*(height/667.0))
        cupNameTextField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cupNameTextField.textAlignment = NSTextAlignment.center
        self.myCupNameTextField = cupNameTextField
        scrollView.addSubview(cupNameTextField)
        
        let leftSeparatorView = UIView(frame: CGRect(x: 30*(width/375.0),y: cupNameTextField.frame.size.height+cupNameTextField.frame.origin.y+10*(height/667.0),width: 150*(width/375.0),height: 1))
        leftSeparatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scrollView.addSubview(leftSeparatorView)
        
        let contentStr:String = loadLanguage("我的水杯")
        let contentDic = [NSFontAttributeName:UIFont.systemFont(ofSize: 17*(height/667.0))];
        let contentSize = contentStr.boundingRect(with: CGSize(width: width, height: 17*(height/667.0)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: contentDic, context: nil).size
        
        var orginx=leftSeparatorView.frame.size.width+leftSeparatorView.frame.origin.x
        orginx+=23*(width/375.0)+16*(width/375.0)
      
        let label = UILabel(frame: CGRect(x: orginx,y: cupNameTextField.frame.origin.y,width: contentSize.width,height: 18*(height/667.0)))
        
        label.text = loadLanguage("我的水杯")
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 17*(height/667.0))
        label.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        scrollView.addSubview(label)
        
        //let rowImg = UIImage(named: "pull_down_row.png")
        
        //let pullDownImgView = UIImageView(frame: CGRectMake(label.frame.size.width+label.frame.origin.x+31*(width/375.0), (label.frame.size.height-(rowImg?.size.height)!)/2+label.frame.origin.y, (rowImg?.size.width)!, (rowImg?.size.height)!))
        //pullDownImgView.image = UIImage(named: "pull_down_row.png")
        //scrollView .addSubview(pullDownImgView)
        
        let rightSeparatorView = UIView(frame: CGRect(x: leftSeparatorView.frame.size.width+leftSeparatorView.frame.origin.x+23*(width/375.0),y: leftSeparatorView.frame.origin.y,width: 150*(width/375.0),height: 1))
        rightSeparatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scrollView.addSubview(rightSeparatorView)
        
        let weightTextField = UITextField(frame: CGRect(x: (width-150*(width/375.0))/2,y: 29*(height/667.0)+leftSeparatorView.frame.size.height+leftSeparatorView.frame.origin.y,width: 150*(width/375.0),height: 17*(height/667.0)))
        weightTextField.placeholder = loadLanguage("输入体重")
        weightTextField.delegate = self
        self.myWeightTextField = weightTextField
        weightTextField.keyboardType = UIKeyboardType.numberPad
        weightTextField.font = UIFont.systemFont(ofSize: 14*(height/667.0))
        weightTextField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        weightTextField.textAlignment = NSTextAlignment.center
        scrollView.addSubview(weightTextField)
        
        let weightStr:String = "KG"
        let weightDic = [NSFontAttributeName:UIFont.systemFont(ofSize: 17*(height/667.0))];
        let weightSize = weightStr.boundingRect(with: CGSize(width: width, height: 17*(height/667.0)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: weightDic, context: nil).size;
        let weightLabel:UILabel = UILabel(frame: CGRect(x: weightTextField.frame.size.width+weightTextField.frame.origin.x+5,y: weightTextField.frame.origin.y,width: weightSize.width,height: 17*(height/667.0)))
        weightLabel.text = "KG"
        weightLabel.textAlignment = NSTextAlignment.center
        weightLabel.font = UIFont.systemFont(ofSize: 17*(height/667.0))
        weightLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        scrollView .addSubview(weightLabel)
        
        let weightSeparatorView = UIView(frame: CGRect(x: weightTextField.frame.origin.x,y: weightTextField.frame.size.height+weightTextField.frame.origin.y+10*(height/667.0),width: 150*(width/375.0) + weightSize.width+5,height: 1))
        weightSeparatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scrollView.addSubview(weightSeparatorView)

        
        let tiplabel:UILabel = UILabel(frame: CGRect(x: 0,y: weightSeparatorView.frame.origin.y+weightSeparatorView.frame.size.height+5*(height/667.0),width: width,height: 15*(height/667.0)))
        tiplabel.text = loadLanguage("填写体重获得更健康的饮水量建议")
        tiplabel.textAlignment = NSTextAlignment.center
        tiplabel.font = UIFont.systemFont(ofSize: 14*(height/667.0))
        tiplabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        scrollView .addSubview(tiplabel)
        
        //let button = UIButton(frame: CGRectMake(16*(width/375.0),tiplabel.frame.origin.y+tiplabel.frame.size.height+40*(height/667.0),width-16*(width/375.0)*2,40*(height/667.0)))
        let button = UIButton(frame: CGRect(x: 16*(width/375.0),y: 180*(height/667.0),width: width-16*(width/375.0)*2,height: 40*(height/667.0)))
        button.backgroundColor = UIColor(red: 60.0/255, green: 137.0/255, blue: 242.0/255, alpha: 1.0)
        button.setTitle(loadLanguage("完成"), for: UIControlState())
        button.addTarget(self, action: #selector(finishedAction), for: UIControlEvents.touchUpInside)
        button.layer.masksToBounds = true;
        button.layer.cornerRadius = 20;
        scrollView .addSubview(button)
        
        scrollView.contentSize = CGSize(width: width, height: button.frame.size.height+button.frame.origin.y+40*(height/667.0)+20)
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(handle))
        self.addGestureRecognizer(gesture)
    }
    
    func handle()
    {
         self .endEditing(true);
    }
    
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self .endEditing(true);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
