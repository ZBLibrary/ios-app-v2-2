//
//  WaterineChartView.m
//  OZner
//
//  Created by 赵兵 on 16/2/19.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

//
//  lineChartViewzb.m
//  OZner
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import "WaterineChartView.h"
#import "CupRecord.h"

@implementation WaterineChartView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//type:0  周,1 月
- (void)drawLineView:(int)dateType dataArr:(NSArray*)dataArr {

    switch (dateType) {
        case 0:
            self.weekArr=dataArr;
            [self weekGraphView:0];//净化前折线图
            [self weekGraphView:1];//净化后折线图
            break;
        case 1:
            self.monthArr=dataArr;
            [self monthGraphView:0];
            [self monthGraphView:1];
            break;
            
        default:
            break;
    }
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
- (int)daysBetweenTwoDate:(NSDate*)firstDate  nowDate:(NSDate*)nowDate
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [df setTimeZone:timeZone];
 
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* firstStr=[df stringFromDate:firstDate];
    firstStr=[firstStr stringByAppendingString:@" 00:00:00"];
    NSString* nowStr=[df stringFromDate:nowDate];
    nowStr=[nowStr stringByAppendingString:@" 00:00:00"];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate* tmpfirstDate=[df dateFromString:firstStr];
    NSDate* tmpnowDate=[df dateFromString:nowStr];
    int days=([tmpnowDate timeIntervalSince1970]-[tmpfirstDate timeIntervalSince1970])/86400;
    return days;
}
//当周
//before 0,after 1
- (void)weekGraphView:(int)beforeOrAfter
{
    NSDate* weekFirstDay = [UToolBox dateStartOfWeek:[NSDate date]];
    NSMutableArray* originArr = [self originDataSource:7];
    NSMutableArray* originArr1 = [self originDataSourceZong:7];
    WaterMPGraphView* graph=[[WaterMPGraphView alloc] initWithFrame: CGRectMake(14*(SCREEN_WIDTH/375.0),0, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:0 IsBadTds:beforeOrAfter];
    
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
   
    for(int i=0;i<self.weekArr.count;i++)
    {
        CupRecord* record = [self.weekArr objectAtIndex:i];
        
        float totalWidth = SCREEN_WIDTH- 14*(SCREEN_WIDTH/375.0)*2 - 35-15;
        
        int betweenDays=[self daysBetweenTwoDate:weekFirstDay nowDate:record.start];
        //----------
        float scale = (betweenDays/6.0);
        float length = totalWidth*scale;
        for(int i =0;i<7;i++)
        {
            if(i == betweenDays)
            {
                [originArr replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:length]];
                double tmpInt=0.0;
                double tmpRCD= beforeOrAfter==0 ? record.TDS_Bad:record.TDS_Good;
                double statevalue1= 50;
                double statevalue2=200;
                double statevalue3=250;
                if (tmpRCD>=0&&tmpRCD<=statevalue1) {
                    tmpInt=tmpRCD/statevalue1/3.0;
                } else if(tmpRCD>statevalue1&&tmpRCD<=statevalue2){
                    tmpInt=(tmpRCD-statevalue1)/(statevalue2-statevalue1)/3.0+1/3.0;
                }
                else if (tmpRCD>statevalue2&&tmpRCD<=statevalue3)
                {
                    tmpInt=(tmpRCD-statevalue2)/(statevalue3-statevalue2)/3.0+2/3.0;
                }
                else if (tmpRCD>statevalue3)
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
    graph.values=originArr;
    graph.zongArr = originArr1;
    
    if(muArr.count > 0)
    {
        [graph stroke:graph.frame color:@"" fillColor:nil orignY:0 count:0];
    }
    graph.curved=YES;
    [self addSubview:graph];
}
//当月
- (void)monthGraphView:(int)beforeOrAfter
{
    //取这个月的
    NSDate* monthFirstDay = [UToolBox dateStartOfMonth:[NSDate date]];
    NSString* firstDayStr = [UToolBox stringFromDate:monthFirstDay format:@"yyyy-MM-dd HH:mm:ss"];
    firstDayStr = [[firstDayStr componentsSeparatedByString:@" "] objectAtIndex:0];
    int month = [[[firstDayStr componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
 
    int firstDay = 1;
    
    NSMutableArray* originArr = [self originDataSource:[UToolBox monthCount:month]];
    NSMutableArray* originArr1 = [self originDataSourceZong:[UToolBox monthCount:month]];
    WaterMPGraphView* graph=[[WaterMPGraphView alloc] initWithFrame: CGRectMake(14*(SCREEN_WIDTH/375.0),0, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:1 IsBadTds:beforeOrAfter];
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    //NSMutableArray* zongArr = [[NSMutableArray alloc]init];
    for(int i=0;i<self.monthArr.count;i++)
    {
        CupRecord* record = [self.monthArr objectAtIndex:i];
        NSString* nowStr = [UToolBox stringFromDate:record.start format:@"yyyy-MM-dd HH:mm:ss"];
        nowStr = [[nowStr componentsSeparatedByString:@" "] objectAtIndex:0];
        nowStr = [[nowStr componentsSeparatedByString:@"-"] objectAtIndex:2];
        int nowDay = [nowStr intValue];
        float totalWidth = SCREEN_WIDTH- 14*(SCREEN_WIDTH/375.0)*2 - 35-15;
        float scale = ((nowDay-firstDay)/(float)([UToolBox monthCount:month]-1));
        float length = totalWidth*scale;
        for(int i =0;i<[UToolBox monthCount:month];i++)
        {
            if(i== nowDay-firstDay)
            {
                [originArr replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:length]];
                double tmpInt=0.0;
                double tmpRCD=beforeOrAfter==0 ? record.TDS_Bad:record.TDS_Good;
                double statevalue1=50;
                double statevalue2=200;
                double statevalue3=250;
                if (tmpRCD>=0&&tmpRCD<=statevalue1) {
                    tmpInt=tmpRCD/statevalue1/3.0;
                } else if(tmpRCD>statevalue1&&tmpRCD<=statevalue2){
                    tmpInt=(tmpRCD-statevalue1)/(statevalue2-statevalue1)/3.0+1/3.0;
                }
                else if (tmpRCD>statevalue2&&tmpRCD<=statevalue3)
                {
                    tmpInt=(tmpRCD-statevalue2)/(statevalue3-statevalue2)/3.0+2/3.0;
                }
                else if (tmpRCD>statevalue3)
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
    graph.values=originArr;
    graph.zongArr = originArr1;
    //graph.fillColors=@[[UIColor colorWithRed:242.0/255 green:98.0/255 blue:100.0/255 alpha:0.7],[UIColor colorWithRed:125.0/255 green:68.0/255 blue:231.0/255 alpha:0.5],[UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:0.25]];
    if(muArr.count > 0)
    {
        [graph stroke:graph.frame color:@"" fillColor:nil orignY:0 count:0];
    }
    //graph.graphColor=[UIColor redColor];
    graph.curved=YES;
    [self addSubview:graph];
}

@end

