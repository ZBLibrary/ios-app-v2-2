//
//  AddDeviceViewController.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/2.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class AddDeviceViewController: SwiftFatherViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    var dataArray: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor(patternImage: UIImage(named: "bg_clear_addDevice")!)
        // Do any additional setup after loading the view.
        self.myTableView.rowHeight = 120
        self.createLeftAndRight()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar .setBackgroundImage(UIImage(named: "bg_clear_addDevice"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage(named: "bg_clear_addDevice")
    }
    func createLeftAndRight()
    {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(leftMethod))
        self.navigationItem.leftBarButtonItem = leftButton;
        self.navigationItem.title = loadLanguage("我的设备")
    }
    
    func leftMethod()
    {
        self.navigationController!.view .removeFromSuperview()
    }
    //测试设备数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = NSBundle.mainBundle().loadNibNamed("AddDeviceCell", owner: self, options: nil).last as! AddDeviceCell
        
        switch indexPath.row
        {
        case 0:
            cell.layOutAddDeviceCell("select_device_0", content: loadLanguage("智能水杯"), iconImgName: "select_device_3.png", funcContent: loadLanguage("蓝牙连接"))
            
        case 1:
            
            cell.layOutAddDeviceCell("select_device_1", content: loadLanguage("水探头"), iconImgName: "select_device_3.png", funcContent: loadLanguage("蓝牙连接"))
            
        case 2:
            
            cell.layOutAddDeviceCell("select_device_2", content: loadLanguage("净水器"), iconImgName: "select_device_4.png", funcContent: loadLanguage("Wifi连接"))
            
        case 3:
            
            cell.layOutAddDeviceCell("select_device_3zb", content: loadLanguage("台式空净"), iconImgName: "select_device_3.png", funcContent: loadLanguage("蓝牙连接"))
            
        case 4:
            
            cell.layOutAddDeviceCell("select_device_4zb", content: loadLanguage("立式空净"), iconImgName: "select_device_4.png", funcContent: loadLanguage("Wifi连接"))
        case 5:
            
            cell.layOutAddDeviceCell("WaterReplenish1_1", content: loadLanguage("补水仪"), iconImgName: "select_device_3.png", funcContent: loadLanguage("蓝牙连接"))
        case 6:
            
            cell.layOutAddDeviceCell("TDSPAN_ICON", content: loadLanguage("TDS笔"), iconImgName: "select_device_3.png", funcContent: loadLanguage("蓝牙连接"))
        default :
            break
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let deviceMatchController = DeviceMatchedViewController(nibName: "DeviceMatchedViewController", bundle: nil)
        print(indexPath.row)
        deviceMatchController.deviceCuttentType = indexPath.row
        self.navigationController!.pushViewController(deviceMatchController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
