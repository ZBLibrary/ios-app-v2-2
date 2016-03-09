//
//  WaterReplenishMainView.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
let kWidthOfWaterReplensh=Screen_Width/375
let kHightOfWaterReplensh=(Screen_Hight-65)/(667-65)
class WaterReplenishMainView: UIView,UIAlertViewDelegate {
    //head视图控件
    @IBOutlet weak var toLeftMenuButton: UIButton!
    @IBOutlet weak var TitleOfReplensh: UILabel!
    @IBOutlet weak var ClickAlertLabel: UILabel!
    @IBOutlet weak var personBgImgView: UIImageView!
    @IBOutlet weak var dianLiangImg: UIImageView!
    @IBOutlet weak var dianLiangValueLabel: UILabel!
    @IBOutlet weak var setButton: UIButton!
    //中部圆形视图
    @IBOutlet weak var centerCircleView: UIView!
    @IBOutlet weak var alertBeforeTest: UILabel!
    @IBOutlet weak var resultValueContainView: UIView!
    @IBOutlet weak var stateOfTestLabel: UILabel!
    @IBOutlet weak var valueOfTestLabel: UILabel!
    //footer容器里的视图
    @IBOutlet weak var skinButton: UIButton!
    @IBOutlet weak var resultOfFooterContainView: UIView!
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var resultStateLabel: UILabel!
    @IBOutlet weak var toDetailButton: UIButton!
    
    private let centerOfImg=CGPoint(x: Screen_Width/2, y: 446*kHightOfWaterReplensh/2)
    //数组以 脸 眼 手 颈 的顺序 半径30范围内
    private let locationOfImg=[
        "女":[CGPoint(x: 142*kWidthOfWaterReplensh, y: 265*kHightOfWaterReplensh),CGPoint(x: 214*kWidthOfWaterReplensh, y: 243*kHightOfWaterReplensh),CGPoint(x: 142*kWidthOfWaterReplensh, y: 370*kHightOfWaterReplensh),CGPoint(x: 206*kWidthOfWaterReplensh, y: 328*kHightOfWaterReplensh)],
        "男":[]
    ]
    //private var currViewIsFirstView=true
    func personImgTapClick(sender: UITapGestureRecognizer) {
        //print(sender.numberOfTouches())
        //print(sender.locationInView(personBgImgView))
        let touchPoint=sender.locationInView(personBgImgView)
        
        if stateOfView>0//当前页是局部器官图
        {
            if pow(centerOfImg.x-touchPoint.x, 2)+pow(centerOfImg.y-touchPoint.y, 2)<=100*100
            {
                print("点击了返回区域")
                stateOfView=0
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![0])
            }
        }
        else
        {
            let locaArr=locationOfImg[currentSex]
            //当前页是四个触电图
            switch true
            {
            case isInside(locaArr![0],touchPoint):
                stateOfView=1
                print("脸")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![1])
            case isInside(locaArr![1],touchPoint):
                stateOfView=1
                print("眼")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![2])
            case isInside(locaArr![2],touchPoint):
                stateOfView=1
                print("手")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![3])
            case isInside(locaArr![3],touchPoint):
                stateOfView=1
                print("颈")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![4])
            default:
                print("其他区域")
                break
            }
        }
        
        print("===================")
    }
    //返回是不是在点的30半径范围内
    private var isInside={ (point1:CGPoint,point2:CGPoint)->Bool in
        
        return pow(point1.x-point2.x, 2)+pow(point1.y-point2.y, 2)<=30*30
    }
    override func drawRect(rect: CGRect) {
        
        centerCircleView.layer.cornerRadius=60.0*Screen_Width/375.0
        centerCircleView.layer.masksToBounds=true
        skinButton.layer.cornerRadius=20
        skinButton.layer.borderWidth=0.5
        skinButton.layer.borderColor=UIColor(red: 91/255, green: 152/255, blue: 240/255, alpha: 1).CGColor
        stateOfView=0
        //图片添加触摸事件
        let tapGesture=UITapGestureRecognizer(target: self, action: Selector("personImgTapClick:"))
        tapGesture.numberOfTapsRequired=1
        tapGesture.numberOfTouchesRequired=1
        personBgImgView.addGestureRecognizer(tapGesture)
        setNeedsLayout()
        layoutIfNeeded()

    }
    
    //0初始页面,1点击某个部位进入的页面,2检测中,3检测结果出来显示的页面
    private let color_blue=UIColor(red: 61/255.0, green: 127/255.0, blue: 250/255.0, alpha: 1)
    private let color_yellow=UIColor(red: 251/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1)
    private var stateOfView = -1{
        didSet{
            ClickAlertLabel.hidden=true
            centerCircleView.hidden=false
            alertBeforeTest.hidden=true
            resultValueContainView.hidden=true
            resultOfFooterContainView.hidden=false
            skinButton.hidden=true
            switch stateOfView
            {
            case 0:
                ClickAlertLabel.hidden=false
                centerCircleView.hidden=true
                skinButton.hidden=false
                resultOfFooterContainView.hidden=true
                
            case 1:
                alertBeforeTest.hidden=false
                centerCircleView.backgroundColor=color_blue
                //alertBeforeTest.text="检测中"
                alertBeforeTest.font=UIFont.systemFontOfSize(16)
                resultStateLabel.text=""
                
            case 2:
                alertBeforeTest.hidden=false
                alertBeforeTest.text="检测中"
                alertBeforeTest.font=UIFont.systemFontOfSize(20)
                resultStateLabel.text=""
            case 3:
                resultValueContainView.hidden=false
            default:
                break
            }
        }
    }
    private let personImgArray=[
        "女":["womanOfReplensh1","womanOfReplensh2","womanOfReplensh3","womanOfReplensh4","womanOfReplensh5"],
        "男":["manOfReplensh1","manOfReplensh2","manOfReplensh3","manOfReplensh4","manOfReplensh5"]
    ]
    
    //当前性别
    private var currentSex="女"{
        didSet{
        }
    }
    //更新视图
    func updateView(state:Int)//,deviceTitle:String,skinVlue:Float)
    {
        stateOfView=state
        setNeedsLayout()
        layoutIfNeeded()
    }

}
