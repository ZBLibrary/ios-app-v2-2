//
//  GYTDSViewController.swift
//  OZner
//
//  Created by zhuguangyang on 2016/11/16.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class GYTDSViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "zuo1.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(GYTDSViewController.btnaCTION))
        self.title = "什么是TDS?";
        let webView = UIWebView(frame: self.view.bounds)
        
        view.addSubview(webView)
        
        
        
       
        
        let filePath = NSBundle.mainBundle().pathForResource("WhatHtml_EN", ofType: "plist")
        let tmpstr = NSDictionary(contentsOfFile: filePath!)
        
        let htmlString = tmpstr?.objectForKey((self.title)!) as! String
        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.scalesPageToFit = true
        
    }
    
    func btnaCTION() {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
