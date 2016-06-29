//
//  setDev_CupView_EN.swift
//  OZner
//
//  Created by test on 15/12/9.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

var setCupStructdata:NSMutableDictionary!
class setDev_CupView_EN: UIView,UITextFieldDelegate {

    var myCurrentDevice:OznerDevice?
    @IBOutlet var getColorBoard: UIView!
    let norcolor=UIColor(red: 95/255, green: 95/255, blue: 95/255, alpha: 1)
    let selectcolor=UIColor(red: 77/255, green: 145/255, blue: 250/255, alpha: 1)
    @IBOutlet var cup_name: UILabel!
    @IBOutlet var my_weight: UITextField!
    @IBOutlet var my_drinkwater: UITextField!
    
    @IBOutlet var my_state1: UIImageView!
    @IBOutlet var my_state1label: UILabel!
    
    @IBOutlet var my_state2: UIImageView!
    @IBOutlet var my_state2label: UILabel!
    
    @IBOutlet var my_state3: UIImageView!
    @IBOutlet var my_state3label: UILabel!
    
    @IBOutlet var my_state4: UIImageView!
    @IBOutlet var my_state4label: UILabel!
    @IBOutlet var cup_remindtime: UILabel!
    @IBOutlet var cup_remindspace: UILabel!
    //？？？灯带颜色
    @IBOutlet var cup_voice: UISwitch!
    @IBOutlet var phone_voice: UISwitch!
    @IBOutlet var color_explan: UISegmentedControl!
    @IBOutlet var color_explan_image2: UIImageView!
    @IBOutlet var color_expan_label1: UILabel!
    @IBOutlet var color_expan_label2: UILabel!
    @IBOutlet var color_expan_label3: UILabel!
    
    
    @IBOutlet var CupNamebutton: UIButton!
    @IBOutlet var setCupTime: UIButton!
    @IBOutlet var aetCuptimeSpace: UIButton!
    
    
    @IBAction func clickstate1(sender: AnyObject) {
        let tmpstate=setCupStructdata["my_state1"] as! Bool
        setCupStructdata["my_state1"] = !tmpstate
        let tmpstring = !tmpstate==true ? "c":""
        my_state1.image=UIImage(named: "setmystate1"+tmpstring)
        my_state1label.textColor = !tmpstate==false ? norcolor:selectcolor
        let  tmpInt=Int(my_drinkwater.text! as String)!+(!tmpstate==true ? 50:(-50))
        my_drinkwater.text="\(tmpInt)"
    }
    @IBAction func clickstate2(sender: AnyObject) {
        let tmpstate=setCupStructdata["my_state2"] as! Bool
        setCupStructdata["my_state2"] = !tmpstate
        let tmpstring = !tmpstate==true ? "c":""
        my_state2.image=UIImage(named: "setmystate2"+tmpstring)
        my_state2label.textColor = !tmpstate==false ? norcolor:selectcolor
        let  tmpInt=Int(my_drinkwater.text! as String)!+(!tmpstate==true ? 50:(-50))
        my_drinkwater.text="\(tmpInt)"
    }
    @IBAction func clickstate3(sender: AnyObject) {
        let tmpstate=setCupStructdata["my_state3"] as! Bool
        setCupStructdata["my_state3"] = !tmpstate
        let tmpstring = !tmpstate==true ? "c":""
        my_state3.image=UIImage(named: "setmystate3"+tmpstring)
        my_state3label.textColor = !tmpstate==false ? norcolor:selectcolor
        let  tmpInt=Int(my_drinkwater.text! as String)!+(!tmpstate==true ? 50:(-50))
        my_drinkwater.text="\(tmpInt)"
    }
    @IBAction func clickstate4(sender: AnyObject) {
        let tmpstate=setCupStructdata["my_state4"] as! Bool
        setCupStructdata["my_state4"] = !tmpstate
        let tmpstring = !tmpstate==true ? "c":""
        my_state4.image=UIImage(named: "setmystate4"+tmpstring)
        my_state4label.textColor = !tmpstate==false ? norcolor:selectcolor
        let  tmpInt=Int(my_drinkwater.text! as String)!+(!tmpstate==true ? 50:(-50))
        my_drinkwater.text="\(tmpInt)"
    }
    
