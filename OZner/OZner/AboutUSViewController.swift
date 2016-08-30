//
//  AboutUSViewController.swift
//  My
//
//  Created by test on 15/11/27.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class AboutUSViewController: UIViewController {

    @IBAction func BackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet var ScoreLable: UILabel!
    

    @IBOutlet var HaozeLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
     self.title=loadLanguage("关于伊泉净品" )
        //UpdateLable.text=loadLanguage("检查更新版本" )
        ScoreLable.text=loadLanguage("评个分吧")
      HaozeLable.text=loadLanguage("伊泉净品")
        // Do any additional setup after loading the view.
    }
    //评个分吧
    @IBAction func GiveScore(sender: AnyObject) {
        let str = "itms-apps://itunes.apple.com/app/id955305764"
        UIApplication.sharedApplication().openURL(NSURL(string: str)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
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
