//
//  userAgreeMentsController.swift
//  OZner
//
//  Created by test on 16/1/1.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class userAgreeMentsController: UIViewController {


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
        required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    @IBAction func BackToLogin(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: "http://cup.ozner.net/app/cn/mzsm.html")!))
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
