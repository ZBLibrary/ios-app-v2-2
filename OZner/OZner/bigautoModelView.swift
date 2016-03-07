//
//  autoModelView.swift
//  OZner
//
//  Created by test on 15/12/31.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class bigautoModelView: UIView {

    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var rightImage: UIImageView!
    @IBOutlet var bottomImage: UIImageView!
    
    
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    
    override func drawRect(rect: CGRect) {
    
        //model.text = loadLanguage("模式");
             
        leftImage.layer.borderColor=UIColor.grayColor().CGColor
        rightImage.layer.borderColor=UIColor.grayColor().CGColor
        bottomImage.layer.borderColor=UIColor.grayColor().CGColor
        //bottomImage.layer.shadowRadius=3//阴影半径
        //bottomImage.layer.shadowOpacity=0.8//透明度
        bottomButton.tag=0
        leftButton.tag=1
        rightButton.tag=2
        // Drawing code
    }
    //0 auto , 1 day ,2 night
    let imgOnArray=["air01002","airdayOn","airnightOn"]
    let imgOffArray=["air22012","airdayOff","airnightOff"]
    func setWhitchIsBottom(indextmp:Int)
    {
        //bottomImage.image=UIImage(named: imgOnArray[indextmp])
        switch indextmp
        {
        case 0 :
            bottomImage.image=UIImage(named: imgOnArray[0])
            leftImage.image=UIImage(named: imgOffArray[1])
            rightImage.image=UIImage(named: imgOffArray[2])
            
            break
        case 1 :
            bottomImage.image=UIImage(named: imgOffArray[0])
            leftImage.image=UIImage(named: imgOnArray[1])
            rightImage.image=UIImage(named: imgOffArray[2])
            break
        case 2 :
            bottomImage.image=UIImage(named: imgOffArray[0])
            leftImage.image=UIImage(named: imgOffArray[1])
            rightImage.image=UIImage(named: imgOnArray[2])
            
            break
        default :
            break
        }
    }

}
