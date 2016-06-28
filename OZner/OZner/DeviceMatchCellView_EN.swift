//
//  DeviceMatchCellView.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/3.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class DeviceMatchCellView_EN: UIView {

    var iconImgView:UIImageView?
    var titleLabel:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let width = UIScreen.mainScreen().bounds.width
        iconImgView = UIImageView(frame: CGRectMake((frame.size.width-53*(width/375.0))/2, (frame.size.height-53*(width/375.0)-10-14)/2, 53*(width/375.0), 53*(width/375.0)))
        iconImgView?.backgroundColor = UIColor.clearColor()
        self.addSubview(iconImgView!)
        
        let label:UILabel = UILabel(frame: CGRectMake(0,(iconImgView?.frame.origin.y)!+(iconImgView?.frame.size.height)!+10,self.frame.size.width,14))
        label.textAlignment = NSTextAlignment.Center
        self.titleLabel = label;
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        self .addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