    @IBAction func cup_voiceclick(sender: AnyObject) {
        setCupStructdata["cup_voice"]=cup_voice.on
    }
    @IBAction func phone_voice(sender: AnyObject) {
        setCupStructdata["phone_voice"]=phone_voice.on
    }
    func color_explanclick()
    {
        if color_explan.selectedSegmentIndex==0
        {
            color_explan_image2.image=UIImage(named: "showhuan2")
            color_expan_label1.text=loadLanguage("25°C以下")
            color_expan_label2.text="25°C-50°C"
            color_expan_label3.text=loadLanguage("50°C以上")
            let cup=myCurrentDevice as! Cup
            cup.settings.haloMode=2
            OznerManager.instance().save(cup)
            print(cup.settings.haloMode)
            
        }
        else
        {
            color_explan_image2.image=UIImage(named: "showhuan2")
            color_expan_label1.text=loadLanguage("健康")
            color_expan_label2.text=loadLanguage("一般")
            color_expan_label3.text=loadLanguage("较差")
            let cup=myCurrentDevice as! Cup
            cup.settings.haloMode=3
            OznerManager.instance().save(cup)
            print(cup.settings.haloMode)
        }
    }
    @IBOutlet var AboutCupbutton: UIButton!
    
    @IBOutlet var ClearButton: UIButton!

    @IBOutlet var weight: UILabel!
    @IBOutlet var State: UILabel!
    @IBOutlet var YSTX: UILabel!
    @IBOutlet var ColorTX: UILabel!
    @IBOutlet var VoiceLable: UILabel!
    @IBOutlet var PhoneTX: UILabel!
    @IBOutlet var XSColor: UILabel!
    @IBOutlet var Attention: UILabel!
    @IBOutlet var CupName: UILabel!
    @IBOutlet var YSTimeLable: UILabel!
    @IBOutlet var YSTimeJLable: UILabel!
    
