//
//  WeiXinURLViewController.swift
//  OZner
//
//  Created by test on 16/1/1.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
struct weiXinUrlNamezb {
    let myMoney = loadLanguage("我的小金库")
    let shareLiKa = loadLanguage("我的订单")
    let callFriend = loadLanguage("领红包")
    let awardInfo = loadLanguage("我的券")
    let waterReport = loadLanguage("查看水质检测报告")
    
    let WaterKnow=loadLanguage("健康水知道")
    
    let byTapLX=loadLanguage("水探头滤芯")
    let byAirLX=loadLanguage("空气净化器滤芯")
    //水探头--更多产品
    let moreDevice_Tap=loadLanguage("浩泽智能水探头")
    let moreDevice_Water=loadLanguage("金色依泉系列")
    let moreDevice_Cup=loadLanguage("浩泽智能杯")
    //净水器滤芯
    let WaterLvXinUrl1=loadLanguage("净水器滤芯1")
    let WaterLvXinUrl2=loadLanguage("净水器滤芯2")
    let WaterLvXinUrl3=loadLanguage("净水器滤芯3")
    //补水仪
    let WaterReplenishOperation=loadLanguage("补水仪使用说明")
    
}
class WeiXinURLViewController_EN: UIViewController,UIWebViewDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    var goUrlOfOut:String?
    
    @IBOutlet var shareButton: UIButton!
    @IBAction func shareClick(_ sender: AnyObject) {
        self.view!.addSubview(shareView!)
    }
    convenience  init(goUrl:String) {
        
        var nibNameOrNil = String?("WeiXinURLViewController_EN")
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        self.goUrlOfOut=goUrl
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    @IBAction func BackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var titleOfURL: UILabel!
    @IBOutlet var webView: UIWebView!
    var mobile=get_Phone()
    var UserTalkCode=get_UserToken()
    var Language="zh"
    var Area="zh"
    var button:UIButton!
    var tmpURL=""
    var shareView:ShareMoneyToWeChat!
    override func viewDidLoad() {
        super.viewDidLoad()

        shareButton.isHidden=true
        shareView = Bundle.main.loadNibNamed("ShareMoneyToWeChat", owner: self, options: nil)?.last as! ShareMoneyToWeChat
        shareView.frame=CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: Screen_Hight)
        shareView.backgroundColor=UIColor.black.withAlphaComponent(0.3)
        
        titleOfURL.text=self.title
        
        //重新加载按钮
        button=UIButton(frame: CGRect(x: 0, y: Screen_Hight/2-40, width: SCREEN_WIDTH, height: 40))
        button.addTarget(self, action: #selector(loadAgain), for: .touchUpInside)
        button.setTitleColor(UIColor.gray, for: UIControlState())
        button.setTitle(loadLanguage("加载失败点击继续加载！"), for: UIControlState())
        button.isHidden=true
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
            shareButton.isHidden=false
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
            titleOfURL.text=loadLanguage("净水器滤芯")
            var tmpUrl:String = goUrlOfOut ?? "http://www.oznerwater.com/lktnew/wap/mall/goodsDetail.aspx?gid=9"
            let whitespace = CharacterSet.whitespacesAndNewlines
            tmpUrl = tmpUrl.trimmingCharacters(in: whitespace)
            tmpURL = GoUrlBefore(tmpUrl)
            
            
            break
        case weiXinUrl.WaterLvXinUrl2://迷你净水器滤芯购买链接
            titleOfURL.text=loadLanguage("净水器滤芯")
            var tmpUrl:String = goUrlOfOut ?? "http://www.oznerwater.com/lktnew/wap/mall/goodsDetail.aspx?gid=68"
            let whitespace = CharacterSet.whitespacesAndNewlines
            tmpUrl = tmpUrl.trimmingCharacters(in: whitespace)
            tmpURL = GoUrlBefore(tmpUrl)
           
            break
        case weiXinUrl.WaterLvXinUrl3://台式净水器滤芯购买链接
            titleOfURL.text=loadLanguage("净水器滤芯")
            var tmpUrl:String = goUrlOfOut ?? "http://www.oznerwater.com/lktnew/wap/mall/goodsDetail.aspx?gid=69"
            let whitespace = CharacterSet.whitespacesAndNewlines
            tmpUrl = tmpUrl.trimmingCharacters(in: whitespace)
            tmpURL = GoUrlBefore(tmpUrl)
            break
        case weiXinUrl.WaterReplenishOperation://补水仪使用说明
            titleOfURL.text=loadLanguage("补水仪使用说明")
            tmpURL = "http://app.ozner.net:888//Public/Index"
            break
            
        default:
            break
        }
        webView.delegate=self
        webView.scalesPageToFit = true
        webView.loadRequest(URLRequest(url: URL(string: tmpURL)!))
        
        // Do any additional setup after loading the view.
    }

    
    //继续加载
    func loadAgain(_ button:UIButton)
    {
        webView.loadRequest(URLRequest(url: URL(string: tmpURL)!))
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        button.isHidden=true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.perform(#selector(hideMbProgressHUD), with: nil, afterDelay: 3);
    }
    func hideMbProgressHUD()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
        button.isHidden=true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        MBProgressHUD.hide(for: self.view, animated: true)
        button.isHidden=false
    }
    func GoUrlBefore(_ url:String)->String
    {
        
        return "http://www.oznerwater.com/lktnew/wap/app/Oauth2.aspx?mobile="+mobile+"&UserTalkCode="+UserTalkCode+"&Language=zh&Area=zh&goUrl="+url
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
