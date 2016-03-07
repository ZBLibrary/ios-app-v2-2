//
//  StarGuideViewController.swift
//  oznerproject
//
//  Created by 111 on 15/11/16.
//  Copyright © 2015年 ozner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    //倒计时时间
    var shuttime=60
    var counttime:NSTimer!
    @IBAction func passToNextclick(sender: UIButton) {

    }
    
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var YZMTextField: UITextField!
    
    @IBOutlet var YZMbutton: UIButton!
    
    @IBOutlet var YZMTextLabel: UILabel!
    @IBAction func getYZMclick(sender: AnyObject) {
        let istrue=checkTel(phoneTextField.text!)
        if istrue
        {
            errorLabel.text=loadLanguage("验证码将以短信形式发送给您,请注意查收。")
            YZMbutton.enabled=false
            YZMbutton.backgroundColor=color_BT_bg_ed
            YZMbutton.layer.borderColor=color_BT_bg_ed.CGColor
            
            YZMTextLabel.textColor=color_black
            shuttime=60
            counttime=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("rushtime"), userInfo: nil, repeats: true)
            yanzhengfunc()
        }
        else
        {
            errorLabel.text=loadLanguage("请输入11位手机号")
        }

    }
    func rushtime(){
        if shuttime==0
        {
            YZMbutton.backgroundColor=UIColor.whiteColor()
            YZMbutton.layer.borderColor=color_main.CGColor
            
            YZMTextLabel.textColor=color_main
            YZMTextLabel.text=loadLanguage("短信验证码")
            YZMbutton.enabled=true
            counttime.invalidate()
        }else
        {
            YZMTextLabel.text=loadLanguage("倒计时\(shuttime)秒")
        }
        
        shuttime--
    }
    
    func yanzhengfunc(){
        let Phone:String=phoneTextField.text!
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerServer/GetPhoneCode"
        let params:NSDictionary = ["phone":Phone]
        manager.POST(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                self.errorLabel.text=loadLanguage("网络连接失败,请重试。")
                self.shuttime=0
        })
        
        
    }

    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBAction func loginClick(sender: AnyObject) {
        

        let phone:String=phoneTextField.text!
        let YZM:String=YZMTextField.text!
        if !isAgree
        {
            errorLabel.text=loadLanguage("请阅读《浩泽净水家免责条款》并勾选")
            return
        }
        if !checkTel(phone)
        {
            errorLabel.text=loadLanguage("请输入11位手机号")
            return
        }
        if (YZM.characters.count==0)
        {
            errorLabel.text=loadLanguage("请输入验证码")
            return
        }
        if !(YZM.characters.count==4)
        {
            errorLabel.text=loadLanguage("您输入的验证码有误,请重新输入。")
            return
        }

        set_Phone(phoneTextField.text!)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        LogInOut.loginInOutInstance().loginWithAccount(phone, password: YZM, currentView: self.view)
        
    }
    
    var isAgree=true

    @IBOutlet var agreeImageView: UIButton!
    @IBOutlet var agreeButton: UIButton!
    @IBAction func agreeButtonClick(sender: AnyObject) {
        let imagename = isAgree ? "agree" : "agreeSelected"
        agreeImageView.setBackgroundImage(UIImage(named: imagename), forState: .Normal)
        
        isAgree = !isAgree
        errorLabel.text=""
    }
    
    @IBAction func agreeTextClick(sender: UIButton) {
        let agreeMentController=userAgreeMentsController()
        self.presentViewController(agreeMentController, animated: true, completion: nil)
    }
    
    @IBOutlet var TishiLabel: UILabel!
    @IBOutlet var getYYbutton: UIButton!
    @IBAction func getYYbuttonclick(sender: UIButton) {
        let istrue=checkTel(phoneTextField.text!)
        if istrue
        {
            
            //调用语音接口
            self.getYYbutton.enabled=false
            self.errorLabel.text=loadLanguage("您将会收到来自4001电话语音,请注意接听。")
            self.getYYbutton.backgroundColor=color_BT_bg_ed
            self.getYYbutton.layer.borderColor=color_BT_bg_ed.CGColor
            self.getYYbutton.setTitleColor(color_black, forState: .Normal)
            let WerbService=UserInfoActionWerbService()
            WerbService.GetVoicePhoneCode(phoneTextField.text!, returnBlock: { (respose:AnyObject!,status:StatusManager!) -> Void in
                if  status.networkStatus == kSuccessStatus
                {
                    
                    if (respose.objectForKey("state") as! Int)>0
                    {
            
                    }
                    else
                    {
                        self.errorLabel.text=loadLanguage("请求失败,请检查网络。")
                        self.getYYbutton.enabled=true
                        self.getYYbutton.backgroundColor=UIColor.whiteColor()
                        self.getYYbutton.layer.borderColor=color_main.CGColor
                        self.getYYbutton.setTitleColor(color_main, forState: .Normal)
                        
                    }
                }
                else
                {
                    self.errorLabel.text=loadLanguage("请求失败,请检查网络。")
                    self.getYYbutton.enabled=true
                    self.getYYbutton.backgroundColor=UIColor.whiteColor()
                    self.getYYbutton.layer.borderColor=color_main.CGColor
                    self.getYYbutton.setTitleColor(color_main, forState: .Normal)
                }
            })
        }
        else
        {
            errorLabel.text=loadLanguage("请输入11位手机号")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    func loginFailed(notice:NSNotification)
    {
        print(notice.userInfo)
        let errorCode =  (notice.userInfo!["errorCode"] as! NSString).intValue
        
        switch errorCode
        {
        case -10002:
            errorLabel.text="您输入的验证码已过期"
            break
        case -10003:
            errorLabel.text="您输入的验证码无效，请重新输入验证码"
            break
        default:
            errorLabel.text="网络错误，请检查网络后重试"
            break
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loginFailed:"), name: "networkFailedInfoNotice", object: nil)
       loginButton.setTitle(loadLanguage("登录"), forState: .Normal)
        getYYbutton.setTitle(loadLanguage("获取语音验证码"), forState: .Normal)
        agreeButton.setTitle(loadLanguage("我已阅读并同意《浩泽净水家免责条款》"), forState: .Normal)
        phoneTextField.placeholder=loadLanguage("请输入手机号")
        YZMTextField.placeholder=loadLanguage("输入验证码")
        TishiLabel.text=loadLanguage("未收到短信验证码？")
        set_islogin(false)
        
        YZMbutton.layer.borderColor=color_main.CGColor
        getYYbutton.layer.borderColor=color_main.CGColor
        errorLabel.text=""
        phoneTextField.delegate=self
        YZMTextField.delegate=self
       
        if Screen_Width<=320
        {
            errorLabel.font=UIFont.systemFontOfSize(10)
        }
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        errorLabel.text=""
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
