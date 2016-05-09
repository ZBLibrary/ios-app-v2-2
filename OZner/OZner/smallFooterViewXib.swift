//
//  smallFooterViewXib.swift
//  OZner
//
//  Created by test on 15/12/22.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class smallFooterViewXib: UIView {

    var blueTooth: AirPurifier_Bluetooth!
    @IBOutlet var JinDuImage_0: UIImageView!
    @IBOutlet var SlideView: UIView!
    //点击和拖动事件视图
    @IBOutlet var targertView: UIView!
    @IBOutlet var speedValue: UILabel!
    @IBOutlet var speedText: UILabel!
    @IBOutlet weak var slideLeft: NSLayoutConstraint!
    @IBOutlet weak var img0Width: NSLayoutConstraint!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    func initView()
    {
        SlideView.layer.borderWidth=1
        SlideView.layer.borderColor=UIColor(red: 0, green: 104/255, blue: 246/255, alpha: 1).CGColor
        SlideView.layer.cornerRadius=30
        SlideView.layer.masksToBounds=false
        SlideView.layer.shadowOffset=CGSizeMake(0, 0)//阴影偏移量
        SlideView.layer.shadowRadius=5//阴影半径
        SlideView.layer.shadowOpacity=0.6//透明度
        SlideView.layer.shadowColor=UIColor(red: 0, green: 104/255, blue: 246/255, alpha: 1).CGColor
        //添加拖动手势
        let panGesture=UIPanGestureRecognizer(target: self, action: #selector(panImage))
        targertView.addGestureRecognizer(panGesture)
        //添加点击手势
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(tapImage))
        tapGesture.numberOfTapsRequired=1//设置点按次数
        targertView.addGestureRecognizer(tapGesture)
        if blueTooth != nil
        {
            print(blueTooth.status.RPM)
            let initpoint:CGFloat=CGFloat(blueTooth.status.RPM)/100.0*(SCREEN_WIDTH-108)
            
            
            upDateFrame(min(initpoint, SCREEN_WIDTH-108))
        }
        
    }
    func panImage(gesture:UIPanGestureRecognizer)
    {
        
        if (gesture.state == UIGestureRecognizerState.Changed || gesture.state == UIGestureRecognizerState.Ended) {
            if (gesture.numberOfTouches() <= 0) {
                return;
            }
            let tapPoint:CGPoint = gesture.locationOfTouch(0, inView: targertView)
            if tapPoint.x<30||tapPoint.x>(SCREEN_WIDTH-78) {
                return
            }
            upDateFrame((tapPoint.x-30))
        }
        
    }
    func tapImage(gesture:UITapGestureRecognizer)
    {
        if (gesture.state == UIGestureRecognizerState.Ended) {
            if (gesture.numberOfTouches() <= 0) {
                return
            }
            let tapPoint:CGPoint = gesture.locationOfTouch(0, inView: targertView)
            print(tapPoint.x)
            //设置视图
            if tapPoint.x<30||tapPoint.x>(SCREEN_WIDTH-108) {
                return
            }
            upDateFrame(tapPoint.x-30)
        }
    }
    
    func upDateFrame(x:CGFloat)
    {
        
        img0Width.constant = -x
        let tmpValue = x/(SCREEN_WIDTH-108)
        
        speedValue.text="\(Int(tmpValue*100))"
        if tmpValue<1/3
        {
            speedText.text="低速"
        }
        else if tmpValue>2/3
        {
            speedText.text="高速"
        }
        else{
            speedText.text="中速"
        }
        blueTooth.status.setRPM(Int32(tmpValue*100), callback: {
            (error:NSError!) in
        })
        if x==0
        {
            blueTooth.status.setPower(false, callback: {
                (error:NSError!) in
                
            })
        }
        else
        {
            blueTooth.status.setPower(true, callback: {
                (error:NSError!) in
                
            })
        }

    }
}
