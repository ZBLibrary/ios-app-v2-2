//
//  SendYanZHViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class SendYanZHViewController: UIViewController,UITextFieldDelegate {

    var sendphone=""
    @IBAction func CancelClick(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func SendClick(_ sender: AnyObject) {
        SendMess(MessTF.text!)
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet var MessTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessTF.delegate=self
        MessTF.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        SendMess(textField.text!)
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func SendMess(_ messstring:String)
    {
        /*
        usertoken
        //用户登录返回标识
        mobile
        //对方手机号
        content
*/
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerServer/AddFriend"
        let params:NSDictionary = ["usertoken":get_UserToken(),"content":messstring,"mobile":sendphone]
        manager.post(url,
            parameters: params,
            success: { (operation,
                responseObject) in
                print(responseObject)
                let isSuccess=(responseObject as AnyObject).object(forKey: "state") as! Int
                if isSuccess > 0
                {
                    let successalert = UIAlertView(title: "", message:loadLanguage("发送成功"), delegate: self, cancelButtonTitle: "ok")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "sendAddFriendMesSuccess"), object: nil)
                    successalert.show()
                    _=self.navigationController?.popViewController(animated: true)
                }
                else if isSuccess == -10017
                {
                    let successalert = UIAlertView(title: "", message:loadLanguage("对方不是浩泽用户"), delegate: self, cancelButtonTitle: "ok")
                    successalert.show()
                }
                
            },
            failure: { (operation,
                error) in
                
                //print("Error: " + error.localizedDescription)
                
        })
//        let werbservice = UserInfoActionWerbService()
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        werbservice.addFriend(sendphone, content: messstring, returnBlock:{ (state:StatusManager!) -> Void in
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
//            if state.networkStatus == kSuccessStatus
//            {
//                let successalert = UIAlertView(title: "提示", message: "发送验证消息成功", delegate: self, cancelButtonTitle: "ok")
//                successalert.show()
//                self.navigationController?.popViewControllerAnimated(true)
//                NSNotificationCenter.defaultCenter().postNotificationName("sendAddFriendMesSuccess", object: nil)
//            }
//            else
//            {
//                let successalert = UIAlertView(title: "提示", message: "添加失败，请检查网络", delegate: self, cancelButtonTitle: "ok")
//                successalert.show()
//            }
//        })
        
        
    }
}
