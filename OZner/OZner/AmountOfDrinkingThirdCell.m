//
//  AmountOfDrinkingThirdCell.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/7.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "AmountOfDrinkingThirdCell.h"

@implementation AmountOfDrinkingThirdCell

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
        UIView* view = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        view.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
        [self addSubview:view];
        
        view = [[UIView alloc ]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
        [self addSubview:view];
        
        view = [[UIView alloc ]initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 1)];
        view.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
        [self addSubview:view];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 12+21, SCREEN_WIDTH, 17)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        label.text = @"改善您的饮水健康";
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
        
        view = [[UIView alloc]initWithFrame:CGRectMake(30*(SCREEN_WIDTH/375.0), label.frame.size.height+label.frame.origin.y+15, 142.5*(SCREEN_WIDTH/375.0), 40)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 20;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorWithRed:59.0/255 green:113.0/255 blue:223.0/255 alpha:1.0].CGColor;
        [self addSubview:view];
        
        UIImage* image = [UIImage imageNamed:@"device_konw.png"];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*(SCREEN_WIDTH/375.0), (view.frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
        imgView.image = image;
        [view addSubview:imgView];
        
        NSString* content = @"健康水知道";
        CGSize size = [content boundingRectWithSize:CGSizeMake(300, 17*(SCREEN_HEIGHT/667.0)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*(SCREEN_HEIGHT/667.0)]} context:nil].size;
        label = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.x+10*(SCREEN_WIDTH/375.0), (view.frame.size.height-size.height)/2, size.width+1, size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17*(SCREEN_HEIGHT/667.0)];
        label.text = content;
        label.textColor = [UIColor colorWithRed:59.0/255 green:113.0/255 blue:223.0/255 alpha:1.0];
        [view addSubview:label];
        
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        [button addTarget:self action:@selector(waterAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    
        UIView* leftView = [[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width+view.frame.origin.x+30*(SCREEN_WIDTH/375.0), view.frame.origin.y, 142*(SCREEN_WIDTH/375.0), 40)];
        leftView.layer.masksToBounds = YES;
        leftView.layer.cornerRadius = 20;
        leftView.layer.borderWidth = 1;
        leftView.layer.borderColor = [UIColor colorWithRed:59.0/255 green:113.0/255 blue:223.0/255 alpha:1.0].CGColor;
        [self addSubview:leftView];
        
        image = [UIImage imageNamed:@"device_puucashe.png"];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*(SCREEN_WIDTH/375.0), (view.frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
        imgView.image = image;
        [leftView addSubview:imgView];
        
        content = @"购买净水器";
        size = [content boundingRectWithSize:CGSizeMake(300, 17*(SCREEN_HEIGHT/667.0)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*(SCREEN_HEIGHT/667.0)]} context:nil].size;
        label = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.x+10*(SCREEN_WIDTH/375.0), (view.frame.size.height-size.height)/2, size.width, size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17*(SCREEN_HEIGHT/667.0)];
        label.text = content;
        label.textColor = [UIColor colorWithRed:59.0/255 green:113.0/255 blue:223.0/255 alpha:1.0];
        [leftView addSubview:label];
        
        button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, leftView.frame.size.width, leftView.frame.size.height)];
        [button addTarget:self action:@selector(purchaseAction) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:button];
    }
    
    return self;
}

- (void)purchaseAction
{
    if([self.delegate respondsToSelector:@selector(purchaseAction)])
    {
        [self.delegate purchaseAction];
    }
}

- (void)waterAction
{
    if([self.delegate respondsToSelector:@selector(jianKangShuiAction)])
    {
        [self.delegate jianKangShuiAction];
    }
    
}

@end
