//
//  MyDeviceCsutomSecondView.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/25.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "MyDeviceCsutomSecondView.h"

@implementation MyDeviceCsutomSecondView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        NSMutableArray* muArr = [[NSMutableArray alloc]initWithObjects:@"加热",@"制冷",@"电源", nil];
        self.titleArr = muArr;
        
        muArr = [[NSMutableArray alloc]initWithObjects:@"icon_jiare_normal.png",@"icon_zhileng_normal.png",@"icon_power_normal.png", nil];
        self.normalImgArr = muArr;
        
        muArr = [[NSMutableArray alloc]initWithObjects:@"icon_jiare.png",@"icon_zhileng.png",@"icon_power.png", nil];
        self.selectImgArr = muArr;
        
        [self createJTlistView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

//创建JTListView
- (void)createJTlistView
{
    mListView = [[JTListView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,160*(SCREEN_HEIGHT/667.0))];
    mListView.delegate = self;
    mListView.dataSource = self;
    mListView.backgroundColor = [UIColor clearColor];
    mListView.pagingEnabled = YES;
    mListView.clipsToBounds = YES;
    mListView.scrollEnabled = YES;
    mListView.showsHorizontalScrollIndicator = NO;
    mListView.showsVerticalScrollIndicator = NO;
    [self addSubview:mListView];
    [mListView reloadData];
}

#pragma mark-MyDeviceCustomSecondCellViewDelegate
- (void)onClickbuttonAction:(UIButton *)button
{
    int tag = (int)button.tag-1000;
    for(int i=0;i<self.titleArr.count;i++)
    {
        MyDeviceCustomSecondCellView* cellView = (MyDeviceCustomSecondCellView*)[mListView viewForItemAtIndex:i];
        if(i == tag)
        {
            cellView.titleLabe.textColor = [UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:1.0];
            [cellView.actionButton setBackgroundImage:[UIImage imageNamed:[self.selectImgArr objectAtIndex:i]] forState:UIControlStateNormal];
        }
        else
        {
            cellView.titleLabe.textColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0];
            [cellView.actionButton setBackgroundImage:[UIImage imageNamed:[self.normalImgArr objectAtIndex:i]] forState:UIControlStateNormal];
        }
    }
    
    switch (tag)
    {
        case 0:
        {
            if (self.waterDevice)
            {
                //[self.deviceInfo startSend];
                
                [self.waterDevice.status setHot:!self.waterDevice.status.hot Callback:^(NSError* error){
                   // [self printSendStatus:error];
                }];
            }
            break;
        }
        case 1:
        {
            if (self.waterDevice)
            {
               // [self.deviceInfo startSend];
                
                [self.waterDevice.status setCool:!self.waterDevice.status.cool Callback:^(NSError* error){
                    //[self printSendStatus:error];
                }];
            }
            break;
        }
        case 2:
        {
           // WaterPurifier* device=(WaterPurifier*)self.device;
            if (self.waterDevice)
            {
                //[self.deviceInfo startSend];
                
                [self.waterDevice.status setPower:!self.waterDevice.status.power Callback:^(NSError* error){
                    //[self printSendStatus:error];
                }];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - JTListViewDataSource
- (NSUInteger)numberOfItemsInListView:(JTListView *)listView
{
    return self.titleArr.count;
}

- (UIView *)listView:(JTListView *)listView viewForItemAtIndex:(NSUInteger)index
{
    MyDeviceCustomSecondCellView* cellView = (MyDeviceCustomSecondCellView*)[listView dequeueReusableView];
    if(cellView == nil)
    {
        cellView = [[MyDeviceCustomSecondCellView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 160*(SCREEN_HEIGHT/667.0))];
    }
    
    cellView.actionButton.tag = 1000+index;
    cellView.delegate = self;
    
    [cellView layOutCellView:[self.normalImgArr objectAtIndex:index] title:[self.titleArr objectAtIndex:index] iconNameSelect:[self.selectImgArr objectAtIndex:index]];
    
    return cellView;
}

- (void)listViewCurrentIndex:(int)nIndex
{
    
}

#pragma mark - JTListViewDelegate
- (CGFloat)listView:(JTListView *)listView widthForItemAtIndex:(NSUInteger)index
{
    return SCREEN_WIDTH/3;
}

- (CGFloat)listView:(JTListView *)listView heightForItemAtIndex:(NSUInteger)index
{
    return 160*(SCREEN_HEIGHT/667.0);
}



@end
