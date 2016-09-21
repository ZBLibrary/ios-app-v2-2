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
        let width = UIScreen.main.bounds.width
        iconImgView = UIImageView(frame: CGRect(x: (frame.size.width-53*(width/375.0))/2, y: (frame.size.height-53*(width/375.0)-10-14)/2, width: 53*(width/375.0), height: 53*(width/375.0)))
        iconImgView?.backgroundColor = UIColor.clear
        self.addSubview(iconImgView!)
        
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: (iconImgView?.frame.origin.y)!+(iconImgView?.frame.size.height)!+10,width: width,height: 14))
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        //label.sizeToFit()
        self.addSubview(label)
        self.titleLabel = label;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
