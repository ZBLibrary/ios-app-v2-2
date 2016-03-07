//
//  StarGuideViewController.swift
//  oznerproject
//
//  Created by 111 on 15/11/19.
//  Copyright © 2015年 ozner. All rights reserved.
//

import UIKit

class StarGuideViewController: UIViewController,UIScrollViewDelegate {

    var starContentOffsetX=CGFloat(0)
    var willEndContentOffsetX=CGFloat(0)
    var endContentOffsetX=CGFloat(0)
    var pagecontrol:UIPageControl!
    //var pagecontrol:UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.initGuide()   //加载新用户指导页面
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initGuide()
    {
        let scrollView = UIScrollView(frame: CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT))
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*3, 0)
        scrollView.pagingEnabled = true  //视图整页显示
        scrollView.bounces=false// setBounces:NO]; //避免弹跳效果,避免把根视图露出来
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.showsVerticalScrollIndicator=false
        scrollView.delegate=self
        for i in 1...3
        {
            let imageview = UIImageView(frame: CGRect(x: CGFloat(i-1)*SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH , height: SCREEN_HEIGHT))
            imageview.image=UIImage(named: "StarGuide\(i)")
            scrollView.addSubview(imageview)
        }
        
        self.view.addSubview(scrollView)
        pagecontrol=UIPageControl(frame: CGRect(x: SCREEN_WIDTH/2-17, y: SCREEN_HEIGHT-21, width: 34, height: 6))
        pagecontrol.numberOfPages=3
        pagecontrol.currentPage=0
        pagecontrol.currentPageIndicatorTintColor=color_sblue
        pagecontrol.pageIndicatorTintColor=color_gray
        //pagecontrol.backgroundColor=UIColor.redColor()
        self.view.addSubview(pagecontrol)
    }
    // scrollView 开始拖动
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        starContentOffsetX=scrollView.contentOffset.x
    }
    // scrollView 将要结束拖动
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        willEndContentOffsetX=scrollView.contentOffset.x
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pagecontrol.currentPage=Int(scrollView.contentOffset.x/SCREEN_WIDTH)
        
    }
    
    // scrollView 结束拖动
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endContentOffsetX=scrollView.contentOffset.x
        if starContentOffsetX==willEndContentOffsetX&&endContentOffsetX==willEndContentOffsetX&&endContentOffsetX==SCREEN_WIDTH*CGFloat(2)
        {
            self.performSegueWithIdentifier("showlogin", sender: self)
        }

    } 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
   
}
