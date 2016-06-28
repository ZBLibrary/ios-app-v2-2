//
//  drawCircleView.swift
//  OZner
//
//  Created by test on 16/1/20.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class drawCircleView_EN: UIView {

    
    var type=1 //0 TDS，1 水温
    var state1=0
    var state2=0
    var state3=0
    
    let colordefault=UIColor.init(red: 235/255, green: 242/255, blue: 248/255, alpha: 1)
    let color1=UIColor.init(red: 241/255, green: 102/255, blue: 102/255, alpha: 1)
    let color2=UIColor.init(red: 128/255, green: 94/255, blue: 230/255, alpha: 1)
    let color21=UIColor.init(red: 242/255, green: 134/255, blue: 82/255, alpha: 1)
    let color3=UIColor.init(red: 70/255, green: 143/255, blue: 241/255, alpha: 1)
    
    override func drawRect(rect: CGRect) {
        // Drawing code
       //setCircle()
        
    }
  
    func setCircle()
    {
        for i in 1...6
        {
            var lineColor:UIColor!
            var radius:CGFloat=0.0
            var endAngle:Double=0
            switch i
            {
            case 1:
                endAngle=M_PI
                lineColor=colordefault
                radius=frame.height/2-5
                break
            case 2:
                endAngle=M_PI
                lineColor=colordefault
                radius=frame.height/2-20
                break
            case 3:
                endAngle=M_PI
                lineColor=colordefault
                radius=frame.height/2-35
                break
            case 4:
                
                endAngle = 3*M_PI*Double(state1)/100/2-M_PI/2
                lineColor=color1
                radius=frame.height/2-5
                break
            case 5:
                endAngle = 3*M_PI*Double(state2)/100/2-M_PI/2
                lineColor=type==0 ? color2:color21
                radius=frame.height/2-20
                break
            case 6:
                endAngle = 3*M_PI*Double(state3)/100/2-M_PI/2
                lineColor=color3
                radius=frame.height/2-35
                break
            default:
                break
            }
            let beierpath=UIBezierPath.init()
            
            beierpath.addArcWithCenter(CGPoint(x: frame.height/2, y: frame.height/2), radius: radius, startAngle: CGFloat(-M_PI/2), endAngle: CGFloat(endAngle), clockwise: true)
            beierpath.lineCapStyle=CGLineCap.Round
            beierpath.lineJoinStyle=CGLineJoin.Round
            beierpath.lineWidth=10.0
            
            let mcashapelayer=CAShapeLayer()
            mcashapelayer.path=beierpath.CGPath
            mcashapelayer.strokeColor=lineColor.CGColor
            mcashapelayer.fillColor=nil
            
            //mcashapelayer.opacity=0.5
            
            mcashapelayer.strokeStart=0.0
            mcashapelayer.strokeEnd=0
            mcashapelayer.lineWidth=10
            mcashapelayer.lineCap=kCALineCapRound
            mcashapelayer.lineJoin=kCALineJoinRound
            
            
            self.layer.addSublayer(mcashapelayer)
            let anim=CABasicAnimation(keyPath: "strokeEnd")
            anim.duration = 3.0
            if i<=3
            {
                anim.duration = 0.0
            }
            
            anim.delegate=self
            anim.removedOnCompletion=false
            anim.additive=true
            anim.fillMode=kCAFillModeForwards
            anim.fromValue=0
            anim.toValue=1
            mcashapelayer.addAnimation(anim, forKey: "strokeEnd")
//            if i>3
//            {
//                drawJianbian(radius,endAngle: endAngle)
//            }
        }
        
        
    }
    
    func drawJianbian(radius:CGFloat,endAngle:Double){
        print(CGFloat(endAngle))
        let drawCount=Int((endAngle+M_PI/2)*180/M_PI)
        if drawCount<=0
        {
            return
        }
        let drawWidth:CGFloat=CGFloat(endAngle+M_PI/2)/CGFloat(drawCount)
        for i in 0...drawCount
        {
            let beierpath=UIBezierPath.init()
            let starAng=CGFloat(i)*drawWidth-CGFloat(M_PI/2)
            let endAng=CGFloat(i+1)*drawWidth-CGFloat(M_PI/2)
            beierpath.addArcWithCenter(CGPoint(x: frame.height/2, y: frame.height/2), radius: radius, startAngle: starAng, endAngle: endAng, clockwise: true)
            beierpath.lineCapStyle=CGLineCap.Round
            beierpath.lineJoinStyle=CGLineJoin.Round
            beierpath.lineWidth=10.0
            
            let mcashapelayer=CAShapeLayer()
            mcashapelayer.path=beierpath.CGPath
            
            mcashapelayer.strokeColor=UIColor.whiteColor().CGColor
            mcashapelayer.fillColor=nil
            mcashapelayer.opacity = Float(i)/Float(drawCount)
            
            mcashapelayer.strokeStart=0.0
            mcashapelayer.strokeEnd=0
            mcashapelayer.lineWidth=10
            mcashapelayer.lineCap=kCALineCapRound
            mcashapelayer.lineJoin=kCALineJoinRound
            self.layer.addSublayer(mcashapelayer)
        }
    }

}
