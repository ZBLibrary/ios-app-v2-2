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
        let panGesture=UIPanGestureRecognizer(target: self, action: Selector("panImage:"))
        targertView.addGestureRecognizer(panGesture)
        //添加点击手势
        let tapGesture=UITapGestureRecognizer(target: self, action: Selector("tapImage:"))
        tapGesture.numberOfTapsRequired=1//设置点按次数
        targertView.addGestureRecognizer(tapGesture)
        if blueTooth != nil
        {
            let initpoint:CGFloat=CGFloat(blueTooth.status.RPM)/100.0*targertView.bounds.size.width
            print(blueTooth.status.RPM)
            print("起始风速：\(initpoint)")
            upDateFrame(initpoint)
        }
        
    }
    func panImage(gesture:UIPanGestureRecognizer)
    {
        
        if (gesture.state == UIGestureRecognizerState.Changed || gesture.state == UIGestureRecognizerState.Ended) {
            if (gesture.numberOfTouches() <= 0) {
                return;
            }
            let tapPoint:CGPoint = gesture.locationOfTouch(0, inView: targertView)
            if tapPoint.x>targertView.frame.size.width||tapPoint.x<0
            {
                return
            }
            upDateFrame(tapPoint.x)
        }
        
    }
    func tapImage(gesture:UITapGestureRecognizer)
    {
        if (gesture.state == UIGestureRecognizerState.Ended) {
            if (gesture.numberOfTouches() <= 0) {
                return
            }
            let tapPoint:CGPoint = gesture.locationOfTouch(0, inView: targertView)
            //设置视图
            upDateFrame(tapPoint.x)
        }
    }
    
    func upDateFrame(x:CGFloat)
    {
        let tmpwidth=targertView.bounds.size.width-x
        let tmpFrame=targertView.frame
        JinDuImage_0.frame=CGRect(x: tmpFrame.origin.x+x, y:JinDuImage_0.frame.origin.y, width: tmpwidth, height: JinDuImage_0.frame.size.height)
        SlideView.frame=CGRect(x: tmpFrame.origin.x+x-30, y:SlideView.frame.origin.y, width: 60, height: 60)
        //
        speedValue.text="\(Int(x/targertView.bounds.size.width*100))"
        if (x/targertView.bounds.size.width)<1/3
        {
            speedText.text="低速"
        }
        else if (x/targertView.bounds.size.width)>2/3
        {
            speedText.text="高速"
        }
        else{
            speedText.text="中速"
        }
        //开机
        blueTooth.status.setPower(true, callback: {
            (error:NSError!) in
            if error != nil
            {
                print(error)
            }
        })

        blueTooth.status.setRPM(Int32(x/targertView.bounds.size.width*100), callback: {
            (error:NSError!) in
          if error != nil
          {
            print(error)
            }
        })
//        setNeedsLayout()
//        layoutIfNeeded()
    }
}
