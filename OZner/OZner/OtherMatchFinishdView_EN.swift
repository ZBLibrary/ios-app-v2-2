
//
//  MatchTanTouFinishdView.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/13.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit
protocol OtherMatchFinishdView_ENDelegate
{
    func otherFinishedAction()
}

class OtherMatchFinishdView_EN: UIView,UITextFieldDelegate {

    var myTanTouNameTextField:UITextField?
    var myWeightTextField:UITextField?
    var segmentControl:UISegmentedControl?
    var delegate:OtherMatchFinishdView_ENDelegate?
    //var deviceType:Int=0//0水杯，1，2，3，4，5补水仪
    func initView(frame: CGRect,deviceType:Int) {
        //super.init(frame: frame)
        self.frame=frame
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        let sanjiaoImg = UIImage(named: "match_finish_sanjiao.png")
        let sanjiaoImgView = UIImageView(frame: CGRectMake((width-(sanjiaoImg?.size.width)!)/2.0, 0, (sanjiaoImg?.size.width)!, (sanjiaoImg?.size.height)!))
        sanjiaoImgView.image = UIImage(named: "match_finish_sanjiao.png")
        self .addSubview(sanjiaoImgView)
        sanjiaoImgView.backgroundColor = UIColor.clearColor()
        
        let bgView = UIView(frame: CGRectMake(0,sanjiaoImgView.frame.size.height-2,width,self.frame.size.height-sanjiaoImgView.frame.size.height+2))
        bgView.backgroundColor = UIColor.whiteColor()
        self.addSubview(bgView)
        
        let scrollView = UIScrollView(frame: CGRectMake(0,sanjiaoImgView.frame.size.height,bgView.frame.size.width,bgView.frame.size.height))
        self.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.clearColor()
        
        self.backgroundColor = UIColor(red: 110.0, green: 206.0, blue: 250.0, alpha: 1.0)
        self.backgroundColor = UIColor.clearColor()
        //TODO:
        //(width-150*(width/375.0))
        let cupNameTextField = UITextField(frame: CGRectMake((width-190*(width/375.0))/2.0,55*(height/667.0),190*(width/375.0),17*(height/667.0)))
        cupNameTextField.placeholder = loadLanguage("输入设备名称")
        cupNameTextField.delegate = self
        cupNameTextField.font = UIFont.systemFontOfSize(17*(height/667.0))
        cupNameTextField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cupNameTextField.textAlignment = NSTextAlignment.Center
        self.myTanTouNameTextField = cupNameTextField
        scrollView.addSubview(cupNameTextField)
        
        let leftSeparatorView = UIView(frame: CGRectMake(cupNameTextField.frame.origin.x,cupNameTextField.frame.size.height+cupNameTextField.frame.origin.y+10*(height/667.0),190*(width/375.0),1))
        leftSeparatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scrollView.addSubview(leftSeparatorView)
        

        let label:UILabel = UILabel(frame: CGRectMake((width-190*(width/375.0))/2.0,29*(height/667.0)+leftSeparatorView.frame.size.height+leftSeparatorView.frame.origin.y,190*(width/375.0),18*(height/667.0)))
            //UILabel(frame: CGRectMake((width-150*(width/375.0))/2,29*(height/667.0)+leftSeparatorView.frame.size.height+leftSeparatorView.frame.origin.y,150*(width/375.0),18*(height/667.0)))
        label.text = loadLanguage("办公室")
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(16*(height/667.0))
        label.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        scrollView.addSubview(label)
        
        //如果是空气净化器 0:水杯 1:探头 2:净水器 3:台式 4:立式 5:补水仪
        print(deviceType)
        switch deviceType
        {
        case 0,1,2,4,5:
            break
        case 3:
            label.text=loadLanguage("客厅")
        case 6:
            segmentControl=UISegmentedControl(items: [loadLanguage("女"),loadLanguage("男")])
            segmentControl?.frame=CGRect(x: (Screen_Width-126)/2, y: 29*(height/667.0)+leftSeparatorView.frame.size.height+leftSeparatorView.frame.origin.y, width: 126, height: 25)
            segmentControl?.layer.borderColor=UIColor(red: 64/255, green: 140/255, blue: 241/255, alpha: 1).CGColor
            segmentControl?.layer.borderWidth=1
            segmentControl?.layer.cornerRadius=12
            segmentControl?.layer.masksToBounds=true
            segmentControl?.selectedSegmentIndex=0
            scrollView.addSubview(segmentControl!)
            label.frame=CGRect(x: (Screen_Width-126)/2, y: segmentControl!.frame.origin.y+30, width: 126, height: 20)
            label.text=loadLanguage("请选择设定您的性别")
            label.font = UIFont.systemFontOfSize(12*(height/667.0))
        default:
            break
        }
        
        //let rowImg = UIImage(named: "pull_down_row.png")
        
        //let pullDownImgView = UIImageView(frame: CGRectMake(label.frame.size.width+label.frame.origin.x+31*(width/375.0), (label.frame.size.height-(rowImg?.size.height)!)/2+label.frame.origin.y, (rowImg?.size.width)!, (rowImg?.size.height)!))
        
        //pullDownImgView.image = UIImage(named: "pull_down_row.png")
        //scrollView .addSubview(pullDownImgView)
        
        let button = UIButton(frame: CGRectMake(16*(width/375.0),180*(height/667.0),width-16*(width/375.0)*2,40*(height/667.0)))
        button.backgroundColor = UIColor(red: 60.0/255, green: 137.0/255, blue: 242.0/255, alpha: 1.0)
        button.setTitle(loadLanguage("完成"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(finishedAction), forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.masksToBounds = true;
        button.layer.cornerRadius = 20;
        scrollView .addSubview(button)
        
        scrollView.contentSize = CGSizeMake(width, button.frame.size.height+button.frame.origin.y+40*(height/667.0)+20)
        
    }
    
    func finishedAction()
    {
        
        delegate?.otherFinishedAction()
        
    }

    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

}