    @IBOutlet var AboutLable: UILabel!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        AboutLable.text=loadLanguage("关于智能杯")
        ClearButton.setTitle(loadLanguage("删除此设备"), forState: .Normal)
        my_state1label.text=loadLanguage("感冒发烧")
        my_state2label.text=loadLanguage("运动出汗")
        my_state3label.text=loadLanguage("天气炎热")
        my_state4label.text=loadLanguage("大姨妈来了")
        YSTimeJLable.text = loadLanguage("饮水提醒时间间隔")
        YSTimeLable.text=loadLanguage("饮水提醒时间段")
        CupName.text=loadLanguage("我的智能杯")
        weight.text=loadLanguage("体重与饮水量")
        State.text=loadLanguage("今日状态")
        YSTX.text=loadLanguage("饮水提醒")
        ColorTX.text=loadLanguage("灯带颜色提醒")
        VoiceLable.text=loadLanguage("水杯声音提醒")
        PhoneTX.text=loadLanguage("手机提醒")
        XSColor.text=loadLanguage("显示灯带颜色")
       Attention.text=loadLanguage("注意:电量低于10%时,光圈双闪。")
    }

    
    func initload()
    {
        loadData()
        updateData()
        //cup_color.text=setCupStructdata["cup_color"] as? String
        color_explan.addTarget(self, action: #selector(color_explanclick), forControlEvents: UIControlEvents.ValueChanged)
        ClearButton.layer.cornerRadius=20
        ClearButton.layer.masksToBounds=true
        ClearButton.layer.borderWidth=1
        ClearButton.layer.borderColor=UIColor(red: 1, green: 64/255, blue: 82/255, alpha: 1).CGColor
    }
    func updateData()
    {

        cup_name.text=(setCupStructdata["cup_name"]! as! String)+"("+(setCupStructdata["cup_Attrib"]! as! String)+")"
        my_weight.text=setCupStructdata["my_weight"] as? String
        my_weight.delegate=self
        my_drinkwater.delegate=self
        print(setCupStructdata["my_drinkwater"])
      let tmpInt=setCupStructdata["my_drinkwater"] as! String
        my_drinkwater.text=tmpInt
        
        var tmpstate=setCupStructdata["my_state1"] as! Bool
        var tmpstring = tmpstate==false ? "":"c"
        my_state1.image=UIImage(named: "setmystate1"+tmpstring)
        my_state1label.textColor = tmpstate==false ? norcolor:selectcolor
        
        tmpstate=setCupStructdata["my_state2"] as! Bool
        tmpstring = tmpstate==false ? "":"c"
        my_state2.image=UIImage(named: "setmystate2"+tmpstring)
        my_state2label.textColor = tmpstate==false ? norcolor:selectcolor
        
        tmpstate=setCupStructdata["my_state3"] as! Bool
        tmpstring = tmpstate==false ? "":"c"
        my_state3.image=UIImage(named: "setmystate3"+tmpstring)
        my_state3label.textColor = tmpstate==false ? norcolor:selectcolor
        
        tmpstate=setCupStructdata["my_state4"] as! Bool
        tmpstring = tmpstate==false ? "":"c"
        my_state4.image=UIImage(named: "setmystate4"+tmpstring)
        my_state4label.textColor = tmpstate==false ? norcolor:selectcolor
        
        let tmpstar=setCupStructdata["remindStart"] as! Int
        let tmpend=setCupStructdata["remindEnd"] as! Int
        var tmptext=tmpstar/3600<10 ? "0\(tmpstar/3600)":"\(tmpstar/3600)"
        tmptext+=":"
        tmptext+=tmpstar%3600/60<10 ? "0\(tmpstar%3600/60)":"\(tmpstar%3600/60)"
        tmptext+="-"
        tmptext+=tmpend/3600<10 ? "0\(tmpend/3600)":"\(tmpend/3600)"
        tmptext+=":"
        tmptext+=tmpend%3600/60<10 ? "0\(tmpend%3600/60)":"\(tmpend%3600/60)"
        cup_remindtime.text=tmptext
        let tmptime=setCupStructdata["remindInterval"] as! Int
        cup_remindspace.text=(tmptime/60==0 ? "":"\(tmptime/60)\(loadLanguage("小时"))")+(tmptime%60==0 ? "":"\(tmptime%60)\(loadLanguage("分钟"))")
        cup_voice.on=setCupStructdata["cup_voice"] as! Bool
        phone_voice.on=setCupStructdata["phone_voice"] as! Bool
        //loadDeviceData()
        
    }
    
    func loadDeviceData(){
        
        let cup = self.myCurrentDevice as! Cup
        //名称体重饮水量
        var nameStr=cup.settings.name
        if nameStr.characters.contains("(")==false
        {
            nameStr=nameStr+loadLanguage("(办公室)")
        }
        setCupStructdata["cup_name"]=nameStr.substringToIndex(nameStr.characters.indexOf("(")!)
        
        
        let nameStr2=(nameStr as NSString).substringWithRange(NSMakeRange(setCupStructdata["cup_name"]!.length+1, nameStr.characters.count-setCupStructdata["cup_name"]!.length-2))
        print(nameStr2)
        setCupStructdata["cup_Attrib"]=nameStr2
        setCupStructdata["my_weight"]=cup.settings.get("weight", default: 56) as? String
        let tmpInt:String=(cup.settings.get("my_drinkwater", default: "2000") as! String)=="" ? "2000":(cup.settings.get("my_drinkwater", default: "2000") as! String)
        
        setCupStructdata["my_drinkwater"]=tmpInt
       
        //今日状态
        setCupStructdata["my_state1"] = cup.settings.get("todayState1", default: false)
        setCupStructdata["my_state2"] = cup.settings.get("todayState2", default: false)
        setCupStructdata["my_state3"] = cup.settings.get("todayState3", default: false)
        setCupStructdata["my_state4"] = cup.settings.get("todayState4", default: false)
        print(setCupStructdata["my_state1"])
        //setCupStructdata["remindStart"] = cup.settings.remindStart as? AnyObject
        //print(setCupStructdata["remindStart"])
        //灯带颜色
        if (cup.settings.remindStart as? AnyObject) != nil
        {
            setCupStructdata["haloColor"]=cup.settings.haloColor as? AnyObject
        }
        
        //提醒时间间隔
        if (cup.settings.remindStart as? AnyObject) != nil
        {
            setCupStructdata["remindInterval"]=cup.settings.remindInterval as? AnyObject
        }
        
        //提醒开始时间
        if (cup.settings.remindStart as? AnyObject) != nil
        {
            setCupStructdata["remindStart"]=cup.settings.remindStart as? AnyObject
        }
        
        
        //提醒结束时间
        if (cup.settings.remindStart as? AnyObject) != nil
        {
            setCupStructdata["remindEnd"]=cup.settings.remindStart as? AnyObject
        }
        //模式切换
        print(cup.settings.haloMode)
        if cup.settings.haloMode==3
        {
            color_explan.selectedSegmentIndex=1
            color_explanclick()
        }
        else
        {
            color_explan.selectedSegmentIndex=0
            color_explanclick()
        }
       
        //是否提醒
        setCupStructdata["cup_voice"]=cup.settings.remindEnable
        setCupStructdata["phone_voice"]=cup.settings.get("phoneVoice", default: false)
        
    }
    
    func loadData()
    {
        let documentpaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        //获取完整路径
        let documentsDirectory=documentpaths[0] as NSString
        let plistPath = documentsDirectory.stringByAppendingPathComponent("SetCup_EN.plist")
        setCupStructdata=NSMutableDictionary(contentsOfFile: plistPath)
       // print(setCupStructdata)
        if setCupStructdata==nil
        {
            let bundle=NSBundle.mainBundle()
            //读取plist文件路径
            let path=bundle.pathForResource("SetCup_EN", ofType: "plist")
            //读取数据到 NsDictionary字典中
            setCupStructdata=NSMutableDictionary(contentsOfFile: path!)
            print(path)
        }
        loadDeviceData()
    }
    
    func SaveData()
    {
        let documentpaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        //获取完整路径
        let documentsDirectory=documentpaths[0] as NSString
        let plistPath = documentsDirectory.stringByAppendingPathComponent("SetCup_EN.plist")
        //let bundle=NSBundle.mainBundle()
        //读取plist文件路径
        //let path=bundle.pathForResource("SetCup_EN", ofType: "plist")
        setCupStructdata.writeToFile(plistPath, atomically: true)
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.backgroundColor=UIColor(red: 213/255, green: 230/255, blue: 254/255, alpha: 1)
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.text != ""
        {
            textField.resignFirstResponder()
            textField.backgroundColor=UIColor.whiteColor()
            let tmpweight=Int(textField.text!)
            var tmpWater=tmpweight!*2000/56
            tmpWater+=(setCupStructdata["my_state1"] as! Bool)==true ? 50:0
            
            tmpWater+=(setCupStructdata["my_state2"] as! Bool)==true ? 50:0
            
            tmpWater+=(setCupStructdata["my_state3"] as! Bool)==true ? 50:0
            
            tmpWater+=(setCupStructdata["my_state4"] as! Bool)==true ? 50:0
            my_drinkwater.text="\(tmpWater)"
        }
        else
        {
            my_weight.text="56"//2000
            var tmpWater=2000
            tmpWater+=(setCupStructdata["my_state1"] as! Bool)==true ? 50:0

            tmpWater+=(setCupStructdata["my_state2"] as! Bool)==true ? 50:0

            tmpWater+=(setCupStructdata["my_state3"] as! Bool)==true ? 50:0

            tmpWater+=(setCupStructdata["my_state4"] as! Bool)==true ? 50:0
            my_drinkwater.text="\(tmpWater)"
  
        }
        //textField.textColor=selectcolor
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let cs:NSCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet// characterSetWithCharactersInString:kAlphaNum] invertedSet];
        let filtered =
            string.componentsSeparatedByCharactersInSet(cs).joinWithSeparator("") as String//componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        let basic = (string==filtered)
        return basic;
    }
}
