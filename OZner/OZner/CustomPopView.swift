//
//  CustomPopView.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/1.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


@objc protocol CustomPopViewDelegate
{
    func touchCustomPopView()
    func addDeviceCallBack()
    @objc optional func infomationClick()
}

class CustomPopView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    let myView = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 100));
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
    var currentIndexPath:IndexPath?
    
    var addLabel:UILabel?
    var luangeHeight:CGFloat?
    override  init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.myView.backgroundColor = UIColor(red: 100.0, green: 200.0, blue: 150.0, alpha: 1.0)
        self.myView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width-50, height: self.frame.size.height)
        self.addSubview(myView)
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let bgImgView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.myView.frame.size.width, height: self.frame.size.height))
        bgImgView.image = UIImage(named: "mydevice_bg.png")
        self.myBgImgView = bgImgView
        self.myView.addSubview(bgImgView)

        if LoginManager.loginInstance().loginInfo.loginName.contains("@") == false {
            UserDefaults.standard.set(LoginByPhone, forKey: CURRENT_LOGIN_STYLE)
        } else {
            UserDefaults.standard.set(LoginByEmail, forKey: CURRENT_LOGIN_STYLE)
        }
        
        if (UserDefaults.standard.object(forKey: CURRENT_LOGIN_STYLE) as! NSString).isEqual(to: LoginByEmail) {
            luangeHeight = 140
            let btn = UIButton(type: UIButtonType.custom)
            btn.frame = CGRect(x: 0, y: 20, width: self.myView.frame.size.width, height: 90*(height/667.0))
            btn.setTitle("Ozner", for: UIControlState())
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.setImage(UIImage(named:"My_Unlogin_head" ), for: UIControlState())
            btn.titleEdgeInsets = UIEdgeInsetsMake(100, -85, 0, 0)
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
            btn.addTarget(self, action: #selector(CustomPopView.btnClick), for: UIControlEvents.touchUpInside)
            self.clickBtn = btn
            self.myView.addSubview(btn)
        } else {
            luangeHeight = 69
        }
        
        
        let stateLabel:UILabel = UILabel(frame: CGRect(x: 0,y: luangeHeight!*(height/667.0),width: self.myView.frame.size.width,height: 24))
        stateLabel.text = loadLanguage("浩泽智能化生活服务")
        stateLabel.textAlignment = NSTextAlignment.center
        stateLabel.font = UIFont.systemFont(ofSize: 24)
        stateLabel.textColor = UIColor(red: 96.0, green: 121.0, blue: 149.0, alpha: 1.0)
        self.firstLabel = stateLabel
        self.myView .addSubview(stateLabel)
        
        let secondLabel:UILabel = UILabel(frame: CGRect(x: 0,y: stateLabel.frame.origin.y+stateLabel.frame.size.height+10*(height/667.0),width: self.myView.frame.size.width,height: 11))
        secondLabel.text = loadLanguage("立即添加设备，体验浩泽智能化生活服务")
        secondLabel.textAlignment = NSTextAlignment.center
        secondLabel.font = UIFont.systemFont(ofSize: 11)
        secondLabel.textColor = UIColor(red: 96.0, green: 121.0, blue: 149.0, alpha: 1.0)
        self.mySecondLabel = secondLabel
        self.myView .addSubview(secondLabel)
        
        let logoImgView:UIImageView = UIImageView(frame: CGRect(x: 21*(width/375.0), y: secondLabel.frame.origin.y+secondLabel.frame.size.height+11*(height/667.0), width: self.myView.frame.size.width-2*21*(width/375.0), height: self.myView.frame.size.width-2*21*(width/375.0)))
        logoImgView.image = UIImage(named: "icon_no_device_logo.png")
        self.myLogoImgView = logoImgView
        self.myView.addSubview(logoImgView)
        
        let bubbleImgView:UIImageView = UIImageView(frame: CGRect(x: 93*(width/375.0), y: logoImgView.frame.origin.y+logoImgView.frame.size.height+23*(height/667.0)-16, width: 113*(width/375.0), height: 110*(height/667.0)))
        bubbleImgView.image = UIImage(named: loadLanguage("icon_buble_add_device.png"))
        self.myBubbleImgView = bubbleImgView
        self.myView.addSubview(bubbleImgView)
        
        let addBtn:UIButton = UIButton(frame: CGRect(x: 20*(width/375.0),y: bubbleImgView.frame.origin.y+bubbleImgView.frame.size.height-5,width: 71*(width/375.0),height: 71*(width/375.0)))
        addBtn.setBackgroundImage(UIImage(named: "icon_add_device_btn.png"), for: UIControlState())
        addBtn.addTarget(self, action:#selector(addDeviceAction), for:UIControlEvents.touchUpInside)
        
        //addDeviceBtn=addBtn
        self.myView.addSubview(addBtn)
        let tmpframezb=addBtn.frame
        addLabel=UILabel(frame: CGRect(x: tmpframezb.origin.x+tmpframezb.size.width+5, y: tmpframezb.origin.y, width: 140, height: tmpframezb.size.height))
        addLabel!.text=loadLanguage("添加新设备")
        addLabel!.font=UIFont.systemFont(ofSize: 18)
        addLabel!.textColor=UIColor(red: 65/255, green: 105/255, blue: 143/255, alpha: 1)
        
        addLabel!.isHidden=true
        self.myView.addSubview(addLabel!)
        //创建tableview
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: self.myView.frame.size.width, height: addBtn.frame.origin.y))
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.clear
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        self.myTableView = table
        table.isHidden = true
        self.myView .addSubview(table)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDeleteDevicesNotify), name: NSNotification.Name(rawValue: "removDeviceByZB"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDeleteDevicesNotify), name: NSNotification.Name(rawValue: "updateDeviceInfo"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func relaodData()
    {
        if(self.myDevices?.count > 0)
        {
            self.myTableView?.isHidden = false;
            self.myView.backgroundColor = UIColor(red: 226.0/250.0, green: 234.0/250.0, blue: 243.0/250.0, alpha: 1.0)
            self.myLogoImgView?.isHidden = true
            self.myBgImgView?.isHidden = true
            self.firstLabel?.isHidden = true;
            self.mySecondLabel?.isHidden = true
            self.myBubbleImgView?.isHidden = true
            addLabel?.isHidden=false
            self.clickBtn?.isHidden = true
        }
        else
        {
            self.myTableView?.isHidden = true
            self.myView.backgroundColor = UIColor.clear
            self.myLogoImgView?.isHidden = false
            self.myBgImgView?.isHidden = false
            self.firstLabel?.isHidden = false;
            self.mySecondLabel?.isHidden = false
            self.myBubbleImgView?.isHidden = false
            addLabel?.isHidden=true
            self.clickBtn?.isHidden = false
        }
        
        self.myTableView!.reloadData()
        
        if (currentIndexPath != Optional.none)&&((currentIndexPath as NSIndexPath?)?.row <= self.myDevices?.count)
        {
            let wCell = self.myTableView!.cellForRow(at: currentIndexPath!) as! CustomPopViewFirstCell
            wCell.setSelected(true, animated: true)
            let device = (self.myDevices?.object(at: (currentIndexPath! as NSIndexPath).row-1))! as! OznerDevice
            
            setSelectWhichCell(wCell, device: device)
            
        }
        
    }
    /**
     设置侧滑栏选中cell
     
     - parameter wCell:
     - parameter device: 
     */
    func setSelectWhichCell(_ wCell:CustomPopViewFirstCell,device:OznerDevice)
    {
        switch true
        {
        case CupManager.isCup(device.type):
            wCell.deviceStateImgView.image = UIImage(named: "deveice_cup_select_state.png")
            
        case TapManager.isTap(device.type):
            
            
            if NSNumber(value: device.settings.get("istap", default: 0) as! Int as Int).boolValue {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.myDevices?.count > 0
        {
            return (self.myDevices?.count)!+1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 0
        {
            return 78
        }
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if (UserDefaults.standard.object(forKey: CURRENT_LOGIN_STYLE) as! NSString).isEqual(to: LoginByEmail) {
            let btn = UIButton(type: UIButtonType.custom)
            btn.frame = CGRect(x: 0, y: 0, width: self.myView.frame.size.width, height: 90*(height/667.0))
            btn.setTitle("Ozner", for: UIControlState())
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.setImage(UIImage(named:"My_Unlogin_head" ), for: UIControlState())
            btn.titleEdgeInsets = UIEdgeInsetsMake(100, -90, 0, 0)
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
            btn.addTarget(self, action: #selector(CustomPopView.btnClick), for: UIControlEvents.touchUpInside)
            tableView.tableHeaderView = btn
        }
        
        if (indexPath as NSIndexPath).row == 0
        {
            let wCell = Bundle.main.loadNibNamed("CustomPopViewSecondCell", owner: self, options: nil)?.first as! CustomPopViewSecondCell;
            wCell.backgroundColor = UIColor.clear
            return wCell
        }
        else
        {
            let wCell = Bundle.main.loadNibNamed("CustomPopViewFirstCell", owner: self, options: nil)?.first as! CustomPopViewFirstCell;
            
            let device = (self.myDevices?.object(at: (indexPath as NSIndexPath).row-1))! as! OznerDevice
            wCell.backgroundColor = UIColor.clear
            wCell.layCustomPopViewFirstCell(device,isSlected:false)
            
            return wCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row > 0
        {
            
            currentIndexPath=indexPath
            let wCell = tableView.cellForRow(at: indexPath) as! CustomPopViewFirstCell
            let device = (self.myDevices?.object(at: (indexPath as NSIndexPath).row-1))! as! OznerDevice
            
            setSelectWhichCell(wCell, device: device)
            delegate?.touchCustomPopView()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "currentSelectedDevice"), object:device)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    }
    
}
