//
//  lineChartViewzb.m
//  OZner
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

#import "lineChartViewzb.h"
#import "CupRecord.h"

@implementation lineChartViewzb

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//type:0 日,1 周,2 月
- (void)drawLineView:(int)cellType dateType:(int)dateType dataArrzb:(NSArray*)dataArrzb Recordzb:(CupRecord*)Recordzb {
    self.CellType=cellType;
    self.title1=cellType==0 ? loadLanguage(@"健康"):loadLanguage(@"偏凉");
    self.title2=cellType==0 ? loadLanguage(@"一般"):loadLanguage(@"适中");
    self.title3=cellType==0 ? loadLanguage(@"较差"):loadLanguage(@"偏烫");
    switch (dateType) {
        case 0:
            self.dataArr=dataArrzb;
            self.todayRecord=Recordzb;
            [self dayGraphView];
            break;
        case 1:
            self.weekArr=dataArrzb;
            self.weekRecord=Recordzb;
            [self weekGraphView];
            break;
        case 2:
            self.monthArr=dataArrzb;
            self.monthRecord=Recordzb;
            [self monthGraphView];
            break;
            
        default:
            break;
    }
    // Drawing code
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
//当天
- (void)dayGraphView
{
    MPGraphViewzb* graph=[[MPGraphViewzb alloc] initWithFrame: CGRectMake(14*(SCREEN_WIDTH/375.0),0, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:0 cellType:self.CellType title1:self.title1 title2:self.title2 title3:self.title3]; //initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),0, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:0];
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    //NSMutableArray* zongArr = [[NSMutableArray alloc]init];
    
    NSMutableArray* originArr = [self originDataSource:24];
    NSMutableArray* originArr1 = [self originDataSourceZong:24];
    
    for(int i=0;i<self.dataArr.count;i++)
    {
        
        CupRecord* record = [self.dataArr objectAtIndex:i];
        NSString* nowStr = [UToolBox stringFromDate:record.start format:@"yyyy-MM-dd HH:mm:ss"];
        nowStr = [[nowStr componentsSeparatedByString:@" "] objectAtIndex:1];
        int hour = [[[nowStr componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
        float totalWidth = SCREEN_WIDTH- 14*(SCREEN_WIDTH/375.0)*2 - 35-15;
        float scale = (hour*3600/86400.0);
        float length = totalWidth*scale;
        for(int i =0;i<24;i++)
        {
            if(i== hour)
            {
                [originArr replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:length]];
                double tmpInt=0.0;
                double tmpRCD=self.CellType==0 ? record.TDS_High:record.Temperature_MAX;
                double statevalue1=self.CellType==0 ? tds_good:25;
                double statevalue2=self.CellType==0 ? tds_bad:50;
                double statevalue3=self.CellType==0 ? 250:100;
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
        //[zongArr addObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
    }
    graph.values=originArr;
    graph.zongArr = originArr1;
    graph.fillColors=@[[UIColor colorWithRed:242.0/255 green:98.0/255 blue:100.0/255 alpha:0.7],[UIColor colorWithRed:125.0/255 green:68.0/255 blue:231.0/255 alpha:0.5],[UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:0.25]];
    graph.graphColor=[UIColor redColor];
    if(muArr.count > 0)
    {
        [graph stroke:graph.frame color:@"" fillColor:nil orignY:0 count:0];
    }
    graph.curved=YES;
    //self.dayMpGraphView = graph;
    if(self.todayRecord.Count<=0)
    {
        
        
        
        graph.firstLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title1,0];
        graph.secondLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title2,0];
        graph.thirdLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title3,0];
    }
    else
    {
        
        graph.firstLabel.text = [NSString stringWithFormat:@""];
        float totalCount = self.todayRecord.Count;
        
        float highF = self.CellType==0 ? (self.todayRecord.TDS_Good / totalCount):(self.todayRecord.Temperature_Low/ totalCount);
        int high1 = highF*100;
        graph.firstLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title1,high1];
        
        highF = self.CellType==0 ? (self.todayRecord.TDS_Mid / totalCount):(self.todayRecord.Temperature_Mid/ totalCount);
        int high2 = highF*100;
        
        
        highF = self.CellType==0 ? (self.todayRecord.TDS_Bad / totalCount):(self.todayRecord.Temperature_High/ totalCount);
        int high3 = highF*100;
        int tmp3need=0;
        if ((100-high1-high2)==1&&high3==0)
        {
            tmp3need=0;
            high2+=1;
        }
        else if (high3>0)
        {
            tmp3need=100-high1-high2;
        }
    
        graph.secondLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title2,high2];
        graph.thirdLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title3,tmp3need];
        
        
    }
    [self addSubview:graph];
    //graph.hidden = YES;
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
- (void)weekGraphView
{
    NSDate* weekFirstDay = [UToolBox dateStartOfWeek:[NSDate date]];
    //NSString* firstDayStr = [UToolBox stringFromDate:weekFirstDay format:@"yyyy-MM-dd HH:mm:ss"];
    //firstDayStr = [[firstDayStr componentsSeparatedByString:@" "] objectAtIndex:0];
    //firstDayStr = [[firstDayStr componentsSeparatedByString:@"-"] objectAtIndex:2];
    
    //int firstDay = [firstDayStr intValue];
    
    NSMutableArray* originArr = [self originDataSource:7];
    NSMutableArray* originArr1 = [self originDataSourceZong:7];
    MPGraphViewzb* graph=[[MPGraphViewzb alloc] initWithFrame: CGRectMake(14*(SCREEN_WIDTH/375.0),0, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:1 cellType:self.CellType title1:self.title1 title2:self.title2 title3:self.title3];
    
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    //NSMutableArray* zongArr = [[NSMutableArray alloc]init];
    for(int i=0;i<self.weekArr.count;i++)
    {
        CupRecord* record = [self.weekArr objectAtIndex:i];
        //NSString* nowStr = [UToolBox stringFromDate:record.start format:@"yyyy-MM-dd HH:mm:ss"];
        //nowStr = [[nowStr componentsSeparatedByString:@" "] objectAtIndex:0];
        //nowStr = [[nowStr componentsSeparatedByString:@"-"] objectAtIndex:2];
        //int nowDay = [nowStr intValue];
        float totalWidth = SCREEN_WIDTH- 14*(SCREEN_WIDTH/375.0)*2 - 35-15;
        int betweenDays=[self daysBetweenTwoDate:weekFirstDay nowDate:record.start];
        float scale = (betweenDays/6.0);
        float length = totalWidth*scale;
        for(int i =0;i<7;i++)
        {
            if(i == betweenDays)
            {
                [originArr replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:length]];
                double tmpInt=0.0;
                double tmpRCD=self.CellType==0 ? record.TDS_High:record.Temperature_MAX;
                double statevalue1=self.CellType==0 ? tds_good:25;
                double statevalue2=self.CellType==0 ? tds_bad:50;
                double statevalue3=self.CellType==0 ? 250:100;
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
        //[zongArr addObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
    }
    graph.values=originArr;
    graph.zongArr = originArr1;
    graph.fillColors=@[[UIColor colorWithRed:242.0/255 green:98.0/255 blue:100.0/255 alpha:0.7],[UIColor colorWithRed:125.0/255 green:68.0/255 blue:231.0/255 alpha:0.5],[UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:0.25]];
    graph.graphColor=[UIColor redColor];
    if(muArr.count > 0)
    {
        [graph stroke:graph.frame color:@"" fillColor:nil orignY:0 count:0];
    }
    graph.curved=YES;
    //self.weekMpGraphView = graph;
    
    if(self.weekRecord.Count>=0)
    {
        
        
        graph.firstLabel.text = [NSString stringWithFormat:@""];
        float totalCount = self.weekRecord.Count;
        
        float highF = self.CellType==0 ? (self.weekRecord.TDS_Good / totalCount):(self.weekRecord.Temperature_Low/ totalCount);
        int high1 = highF*100;
        graph.firstLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title1,high1];
        
        highF = self.CellType==0 ? (self.weekRecord.TDS_Mid / totalCount):(self.weekRecord.Temperature_Mid/ totalCount);
        int high2 = highF*100;
        //graph.secondLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title2,high2];
        
        highF = self.CellType==0 ? (self.weekRecord.TDS_Bad / totalCount):(self.weekRecord.Temperature_High/ totalCount);
        int high3 = highF*100;
        int tmp3need=0;
        if ((100-high1-high2)==1&&high3==0)
        {
            tmp3need=0;
            high2+=1;
        }
        else if (high3>0)
        {
            tmp3need=100-high1-high2;
        }
        graph.secondLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title2,high2];
        graph.thirdLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title3,tmp3need];
        
    }
    else
    {
        graph.firstLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title1,0];
        graph.secondLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title2,0];
        graph.thirdLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title3,0];
        
        
    }
    
    [self addSubview:graph];
}
//当月
- (void)monthGraphView
{
    //取这个月的
    NSDate* monthFirstDay = [UToolBox dateStartOfMonth:[NSDate date]];
    NSString* firstDayStr = [UToolBox stringFromDate:monthFirstDay format:@"yyyy-MM-dd HH:mm:ss"];
    firstDayStr = [[firstDayStr componentsSeparatedByString:@" "] objectAtIndex:0];
    int month = [[[firstDayStr componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
    //firstDayStr = [[firstDayStr componentsSeparatedByString:@"-"] objectAtIndex:2];
    
    
    int firstDay = 1;
    
    NSMutableArray* originArr = [self originDataSource:[UToolBox monthCount:month]];
    NSMutableArray* originArr1 = [self originDataSourceZong:[UToolBox monthCount:month]];
    MPGraphViewzb* graph=[[MPGraphViewzb alloc] initWithFrame: CGRectMake(14*(SCREEN_WIDTH/375.0),0, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:2 cellType:self.CellType title1:self.title1 title2:self.title2 title3:self.title3];
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
                double tmpRCD=self.CellType==0 ? record.TDS_High:record.Temperature_MAX;
                double statevalue1=self.CellType==0 ? tds_good:25;
                double statevalue2=self.CellType==0 ? tds_bad:50;
                double statevalue3=self.CellType==0 ? 250:100;
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
        //[zongArr addObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
        
    }
    graph.values=originArr;
    graph.zongArr = originArr1;
    graph.fillColors=@[[UIColor colorWithRed:242.0/255 green:98.0/255 blue:100.0/255 alpha:0.7],[UIColor colorWithRed:125.0/255 green:68.0/255 blue:231.0/255 alpha:0.5],[UIColor colorWithRed:60.0/255 green:137.0/255 blue:242.0/255 alpha:0.25]];
    if(muArr.count > 0)
    {
        [graph stroke:graph.frame color:@"" fillColor:nil orignY:0 count:0];
    }
    graph.graphColor=[UIColor redColor];
    graph.curved=YES;
    
    //self.monthMpGraphView = graph;
    if(self.monthRecord.Count>0)
    {
        graph.firstLabel.text = [NSString stringWithFormat:@""];
        float totalCount = self.monthRecord.Count;
        
        float highF = self.CellType==0 ? (self.monthRecord.TDS_Good / totalCount):(self.monthRecord.Temperature_Low/ totalCount);
        int high1 = highF*100;
        graph.firstLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title1,high1];
        
        highF = self.CellType==0 ? (self.monthRecord.TDS_Mid / totalCount):(self.monthRecord.Temperature_Mid/ totalCount);
        int high2 = highF*100;
        //graph.secondLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title2,high2];
        
        highF = self.CellType==0 ? (self.monthRecord.TDS_Bad / totalCount):(self.monthRecord.Temperature_High/ totalCount);
        int high3 = highF*100;
        int tmp3need=0;
        if ((100-high1-high2)==1&&high3==0)
        {
            tmp3need=0;
            high2+=1;
        }
        else  if (high3>0)
        {
            tmp3need=100-high1-high2;
        }
        graph.secondLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title2,high2];
        graph.thirdLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title3,tmp3need];
    }
    else
    {
        graph.firstLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title1,0];
        graph.secondLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title2,0];
        graph.thirdLabel.text = [NSString stringWithFormat:@"%@(%d%%)",self.title3,0];
    }
    
    //graph.currentMonthLabel.text = [NSString stringWithFormat:@"%d月1日",month];
    //graph.endMonthLabel.text = [NSString stringWithFormat:@"%d",[UToolBox monthCount:month]];
    
    [self addSubview:graph];
}

@end
