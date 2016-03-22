//
//  TDSStateController.swift
//  OZner
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class ToWhatViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience  init() {
        
        var nibNameOrNil = String?("RootViewController")
        
        //考虑到xib文件可能不存在或被删，故加入判断
        
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
            
        {
            
            nibNameOrNil = nil
            
        }
        
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text=self.title
        let filePath = NSBundle.mainBundle().pathForResource("WhatHtml", ofType: "plist")
        let tmpstr = NSDictionary(contentsOfFile: filePath!)

        let htmlString = tmpstr?.objectForKey((self.title)!) as! String
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
