//
//  RNEmailRegisterViewController.swift
//  OZner
//
//  Created by 婉卿容若 on 16/7/25.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class RNEmailRegisterViewController: UIViewController {
    
    // 正则判定
    
    struct RNRegexHelper {
        
        let regex: NSRegularExpression
        
        init(_ pattern: String) throws {
            
            try regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            
        }
        
        func match(input: String) -> Bool {
            
            let matches = regex.matchesInString(input, options: [], range: NSMakeRange(0, input.characters.count))
            
            return matches.count > 0
        }
    }


    // MARK: - properties - 即定义的各种属性
    
    @IBOutlet weak var emailTextField: UITextField! // 邮箱
    
    @IBOutlet weak var codeTextField: UITextField! // 验证码
    
    @IBOutlet weak var pswTextField: UITextField! // 密码
    
    @IBOutlet weak var cPswTextField: UITextField! // 确认密码
    
    @IBOutlet weak var getCodeBtn: UIButton! // 获取验证码
    
    var countDownTimer: NSTimer? // 计时器
    
    var remainingSeconds = 0{ // 倒计时剩余多少秒
        
        willSet{
            
            getCodeBtn.setTitle("\(newValue)s", forState: UIControlState.Normal)
            
            if newValue <= 0 {
                
                getCodeBtn.setTitle("重新获取", forState: UIControlState.Normal)
                
                isCounting = false
            }
        }
    }
    
    var isCounting: Bool = false{ // 用于开启和关闭计时器
        
        willSet{
            
            if  newValue {
                countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                
               // getCodeBtn.backgroundColor = UIColor.grayColor()
            }else {
                
                countDownTimer?.invalidate()
                countDownTimer = nil
                
              //  getCodeBtn.backgroundColor = UIColor.brownColor()
            }
            
            getCodeBtn.enabled = !newValue
        }
    }
    
    
    // MARK: -  Life cycle - 即生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit{
        
        
    }
    
}

// MARK: - Public Methods - 即系统提供的方法

extension RNEmailRegisterViewController{
    
}

// MARK: - Private Methods - 即私人写的方法

extension  RNEmailRegisterViewController{
    
    // 校验
    func checkout01() -> Bool{
        
        guard !(emailTextField.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "邮箱不能为空")
            
            return false
        }
        
        guard isValidateEmail(emailTextField.text!) else{
            
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "邮箱格式不正确")
            
            return false
        }
        
        
        return true
    }
    
    func checkout02() -> Bool{
        
        guard !(codeTextField.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "验证码不能为空")
            
            return false
        }
        
        guard !(pswTextField.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "密码不能为空")
            
            return false
        }
        
        guard !(cPswTextField.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "确认密码不能为空")
            
            return false
        }

        
        guard (pswTextField.text! as NSString).isEqualToString(cPswTextField.text!) else {
         
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "两次密码不同")
            
            return false
        }
        
        return true

    }
    
    
    // 邮箱格式
    func isValidateEmail(email: String) -> Bool{
        
        let emailRegex = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher: RNRegexHelper
        do {
            matcher = try! RNRegexHelper(emailRegex)
        }
        
        return matcher.match(email)
    }

    
}

// MARK: - Event response - 按钮/手势等事件的回应方法

extension  RNEmailRegisterViewController{
    
    // 获取验证码
    @IBAction func getCodeAction(sender: UIButton) {
        
        // 先校验邮箱格式
        
        guard checkout01() else{ return }
        
        // 调用发送验证码接口
        // 成功回调
        
        remainingSeconds = 60
        isCounting = true
        
    }
    
    // 注册
    @IBAction func registerAction(sender: UIButton) {
        
        guard checkout01() else{ return }
        
        guard checkout02() else{ return }
        
        // 请求接口
    }
    
    //计时器事件
    func updateTime() -> Void {
        
        remainingSeconds -= 1
    }

    
}

// MARK: - Delegates - 即各种代理方法


