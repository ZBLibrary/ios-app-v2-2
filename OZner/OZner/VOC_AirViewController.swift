//
//  VOC_AirViewController.swift
//  OZner
//
//  Created by test on 15/12/20.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class VOC_AirViewController: UIViewController {

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
    @IBOutlet weak var Volotiiecompounds: UILabel!
    
    
    
    @IBOutlet weak var desriText: UITextView!
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Volotiiecompounds.text = loadLanguage("挥发性有机化合物");
        self.title="什么是VOC"
        desriText.text = loadLanguage("  通常指在常温下容易挥发的有机化物。较常见的苯 、甲苯、二甲苯、乙苯、苯乙烯、甲醛、TVOC(6-16个碳的烷烃）、酮类等。 这些化合物具有易挥发和亲油等特点，被广泛应用于鞋类、玩具、油漆和石墨、粘合剂、化妆品、室内和汽车装饰材料等工业领域。VOC对人体健康有巨大的影响，会伤害人的肝脏、肾脏、大脑和神经系统，造成记忆力减退等严重后果，甚至可能致癌。");

        
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: Selector("back"), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        // Do any additional setup after loading the view.
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
        self.navigationController?.navigationBarHidden=false
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
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
