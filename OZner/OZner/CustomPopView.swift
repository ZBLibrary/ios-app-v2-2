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
    var firstLabel:UILabel?
    var mySecondLabel:UILabel?
    var myBubbleImgView:UIImageView?
    //当前选中的indexpath
    var currentIndexPath:NSIndexPath?

    var addLabel:UILabel?
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
        
        let stateLabel:UILabel = UILabel(frame: CGRectMake(0,69*(height/667.0),self.myView.frame.size.width,24))
        stateLabel.text = "浩泽智能化生活服务"
        stateLabel.textAlignment = NSTextAlignment.Center
        stateLabel.font = UIFont.systemFontOfSize(24)
        stateLabel.textColor = UIColor(red: 96.0, green: 121.0, blue: 149.0, alpha: 1.0)
        self.firstLabel = stateLabel
        self.myView .addSubview(stateLabel)
        
        let secondLabel:UILabel = UILabel(frame: CGRectMake(0,stateLabel.frame.origin.y+stateLabel.frame.size.height+10*(height/667.0),self.myView.frame.size.width,11))
        secondLabel.text = "立即添加设备，体验浩泽智能化生活服务"
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
        bubbleImgView.image = UIImage(named: "icon_buble_add_device.png")
        self.myBubbleImgView = bubbleImgView
        self.myView.addSubview(bubbleImgView)
        print(width)
        let addBtn:UIButton = UIButton(frame: CGRectMake(20*(width/375.0),bubbleImgView.frame.origin.y+bubbleImgView.frame.size.height-5-16,71*(width/375.0),71*(width/375.0)))
        addBtn.setBackgroundImage(UIImage(named: "icon_add_device_btn.png"), forState: UIControlState.Normal)
        addBtn.addTarget(self, action:"addDeviceAction", forControlEvents:UIControlEvents.TouchUpInside)
        self.myView.addSubview(addBtn)
        let tmpframezb=addBtn.frame
        addLabel=UILabel(frame: CGRect(x: tmpframezb.origin.x+tmpframezb.size.width+5, y: tmpframezb.origin.y, width: 100, height: tmpframezb.size.height))
        addLabel!.text="添加新设备"
        addLabel!.font=UIFont.systemFontOfSize(18)
        addLabel!.textColor=UIColor(red: 65/255, green: 105/255, blue: 143/255, alpha: 1)
        addLabel!.hidden=true
        self.myView.addSubview(addLabel!)
        //创建tableview
        let table = UITableView(frame: CGRectMake(0, 0, self.myView.frame.size.width, addBtn.frame.origin.y))
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.clearColor()
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        self.myTableView = table
        table.hidden = true
        self.myView .addSubview(table)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveDeleteDevicesNotify", name: "removDeviceByZB", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveDeleteDevicesNotify", name: "updateDeviceInfo", object: nil)
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
    func setSelectWhichCell(wCell:CustomPopViewFirstCell,device:OznerDevice)
    {
        if CupManager.isCup(device.type) == true
        {
            //智能水杯
            wCell.deviceStateImgView.image = UIImage(named: "deveice_cup_select_state.png")
        }
        else if TapManager.isTap(device.type) == true
        {
            //水探头
            wCell.deviceStateImgView.image = UIImage(named: "device_tan_tou_select_state.png")
        }
        else if WaterPurifierManager.isWaterPurifier(device.type) == true//WaterReplenishmentMeterMgr.isWaterReplenishmentMeter(device.type)
        {
            //净水器
            wCell.deviceStateImgView.image = UIImage(named: "device_jin_shui_qi_select.png")
        } else if AirPurifierManager.isBluetoothAirPurifier(device.type)
        {
            //台式空气净化器（蓝牙）
            wCell.deviceStateImgView.image = UIImage(named: "device_jin_smallair_select.png")
        }
        else if AirPurifierManager.isMXChipAirPurifier(device.type)
        {
            //立式空气净化器（wifi）
            wCell.deviceStateImgView.image = UIImage(named: "device_jin_bigair_select.png")
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
//            for var i = 0; i < self.myDevices?.count;i++
//            {
                //let path = NSIndexPath(forRow: i+1, inSection: 0)
            currentIndexPath=indexPath
                let wCell = tableView.cellForRowAtIndexPath(indexPath) as! CustomPopViewFirstCell
                let device = (self.myDevices?.objectAtIndex(indexPath.row-1))! as! OznerDevice
//                if(i == indexPath.row-1)
//                {
            
                    setSelectWhichCell(wCell, device: device)
                    delegate?.touchCustomPopView()
                    NSNotificationCenter.defaultCenter().postNotificationName("currentSelectedDevice", object:device)
                    
                //}
//                else
//                {
//                    if CupManager.isCup(device.type) == true
//                    {
//                        //智能水杯
//                        wCell.deviceStateImgView.image = UIImage(named: "device_cup_normal_state.png")
//                        
//                    }
//                    else if TapManager.isTap(device.type) == true
//                    {
//                        //水探头
//                        wCell.deviceStateImgView.image = UIImage(named: "device_tan_tou_noamrl_state.png")
//                    }
//                    else if WaterPurifierManager.isWaterPurifier(device.type) == true
//                    {
//                        //净水器
//                        wCell.deviceStateImgView.image = UIImage(named: "device_jin_shui_qi_normal.png")
//                    }
//                    else if AirPurifierManager.isBluetoothAirPurifier(device.type)
//                    {
//                        //台式空气净化器（蓝牙）
//                        wCell.deviceStateImgView.image = UIImage(named: "device_jin_smallair_normal.png")
//                    }
//                    else if AirPurifierManager.isMXChipAirPurifier(device.type)
//                    {
//                        //立式空气净化器（wifi）
//                        wCell.deviceStateImgView.image = UIImage(named: "device_jin_bigair_normal.png")
//                    }
//                }
                
            //}
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
}
