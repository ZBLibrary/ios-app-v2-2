//
//  TanTouFivethCell.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/14.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "TanTouFivethCell.h"
#import "TantouFivthCellView.h"

@implementation TanTouFivethCell

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
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, SCREEN_WIDTH-30, 14)];
        label.text = @"浩泽安心服务";
        label.textColor = [UIColor colorWithRed:58.0/255 green:58.0/255 blue:58.0/255 alpha:1.0];
        label.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:label];
        
        NSArray* imgNameArr = [[NSArray alloc]initWithObjects:@"icon_lvxin_service_1.png",@"icon_lvxin_service_2.png",@"icon_lvxin_service_3.png",@"icon_lvxin_service_4.png",@"icon_lvxin_service_5.png",@"icon_lvxin_service_6.png",@"icon_lvxin_service_7.png",@"icon_lvxin_service_8.png", nil];
        NSArray* titleArr1 = [[NSArray alloc]initWithObjects:@"365天滤芯寿命",@"每年上门更换",@"10项职能",@"上门整机维修",@"安全断水",@"24小时客服咨询",@"定期水质监测",@"产品职能软件升级", nil];
        NSArray* titleArr2 = [[NSArray alloc]initWithObjects:@"监测与预警",@"标准滤芯材料一次",@"安全净水服务",@"零配件更换服务",@"更换滤芯提醒",@"",@"",@"", nil];
        
        int width = SCREEN_WIDTH/2;
        int height =  152;
        int x= 0;
        int y = 60;
        for(int i=0;i<imgNameArr.count;i++)
        {
            TantouFivthCellView* cellView = [[TantouFivthCellView alloc]initWithFrame:CGRectMake(x, y, width, height)];
            cellView.iconImgView.image = [UIImage imageNamed:[imgNameArr objectAtIndex:i]];
            cellView.firstLabel.text = [titleArr1 objectAtIndex:i];
            cellView.secodLabel.text = [titleArr2 objectAtIndex:i];
            cellView.backgroundColor = [UIColor clearColor];
            [self addSubview:cellView];
            
            x= width*((i+1)%2);
            if(i%2 == 1)
            {
                y += height;
            }
        }
    }
    
    return self;
}

@end
