//
//  SetSexViewController_EN.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
//typealias InputClosureType = (String) -> Void   //定义闭包类型（特定的函数类型函数类型）
class SetSexViewController_EN: UIViewController,UIAlertViewDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
        required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var backClosure:((String) -> Void)?           //接收上个页面穿过来的闭包块
    @IBOutlet weak var womenImg: UIImageView!
    @IBOutlet weak var manImg: UIImageView!
    @IBAction func womenClick(sender: AnyObject) {
        sex=loadLanguage("女")
    }
    @IBAction func manClick(sender: AnyObject) {
        sex=loadLanguage("男")
    }
    var tmpSex:String?//初始化时外部传入的值
    private var sex=loadLanguage("女") {
        didSet{
            print(sex)
            womenImg.hidden = sex==loadLanguage("男")
            manImg.hidden = sex==loadLanguage("女")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tmpSex)
        sex=tmpSex ?? loadLanguage("女")
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .Plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        // Do any additional setup after loading the view.
    }

    //返回
    func back(){
        if tmpSex != sex
        {
            let alert=UIAlertView(title: "", message: loadLanguage("是否保存？"), delegate: self, cancelButtonTitle: "取消", otherButtonTitles: loadLanguage("保存"))
            alert.show()
        }
        else
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    func SaveClick()
    {
        if backClosure != nil
        {
            print(sex)
            backClosure!(sex)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    //alert 点击事件
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.message==loadLanguage("是否保存？")
        {
            if buttonIndex==0
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                SaveClick()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        self.navigationController?.navigationBarHidden=false
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
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
