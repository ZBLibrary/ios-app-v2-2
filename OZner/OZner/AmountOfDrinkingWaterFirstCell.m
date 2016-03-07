//
//  AmountOfDrinkingWaterFirstCell.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/6.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "AmountOfDrinkingWaterFirstCell.h"

@implementation AmountOfDrinkingWaterFirstCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layOUtWaterFirstCell:(int)type
{
    if(type == 0)
    {
        self.firstLabel.text = @"今日饮水完成";
        NSString* title = [NSString stringWithFormat:@"%d",self.volume];
        if(self.volume == 0)
        {
            title = @"暂无";
        }
        CGSize size = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 45*(SCREEN_HEIGHT)/667.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:45*(SCREEN_HEIGHT)/667.0]} context:nil].size;
        
        NSString* secondTitle = @"%";
        CGSize secondSize = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 24*(SCREEN_HEIGHT)/667.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24*(SCREEN_HEIGHT)/667.0]} context:nil].size;
        
        NSString* rankTitle = [NSString stringWithFormat:@"%d",self.rankValue];
        if(self.rankValue == 0)
        {
            rankTitle = @"暂无";
        }
        CGSize rankSize = [rankTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 45*(SCREEN_HEIGHT/667.0)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:45*(SCREEN_HEIGHT/667.0)]} context:nil].size;

        
        UIImage* img = [UIImage imageNamed:@"device_cup.png"];
        
        CGFloat middleDistance = (SCREEN_WIDTH-size.width-secondSize.width-rankSize.width-5*(SCREEN_WIDTH/375.0)-img.size.width-80*(SCREEN_WIDTH/375.0)-15*(SCREEN_WIDTH/375.0)*2)/2.0;
        
        self.secodLabel.text = title;
        self.secodLabel.font = [UIFont systemFontOfSize:45*(SCREEN_HEIGHT/667.0)];
        self.secodLabel.frame = CGRectMake(15*(SCREEN_WIDTH/375.0), self.firstLabel.frame.size.height+self.firstLabel.frame.origin.y+10, size.width, 45*(SCREEN_HEIGHT)/667.0);
        
        self.thirdLabel.text = secondTitle;
        self.thirdLabel.hidden = false;
        self.thirdLabel.font = [UIFont systemFontOfSize:24*(SCREEN_HEIGHT/667.0)];
        self.thirdLabel.frame = CGRectMake(self.secodLabel.frame.size.width+self.secodLabel.frame.origin.x, self.secodLabel.frame.size.height+self.secodLabel.frame.origin.y-24*(SCREEN_HEIGHT/667.0)-4, secondSize.width, 24*(SCREEN_HEIGHT)/667.0);
        
        
        self.rankLabel.frame = CGRectMake(self.thirdLabel.frame.size.width+self.thirdLabel.frame.origin.x+middleDistance, self.secodLabel.frame.origin.y, rankSize.width, 45*(SCREEN_HEIGHT/667.0));
        self.rankLabel.font = [UIFont systemFontOfSize:45*(SCREEN_HEIGHT/667.0)];
        self.rankLabel.text = rankTitle;
        
        self.cupImgView.frame = CGRectMake(self.rankLabel.frame.origin.x+self.rankLabel.frame.size.width+5*(SCREEN_WIDTH/375.0), self.rankLabel.frame.size.height+self.rankLabel.frame.origin.y-img.size.height-6, img.size.width, img.size.height);
        self.cupImgView.image = img;
        self.wishLabel.text = @"健康的身体，需要配合良好的饮水习惯，加油哦！";

    }
    else if(type == 1)
    {
        self.firstLabel.text = @"水温";
        NSString* title = @"";
        if(self.maxTemp == 0)
        {
            title = @"暂无";
            self.wishLabel.text = @"暂无";
        }
        else
        {
            if(self.maxTemp <= TEMPERATURE_LOW)
            {
                title = @"偏凉";
                self.wishLabel.text = @"水温太凉啦！让胃暖起来，心才会暖！";
            }
            else if (self.maxTemp >= TEMPERATURE_HIGH)
            {
                title =  @"偏烫";
                self.wishLabel.text = @"水温偏烫再凉一凉吧，心急可是会受伤的哦！";
            }
            else
            {
                title = @"适中";
                self.wishLabel.text = @"不凉不烫，要的就是刚刚好！";
            }
        }
        
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 45*(SCREEN_HEIGHT)/667.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:45*(SCREEN_HEIGHT)/667.0]} context:nil].size;
        self.secodLabel.frame = CGRectMake(15*(SCREEN_WIDTH/375.0), self.firstLabel.frame.size.height+self.firstLabel.frame.origin.y+10, size.width, 45*(SCREEN_HEIGHT/667.0));
        self.secodLabel.font = [UIFont systemFontOfSize:45*(SCREEN_HEIGHT/667.0)];
        self.secodLabel.text = title;
        self.thirdLabel.hidden = YES;
        
        self.rankLabel.hidden = YES;
        
        self.cupImgView.hidden = YES;
    }
    else
    {
        self.firstLabel.text = @"水质纯净值";
        NSString* title = @"TDS";
        NSString* secondTitle = [NSString stringWithFormat:@"%d",self.tdsValue];
        if(self.tdsValue == 0 || self.tdsValue == 65535)
        {
            secondTitle = @"暂无";
        }
        CGSize size = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 24*(SCREEN_HEIGHT)/667.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24*(SCREEN_HEIGHT)/667.0]} context:nil].size;
        
        CGSize secondSize = [secondTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 45*(SCREEN_HEIGHT)/667.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:45*(SCREEN_HEIGHT)/667.0]} context:nil].size;
        
        NSString* rankTitle = [NSString stringWithFormat:@"%d",self.rankValue];
        if(self.rankValue == 0)
        {
            rankTitle = @"暂无";
        }
        CGSize rankSize = [rankTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 45*(SCREEN_HEIGHT/667.0)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:45*(SCREEN_HEIGHT/667.0)]} context:nil].size;
        
        UIImage* img = [UIImage imageNamed:@"device_cup.png"];
        
        CGFloat middleDistance = (SCREEN_WIDTH-size.width-secondSize.width-rankSize.width-5*(SCREEN_WIDTH/375.0)-img.size.width-80*(SCREEN_WIDTH/375.0)-15*(SCREEN_WIDTH/375.0)*2)/2.0;
        
        self.secodLabel.text = title;
        self.secodLabel.font = [UIFont systemFontOfSize:24*(SCREEN_HEIGHT/667.0)];
        self.secodLabel.frame = CGRectMake(15*(SCREEN_WIDTH/375.0), self.firstLabel.frame.size.height+self.firstLabel.frame.origin.y+10+(45-24-2)*(SCREEN_HEIGHT/667.0), size.width, 24*(SCREEN_HEIGHT)/667.0);
        
        self.thirdLabel.text = secondTitle;
        self.thirdLabel.hidden = false;
        self.thirdLabel.font = [UIFont fontWithName:@".SFUIDisplay-Thin" size:45*(SCREEN_HEIGHT/667.0)];//[UIFont systemFontOfSize:45*(SCREEN_HEIGHT/667.0)];
        self.thirdLabel.frame = CGRectMake(self.secodLabel.frame.size.width+self.secodLabel.frame.origin.x, self.firstLabel.frame.size.height+self.firstLabel.frame.origin.y+10, secondSize.width, 45*(SCREEN_HEIGHT)/667.0);
        
        
        self.rankLabel.frame = CGRectMake(self.thirdLabel.frame.size.width+self.thirdLabel.frame.origin.x+middleDistance, self.thirdLabel.frame.origin.y, rankSize.width, 45*(SCREEN_HEIGHT/667.0));
        self.rankLabel.font = [UIFont fontWithName:@".SFUIDisplay-Thin" size:45*(SCREEN_HEIGHT/667.0)];//[UIFont systemFontOfSize:45*(SCREEN_HEIGHT/667.0)];
        self.rankLabel.text = rankTitle;
        
        self.cupImgView.frame = CGRectMake(self.rankLabel.frame.origin.x+self.rankLabel.frame.size.width+5*(SCREEN_WIDTH/375.0), self.rankLabel.frame.size.height+self.rankLabel.frame.origin.y-img.size.height-6, img.size.width, img.size.height);
        self.cupImgView.image = img;
        self.wishLabel.text = @"健康的身体，需要配合良好的饮水习惯，加油哦！";
        
    }
    
    self.firstLabel.frame = CGRectMake(15*(SCREEN_WIDTH/375.0), self.firstLabel.frame.origin.y, self.firstLabel.frame.size.width, self.firstLabel.frame.size.height);
    if(type == 1)
    {
        self.titleLabel.frame = CGRectMake(SCREEN_WIDTH-15*(SCREEN_WIDTH/375.0)-self.titleLabel.frame.size.width, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.hidden = YES;
    }
    else
    {
        self.titleLabel.frame = CGRectMake(self.rankLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        self.titleLabel.hidden = FALSE;
    }
    
    self.iconImgView.frame = CGRectMake(15*(SCREEN_WIDTH/375.0), self.wishLabel.frame.origin.y-0.5, 16, 16);
    self.wishLabel.frame = CGRectMake(self.iconImgView.frame.size.width+self.iconImgView.frame.origin.x+5*(SCREEN_WIDTH/375.0), self.wishLabel.frame.origin.y, SCREEN_WIDTH-15*(SCREEN_WIDTH/375.0)-16-5*(SCREEN_WIDTH/375.0), 15);
    
    self.zixunBgView.frame = CGRectMake(SCREEN_WIDTH-15*(SCREEN_WIDTH/375.0)-80*(SCREEN_WIDTH/375.0), (151*(SCREEN_HEIGHT/667.0)-40*(SCREEN_HEIGHT/667.0))/2, 80*(SCREEN_WIDTH/375.0), 40*(SCREEN_HEIGHT/667.0));
    self.zixunBgView.layer.masksToBounds = YES;
    self.zixunBgView.layer.cornerRadius = 20;
    self.zixunBgView.layer.borderColor = self.rankLabel.textColor.CGColor;
    self.zixunBgView.backgroundColor = [UIColor clearColor];
    self.zixunBgView.layer.borderWidth = 1;
    
    UIImage* image = [UIImage imageNamed:@"device_zixun.png"];
    self.zixunImgView.frame = CGRectMake(10*(SCREEN_WIDTH/375.0), (self.zixunBgView.frame.size.height-image.size.height)/2, image.size.width, image.size.height);
    
    NSString* content = @"咨询";
    CGSize size = [content boundingRectWithSize:CGSizeMake(100, 17*(SCREEN_HEIGHT/667.0)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0*(SCREEN_HEIGHT/667.0)]} context:nil].size;
    self.zixunLabel.frame = CGRectMake(self.zixunImgView.frame.origin.x+self.zixunImgView.frame.size.width+6*(SCREEN_WIDTH/375.0), (self.zixunBgView.frame.size.height-17*(SCREEN_HEIGHT/667.0))/2, size.width, size.height);
    self.zixunLabel.textColor = self.rankLabel.textColor;
    self.zixunLabel.font = [UIFont systemFontOfSize:17*(SCREEN_HEIGHT/667.0)];
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.zixunBgView.frame.size.width, self.zixunBgView.frame.size.height)];
    [button addTarget:self action:@selector(ziXunAction) forControlEvents:UIControlEventTouchUpInside];
    [self.zixunBgView addSubview:button];
}

- (void)ziXunAction
{
    if([self.delegate respondsToSelector:@selector(amountOfDrinkingWaterZiXunAction)])
    {
        [self.delegate amountOfDrinkingWaterZiXunAction];
    }
}

@end
