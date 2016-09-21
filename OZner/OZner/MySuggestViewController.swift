//
//  MySuggestViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class MySuggestViewController: UIViewController,UITextViewDelegate {

    @IBOutlet var messCount: UILabel!
    @IBAction func BackClick(_ sender: AnyObject) {
    
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet var MessTV: UITextView!
    @IBOutlet var TiaShiButton: UIButton!
    
    @IBAction func TiShiClick(_ sender: AnyObject) {
        TiaShiButton.isHidden=true
        MessTV.becomeFirstResponder()
    }
    
    @IBAction func OKClick(_ sender: AnyObject) {
        sendsuggest(MessTV.text)
        
    }
    var counttmp=0
    @IBOutlet var OKButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      OKButton.setTitle(loadLanguage("提交"), for: UIControlState())
        MessTV.delegate=self
        self.automaticallyAdjustsScrollViewInsets = false
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text=="\n" {
            //sendsuggest(MessTV.text)
            textView.resignFirstResponder()
            return false
        }
        else
        {
            counttmp=MessTV.text.characters.count
            messCount.text="\(counttmp)/300"
        }
        
        return true
    }
    func sendsuggest(_ msg:String)
    {
        if msg==""
        {return}
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerServer/SubmitOpinion"
        let params:NSDictionary = ["usertoken":get_UserToken(),"message":msg]
        manager.post(url,
            parameters: params,
            success: { (operation,
                responseObject) in
                MBProgressHUD.hide(for: self.view, animated: true)
                print(responseObject)
                let isSuccess=(responseObject as AnyObject).object(forKey: "state") as! Int
                if isSuccess > 0
                {
                    let successalert = UIAlertView(title: "", message:loadLanguage("意见提交成功"), delegate: self, cancelButtonTitle: "ok")
                    successalert.show()
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    let successalert = UIAlertView(title: "", message:loadLanguage("意见提交失败"), delegate: self, cancelButtonTitle: "ok")
                    successalert.show()
                }
                
            },
            failure: { (operation,
                error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                
        })

       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title=loadLanguage("我要提意见")
        self.navigationController?.isNavigationBarHidden=false
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
        //self.tabBarController?.tabBar.hidden=true
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
