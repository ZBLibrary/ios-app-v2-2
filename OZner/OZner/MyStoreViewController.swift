//
//  MyStoreViewController.swift
//  OZner
//
//  Created by test on 15/12/3.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class MyStoreViewController: UIViewController,UIWebViewDelegate {

    var mobile=get_Phone()
    var UserTalkCode=get_UserToken()
    var Language="zh"
    var Area="zh"
    //webView
    var webView:UIWebView!
    //继续加载按钮
    var button:UIButton!
    var urlstr:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        urlstr = GoUrlBefore("http://www.oznerwater.com/lktnew/wap/mall/mallHomePage.aspx")
        //加载失败
        button=UIButton(frame: CGRect(x: 0, y: Screen_Hight/2-40, width: SCREEN_WIDTH, height: 40))
        button.addTarget(self, action: #selector(loadAgain), for: .touchUpInside)
        button.setTitleColor(UIColor.gray, for: UIControlState())
        button.setTitle(loadLanguage("加载失败点击继续加载！"), for: UIControlState())
        button.isHidden=true
        webView=UIWebView(frame: CGRect(x: 0, y: -20, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-25))
        
        webView.delegate=self
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        webView.loadRequest(URLRequest(url: URL(string: urlstr!)!))
        //webView = SMWebView.loadURL(NSURL(string: urlstr)!)
        
        webView.addSubview(button)
        // Do any additional setup after loading the view.
    }
   
    //继续加载
    func loadAgain(_ button:UIButton)
    {
        webView.loadRequest(URLRequest(url: URL(string: urlstr!)!))
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        button.isHidden=true
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //MBProgressHUD.hideHUDForView(self.view, animated: true)
        button.isHidden=true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        //MBProgressHUD.hideHUDForView(self.view, animated: true)
        button.isHidden=false
    }
    func GoUrlBefore(_ url:String)->String
    {
        
        print("tttttttttt:\(UserTalkCode)")
        return "http://www.oznerwater.com/lktnew/wap/app/Oauth2.aspx?mobile="+mobile+"&UserTalkCode="+UserTalkCode+"&Language="+Language+"&Area="+Area+"&goUrl="+url
        //print("http://test.oznerwater.com/lktnew/wap/app/Oauth2.aspx?mobile="+mobile+"&UserTalkCode="+UserTalkCode+"&Language="+Language+"&Area="+Area+"&goUrl="+url)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden=true
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).showAllMyTabBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden=false
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
