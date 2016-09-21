//
//  SetTdsPanViewController.swift
//  OZner
//
//  Created by 赵兵 on 16/7/4.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SetTdsPanViewController: UIViewController,UIAlertViewDelegate,UITextFieldDelegate {

    var myCurrentDevice:Tap?
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBAction func AboutClick(_ sender: AnyObject) {
        
        let aboutDevice=AboutDeviceViewController_EN(nibName: "AboutDeviceViewController_EN", bundle: nil)
        aboutDevice.title=loadLanguage("关于检测笔")
        aboutDevice.urlstring="http://cup.ozner.net/app/gystt/gystt.html"
        self.navigationController?.pushViewController(aboutDevice, animated: true)
    }
    @IBAction func DeleteDeviceClick(_ sender: AnyObject) {
        let alert=UIAlertView(title: "", message: loadLanguage("删除此设备"), delegate: self, cancelButtonTitle: loadLanguage("否"), otherButtonTitles: loadLanguage("是"))
        alert.show()
    }
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if alertView.message==loadLanguage("删除此设备")
        {
            if buttonIndex==1
            {
                OznerManager.instance().remove(myCurrentDevice)
                //发出通知
                NotificationCenter.default.post(name: Notification.Name(rawValue: "removDeviceByZB"), object: nil)
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=loadLanguage("我的检测笔")
        NameTextField.delegate=self
        clearButton.layer.borderWidth=1
        clearButton.layer.borderColor=UIColor(red: 1, green: 92/255, blue: 102/255, alpha: 1).cgColor
        clearButton.layer.cornerRadius=20
        clearButton.layer.masksToBounds=true
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NameTextField.resignFirstResponder()
        if NameTextField.text != ""
        {
            myCurrentDevice?.settings.name=NameTextField.text
            OznerManager.instance().save(myCurrentDevice)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateDeviceInfo"), object: nil)
        }
        return true
    }
    convenience  init(currDevice:Tap?) {
        var nibNameOrNil = String?("SetTdsPanViewController")
        //考虑到xib文件可能不存在或被删，故加入判断
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        myCurrentDevice=currDevice
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
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
