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
    var counttime:Timer!
    @IBAction func passToNextclick(_ sender: UIButton) {

    }
    
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var YZMTextField: UITextField!
    
    @IBOutlet var YZMbutton: UIButton!
    
    @IBOutlet var YZMTextLabel: UILabel!
    @IBAction func getYZMclick(_ sender: AnyObject) {
        let istrue=checkTel(phoneTextField.text! as NSString)
        if istrue
        {
            errorLabel.text=loadLanguage("验证码将以短信形式发送给您,请注意查收。")
            YZMbutton.isEnabled=false
            YZMbutton.backgroundColor=color_BT_bg_ed
            YZMbutton.layer.borderColor=color_BT_bg_ed.cgColor
            
            YZMTextLabel.textColor=color_black
            shuttime=60
            counttime=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(rushtime), userInfo: nil, repeats: true)
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
            YZMbutton.backgroundColor=UIColor.white
            YZMbutton.layer.borderColor=color_main.cgColor
            
            YZMTextLabel.textColor=color_main
            YZMTextLabel.text=loadLanguage("短信验证码")
            YZMbutton.isEnabled=true
            counttime.invalidate()
        }else
        {
            YZMTextLabel.text=loadLanguage("倒计时\(shuttime)秒")
        }
        
        shuttime -= 1
    }
    
    func yanzhengfunc(){
        let Phone:String=phoneTextField.text!
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerServer/GetPhoneCode"
        let params:NSDictionary = ["phone":Phone]
        manager.post(url,
            parameters: params,
            success: { (operation,
                responseObject) in
            },
            failure: { (operation,
                error) in
                self.errorLabel.text=loadLanguage("网络连接失败,请重试。")
                self.shuttime=0
        })
        
        
    }

    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBAction func loginClick(_ sender: AnyObject) {
        

        let phone:String=phoneTextField.text!
        let YZM:String=YZMTextField.text!
        if !isAgree
        {
            errorLabel.text=loadLanguage("请阅读《浩泽净水家免责条款》并勾选")
            return
        }
        if !checkTel(phone as NSString)
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
        MBProgressHUD.showAdded(to: self.view, animated: true)
        LogInOut.loginInOutInstance().login(withAccount: phone, password: YZM, currentView: self.view)
        
    }
    
    var isAgree=true

    @IBOutlet var agreeImageView: UIButton!
    @IBOutlet var agreeButton: UIButton!
    @IBAction func agreeButtonClick(_ sender: AnyObject) {
        let imagename = isAgree ? "agree" : "agreeSelected"
        agreeImageView.setBackgroundImage(UIImage(named: imagename), for: UIControlState())
        
        isAgree = !isAgree
        errorLabel.text=""
    }
    
    @IBAction func agreeTextClick(_ sender: UIButton) {
        let agreeMentController=userAgreeMentsController(nibName: "userAgreeMentsController", bundle: nil)
        self.present(agreeMentController, animated: true, completion: nil)
    }
    
    @IBOutlet var TishiLabel: UILabel!
    @IBOutlet var getYYbutton: UIButton!
    @IBAction func getYYbuttonclick(_ sender: UIButton) {
        let istrue=checkTel(phoneTextField.text! as NSString)
        if istrue
        {
            
            //调用语音接口
            self.getYYbutton.isEnabled=false
            self.errorLabel.text=loadLanguage("您将会收到语音电话,请注意接听。")
            self.getYYbutton.backgroundColor=color_BT_bg_ed
            self.getYYbutton.layer.borderColor=color_BT_bg_ed.cgColor
            self.getYYbutton.setTitleColor(color_black, for: UIControlState())
            let WerbService=UserInfoActionWerbService()
            WerbService.getVoicePhoneCode(phoneTextField.text!, return: { (respose,status) -> Void in
                if  status?.networkStatus == kSuccessStatus
                {
                    
                    if ((respose as AnyObject).object(forKey: "state") as! Int)<=0
                    {
                        self.errorLabel.text=loadLanguage("请求失败,请检查网络。")
                        self.getYYbutton.isEnabled=true
                        self.getYYbutton.backgroundColor=UIColor.white
                        self.getYYbutton.layer.borderColor=color_main.cgColor
                        self.getYYbutton.setTitleColor(color_main, for: UIControlState())
                        
                    }
                }
                else
                {
                    self.errorLabel.text=loadLanguage("请求失败,请检查网络。")
                    self.getYYbutton.isEnabled=true
                    self.getYYbutton.backgroundColor=UIColor.white
                    self.getYYbutton.layer.borderColor=color_main.cgColor
                    self.getYYbutton.setTitleColor(color_main, for: UIControlState())
                }
            })
        }
        else
        {
            errorLabel.text=loadLanguage("请输入11位手机号")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    func loginFailed(_ notice:Notification)
    {
        print((notice as NSNotification).userInfo)
        let errorCode =  ((notice as NSNotification).userInfo!["errorCode"] as! NSString).intValue
        
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
       NotificationCenter.default.addObserver(self, selector: #selector(loginFailed), name: NSNotification.Name(rawValue: "networkFailedInfoNotice"), object: nil)
       loginButton.setTitle(loadLanguage("登录"), for: UIControlState())
        getYYbutton.setTitle(loadLanguage("获取语音验证码"), for: UIControlState())
        agreeButton.setTitle(loadLanguage("我已阅读并同意《浩泽净水家免责条款》"), for: UIControlState())
        phoneTextField.placeholder=loadLanguage("请输入手机号")
        YZMTextField.placeholder=loadLanguage("输入验证码")
        TishiLabel.text=loadLanguage("未收到短信验证码？")
        set_islogin(false)
        
        YZMbutton.layer.borderColor=color_main.cgColor
        getYYbutton.layer.borderColor=color_main.cgColor
        errorLabel.text=""
        phoneTextField.delegate=self
        YZMTextField.delegate=self
       
        if Screen_Width<=320
        {
            errorLabel.font=UIFont.systemFont(ofSize: 10)
        }
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
