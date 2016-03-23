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
enum SexType:String{
    case Man="男"
    case WoMan="女"
}
enum BodyParts:String{
    case Face="Face"
    case Eyes="Eyes"
    case Hands="Hands"
    case Neck="Neck"
}//Face ，Eyes ,Hands, Neck
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
    @IBOutlet weak var TestingIcon: UIImageView!
    //footer容器里的视图
    @IBOutlet weak var skinButton: UIButton!
    @IBOutlet weak var resultOfFooterContainView: UIView!
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var resultStateLabel: UILabel!
    @IBOutlet weak var toDetailButton: UIButton!
    
    private let centerOfImg=CGPoint(x: Screen_Width/2, y: 446*kHightOfWaterReplensh/2)
    //数组以 脸 眼 手 颈 的顺序 半径30范围内
    private let locationOfImg=[
        SexType.WoMan:[CGPoint(x: 142*kWidthOfWaterReplensh, y: 265*kHightOfWaterReplensh),CGPoint(x: 214*kWidthOfWaterReplensh, y: 243*kHightOfWaterReplensh),CGPoint(x: 142*kWidthOfWaterReplensh, y: 370*kHightOfWaterReplensh),CGPoint(x: 206*kWidthOfWaterReplensh, y: 328*kHightOfWaterReplensh)],
        SexType.Man:[CGPoint(x: 142*kWidthOfWaterReplensh, y: 265*kHightOfWaterReplensh),CGPoint(x: 214*kWidthOfWaterReplensh, y: 243*kHightOfWaterReplensh),CGPoint(x: 142*kWidthOfWaterReplensh, y: 370*kHightOfWaterReplensh),CGPoint(x: 206*kWidthOfWaterReplensh, y: 328*kHightOfWaterReplensh)]
    ]
    //设备
    private var WaterReplenishDevice:WaterReplenishmentMeter?
    func personImgTapClick(sender: UITapGestureRecognizer) {
        let touchPoint=sender.locationInView(personBgImgView)
        if stateOfView>0//当前页是局部器官图二级界面
        {
                stateOfView=0
                print("点击了返回区域")
        }
        else//当前页是主视图一级界面
        {
            let locaArr=locationOfImg[currentSex]
            switch true
            {
            case isInside(locaArr![0],touchPoint):
                stateOfView=1
                alertBeforeTest.text="请将补水仪放置脸部"
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![1])
            case isInside(locaArr![1],touchPoint):
                stateOfView=1
                alertBeforeTest.text="请将补水仪放置眼部"
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![2])
            case isInside(locaArr![2],touchPoint):
                stateOfView=1
                alertBeforeTest.text="请将补水仪放置手部"
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![3])
            case isInside(locaArr![3],touchPoint):
                stateOfView=1
                alertBeforeTest.text="请将补水仪放置颈部"
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![4])
            default:
                print("点击了其它区域")
                break
            }
        }
        
        
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
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(personImgTapClick))
        tapGesture.numberOfTapsRequired=1
        tapGesture.numberOfTouchesRequired=1
        personBgImgView.addGestureRecognizer(tapGesture)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    //0初始页面,1点击某个部位进入的页面,2检测中,3检测结果出来显示的页面
    private let color_blue=UIColor(red: 61/255.0, green: 127/255.0, blue: 250/255.0, alpha: 1)
    private let color_yellow=UIColor(red: 251/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1)
    //当前选中部位
    private var currentBodyPart:BodyParts=BodyParts.Face
    private var stateOfView = -1{
        didSet{
            ClickAlertLabel.hidden=true
            centerCircleView.hidden=false
            alertBeforeTest.hidden=true
            resultValueContainView.hidden=true
            resultOfFooterContainView.hidden=false
            skinButton.hidden=true
            TestingIcon.hidden=true
            isStopAnimation=true
            switch stateOfView
            {
            case 0:
                ClickAlertLabel.hidden=false
                centerCircleView.hidden=true
                skinButton.hidden=false
                
                resultOfFooterContainView.hidden=true
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![0])
            case 1:
                alertBeforeTest.hidden=false
                centerCircleView.backgroundColor=color_blue
                alertBeforeTest.font=UIFont.systemFontOfSize(16)
                resultStateLabel.text=""
                
            case 2:
                //下载水分数据
                downWaterTypeData()
                alertBeforeTest.hidden=false
                TestingIcon.hidden=false
                alertBeforeTest.text="检测中"
                alertBeforeTest.font=UIFont.systemFontOfSize(20)
                resultStateLabel.text=""
                //检测转圈动画
                isStopAnimation=false
                startAnimations(0)
            case 3:
                resultValueContainView.hidden=false
                print(WaterReplenishDevice!.status.oil)//油分
                print(WaterReplenishDevice!.status.moisture)//水分
                let testResult=getNeedOilAndWaterValue(WaterReplenishDevice!.status.oil)
                stateOfTestLabel.text=testResult.moistureValue
                valueOfTestLabel.text=WaterType[testResult.TypeIndex]
                resultStateLabel.text=WaterStateArr[currentBodyPart]![testResult.TypeIndex]
                skinButton.titleLabel?.text="您的肤质   "+SkinType[testResult.skinTypeIndex]
                uploadSKinData(testResult.oilValue, snumber: testResult.moistureValue)
                
            default:
                break
            }
        }
    }
    //服务器部位字段 action:  Face ，Eyes ,Hands, Neck
    private func downWaterTypeData()
    {
        
        //下载周月数据
        MBProgressHUD.showHUDAddedTo(self, animated: true)
        let deviceService=DeviceWerbservice()
        deviceService.GetTimesCountBuShui(WaterReplenishDevice?.identifier, action: currentBodyPart.rawValue) { (Times, status) -> Void in
            MBProgressHUD.hideHUDForView(self, animated: true)
            if(status.networkStatus == kSuccessStatus)
            {
                print(Times)
                //更新数据
                self.resultValueLabel.text="上一次检测 40%  |  平均值 33.3%（3次）"
                
                print(Times)
            }
        }
        
    }
    //水分类型描述
    private let WaterStateArr=[
        BodyParts.Face:["脸颊两边皮肤干燥起皮  T区油腻毛孔粗大痘痘横行 脸部亟需补水哦","皮肤不油也不干 脸部缺水问题暂时得到缓解","脸部细腻红润有光泽 补水到位 面色也不一样哦"],
        BodyParts.Eyes:["眼部肌肤干燥，易出现皱纹及水肿。此处皮肤一旦松弛较难恢复原状态。补水是延缓衰老的根本保障","眼部现在的皮肤水分属于正常水平，但是略显疲惫，请注意保湿！","眼部现在的肌肤已经喝饱了水分！要继续保持哦！"],
        BodyParts.Hands:["手部干燥细纹也跑出来啦 手指的肉刺也变多 需要赶快补充水分哦","手部现在的肌肤水份得到补充 果然光滑许多","手部润滑有弹性 喝饱水的肌肤果然让人爱不释手呢 "],
        BodyParts.Neck:["颈部组织薄弱，油脂分泌少，水分难以保持，皱纹容易产生，补水显得格外重要","颈部水份已达标，别让颈纹泄露了你的年龄","颈部现在很水润，但不要松懈哦"]
    ]
    //通过adc数据得到油分，水分，和肤质类型
    private let oilArr=[0.036,
        0.036,
        0.0355,
        0.035,
        0.0345,
        0.034,
        0.0335,
        0.033,
        0.0325,
        0.032,
        0.0315,
        0.031,
        0.0305,
        0.03,
        0.0295,
        0.029]
    private let moistureArr=[0.082,
        0.082,
        0.081,
        0.08,
        0.079,
        0.079,
        0.078,
        0.078,
        0.078,
        0.076,
        0.0755,
        0.075,
        0.0745,
        0.074,
        0.0735,
        0.073]
    private let SkinType=["干性","中性","油性"]
    private let WaterType=["干燥","正常","水润"]
    private let WaterTypeValue=[BodyParts.Face:[32,42],
                           BodyParts.Eyes:[35,45],
                           BodyParts.Hands:[30,38],
                           BodyParts.Neck:[35,45]
    ]
    private func getNeedOilAndWaterValue(adc:Float)->(oilValue:String,moistureValue:String,TypeIndex:Int,skinTypeIndex:Int)
    {
        var tmpIndex=Int(adc-1)/50-3
        tmpIndex=tmpIndex<0 ? 0:tmpIndex
        tmpIndex=tmpIndex>15 ? 15:tmpIndex
        var tmpOil=Int(Float(oilArr[tmpIndex])*adc)
        tmpOil=tmpOil>=100 ? 99:tmpOil
        var tmpmoisture=Int(Float(moistureArr[tmpIndex])*adc)
        tmpmoisture=tmpmoisture>=100 ? 99:tmpmoisture
        //肤质类型
        var tmpTypeindex=1
        
        if tmpmoisture<WaterTypeValue[currentBodyPart]![0]
        {
            tmpTypeindex=0
        }
        else if tmpmoisture>WaterTypeValue[currentBodyPart]![1]
        {
            tmpTypeindex=2
        }
        var tmpskinTypeIndex=1
        if tmpOil<12
        {
            tmpskinTypeIndex=0
        }
        else if tmpOil>20
        {
            tmpskinTypeIndex=2
        }
        return ("\(Int(tmpOil))","\(Int(tmpmoisture))",tmpTypeindex,tmpskinTypeIndex)
    }
    //private getStateOf
    //检测中动画效果
    private var isStopAnimation=false
    private func startAnimations(angle:CGFloat)
    {
        let endAngle:CGAffineTransform = CGAffineTransformMakeRotation(angle*CGFloat(M_PI/180.0))
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.TestingIcon.transform = endAngle
            
            }, completion: {(finished:Bool) in
                if self.isStopAnimation==false
                {
                    self.startAnimations(angle+30)
                }
        })
    }

    private let personImgArray=[
        SexType.WoMan:["womanOfReplensh1","womanOfReplensh2","womanOfReplensh3","womanOfReplensh4","womanOfReplensh5"],
        SexType.Man:["manOfReplensh1","manOfReplensh2","manOfReplensh3","manOfReplensh4","manOfReplensh5"]
    ]
    
    //当前性别
    private var currentSex:SexType=SexType.WoMan{
        didSet{
            stateOfView=0
        }
    }
    //更新性别
    func updateViewzb(Sex Sex:SexType)
    {
        currentSex=Sex
        setNeedsLayout()
        layoutIfNeeded()
    }
    //皮肤检测回掉方法
    func updateViewState()
    {
        
        if ((WaterReplenishDevice?.status.testing) == true)&&(stateOfView==1||stateOfView==3)
        {
            stateOfView=2//检测中
            
        }else if stateOfView==2&&WaterReplenishDevice!.status.oil>0&&WaterReplenishDevice!.status.moisture>0
        {
            //检测完成
            stateOfView=3
        }
        else
        {
            return
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    //初始化视图
    func initView(currentDevice:OznerDevice)
    {
        WaterReplenishDevice=currentDevice as? WaterReplenishmentMeter
        //设置电量
        self.TitleOfReplensh.text = removeAdressOfDeviceName(WaterReplenishDevice!.settings.name)
        var dianliang = Double((WaterReplenishDevice?.status.battery)!)
        print(dianliang)
        if(dianliang == 65535)
        {
            dianliang = 0
        }
        if(dianliang == 0)
        {
            dianLiangImg.image = UIImage(named: "dian_liang_0.png")
        }
        else if(dianliang <= 0.3)
        {
            dianLiangImg.image = UIImage(named: "dian_liang_30.png")
        }
        else if(dianliang <= 0.7)
        {
            dianLiangImg.image = UIImage(named: "dian_liang_70.png")
        }
        else
        {
            dianLiangImg.image = UIImage(named: "dian_liang_100.png")
        }
        dianliang = dianliang * 100
        dianLiangValueLabel.text = String(Int(dianliang)) + "%"
    
        //设置性别
        let tmpSex=WaterReplenishDevice?.settings.get("sex", default: "女") as! String
        updateViewzb(Sex: tmpSex=="女" ? SexType.WoMan:SexType.Man)
       
    }
    
    
    
    //上传检测数据
    private func uploadSKinData(ynumber:String,snumber:String)
    {
        let deviceService=DeviceWerbservice()
        deviceService.UpdateBuShuiYiNumber(WaterReplenishDevice?.identifier, ynumber: ynumber, snumber: snumber, action: currentBodyPart.rawValue, returnBlock: { (status) in
            if(status.networkStatus == kSuccessStatus)
            {
                print("上传检测肤质成功")
            }
        })
    }
    private func removeAdressOfDeviceName(tmpName:String)->String
    {
        if tmpName.characters.contains("(")==false
        {
            return tmpName
        }
        else
        {
            let NameStr:NSArray = tmpName.componentsSeparatedByString("(")
            return (NameStr.objectAtIndex(0) as! String)
        }
    }
}
