//
//  WaterRefreshIntrounVCViewController.swift
//  OZner
//
//  Created by zhuguangyang on 16/10/21.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class WaterRefreshIntrounVC: UIViewController {
    
    var deviceType:String!
    var str:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        
        //        let filePath = NSBundle.mainBundle().pathForResource("3", ofType: "html")
        //        let url = NSURL(fileURLWithPath: filePath!)
        //        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fanhui"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WaterRefreshIntrounVC.backAction))
        let webView = UIWebView(frame: self.view.bounds)
        
        switch deviceType {
            //补水仪
        case "WaterRefresh":
             str = htmlforJPGImage(UIImage(named: "water.jpg" )!)
            //空净
        case "waterair":
            str = htmlforJPGImage(UIImage(named: "waterair.jpg" )!)
        case "lishi":
            str = htmlforJPGImage(UIImage(named: "lishi.jpg" )!)
        case "taishi":
            str = htmlforJPGImage(UIImage(named: "taishi.jpg" )!)
            //水潭头
        case "tap" :
            str = htmlforJPGImage(UIImage(named: "tap.jpg" )!)
            
        default:
            break
        }
        
        
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .PhoneNumber
        view.addSubview(webView)
        webView.loadHTMLString(str, baseURL: nil)
        //        webView.loadRequest(NSURLRequest(URL: url))
        
        
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func htmlforJPGImage(image: UIImage) -> String {
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        let imageSource = NSString().stringByAppendingFormat("data:image/jpg;base64,%@", (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))!)
        
        return NSString().stringByAppendingFormat("<div align=center ><img src='%@' /></div>", imageSource) as String
        
        
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
