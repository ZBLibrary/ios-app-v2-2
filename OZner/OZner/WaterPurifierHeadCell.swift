//
//  WaterPurifierHeadCell.swift
//  OZner
//
//  Created by 赵兵 on 16/2/17.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class WaterPurifierHeadCell: UITableViewCell {

    //TDS详情页
    @IBOutlet var toTDSDetailButton: UIButton!
    //半圆容器
    @IBOutlet var cicleContainerView: UIView!
    //
    @IBOutlet var faceImgView: UIImageView!
    @IBOutlet var faceTextLabel: UILabel!
    @IBOutlet var purifiedBefore: UILabel!//有数据字体 54，无数据字体 40
    @IBOutlet var purifiedAfter: UILabel!
    @IBOutlet var drinkingSuggest: UILabel!
    //为了解决一个bug
    //var firstLoadTwo=3
    //净化前数据
    var TdsBefore:Int = 0{
        didSet{
            print("TdsBefore:\(TdsBefore)")
            if TdsBefore==oldValue//&&firstLoadTwo<0
            {
                return
            }
            //firstLoadTwo--
            if TdsBefore==65535
            {
                RedrawCicle(0, TDS: 0)
                return
            }
            else
            {
                RedrawCicle(0, TDS:TdsBefore)
            }
            purifiedBefore.text=TdsBefore==0 ? "暂无":"\(TdsBefore)"
            purifiedBefore.font=UIFont(name: ".SFUIDisplay-Thin", size: (TdsBefore==0 ? 40:52)*Screen_Width/375)
            //RedrawCicle(0, TDS: TdsBefore)
        }
    }
    //净化后数据
    var TdsAfter:Int = 0{
        didSet{
            print("TdsAfter:\(TdsAfter)")
            if TdsAfter==oldValue//&&firstLoadTwo<0
            {
                return
            }
            //firstLoadTwo--
            if TdsAfter==65535||TdsAfter==0
            {
                NoRecord()
                RedrawCicle(1, TDS: 0)
                return
            }
            else
            {
                RedrawCicle(1, TDS:TdsAfter)
            }
            
            purifiedAfter.text="\(TdsAfter)"
            purifiedAfter.font=UIFont(name: ".SFUIDisplay-Thin", size: 52*Screen_Width/375)
            faceImgView.hidden=false
            switch TdsAfter
            {
            case 0...50:
                faceImgView.image=UIImage(named: "waterState1")
                faceTextLabel.text="健康"
                drinkingSuggest.text="经过净化后的水质健康，适合您直饮"
                break
            case 51...200:
                faceImgView.image=UIImage(named: "waterState2")
                faceTextLabel.text="一般"
                drinkingSuggest.text="经过净化后的水质健康，适合您直饮"
                break
            default:
                faceImgView.image=UIImage(named: "waterState3")
                faceTextLabel.text="较差"
                drinkingSuggest.text="经过净化后的水质健康，适合您直饮"
                break
            }
            
        }
    }
    func NoRecord()
    {
        faceImgView.hidden=true
        faceTextLabel.text="暂无"
        purifiedBefore.text="暂无"
        
        purifiedBefore.font=UIFont(name: ".SFUIDisplay-Thin", size: 40*Screen_Width/375)
        purifiedAfter.text="暂无"
        purifiedAfter.font=UIFont(name: ".SFUIDisplay-Thin", size: 40*Screen_Width/375)
        drinkingSuggest.text="您未使用净水器 暂无数据显示"
        //RedrawCicle(0, TDS: 0)
        //RedrawCicle(1, TDS: 0)
    }
    /*重绘半圆 
      type:0 净化前
      TDS:TDS数值
    **/
    var currentShapeLayer_before:CAGradientLayer?
    var currentShapeLayer_after:CAGradientLayer?
    func RedrawCicle(type:Int,TDS:Int)
    {
        setNeedsLayout()
        layoutIfNeeded()
        var radius:CGFloat=0.0
        
        switch type
        {
        case 0:
            
            radius=315*Screen_Width/375/2-4
            if currentShapeLayer_before != Optional.None
            {
                currentShapeLayer_before?.removeFromSuperlayer()
            }
            break
        case 1:
            
            radius=315*Screen_Width/375/2-16
            if currentShapeLayer_after != Optional.None
            {
                currentShapeLayer_after?.removeFromSuperlayer()
            }
            break
        default:
            break
        }
        let beierpath=UIBezierPath.init()
        var tmpAng:CGFloat!
        switch TDS
        {
        case 0...50:
            tmpAng=CGFloat(CGFloat(TDS)/50.0*0.3333-1)*CGFloat(M_PI)
            break
        case 51...200:
            tmpAng=CGFloat(CGFloat(TDS-50)/150.0*0.3333-0.6666)*CGFloat(M_PI)
            break
        case 201...250:
            tmpAng=CGFloat(CGFloat(TDS-200)/50.0*0.3333-0.3333)*CGFloat(M_PI)
            break
        default:
            tmpAng=0
            break
        }
        
        print(315*Screen_Width/375/2)
        beierpath.addArcWithCenter(CGPoint(x: 315*Screen_Width/375/2, y: 315*Screen_Width/375/2), radius: radius, startAngle: CGFloat(-M_PI), endAngle: tmpAng, clockwise: true)
 
        let arc = CAShapeLayer()
        arc.path = beierpath.CGPath
        arc.lineCap = "round"
        arc.fillColor = UIColor.clearColor().CGColor
        arc.strokeColor = UIColor.purpleColor().CGColor
        arc.lineWidth = 8
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration            = 5.0
        
        drawAnimation.repeatCount         = 0
        drawAnimation.removedOnCompletion = false
        drawAnimation.fromValue = 0.0
        drawAnimation.toValue   = 10.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        arc.addAnimation(drawAnimation, forKey: "drawCircleAnimation")
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cicleContainerView.bounds;
        gradientLayer.colors = [
            UIColor(red: 9.0/255, green: 142.0/255, blue: 254.0/255, alpha: 1.0).CGColor,
            UIColor(red: 134.0/255, green: 102.0/255, blue: 255.0/255, alpha: 1.0).CGColor,
            
            UIColor(red: 215.0/255, green: 67.0/255, blue: 113.0/255, alpha: 1.0).CGColor]
        
        gradientLayer.startPoint = CGPointMake(0,0.5);
        gradientLayer.endPoint = CGPointMake(1,0.5);
        if type==0
        {
            currentShapeLayer_before=gradientLayer
        }
        else
        {
            currentShapeLayer_after=gradientLayer
        }
        
        cicleContainerView.layer.addSublayer(gradientLayer)
        gradientLayer.mask = arc
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //初始化视图
        drawSpaceLine()
        NoRecord()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func drawSpaceLine()
    {
        for i in 0...1
        {
            let lineColor=UIColor(red: 212/255, green: 245/255, blue: 252/255, alpha: 1)
            var radius:CGFloat=0.0
            switch i
            {
            case 0:
                radius=315*Screen_Width/375/2-4
                if currentShapeLayer_before != Optional.None
                {
                    currentShapeLayer_before?.removeFromSuperlayer()
                }
                break
            case 1:
               
                radius=315*Screen_Width/375/2-16
                if currentShapeLayer_after != Optional.None
                {
                    currentShapeLayer_after?.removeFromSuperlayer()
                }
                break
            default:
                break
            }
            let beierpath=UIBezierPath.init()
        
            beierpath.addArcWithCenter(CGPoint(x: 315*Screen_Width/375/2, y: 315*Screen_Width/375/2), radius: radius, startAngle: CGFloat(-M_PI), endAngle: 0, clockwise: true)
            beierpath.lineCapStyle=CGLineCap.Round
            beierpath.lineJoinStyle=CGLineJoin.Round
            beierpath.lineWidth=2.0
            
            let mcashapelayer=CAShapeLayer()
            mcashapelayer.path=beierpath.CGPath
            mcashapelayer.strokeColor=lineColor.CGColor
            mcashapelayer.fillColor=nil
            
            //mcashapelayer.opacity=0.5
            
            mcashapelayer.strokeStart=0.0
            mcashapelayer.strokeEnd=0
            mcashapelayer.lineWidth=2
            mcashapelayer.lineCap=kCALineCapRound
            mcashapelayer.lineJoin=kCALineJoinRound
            cicleContainerView.layer.addSublayer(mcashapelayer)
            let anim=CABasicAnimation(keyPath: "strokeEnd")
            anim.duration = 0.0
          
            anim.delegate=self
            anim.removedOnCompletion=false
            anim.additive=true
            anim.fillMode=kCAFillModeForwards
            anim.fromValue=0
            anim.toValue=1
            mcashapelayer.addAnimation(anim, forKey: "strokeEnd")
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
