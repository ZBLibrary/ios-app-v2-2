//
//  SwiftFatherViewController.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/2.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class SwiftFatherViewController: UIViewController {

    
    var heightValue:CGFloat = 0.0;
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addkeyBoardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if self.respondsToSelector("setEdgesForExtendedLayout:")
        {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        if(UIScreen.mainScreen().bounds.height <= 568)
        {
            heightValue = 150;
        }
        else
        {
            heightValue = 100;
        }
        
    }
    
    func addkeyBoardNotification()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillShow:", name:UIKeyboardWillShowNotification, object:nil);
    }
    
    func keyboardWillHide(note:NSNotification)
    {
        self.viewAnmiatonMethod(2)
    }
    func keyboardWillShow(note:NSNotification)
    {
        self.viewAnmiatonMethod(1)
    }
    
    /*
    *键盘显示隐藏状态
    *index : 方式
    */
    func viewAnmiatonMethod(index:Int)
    {
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.5)
        
        switch (index)
        {
        case 1:
            if (self.view.frame.origin.y == 64)
            {
                self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - heightValue,self.view.frame.size.width,self.view.frame.size.height);
            }
            
        case 2:
            if (self.view.frame.origin.y != 64)
            {
                self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y + heightValue,self.view.frame.size.width,self.view.frame.size.height);
                
            }
        default:
            break;
        }
        UIView.commitAnimations();
    }

}
