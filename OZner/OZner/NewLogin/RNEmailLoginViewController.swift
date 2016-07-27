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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contrainerView: UIView! //
    
    @IBOutlet weak var emailTextField: UITextField! // 邮箱
    
    @IBOutlet weak var passwordTextfield: UITextField! // 密码
    
    @IBOutlet weak var phoneLoginButton: UIButton!
    
    // MARK: -  Life cycle - 即生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneLoginButton.hidden = true
        
        addDelegateForTextField()
        keyBoardObserve()
        addTap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

    }
    
}

// MARK: - Public Methods - 即系统提供的方法

extension RNEmailLoginViewController{
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        view.endEditing(true)
//        
//    }
}

// MARK: - Private Methods - 即私人写的方法

extension  RNEmailLoginViewController: UITextFieldDelegate{
    
    // 添加代理
    func addDelegateForTextField() {
        
        emailTextField.delegate = self
        passwordTextfield.delegate = self
    }
    
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
    
    
    // 键盘监听
    func keyBoardObserve() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    
    // 添加手势
    func addTap() {
        
        scrollView.userInteractionEnabled = true
        contrainerView.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyHidden))
        contrainerView.addGestureRecognizer(tap)
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
        //loginRequeset()
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        LogInOut.loginInOutInstance().loginWithEmail(emailTextField.text!, password: passwordTextfield.text!, currentView: self.view)
    }
    
    // 忘记密码
    @IBAction func forgetPassword(sender: UIButton) {
        
        let modifyPassword = RNModifyPasswordViewController()
        navigationController?.pushViewController(modifyPassword, animated: true)
    }
    // 注册账号(邮箱)
    @IBAction func registerAction(sender: UIButton) {
        
        let register = RNEmailRegisterViewController()
        
        navigationController?.pushViewController(register, animated: true)
        
    }
    
    // 验证码登录
    @IBAction func loginWithVetificationCode(sender: UIButton) {
        
        
//        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        mLoginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
        
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    // 键盘显示
    func keyboardWillShow(notification: NSNotification) {
        
        // 获取键盘高度
        let height = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue().height
        
        // 设置 contentInset 的值,默认为(0,0,0,0)
        let e = UIEdgeInsetsMake(0, 0, height!, 0)
        
        scrollView.contentInset = e
        
    }
    
    // 键盘隐藏
    func keyboardWillHidden(notification: NSNotification) {
        
        // 将 contentInset 的值设回默认值(0,0,0,0)
        let e = UIEdgeInsetsMake(0, 0, 0, 0)
        
        scrollView.contentInset = e
        
    }

    // 手势收起键盘
    func keyHidden() {
        
        contrainerView.endEditing(true)
    }
    
    // 登陆请求
    func loginRequeset(){
        let phone = emailTextField.text!
        let password = passwordTextfield.text!
        let miei = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let devicename = UIDevice.currentDevice().name
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerServer/MailLogin"
        let params:NSDictionary = ["username":phone,"password":password,"miei":miei,"devicename":devicename]
        manager.POST(url,
                     parameters: params,
                     success: { (operation: AFHTTPRequestOperation!,
                        responseObject: AnyObject!) in
                        
                        // 登陆成功
                        print("dengluchenggong")
            },
                     failure: { (operation: AFHTTPRequestOperation!,
                        error: NSError!) in
                       
                        let alertView=SCLAlertView()
                        alertView.addButton("确定", action: {})
                        alertView.showError("错误提示", subTitle: error.localizedDescription)
        })
        
        
    }

}

// MARK: - Delegates - 即各种代理方法

// MARK: - UITextFieldDelegate

extension RNEmailLoginViewController{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.tag < 1 {
            let tf = contrainerView.viewWithTag(textField.tag + 1) as! UITextField
            tf.becomeFirstResponder()
            return true
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}

