//
//  TanTouErWeimaCell.m
//  OZner
//
//  Created by sunlinlin on 16/1/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import "TanTouErWeimaCell.h"

@implementation TanTouErWeimaCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        NSString* content = @"扫描二维码";
        CGSize size = [content boundingRectWithSize:CGSizeMake(300, 17*(SCREEN_HEIGHT/667.0)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*(SCREEN_HEIGHT/667.0)]} context:nil].size;
        
        UIImage* image = [UIImage imageNamed:@"device_puucashe.png"];
        
        UIView* leftView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-40*(SCREEN_WIDTH/375.0)-image.size.width-size.width)/2, 20, 40*(SCREEN_WIDTH/375.0)+image.size.width+size.width, 40)];
        leftView.layer.masksToBounds = YES;
        leftView.layer.cornerRadius = 20;
        leftView.layer.borderWidth = 1;
        leftView.layer.borderColor = [UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:1.0].CGColor;
        [self addSubview:leftView];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*(SCREEN_WIDTH/375.0), (leftView.frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
        imgView.image = image;
        [leftView addSubview:imgView];
        
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.x+10*(SCREEN_WIDTH/375.0), (leftView.frame.size.height-size.height)/2, size.width, size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17*(SCREEN_HEIGHT/667.0)];
        label.text = content;
        label.textColor = [UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:1.0];
        [leftView addSubview:label];
        
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, leftView.frame.size.width, leftView.frame.size.height)];
        [button addTarget:self action:@selector(erweiMaAction) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:button];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, leftView.frame.size.height+leftView.frame.origin.y+20, SCREEN_WIDTH, 14)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14*(SCREEN_HEIGHT/667.0)];
        label.text = @"扫描包装上的二维码，激活APP并启动滤芯复位。";
        label.textColor = [UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:1.0];
        [self addSubview:label];
    }
    
    return self;
}

- (void)erweiMaAction
{
    if([self.delegate respondsToSelector:@selector(scanDiscode)])
    {
        [self.delegate scanDiscode];
    }
}

@end
