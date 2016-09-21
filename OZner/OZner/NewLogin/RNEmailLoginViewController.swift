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
            
            try regex = NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
        }
        
        func match(_ input: String) -> Bool {
            
            let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
            
            return matches.count > 0
        }
    }


    // MARK: - properties - 即定义的各种属性
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contrainerView: UIView! //
    
    @IBOutlet weak var emailTextField: UITextField! // 邮箱
    
    @IBOutlet weak var passwordTextfield: UITextField! // 密码
    
    @IBOutlet weak var phoneLoginButton: UIButton! // 验证码登录
    
    // MARK: -  Life cycle - 即生命周期
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init() {
        
        var nibNameOrNil = String?("RNEmailLoginViewController")
        
        //考虑到xib文件可能不存在或被删，故加入判断
        
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "xib") == nil
            
        {
            
            nibNameOrNil = nil
            
        }
        
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneLoginButton.isHidden = true
        
        addDelegateForTextField()
        keyBoardObserve()
        addTap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit{
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

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
            _=alertView.addButton("OK", action: {})
            _=alertView.showError("Error Tips", subTitle: "Email cannot be empty")
            return false
        }
        
        guard isValidateEmail(emailTextField.text!) else{
            
            let alertView=SCLAlertView()
            _=alertView.addButton("OK", action: {})
            _=alertView.showError("Error Tips", subTitle:  "Email address format is not correct")
            
            return false
        }
        
        guard !(passwordTextfield.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            _=alertView.addButton("OK", action: {})
            _=alertView.showError("Error Tips", subTitle:  "Password connot be empty")
            
            return false
        }
        
        
        return true
    }
    
    
    // 邮箱格式
    func isValidateEmail(_ email: String) -> Bool{
        
        let emailRegex = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher: RNRegexHelper
        do {
            matcher = try! RNRegexHelper(emailRegex)
        }
        
        return matcher.match(email)
    }
    
    
    // 键盘监听
    func keyBoardObserve() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    // 添加手势
    func addTap() {
        
        scrollView.isUserInteractionEnabled = true
        contrainerView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyHidden))
        contrainerView.addGestureRecognizer(tap)
    }
}

// MARK: - Event response - 按钮/手势等事件的回应方法

extension  RNEmailLoginViewController{
    
    // 邮箱登录
    @IBAction func loginAction(_ sender: UIButton) {
        
        guard checkout() else{
            
            return
        }
        
        // 登陆请求
        //loginRequeset()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        LogInOut.loginInOutInstance().login(withEmail: emailTextField.text!, password: passwordTextfield.text!, currentView: self.view)
    }
    
    // 忘记密码
    @IBAction func forgetPassword(_ sender: UIButton) {
        
        let modifyPassword = RNModifyPasswordViewController(nibName: "RNModifyPasswordViewController", bundle: nil)
        navigationController?.pushViewController(modifyPassword, animated: true)
    }
    // 注册账号(邮箱)
    @IBAction func registerAction(_ sender: UIButton) {
        
        let register = RNEmailRegisterViewController(nibName: "RNEmailRegisterViewController", bundle: nil)
        
        navigationController?.pushViewController(register, animated: true)
        
    }
    
    // 验证码登录
    @IBAction func loginWithVetificationCode(_ sender: UIButton) {
        
        
//        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        mLoginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    // 键盘显示
    func keyboardWillShow(_ notification: Notification) {
        
        // 获取键盘高度
        let heightTmp = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]) as AnyObject
         let height = heightTmp.cgRectValue//.cgRectValue.height
        
        // 设置 contentInset 的值,默认为(0,0,0,0)
        let e = UIEdgeInsetsMake(0, 0, (height?.height ?? 0)!, 0)
        
        scrollView.contentInset = e
        
    }
    
    // 键盘隐藏
    func keyboardWillHidden(_ notification: Notification) {
        
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
        let miei = UIDevice.current.identifierForVendor!.uuidString
        let devicename = UIDevice.current.name
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerServer/MailLogin"
        let params:NSDictionary = ["username":phone,"password":password,"miei":miei,"devicename":devicename]
        manager.post(url,
                     parameters: params,
                     success: { (operation,
                        responseObject) in
                        
                        // 登陆成功
                        print("dengluchenggong")
            },
                     failure: { (operation,
                        error) in
                       
                        let alertView=SCLAlertView()
                        _=alertView.addButton("OK", action: {})
                        _=alertView.showError("Error Tips", subTitle: error.localizedDescription)
        })
        
        
    }

}

// MARK: - Delegates - 即各种代理方法

// MARK: - UITextFieldDelegate

extension RNEmailLoginViewController{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag < 1 {
            let tf = contrainerView.viewWithTag(textField.tag + 1) as! UITextField
            tf.becomeFirstResponder()
            return true
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}

