//
//  TDSStateController.swift
//  OZner
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class TDSStateController: UIViewController {

    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = NSBundle.mainBundle().pathForResource("WhatTDShtmlString", ofType: "plist")
        let tmpstr = NSDictionary(contentsOfFile: filePath!)
        let htmlString = tmpstr?.objectForKey("htmlstr") as! String
        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.scalesPageToFit = true
        // Do any additional setup after loading the view.
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
