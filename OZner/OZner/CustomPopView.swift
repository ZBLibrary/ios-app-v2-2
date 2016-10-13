//
//  CustomPopView.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/1.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

@objc protocol CustomPopViewDelegate
{
    func touchCustomPopView()
    func addDeviceCallBack()
    optional func infomationClick()
}

class CustomPopView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    let myView = UIView(frame: CGRectMake(0,0,0,100));
    //保存当前存在的设备
    var myDevices:NSMutableArray?
    var delegate:CustomPopViewDelegate?
    var myLogoImgView:UIImageView?
    var myBgImgView:UIImageView?
    //显示设备数据
    var myTableView:UITableView?
    var clickBtn: UIButton?
    //var addDeviceBtn: UIButton?
    var firstLabel:UILabel?
    var mySecondLabel:UILabel?
    var myBubbleImgView:UIImageView?
    //当前选中的indexpath
    var currentIndexPath:NSIndexPath?
    
    var addLabel:UILabel?
    var luangeHeight:CGFloat?
    override  init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.myView.backgroundColor = UIColor(red: 100.0, green: 200.0, blue: 150.0, alpha: 1.0)
        self.myView.frame = CGRectMake(0, 0, self.frame.size.width-50, self.frame.size.height)
        self.addSubview(myView)
        
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        let bgImgView:UIImageView = UIImageView(frame: CGRectMake(0, 0, self.myView.frame.size.width, self.myView.frame.size.height))
        bgImgView.image = UIImage(named: "mydevice_bg.png")
        self.myBgImgView = bgImgView
        self.myView.addSubview(bgImgView)
        
        //        if LoginManager.loginInstance().loginInfo.loginName.containsString("@") == false {
        //            NSUserDefaults.standardUserDefaults().setObject(LoginByPhone, forKey: CURRENT_LOGIN_STYLE)
        //        } else {
        NSUserDefaults.standardUserDefaults().setObject(LoginByEmail, forKey: CURRENT_LOGIN_STYLE)
        //        }
        
        if (NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_LOGIN_STYLE) as! NSString).isEqualToString(LoginByEmail) {
            luangeHeight = 140
            let btn = UIButton(type: UIButtonType.Custom)
            btn.frame = CGRect(x: 0, y: 20, width: self.myView.frame.size.width, height: 90*(height/667.0))
            btn.setTitle("Ines", forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btn.setImage(UIImage(named:"My_Unlogin_head" ), forState: UIControlState.Normal)
            btn.titleEdgeInsets = UIEdgeInsetsMake(100, -70, 0, 0)
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
            btn.addTarget(self, action: #selector(CustomPopView.btnClick), forControlEvents: UIControlEvents.TouchUpInside)
            self.clickBtn = btn
            self.myView.addSubview(btn)
        } else {
            luangeHeight = 69
        }
        
        
        let stateLabel:UILabel = UILabel(frame: CGRectMake(0,luangeHeight!*(height/667.0),self.myView.frame.size.width,24))
        stateLabel.text = loadLanguage("伊泉净品智慧生活体验")
        stateLabel.textAlignment = NSTextAlignment.Center
        stateLabel.font = UIFont.systemFontOfSize(24)
        stateLabel.textColor = UIColor(red: 96.0, green: 121.0, blue: 149.0, alpha: 1.0)
        self.firstLabel = stateLabel
        self.myView .addSubview(stateLabel)
        
        let secondLabel:UILabel = UILabel(frame: CGRectMake(0,stateLabel.frame.origin.y+stateLabel.frame.size.height+10*(height/667.0),self.myView.frame.size.width,11))
        secondLabel.text = loadLanguage("立即添加设备,开启您的智慧生活吧!")
        secondLabel.textAlignment = NSTextAlignment.Center
        secondLabel.font = UIFont.systemFontOfSize(11)
        secondLabel.textColor = UIColor(red: 96.0, green: 121.0, blue: 149.0, alpha: 1.0)
        self.mySecondLabel = secondLabel
        self.myView .addSubview(secondLabel)
        
        let logoImgView:UIImageView = UIImageView(frame: CGRectMake(21*(width/375.0), secondLabel.frame.origin.y+secondLabel.frame.size.height+11*(height/667.0), self.myView.frame.size.width-2*21*(width/375.0), self.myView.frame.size.width-2*21*(width/375.0)))
        logoImgView.image = UIImage(named: "icon_no_device_logo.png")
        self.myLogoImgView = logoImgView
        self.myView.addSubview(logoImgView)
        
        let bubbleImgView:UIImageView = UIImageView(frame: CGRectMake(93*(width/375.0), logoImgView.frame.origin.y+logoImgView.frame.size.height+23*(height/667.0)-16, 113*(width/375.0), 110*(height/667.0)))
        bubbleImgView.image = UIImage(named: loadLanguage("icon_buble_add_device.png"))
        self.myBubbleImgView = bubbleImgView
        self.myView.addSubview(bubbleImgView)
        
        let addBtn:UIButton = UIButton(frame: CGRectMake(20*(width/375.0),bubbleImgView.frame.origin.y+bubbleImgView.frame.size.height-5-16,71*(width/375.0),71*(width/375.0)))
        addBtn.setBackgroundImage(UIImage(named: "icon_add_device_btn.png"), forState: UIControlState.Normal)
        addBtn.addTarget(self, action:#selector(addDeviceAction), forControlEvents:UIControlEvents.TouchUpInside)
        
        //addDeviceBtn=addBtn
        self.myView.addSubview(addBtn)
        let tmpframezb=addBtn.frame
        addLabel=UILabel(frame: CGRect(x: tmpframezb.origin.x+tmpframezb.size.width+5, y: tmpframezb.origin.y, width: 140, height: tmpframezb.size.height))
        addLabel!.text=loadLanguage("添加新设备")
        addLabel!.font=UIFont.systemFontOfSize(18)
        addLabel!.textColor=UIColor(red: 65/255, green: 105/255, blue: 143/255, alpha: 1)
        //addLabel?.backgroundColor=UIColor.blackColor()
        addLabel!.hidden=true
        self.myView.addSubview(addLabel!)
        //创建tableview
        let table = UITableView(frame: CGRectMake(0, 20, self.myView.frame.size.width, addBtn.frame.origin.y))
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.clearColor()
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        self.myTableView = table
        table.hidden = true
        self.myView .addSubview(table)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveDeleteDevicesNotify), name: "removDeviceByZB", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveDeleteDevicesNotify), name: "updateDeviceInfo", object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func relaodData()
    {
        if(self.myDevices?.count > 0)
        {
            self.myTableView?.hidden = false;
            self.myView.backgroundColor = UIColor(red: 226.0/250.0, green: 234.0/250.0, blue: 243.0/250.0, alpha: 1.0)
            self.myLogoImgView?.hidden = true
            self.myBgImgView?.hidden = true
            self.firstLabel?.hidden = true;
            self.mySecondLabel?.hidden = true
            self.myBubbleImgView?.hidden = true
            addLabel?.hidden=false
            self.clickBtn?.hidden = true
        }
        else
        {
            self.myTableView?.hidden = true
            self.myView.backgroundColor = UIColor.clearColor()
            self.myLogoImgView?.hidden = false
            self.myBgImgView?.hidden = false
            self.firstLabel?.hidden = false;
            self.mySecondLabel?.hidden = false
            self.myBubbleImgView?.hidden = false
            addLabel?.hidden=true
            self.clickBtn?.hidden = false
        }
        
        self.myTableView!.reloadData()
        
        if (currentIndexPath != Optional.None)&&(currentIndexPath?.row <= self.myDevices?.count)
        {
            let wCell = self.myTableView!.cellForRowAtIndexPath(currentIndexPath!) as! CustomPopViewFirstCell
            wCell.setSelected(true, animated: true)
            let device = (self.myDevices?.objectAtIndex(currentIndexPath!.row-1))! as! OznerDevice
            
            setSelectWhichCell(wCell, device: device)
            
        }
        
    }
    /**
     设置侧滑栏选中cell
     
     - parameter wCell:
     - parameter device: 
     */
    func setSelectWhichCell(wCell:CustomPopViewFirstCell,device:OznerDevice)
    {
        switch true
        {
        case CupManager.isCup(device.type):
            wCell.deviceStateImgView.image = UIImage(named: "deveice_cup_select_state.png")
            
        case TapManager.isTap(device.type):
            
            
            if NSNumber(integer: device.settings.get("istap", default: 0) as! Int).boolValue {
                wCell.deviceStateImgView.image = UIImage(named: "device_tan_tou_select_state.png")
            }else{
                wCell.deviceStateImgView.image = UIImage(named: "device_tdspan_select_state.png")
            }
            
            
        case WaterPurifierManager.isWaterPurifier(device.type):
            wCell.deviceStateImgView.image = UIImage(named: "device_jin_shui_qi_select.png")
            
        case AirPurifierManager.isBluetoothAirPurifier(device.type):
            wCell.deviceStateImgView.image = UIImage(named: "device_jin_smallair_select.png")
            
        case AirPurifierManager.isMXChipAirPurifier(device.type):
            wCell.deviceStateImgView.image = UIImage(named: "device_jin_bigair_select.png")
            
            
        //补水仪
        case  WaterReplenishmentMeterMgr.isWaterReplenishmentMeter(device.type):
            wCell.deviceStateImgView.image = UIImage(named: "WaterReplenish1_2")
            
            
        default:
            break
        }
        
    }
    func receiveDeleteDevicesNotify()
    {
        let muArr = NSMutableArray(array: OznerManager.instance().getDevices()) as NSMutableArray;
        self.myDevices = muArr
        self.relaodData()
    }
    
    //tableviewdatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.myDevices?.count > 0
        {
            return (self.myDevices?.count)!+1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 78
        }
        return 88
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if (NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_LOGIN_STYLE) as! NSString).isEqualToString(LoginByEmail) {
            let btn = UIButton(type: UIButtonType.Custom)
            btn.frame = CGRect(x: 0, y: 0, width: self.myView.frame.size.width, height: 90*(height/667.0))
            btn.setTitle("Ines", forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btn.setImage(UIImage(named:"My_Unlogin_head" ), forState: UIControlState.Normal)
            btn.titleEdgeInsets = UIEdgeInsetsMake(100, -70, 0, 0)
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
            btn.addTarget(self, action: #selector(CustomPopView.btnClick), forControlEvents: UIControlEvents.TouchUpInside)
            tableView.tableHeaderView = btn
        }
        
        if indexPath.row == 0
        {
            let wCell = NSBundle.mainBundle().loadNibNamed("CustomPopViewSecondCell", owner: self, options: nil).first as! CustomPopViewSecondCell;
            wCell.backgroundColor = UIColor.clearColor()
            return wCell
        }
        else
        {
            let wCell = NSBundle.mainBundle().loadNibNamed("CustomPopViewFirstCell", owner: self, options: nil).first as! CustomPopViewFirstCell;
            
            let device = (self.myDevices?.objectAtIndex(indexPath.row-1))! as! OznerDevice
            wCell.backgroundColor = UIColor.clearColor()
            wCell.layCustomPopViewFirstCell(device,isSlected:false)
            
            return wCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row > 0
        {
            
            currentIndexPath=indexPath
            let wCell = tableView.cellForRowAtIndexPath(indexPath) as! CustomPopViewFirstCell
            let device = (self.myDevices?.objectAtIndex(indexPath.row-1))! as! OznerDevice
            
            setSelectWhichCell(wCell, device: device)
            delegate?.touchCustomPopView()
            NSNotificationCenter.defaultCenter().postNotificationName("currentSelectedDevice", object:device)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.touchCustomPopView()
    }
    
    //点击添加按钮事件
    func addDeviceAction()
    {
        delegate?.addDeviceCallBack()
    }
    func btnClick()
    {
        delegate?.infomationClick!()
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideCustomViewFrame" object:nil];
        NSNotificationCenter.defaultCenter().postNotificationName("hideCustomViewFrame", object: nil)
    }
    
}
