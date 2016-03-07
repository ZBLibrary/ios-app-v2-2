//
//  AddDeviceCell.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/2.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class AddDeviceCell: UITableViewCell {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var smallIconImgVIew: UIImageView!
    @IBOutlet weak var rightRowImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layOutAddDeviceCell(imgViewName:String, content:String, iconImgName:String,funcContent:String)
    {
        let width = UIScreen.mainScreen().bounds.width
        self.iconImgView.image = UIImage(named: imgViewName)
        self.iconImgView.frame = CGRectMake(28, 23, 75, 75)
        
        let dic = [NSFontAttributeName:UIFont.systemFontOfSize(19*(width/375.0))];
        let size = content.boundingRectWithSize(CGSizeMake(width, 19*(width/375.0)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: dic, context:nil).size;
        self.titleLabel.text = content;
        self.titleLabel.font = UIFont.systemFontOfSize(19*(width/375.0))
        self.titleLabel.frame = CGRectMake(self.iconImgView.frame.size.width+self.iconImgView.frame.origin.x+21, (120-size.height)/2, size.width, size.height)
        
        let contentDic = [NSFontAttributeName:UIFont.systemFontOfSize(14)];
        let contentSize = funcContent.boundingRectWithSize(CGSizeMake(width, 14), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: contentDic, context: nil).size;
        self.contentLabel.frame = CGRectMake(width-15-11-31*(width/375.0)-contentSize.width, (120-contentSize.height)/2, contentSize.width, contentSize.height)
        self.contentLabel.text = funcContent
        
        let iconImg = UIImage(named: iconImgName)
        self.smallIconImgVIew.frame = CGRectMake(self.contentLabel.frame.origin.x-5*(width/375.0)-((iconImg?.size.width)!/2), (120-((iconImg?.size.height)!)/2)/2, ((iconImg?.size.width)!/2), ((iconImg?.size.height)!/2))
        self.smallIconImgVIew.image = iconImg
    }
    
}
