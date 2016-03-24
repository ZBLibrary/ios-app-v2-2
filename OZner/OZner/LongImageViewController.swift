//
//  LongImageViewController.swift
//  OZner
//
//  Created by test on 16/1/5.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class LongImageViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
        required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    @IBOutlet var mainScrollerView: UIScrollView!
    var iswhitch=0//0使用说明，1代表问题，4台式，5立式
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)

        //
        var imageView:UIImageView
        if iswhitch==0
        {
        
            if get_CurrSelectEquip()==4
            {
                 self.title="台式空气净化器使用说明"
                 imageView=UIImageView(image: UIImage(named: "airOperation_small"))
            }
            else
            {
                 self.title="立式空气净化器使用说明"
                 imageView=UIImageView(image: UIImage(named: "airOperation_big"))
            }
        }
        else
        {
            if get_CurrSelectEquip()==4
            {
                self.title="台式空气净化器常见问题"
                imageView=UIImageView(image: UIImage(named: "airProblem_small"))
            }
            else
            {
                self.title="立式空气净化器常见问题"
                imageView=UIImageView(image: UIImage(named: "airProblem_big"))
            }
        }
        imageView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: imageView.frame.height*Screen_Width/imageView.frame.width)
        mainScrollerView.addSubview(imageView)
        mainScrollerView.contentSize=CGSize(width: 0, height: imageView.frame.height)
        // Do any additional setup after loading the view.
    }

    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
        self.navigationController?.navigationBarHidden=false
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
