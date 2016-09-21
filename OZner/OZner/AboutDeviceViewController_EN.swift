//
//  AboutDeviceViewController.swift
//  OZner
//
//  Created by test on 15/12/18.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class AboutDeviceViewController_EN: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    @IBOutlet var webView: UIWebView!
    var urlstring=""
    //var viewTitle=""
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        //self.title=viewTitle
        webView.loadRequest(URLRequest(url: URL(string: urlstring)!))
        webView.scalesPageToFit = true
        // Do any additional setup after loading the view.
    }

    func back(){
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
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
