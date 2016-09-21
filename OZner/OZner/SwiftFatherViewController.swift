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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addkeyBoardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        if self.respondsToSelector("setEdgesForExtendedLayout")
//        {
//            self.edgesForExtendedLayout = UIRectEdge.None
//        }
        
        if(UIScreen.main.bounds.height <= 568)
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object:nil);
    }
    
    func keyboardWillHide(_ note:Notification)
    {
        self.viewAnmiatonMethod(2)
    }
    func keyboardWillShow(_ note:Notification)
    {
        self.viewAnmiatonMethod(1)
    }
    
    /*
    *键盘显示隐藏状态
    *index : 方式
    */
    func viewAnmiatonMethod(_ index:Int)
    {
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.5)
        
        switch (index)
        {
        case 1:
            if (self.view.frame.origin.y == 64)
            {
                self.view.frame = CGRect(x: self.view.frame.origin.x,y: self.view.frame.origin.y - heightValue,width: self.view.frame.size.width,height: self.view.frame.size.height);
            }
            
        case 2:
            if (self.view.frame.origin.y != 64)
            {
                self.view.frame = CGRect(x: self.view.frame.origin.x,y: self.view.frame.origin.y + heightValue,width: self.view.frame.size.width,height: self.view.frame.size.height);
                
            }
        default:
            break;
        }
        UIView.commitAnimations();
    }

}
