//
//  PM2.swift
//  OZner
//
//  Created by test on 15/12/20.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class PM2d5ViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    @IBOutlet weak var fineMatter: UILabel!
    
    @IBOutlet weak var descrText: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="什么是PM2.5"
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
       
        fineMatter.text = loadLanguage("细颗粒物");
        
        descrText.text = loadLanguage("  PM2.5是直径小于或等于2.5微米的颗粒物，也称为细颗粒物或可入肺颗粒物，可直接进入肺部。PM2.5沉淀进肺泡后无法排除，会对呼吸系统和心血管系统造成很大伤害，引起包括支气管炎，哮喘，冠心病等疾病。");
    
    
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
        self.navigationController?.navigationBarHidden=false
        //CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden=true
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
