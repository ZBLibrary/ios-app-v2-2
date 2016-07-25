//
//  RNEmailLoginViewController.swift
//  OZner
//
//  Created by 婉卿容若 on 16/7/25.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit


class RNEmailLoginViewController: UIViewController {
    
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
    
    @IBOutlet weak var passwordTextfield: UITextField! // 密码
    
    
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

extension RNEmailLoginViewController{
    
}

// MARK: - Private Methods - 即私人写的方法

extension  RNEmailLoginViewController{
    
    // 校验
    func checkout() -> Bool{
        
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
        
        guard !(passwordTextfield.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "密码不能为空")
            
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

extension  RNEmailLoginViewController{
    
    // 邮箱登录
    @IBAction func loginAction(sender: UIButton) {
        
        guard checkout() else{
            
            return
        }
        
        // 登陆请求
    }
    
    // 注册账号(邮箱)
    @IBAction func registerAction(sender: UIButton) {
        
        let register = RNEmailRegisterViewController()
        
        navigationController?.pushViewController(register, animated: true)
        
    }
    
    // 验证码登录
    @IBAction func loginWithVetificationCode(sender: UIButton) {
        
    }
    
}

// MARK: - Delegates - 即各种代理方法


