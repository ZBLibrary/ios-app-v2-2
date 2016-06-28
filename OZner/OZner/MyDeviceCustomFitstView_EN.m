//
//  MyDeviceCustomFitstView.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/13.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "MyDeviceCustomFitstView_EN.h"

@implementation MyDeviceCustomFitstView_EN

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 21*(SCREEN_HEIGHT/667.0), SCREEN_WIDTH-15, 14*(SCREEN_HEIGHT)/667.0)];
        label.text = loadLanguage(@"本月水质纯净指数分布");
        label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
        label.font = [UIFont fontWithName:@".SFUIDisplay-Light" size:17];//]systemFontOfSize:14.0*(SCREEN_HEIGHT/667.0)];
        [self addSubview:label];
        //NSLog(@"%f",frame.origin.y);
        MPGraphView* graph=[[MPGraphView alloc] initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),45*(SCREEN_HEIGHT/667.0), SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:2];
        NSMutableArray* muArr = [[NSMutableArray alloc]init];
        //graph.mCurrentType=2;
        graph.values=muArr;
        graph.fillColors=@[[UIColor colorWithRed:242.0/255 green:98.0/255 blue:100.0/255 alpha:0.7],[UIColor colorWithRed:125.0/255 green:68.0/255 blue:231.0/255 alpha:0.5],[UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:0.25]];
        graph.graphColor=[UIColor redColor];
        graph.curved=YES;
        graph.hidden = false;
        self.monthMpGraphView = graph;
        [self addSubview:self.monthMpGraphView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

//初始化原始数组
- (NSMutableArray*)originDataSource:(int)nCount
{
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    float totalWidth = SCREEN_WIDTH- 14*(SCREEN_WIDTH/375.0)*2 - 35-15;
    for(int i=0;i<nCount;i++)
    {
        float scale = ((CGFloat)i/(nCount-1));
        float length = totalWidth*scale;
        [muArr addObject:[NSNumber numberWithFloat:length]];
    }
    return muArr;
}

- (NSMutableArray*)originDataSourceZong:(int)nCount
{
    NSMutableArray* zongArr = [[NSMutableArray alloc]init];
    for(int i=0;i<nCount;i++)
    {
        [zongArr addObject:[NSNumber numberWithFloat:0]];
    }
    return zongArr;
}

//当月
- (void)dayGraphView:(NSArray*)record
{
 
    //取这个月的
    NSDate* monthFirstDay = [UToolBox dateStartOfMonth:[NSDate date]];
    NSString* firstDayStr = [UToolBox stringFromDate:monthFirstDay format:@"yyyy-MM-dd HH:mm:ss"];
    firstDayStr = [[firstDayStr componentsSeparatedByString:@" "] objectAtIndex:0];
    int month = [[[firstDayStr componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
    
    int firstDay = 1;
    NSMutableArray* originArr = [self originDataSource:[UToolBox monthCount:month]];
    NSMutableArray* originArr1 = [self originDataSourceZong:[UToolBox monthCount:month]];
    
    MPGraphView* graph=[[MPGraphView alloc] initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),45*(SCREEN_HEIGHT/667.0), SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:2];
    
    if (self.monthMpGraphView != nil) {
        [self.monthMpGraphView removeFromSuperview];
    }
    
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    
    for(int i=0;i<record.count;i++)
    {
        TapRecord* tmprecord = [record objectAtIndex:i];
        NSLog(@"%d",tmprecord.TDS);
        NSString* nowStr = [UToolBox stringFromDate:tmprecord.Time format:@"yyyy-MM-dd HH:mm:ss"];
        nowStr = [[nowStr componentsSeparatedByString:@" "] objectAtIndex:0];
        nowStr = [[nowStr componentsSeparatedByString:@"-"] objectAtIndex:2];
        int nowDay = [nowStr intValue];
        

        float totalWidth = SCREEN_WIDTH- 14*(SCREEN_WIDTH/375.0)*2 - 35-15;
        float scale = ((nowDay-firstDay)/(float)([UToolBox monthCount:month]-1));
        float length = totalWidth*scale;
        for(int i =0;i<originArr.count;i++)
        {
            if(i== nowDay-firstDay)
            {
                [originArr replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:length]];
                double tmpInt=0.0;
                if (tmprecord.TDS>=0&&tmprecord.TDS<=tds_good) {
                    tmpInt=tmprecord.TDS/tds_good/3.0;
                } else if(tmprecord.TDS>tds_good&&tmprecord.TDS<=tds_bad){
                    tmpInt=(tmprecord.TDS-tds_good)/(tds_bad-tds_good)/3.0+1/3.0;
                }
                else if (tmprecord.TDS>tds_bad&&tmprecord.TDS<=250)
                {
                    tmpInt=(tmprecord.TDS-tds_bad)/50.0/3.0+2/3.0;
                }
                else if (tmprecord.TDS>250)
                {
                    tmpInt=1.0;
                }
                else
                {
                    tmpInt=0.0;
                }
                if ([originArr1 objectAtIndex:i] != nil) {
                    if (tmpInt*(150-23-44-2)>[[originArr1 objectAtIndex:i] floatValue]) {
                        [originArr1 replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tmpInt*(150-23-44-2)]];
                    }
                }
                else
                {
                    [originArr1 replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tmpInt*(150-23-44-2)]];
                }
                
            }
        }
        [muArr addObject:[NSNumber numberWithFloat:length]];
       
    }
    graph.values=originArr;//横坐标
    graph.zongArr = originArr1;//总坐标
    graph.fillColors=@[[UIColor colorWithRed:242.0/255 green:98.0/255 blue:100.0/255 alpha:0.7],[UIColor colorWithRed:125.0/255 green:68.0/255 blue:231.0/255 alpha:0.5],[UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:0.25]];
    if(muArr.count > 0)
    {
        [graph stroke:graph.frame color:@"" fillColor:nil orignY:0 count:0];
    }
    graph.graphColor=[UIColor redColor];
    graph.curved=YES;
    graph.hidden = false;
    self.monthMpGraphView = graph;
    if(record.count>0)
    {
        float state1 = 0;
        float state2 = 0;
        float state3 = 0;
        for (int i=0; i<originArr1.count; i++) {
            if ([originArr1 objectAtIndex:i]!=nil) {
                double tmpvalue=[[originArr1 objectAtIndex:i] floatValue]/(150-23-44-2);
                if (0<tmpvalue&&tmpvalue<=1/3.0) {
                    state1=+1;
                } else if(1/3.0<tmpvalue&&tmpvalue<=2/3.0){
                    state2=+1;
                }
                else if(0<tmpvalue)
                {
                    state3=+1;
                }
            }
        }
        float totolCount=state1+state2+state3;
        if (totolCount>0) {
            graph.firstLabel.text = [NSString stringWithFormat:@"健康(%d%%)",(int)(100*state1/totolCount)];
            graph.secondLabel.text = [NSString stringWithFormat:@"一般(%d%%)",(int)(100*state2/totolCount)];
            graph.thirdLabel.text = [NSString stringWithFormat:@"较差(%d%%)",100-(int)(100*state1/totolCount)-(int)(100*state2/totolCount)];
            
            
            
        } else {
            graph.firstLabel.text = [NSString stringWithFormat:@"健康(%d%%)",0];
            graph.secondLabel.text = [NSString stringWithFormat:@"一般(%d%%)",0];
            graph.thirdLabel.text = [NSString stringWithFormat:@"较差(%d%%)",0];
        }
       
    }
    else
    {
        graph.firstLabel.text = [NSString stringWithFormat:@"健康(%d%%)",0];
        graph.secondLabel.text = [NSString stringWithFormat:@"一般(%d%%)",0];
        graph.secondLabel.text = [NSString stringWithFormat:@"较差(%d%%)",0];
    }
    [self addSubview:self.monthMpGraphView];
}

- (void)layOUtTDSCell:(NSArray*)record
{
    [self dayGraphView:record];
}


@end
