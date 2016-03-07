//
//  ViewController.swift
//  Test
//
//  Created by 赵兵 on 16/1/27.
//  Copyright © 2016年 赵兵. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label1: UILabel!
    @IBAction func click1(sender: AnyObject) {
        self.label1.text="\(0)"
        
        UIView.animateWithDuration(3.0, animations: { () -> Void in
            self.label1.text="\(100)"
            }, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

