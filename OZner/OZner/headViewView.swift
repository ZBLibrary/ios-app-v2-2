//
//  headViewView.swift
//  OZner
//
//  Created by test on 15/12/21.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit
let airViewColor_state1:UIColor=UIColor(red: 94/255, green: 207/255, blue: 254/255, alpha: 1)//蓝
let airViewColor_state2:UIColor=UIColor(red: 163/255, green: 129/255, blue: 251/255, alpha: 1)//紫
let airViewColor_state3:UIColor=UIColor(red: 254/255, green: 101/255, blue: 101/255, alpha: 1)//红
class headViewView: UIView {

    
    @IBOutlet var loadingLabel: UILabel!
    @IBOutlet var headTitle: UILabel!
    @IBOutlet var toLeftMenu: UIButton!
    @IBOutlet var backGroundView: UIView!
    @IBOutlet var gitWebView: UIWebView!
    @IBOutlet var guangHuanBgImage: UIImageView!
    @IBOutlet var guanghuanInImage: UIImageView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var toSetting: UIButton!
    @IBOutlet var seeOutAir: UIButton!
    @IBOutlet var seeIndoorAir: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var lvxinState: UILabel!
    
    @IBOutlet var cityName: UILabel!
    @IBOutlet var polution: UILabel!
    @IBOutlet var PM25: UILabel!
    
    @IBOutlet var LvXinState: UIButton!
    @IBOutlet weak var Airpulifer: UILabel!
    @IBOutlet var centerViewzb: UIView!
    
    @IBOutlet var LvXinStateImage: UIImageView!
    var bgColorIndex:Int=1 {
        didSet{
            print(bgColorIndex)
            updateState(bgColorIndex)
        }
    }
    
   
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
     
        
      //polution.text = loadLanguage("滤芯状态");
        
        //Airpulifer.text = loadLanguage("台式空气净化器");
        
        setNeedsLayout()
        layoutIfNeeded()
        
        
    }
    
    func updateState(state:Int)
    {
        switch(state)
        {
        case 1:
            backGroundView.backgroundColor=airViewColor_state1
            bottomView.backgroundColor=airViewColor_state1
            guangHuanBgImage.image=UIImage(named: "GuangHuanbg")
            break
        case 2:
            backGroundView.backgroundColor=airViewColor_state2
            bottomView.backgroundColor=airViewColor_state2
            guangHuanBgImage.image=UIImage(named: "GuangHuanbg2")
            break
        case 3:
            backGroundView.backgroundColor=airViewColor_state3
            bottomView.backgroundColor=airViewColor_state3
            guangHuanBgImage.image=UIImage(named: "GuangHuanbg3")
            break
        default:
            break
        }
    }
    func initView() {
        let gif:NSData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("Airgif_blue", ofType: "gif")!)!
        gitWebView.userInteractionEnabled = false
        gitWebView.scalesPageToFit = true
        gitWebView.loadData(gif, MIMEType: "image/gif", textEncodingName: "utf-8", baseURL: NSURL(string: "")!)
        //旋转动画
        startAnimation(0,angle1: 0)
        loadingView.hidden=true
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func startAnimation(angle:CGFloat,angle1:CGFloat)
    {
        let endAngle:CGAffineTransform = CGAffineTransformMakeRotation(angle*CGFloat(M_PI/180.0))
        let endAngle1:CGAffineTransform = CGAffineTransformMakeRotation(angle1*CGFloat(M_PI/180.0))
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.guangHuanBgImage.transform = endAngle
            self.guanghuanInImage.transform = endAngle1
            }, completion: {(finished:Bool) in
                self.startAnimation(angle+10,angle1: angle1+340)
        })
        
    }

}
