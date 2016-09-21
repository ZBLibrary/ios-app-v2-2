//
//  AddDeviceCell.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/2.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class AddDeviceCell_EN: UITableViewCell {

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layOutAddDeviceCell(_ imgViewName:String, content:String, iconImgName:String,funcContent:String)
    {
        let width = UIScreen.main.bounds.width
        self.iconImgView.image = UIImage(named: imgViewName)
        self.iconImgView.frame = CGRect(x: 28, y: 23, width: 75, height: 75)
        
        let dic = [NSFontAttributeName:UIFont.systemFont(ofSize: 19*(width/375.0))];
        let size = content.boundingRect(with: CGSize(width: width, height: 19*(width/375.0)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic, context:nil).size;
        self.titleLabel.text = content;
        self.titleLabel.font = UIFont.systemFont(ofSize: 19*(width/375.0))
        self.titleLabel.frame = CGRect(x: self.iconImgView.frame.size.width+self.iconImgView.frame.origin.x+21, y: (120-size.height)/2, width: size.width, height: size.height)
        
        let contentDic = [NSFontAttributeName:UIFont.systemFont(ofSize: 14)];
        let contentSize = funcContent.boundingRect(with: CGSize(width: width, height: 14), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: contentDic, context: nil).size;
        self.contentLabel.frame = CGRect(x: width-15-11-31*(width/375.0)-contentSize.width, y: (120-contentSize.height)/2, width: contentSize.width, height: contentSize.height)
        self.contentLabel.text = funcContent
        
        let iconImg = UIImage(named: iconImgName)
        self.smallIconImgVIew.frame = CGRect(x: self.contentLabel.frame.origin.x-5*(width/375.0)-((iconImg?.size.width)!/2), y: (120-((iconImg?.size.height)!)/2)/2, width: ((iconImg?.size.width)!/2), height: ((iconImg?.size.height)!/2))
        self.smallIconImgVIew.image = iconImg
    }
    
}
