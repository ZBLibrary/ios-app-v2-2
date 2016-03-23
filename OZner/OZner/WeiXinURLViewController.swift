//
//  WeiXinURLViewController.swift
//  OZner
//
//  Created by test on 16/1/1.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
struct weiXinUrlNamezb {
    let myMoney="我的小金库"
    let shareLiKa="我的订单"
    let callFriend="领红包"
    let awardInfo="我的券"
    let waterReport="查看水质检测报告"
    
    let WaterKnow="健康水知道"
    
    let byTapLX="水探头滤芯"
    let byAirLX="空气净化器滤芯"
    //水探头--更多产品
    let moreDevice_Tap="浩泽智能水探头"
    let moreDevice_Water="金色依泉系列"
    let moreDevice_Cup="浩泽智能杯"
    //净水器滤芯
    let WaterLvXinUrl1="净水器滤芯1"
    let WaterLvXinUrl2="净水器滤芯2"
    let WaterLvXinUrl3="净水器滤芯3"
    //补水仪
    let WaterReplenishOperation="补水仪使用说明"
    
}
class WeiXinURLViewController: UIViewController,UIWebViewDelegate {

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
    @IBAction func BackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet var titleOfURL: UILabel!
    @IBOutlet var webView: UIWebView!
    var mobile=get_Phone()
    var UserTalkCode=get_UserToken()
    var Language="zh"
    var Area="zh"
    var button:UIButton!
    var tmpURL=""
    override func viewDidLoad() {
        super.viewDidLoad()

        titleOfURL.text=self.title
        
        //重新加载按钮
        button=UIButton(frame: CGRect(x: 0, y: Screen_Hight/2-40, width: SCREEN_WIDTH, height: 40))
        button.addTarget(self, action: #selector(loadAgain), forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        button.setTitle("加载失败点击继续加载！", forState: .Normal)
        button.hidden=true
        webView.addSubview(button)
        
        let weiXinUrl=weiXinUrlNamezb()
        switch (self.title!)
        {
        
        //我的小金库
        case weiXinUrl.myMoney:
        
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wapnew/Member/MyCoffers.aspx")
            
            break

        //我的订单
        case weiXinUrl.shareLiKa:
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wapnew/Orders/OrderList.aspx")
            break
            
        //领红包
        case weiXinUrl.callFriend:
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wapnew/Member/GrapRedPackages.aspx")
            break
        //我的券
        case weiXinUrl.awardInfo:
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wapnew/Member/AwardList.aspx")
            break
        //查看水质检测报告
        case weiXinUrl.waterReport:
            tmpURL = "http://erweima.ozner.net:85/index.aspx?tel="+mobile
            break
        //健康水知道
        case weiXinUrl.WaterKnow:
            tmpURL = "http://cup.ozner.net/app/cn/jxszd.html"
            break
            //水探头滤芯
        case weiXinUrl.byTapLX:
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wap/mall/goodsDetail.aspx?gid=39")
            break
            //空净滤芯
        case weiXinUrl.byAirLX:
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wap/mall/goodsDetail.aspx?gid=64&il=1")
            break
            
            //智能水探头
        case weiXinUrl.moreDevice_Tap:
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wap/mall/goodsDetail.aspx?gid=36")
            break
            //金色依泉系列
        case weiXinUrl.moreDevice_Water:
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wap/mall/goodsDetail.aspx?gid=43")
            break
            //智能杯
        case weiXinUrl.moreDevice_Cup:
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wap/mall/goodsDetail.aspx?gid=7")
            break
 
        case weiXinUrl.WaterLvXinUrl1://365安心服务
            titleOfURL.text="净水器滤芯"
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wap/mall/goodsDetail.aspx?gid=9")
            break
        case weiXinUrl.WaterLvXinUrl2://迷你净水器滤芯购买链接
            titleOfURL.text="净水器滤芯"
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wap/shopping/confirmOrderFromQrcode.aspx?gid=68")
            break
        case weiXinUrl.WaterLvXinUrl3://台式净水器滤芯购买链接
            titleOfURL.text="净水器滤芯"
            tmpURL = GoUrlBefore("http://www.oznerwater.com/lktnew/wap/shopping/confirmOrderFromQrcode.aspx?gid=69")
            break
        case weiXinUrl.WaterReplenishOperation://补水仪使用说明
            titleOfURL.text="补水仪使用说明"
            tmpURL = "http://app.ozner.net:888//Public/Index"
            break
            
        default:
            break
        }
        webView.delegate=self
        webView.scalesPageToFit = true
        webView.loadRequest(NSURLRequest(URL: NSURL(string: tmpURL)!))
        
        // Do any additional setup after loading the view.
    }

    
    //继续加载
    func loadAgain(button:UIButton)
    {
        webView.loadRequest(NSURLRequest(URL: NSURL(string: tmpURL)!))
        
    }
    func webViewDidStartLoad(webView: UIWebView) {
        button.hidden=true
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.performSelector(#selector(hideMbProgressHUD), withObject: nil, afterDelay: 3);
    }
    func hideMbProgressHUD()
    {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        button.hidden=true
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        button.hidden=false
    }
    func GoUrlBefore(url:String)->String
    {
        
        return "http://www.oznerwater.com/lktnew/wap/app/Oauth2.aspx?mobile="+mobile+"&UserTalkCode="+UserTalkCode+"&Language="+Language+"&Area="+Area+"&goUrl="+url
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
