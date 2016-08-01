//
//  LoadingXib.swift
//  OZner
//
//  Created by 赵兵 on 16/1/28.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class LoadingXib: UIView {

    @IBOutlet var loadIcon: UIImageView!
    @IBOutlet var loadText: UILabel!
    //0加载中，1加载失败，2加载成功
    var state=0{
        didSet{
            switch state
            {
            case 0:
                loadIcon.hidden=false
                loadText.hidden=false
                loadIcon.image=UIImage(named: "airloding")
                loadText.text="正在连接中"
                isEnd=false
                starAnima()
                break
            case 1:
                loadIcon.hidden=false
                loadText.hidden=false
                loadIcon.image=UIImage(named: "air007")
                loadText.text="设备已断开"
                isEnd=true
                break
            case 2:
                loadIcon.hidden=false
                loadText.hidden=false
                loadIcon.image=UIImage(named: "air007")
                loadText.text="手机网络不可用，请检查网络"
                isEnd=true
                break
            default://-1已连接
                isEnd=true
                loadIcon.hidden=true
                loadText.hidden=true
                break
            }
            
        }
    }
    var imageViewAngle=0.0
    var isEnd=false
    func starAnima()
    {
        if isEnd==true
        {
            self.loadIcon.transform=CGAffineTransformMakeRotation(0)
            return
        }
        let endAngle = CGAffineTransformMakeRotation(CGFloat(imageViewAngle*(M_PI / 180.0)))
        UIView.animateWithDuration(0.01, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.loadIcon.transform=endAngle
            }) { (finished:Bool) -> Void in
                self.imageViewAngle += 10
                    self.starAnima()
                
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}