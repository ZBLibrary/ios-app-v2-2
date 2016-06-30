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
    case Face="FaceSkinValue"
    case Eyes="EyesSkinValue"
    case Hands="HandSkinValue"
    case Neck="NeckSkinValue"
}//Face ，Eyes ,Hands, Neck
class WaterReplenishMainView_EN: UIView,UIAlertViewDelegate {
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
        SexType.Man:[CGPoint(x: 142*kWidthOfWaterReplensh, y: 262*kHightOfWaterReplensh),CGPoint(x: 214*kWidthOfWaterReplensh, y: 240*kHightOfWaterReplensh),CGPoint(x: 142*kWidthOfWaterReplensh, y: 370*kHightOfWaterReplensh),CGPoint(x: 206*kWidthOfWaterReplensh, y: 328*kHightOfWaterReplensh)]
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
                currentBodyPart=BodyParts.Face
                alertBeforeTest.text=loadLanguage("请将补水仪放置脸部")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![1])
                stateOfView=1
            case isInside(locaArr![1],touchPoint):
                currentBodyPart=BodyParts.Eyes
                alertBeforeTest.text=loadLanguage("请将补水仪放置眼部")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![2])
                stateOfView=1
            case isInside(locaArr![2],touchPoint):
                currentBodyPart=BodyParts.Hands
                alertBeforeTest.text=loadLanguage("请将补水仪放置手部")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![3])
                stateOfView=1
            case isInside(locaArr![3],touchPoint):
                currentBodyPart=BodyParts.Neck
                alertBeforeTest.text=loadLanguage("请将补水仪放置颈部")
                personBgImgView.image=UIImage(named: personImgArray[currentSex]![4])
                stateOfView=1
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
    var currentBodyPart:BodyParts=BodyParts.Face
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
            runTimeOfAnimations=0.0
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
                
                if avgAndTimesArr.count>0
                {
                    let tmpStruct=avgAndTimesArr["\(currentBodyPart.hashValue)"]! as HeadOfWaterReplenishStruct
                    resultValueLabel.text = "\(loadLanguage("上一次检测")) \(Int(tmpStruct.lastSkinValue))%  |  \(loadLanguage("平均值")) \(Int(tmpStruct.averageSkinValue))%（\(tmpStruct.checkTimes)\(loadLanguage("次"))）"
                }
            case 2:
                centerCircleView.backgroundColor=color_blue
                alertBeforeTest.hidden=false
                TestingIcon.hidden=false
                alertBeforeTest.text=loadLanguage("检测中")
                alertBeforeTest.font=UIFont.systemFontOfSize(20)
                resultStateLabel.text=""
                //检测转圈动画
                isStopAnimation=false
                runTimeOfAnimations=0.0
                startAnimations(0)
                if avgAndTimesArr.count>0
                {
                    let tmpStruct=avgAndTimesArr["\(currentBodyPart.hashValue)"]! as HeadOfWaterReplenishStruct
                    resultValueLabel.text = "\(loadLanguage("上一次检测")) \(Int(tmpStruct.lastSkinValue))%  |  \(loadLanguage("平均值")) \(Int(tmpStruct.averageSkinValue))%（\(tmpStruct.checkTimes)\(loadLanguage("次"))）"
                }
            case 3:
                resultValueContainView.hidden=false
                let testResult=getNeedOilAndWaterValue(WaterReplenishDevice!.status.oil,moisture: WaterReplenishDevice!.status.moisture)
                valueOfTestLabel.text=testResult.moistureValue
                stateOfTestLabel.text=WaterType[testResult.TypeIndex]
                centerCircleView.backgroundColor=ColorType[testResult.TypeIndex]
                resultStateLabel.text=WaterStateArr[currentBodyPart]![testResult.TypeIndex]
                if currentBodyPart==BodyParts.Face {
                    currentSkinTypeIndex=testResult.skinTypeIndex
                }
                uploadSKinData(testResult.oilValue, snumber: testResult.moistureValue)

                let tmpTimes=avgAndTimesArr["\(currentBodyPart.hashValue)"]?.checkTimes ?? 0
                avgAndTimesArr["\(currentBodyPart.hashValue)"]?.checkTimes+=1
               
                avgAndTimesArr["\(currentBodyPart.hashValue)"]?.lastSkinValue=Double(testResult.moistureValue as String)!
                var tmpAvg=Double(testResult.moistureValue as String)!
                
                tmpAvg=tmpAvg+(avgAndTimesArr["\(currentBodyPart.hashValue)"]?.averageSkinValue ?? 0)!*Double(tmpTimes)
                tmpAvg=tmpAvg/Double(tmpTimes+1)
                avgAndTimesArr["\(currentBodyPart.hashValue)"]?.averageSkinValue=Double(String(format: "%.1f",tmpAvg))!
                if avgAndTimesArr.count>0
                {
                    let tmpStruct=avgAndTimesArr["\(currentBodyPart.hashValue)"]! as HeadOfWaterReplenishStruct
                    resultValueLabel.text = "\(loadLanguage("上一次检测")) \(Int(tmpStruct.lastSkinValue))%  |  \(loadLanguage("平均值")) \(Int(tmpStruct.averageSkinValue))%（\(tmpStruct.checkTimes)\(loadLanguage("次"))）"
                }
            default:
                break
            }
        }
    }

    //水分类型描述
    private let WaterStateArr=[
        BodyParts.Face:[loadLanguage("脸颊两边皮肤干燥起皮,T区油腻毛孔粗大痘痘横行,脸部亟需补水哦"),loadLanguage("皮肤不油也不干,脸部缺水问题暂时得到缓解"),loadLanguage("脸部细腻红润有光泽,补水到位,面色也不一样哦")],
        BodyParts.Eyes:[loadLanguage("眼部肌肤干燥，易出现皱纹及水肿。此处皮肤一旦松弛较难恢复原状态。补水是延缓衰老的根本保障"),loadLanguage("眼部现在的皮肤水分属于正常水平，但是略显疲惫，请注意保湿！"),loadLanguage("眼部现在的肌肤已经喝饱了水分！要继续保持哦！")],
        BodyParts.Hands:[loadLanguage("手部干燥细纹也跑出来啦,手指的肉刺也变多,需要赶快补充水分哦"),loadLanguage("手部现在的肌肤水份得到补充,果然光滑许多"),loadLanguage("手部润滑有弹性,喝饱水的肌肤果然让人爱不释手呢 ")],
        BodyParts.Neck:[loadLanguage("颈部组织薄弱，油脂分泌少，水分难以保持，皱纹容易产生，补水显得格外重要"),loadLanguage("颈部水份已达标，别让颈纹泄露了你的年龄"),loadLanguage("颈部现在很水润，但不要松懈哦")]
    ]


    private let SkinType=[loadLanguage("干性"),loadLanguage("中性"),loadLanguage("油性")]
    private let WaterType=[loadLanguage("干燥"),loadLanguage("正常"),loadLanguage("水润")]
    private let ColorType=[UIColor(red: 252/255, green: 128/255, blue: 65/255, alpha: 1),UIColor(red: 64/255, green: 125/255, blue: 250/255, alpha: 1),UIColor(red: 64/255, green: 125/255, blue: 250/255, alpha: 1)]
    
    //water,取值范围
    private let WaterTypeValue=[BodyParts.Face:[32,42],
                           BodyParts.Eyes:[35,45],
                           BodyParts.Hands:[30,38],
                           BodyParts.Neck:[35,45]
    ]
    private func getNeedOilAndWaterValue(oil:Float,moisture:Float)->(oilValue:String,moistureValue:String,TypeIndex:Int,skinTypeIndex:Int)
    {
        
        var tmpOil=Int(oil)
        tmpOil=tmpOil>=100 ? 99:tmpOil
        var tmpmoisture=Int(moisture)
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
        return ("\(tmpOil)","\(tmpmoisture)",tmpTypeindex,tmpskinTypeIndex)
    }
    //private getStateOf
    //检测中动画效果
    private var isStopAnimation=false
    private var runTimeOfAnimations:Double=0.0
    private func startAnimations(angle:CGFloat)
    {
        runTimeOfAnimations+=0.1
        let endAngle:CGAffineTransform = CGAffineTransformMakeRotation(angle*CGFloat(M_PI/180.0))
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.TestingIcon.transform = endAngle
            }, completion: {[weak self](finished:Bool) in
                
                if self!.isStopAnimation==false&&self!.runTimeOfAnimations<=10.0
                {
                    self!.startAnimations(angle+30)
                }else
                {
                    if self!.runTimeOfAnimations>=10.0
                    {
                        let alertView=SCLAlertView()
                        alertView.showTitle("", subTitle: loadLanguage("您的检测时间未满5秒..."), duration: 2.0, completeText: loadLanguage("完成"), style: SCLAlertViewStyle.Notice)
                        self!.stateOfView=1
                        self!.alertBeforeTest.text=loadLanguage("检测失败,请重试")
                    }
                    self!.runTimeOfAnimations=0.0
                    self!.isStopAnimation=true
                    
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
    func updateViewzb()
    {
        currentSex=(WaterReplenishDevice?.settings.get("sex", default: loadLanguage("女")))! as! String==loadLanguage("女") ? SexType.WoMan:SexType.Man
        setNeedsLayout()
        layoutIfNeeded()
    }
    //皮肤检测回掉方法
    func updateViewState()
    {
        switch stateOfView {
        case 1:
            if WaterReplenishDevice?.status.testing==true {
                stateOfView=2//检测中
            }
        case 2:
            if WaterReplenishDevice?.status.testing==false {
                let weakSelf=self
                if WaterReplenishDevice!.status.oil==0 {
                    let alertView=SCLAlertView()
                    alertView.showTitle("", subTitle: loadLanguage("您的检测时间未满5秒..."), duration: 2.0, completeText: loadLanguage("完成"), style: SCLAlertViewStyle.Notice)
                    weakSelf.stateOfView=1
                    weakSelf.alertBeforeTest.text=loadLanguage("检测失败,请重试")
                }
                else if (WaterReplenishDevice!.status.oil < 0)||(WaterReplenishDevice!.status.moisture < 0){
                    weakSelf.alertBeforeTest.text=loadLanguage("水分太低")
                    weakSelf.stateOfView=1
                }else{
                    stateOfView=3//检测完成
                }
    
            }
        case 3:
            if WaterReplenishDevice?.status.testing==true {
                stateOfView=2//检测中
            }
        default:
            return
        }
//        if ((WaterReplenishDevice?.status.testing) == true)&&(stateOfView==1||stateOfView==3)
//        {
//            stateOfView=2//检测中
//            
//        }else if stateOfView==2&&WaterReplenishDevice!.status.oil>0&&WaterReplenishDevice!.status.moisture>0
//        {
//            //检测完成
//            stateOfView=3
//        }
//        else
//        {
//            return
//        }
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
        updateViewzb()
        getAllWeakAndMonthData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateViewzb), name: "updateDeviceInfo", object: nil)
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
    
    
    var currentSkinTypeIndex:Int = -1//-1暂无，0，1，2，干中油
        {
        didSet{
            if currentSkinTypeIndex>0&&currentSkinTypeIndex<3
            {
                self.skinButton.setTitle("\(loadLanguage("您的肤质"))   "+self.SkinType[currentSkinTypeIndex], forState: .Normal)
                
            }
            
        }
    }
    
    var avgAndTimesArr=[String:HeadOfWaterReplenishStruct]()
    func getAllWeakAndMonthData()
    {
        print(get_UserToken())
        //下载周月数据
        MBProgressHUD.showHUDAddedTo(self, animated: true)
        let deviceService=DeviceWerbservice()
        deviceService.GetBuShuiFenBu(WaterReplenishDevice?.identifier, action: currentBodyPart.rawValue) { [weak self](dataArr, Status) in
            MBProgressHUD.hideHUDForView(self!, animated: true)
            if Status.networkStatus==kSuccessStatus
            {
                let tmpKeyArr=["FaceSkinValue","EyesSkinValue","HandSkinValue","NeckSkinValue"]
                let tmpData=dataArr.objectForKey("data")
                
                for i in 0...3
                {
                    
                    let tempBody=tmpData?.objectForKey(tmpKeyArr[i])
                    
                    //月数据
                    var maxTimes=0
                    var todayValue:Double=0
                    var lastValue:Double=0
                    var totolValue:Double=0
                    var totolOilValue:Double=0
                    for item in (tempBody?.objectForKey("monty") as! NSArray)
                    {
                        let record=CupRecord()
                        record.TDS_Bad=(item.objectForKey("ynumber") as! NSNumber).intValue//油分
                        record.TDS_Good=(item.objectForKey("snumber") as! NSNumber).intValue//水分
                        totolOilValue+=Double(record.TDS_Bad)
                        totolValue+=Double(record.TDS_Good)
                        let dateStr=dateStampToString((item.objectForKey("updatetime") as! String), format: "yyyy-MM-dd")
                        record.start=dateFromString(dateStr, format: "yyyy-MM-dd")
                        print(item.objectForKey("updatetime"))
                        print(record.start)
                        if stringFromDate(record.start, format: "yyyy-MM-dd")==stringFromDate(NSDate(), format: "yyyy-MM-dd")
                        {
                            todayValue=Double(record.TDS_Good)
                        }
                        maxTimes=max(maxTimes,item.objectForKey("times") as! Int)
                    }
                    
                    let tmpCount=(tempBody?.objectForKey("monty") as! NSArray).count
                    if tmpCount<=1
                    {
                        lastValue=todayValue
                    }
                    else{
                        let LastData=tempBody?.objectForKey("monty")?.objectAtIndex(tmpCount-2)
                        lastValue=LastData?.objectForKey("snumber") as! Double
                    }
                    let tmpAveValue=tmpCount==0 ? 0:(totolValue/Double(tmpCount))
                    let tmpAveOilValue=tmpCount==0 ? 0:(totolOilValue/Double(tmpCount))
                    let tmpStru=HeadOfWaterReplenishStruct(skinValueOfToday: todayValue, lastSkinValue: lastValue, averageSkinValue:tmpAveValue, checkTimes: maxTimes)
                    self!.avgAndTimesArr["\(i)"]=tmpStru
                    
                    if i==0&&tmpAveOilValue>0
                    {
                        
                        if tmpAveOilValue<12
                        {
                            self!.currentSkinTypeIndex=0
                        }else if tmpAveOilValue<12
                        {
                            self!.currentSkinTypeIndex=2
                        }else
                        {
                            self!.currentSkinTypeIndex=1
                        }
                        
                        
                    }
                }

            }
        }
    }
}
