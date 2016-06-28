//
//  AmountOfDrinkingCell.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/6.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "AmountOfDrinkingCell_EN.h"

@implementation AmountOfDrinkingCell_EN

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
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, 17)];
        label.textColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1.0];
        label.text = loadLanguage(@"饮水量分布指数");
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        [self addSubview:label];
        
        NSArray *arr = [[NSArray alloc]initWithObjects:loadLanguage(@"日"), loadLanguage(@"周"),loadLanguage(@"月"), nil];
        UISegmentedControl* controller = [[UISegmentedControl alloc]initWithItems:arr];
        controller.frame = CGRectMake(20*(SCREEN_WIDTH/375.0), 48, SCREEN_WIDTH-20*(SCREEN_WIDTH/375.0)*2, 25);
        controller.selectedSegmentIndex = 0;
        controller.layer.borderColor = [UIColor  colorWithRed:0.23 green:0.50 blue:0.92 alpha:1].CGColor;
        controller.layer.borderWidth = 1;
        controller.layer.masksToBounds = YES;
        controller.layer.cornerRadius = 13;
        self.currentControl = controller;
        [controller addTarget:self action:@selector(switchChart:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:controller];
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

//当天
- (void)dayGraphView
{
    MPBarsGraphView* graph=[MPPlot plotWithType:MPPlotTypeBars frame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:0];
    
    NSMutableArray* originArr = [self originDataSource:24];
    NSMutableArray* originArr1 = [self originDataSourceZong:24];
    
    for(int i=0;i<self.dataArr.count;i++)
    {
        CupRecord* record = [self.dataArr objectAtIndex:i];
        if(record.volume > 500)
        {
            record.volume = 540;
        }
        NSString* nowStr = [UToolBox stringFromDate:record.start format:@"yyyy-MM-dd HH:mm:ss"];
        nowStr = [[nowStr componentsSeparatedByString:@" "] objectAtIndex:1];
        int hour = [[[nowStr componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
        for(int i =0;i<24;i++)
        {
            if(i == hour)
            {
                [originArr1 replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:record.volume/500.0*(120)]];
                break;
            }
        }
    }
    [graph setAlgorithm:^CGFloat(CGFloat x) {
        return tan(x);
    } numberOfPoints:4];
    //graph.graphColor=[UIColor colorWithRed:0.120 green:0.806 blue:0.157 alpha:1.000];
    graph.graphColor=[UIColor colorWithRed:88/255 green:155/255 blue:254/255 alpha:1.000];
    graph.values=originArr;
    graph.zongArr = originArr1;
    graph.hidden = FALSE;
    self.myBarView = graph;
    [self addSubview:graph];
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
    
    MPBarsGraphView* graph=[MPPlot plotWithType:MPPlotTypeBars frame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:1];
    
    NSMutableArray* originArr = [self originDataSource:7];
    NSMutableArray* originArr1 = [self originDataSourceZong:7];
    for(int i=0;i<self.weekArr.count;i++)
    {
        CupRecord* record = [self.weekArr objectAtIndex:i];
        if(record.volume > 3000)
        {
            record.volume = 3000;
        }
        //NSString* nowStr = [UToolBox stringFromDate:record.start format:@"yyyy-MM-dd HH:mm:ss"];
        //nowStr = [[nowStr componentsSeparatedByString:@" "] objectAtIndex:0];
//nowStr = [[nowStr componentsSeparatedByString:@"-"] objectAtIndex:2];
        int betweenDays=[self daysBetweenTwoDate:weekFirstDay nowDate:record.start];
        //int nowDay = [nowStr intValue];
        for(int i =0;i<7;i++)
        {
            if(i== betweenDays)
            {
                [originArr1 replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:record.volume/3000.0*(102)]];
            }
        }
    }
    [graph setAlgorithm:^CGFloat(CGFloat x) {
        return tan(x);
    } numberOfPoints:7];
    graph.values=originArr;
    graph.zongArr = originArr1;
    self.myWeekBarView = graph;
    graph.hidden = YES;
    graph.graphColor=[UIColor colorWithRed:0.120 green:0.806 blue:0.157 alpha:1.000];
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
    firstDayStr = [[firstDayStr componentsSeparatedByString:@"-"] objectAtIndex:2];
    
    
    int firstDay = [firstDayStr intValue];
    
    MPBarsGraphView* graph=[MPPlot plotWithType:MPPlotTypeBars frame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:2];
    
    NSMutableArray* originArr = [self originDataSource:[UToolBox monthCount:month]];
    NSMutableArray* originArr1 = [self originDataSourceZong:[UToolBox monthCount:month]];
    for(int i=0;i<self.monthArr.count;i++)
    {
        CupRecord* record = [self.monthArr objectAtIndex:i];
        if(record.volume > 3000)
        {
            record.volume = 3000;
        }
        NSString* nowStr = [UToolBox stringFromDate:record.start format:@"yyyy-MM-dd HH:mm:ss"];
        nowStr = [[nowStr componentsSeparatedByString:@" "] objectAtIndex:0];
        nowStr = [[nowStr componentsSeparatedByString:@"-"] objectAtIndex:2];
        int nowDay = [nowStr intValue];
        for(int i =0;i<[UToolBox monthCount:month];i++)
        {
            if(i== nowDay-firstDay)
            {
                [originArr1 replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:record.volume/3000.0*(102)]];
            }
        }
    }
    [graph setAlgorithm:^CGFloat(CGFloat x) {
        return tan(x);
    } numberOfPoints:[UToolBox monthCount:month]];
    graph.values=originArr;
    graph.zongArr = originArr1;
    graph.hidden = YES;
    self.myMonthBarView = graph;
    graph.graphColor=[UIColor colorWithRed:0.120 green:0.806 blue:0.157 alpha:1.000];
    [self addSubview:graph];
}

- (void)showCircle:(BOOL)isShowCircle type:(int)type
{
    self.currentType = type;
    self.isShowCircle = isShowCircle;
    [self switchChart:self.currentControl];
}


- (void)layOUtAmountDrinkingCell:(int)type isShowCircle:(BOOL)isShowCircle
{
    self.currentType = type;
    self.isShowCircle = isShowCircle;
    if(type == 0)
    {
        [self dayGraphView];
        [self weekGraphView];
        [self monthGraphView];
        [self createDayTDSCircleView];
        [self createWeekTDSCircleView];
        [self createMonthTDSCircleView];
        [self switchChart:self.currentControl];
    }
    else
    {
        [self createDayCircleView];
        [self createWeekCircleView];
        [self createMonthCircleView];
    }
}
//tds
- (void)createDayTDSCircleView
{
    NSDate* date=[[NSDate alloc] initWithTimeIntervalSince1970:(int)([[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970])/86400*86400];
    CupRecord* record = [self.myCurrentDevice.volumes getRecordByDate:date];
    CustomThreeCircleView_EN* circleView = [[CustomThreeCircleView_EN alloc]initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) high:record.TDS_Good/(CGFloat)record.Count middle:record.Temperature_Mid/(CGFloat)record.Count low:record.Temperature_Low/(CGFloat)record.Count type:0];
    circleView.highScale = record.TDS_Good/(CGFloat)record.Count;
    circleView.middleScale = record.TDS_Mid/(CGFloat)record.Count;
    circleView.lowScale = record.TDS_Bad/(CGFloat)record.Count;
    self.dayTDSCircleView = circleView;
    circleView.hidden = FALSE;
    [self addSubview:circleView];
}

- (void)createWeekTDSCircleView
{
    NSDate* weekFirstDay = [UToolBox dateStartOfWeek:[NSDate date]];
    //取整
    NSInteger dayZeor = ((int)[weekFirstDay timeIntervalSince1970])/86400*86400;
    weekFirstDay = [[NSDate alloc]initWithTimeIntervalSince1970:dayZeor];
    CupRecord* record = [self.myCurrentDevice.volumes getRecordByDate:weekFirstDay];
    CustomThreeCircleView_EN* circleView = [[CustomThreeCircleView_EN alloc]initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) high:record.Temperature_High/(CGFloat)record.Count middle:record.Temperature_Mid/(CGFloat)record.Count low:record.Temperature_Low/(CGFloat)record.Count type:0];
    circleView.highScale = record.TDS_Good/(CGFloat)record.Count;
    circleView.middleScale = record.TDS_Mid/(CGFloat)record.Count;
    circleView.lowScale = record.TDS_Bad/(CGFloat)record.Count;
    self.weekTDSCircleView = circleView;
    circleView.hidden = YES;
    [self addSubview:circleView];
}

- (void)createMonthTDSCircleView
{
    NSDate* monthFirstDay = [UToolBox dateStartOfMonth:[NSDate date]];
    //取整
    NSInteger monthZeor = ((int)[monthFirstDay timeIntervalSince1970])/86400*86400;
    monthFirstDay = [[NSDate alloc]initWithTimeIntervalSince1970:monthZeor];
    CupRecord* record = [self.myCurrentDevice.volumes getRecordByDate:monthFirstDay];
    CustomThreeCircleView_EN* circleView = [[CustomThreeCircleView_EN alloc]initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) high:record.Temperature_High/(CGFloat)record.Count middle:record.Temperature_Mid/(CGFloat)record.Count low:record.Temperature_Low/(CGFloat)record.Count type:0];
    circleView.highScale = record.TDS_Good/(CGFloat)record.Count;
    circleView.middleScale = record.TDS_Mid/(CGFloat)record.Count;
    circleView.lowScale = record.TDS_Bad/(CGFloat)record.Count;
    self.monthTDSCircleView = circleView;
    circleView.hidden = YES;
    [self addSubview:circleView];
}
//水温
- (void)createDayCircleView
{
    NSDate* date=[[NSDate alloc] initWithTimeIntervalSince1970:(int)([[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970])/86400*86400];
    CupRecord* record = [self.myCurrentDevice.volumes getRecordByDate:date];
    CustomThreeCircleView_EN* circleView = [[CustomThreeCircleView_EN alloc]initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) high:record.Temperature_High/(CGFloat)record.Count middle:record.Temperature_Mid/(CGFloat)record.Count low:record.Temperature_Low/(CGFloat)record.Count type:1];
    circleView.highScale = record.Temperature_High/(CGFloat)record.Count;
    circleView.middleScale = record.Temperature_Mid/(CGFloat)record.Count;
    circleView.lowScale = record.Temperature_Low/(CGFloat)record.Count;
    self.dayCircleView = circleView;
    circleView.hidden = FALSE;
    [self addSubview:circleView];
}

- (void)createWeekCircleView
{
    NSDate* weekFirstDay = [UToolBox dateStartOfWeek:[NSDate date]];
    //取整
    NSInteger dayZeor = ((int)[weekFirstDay timeIntervalSince1970])/86400*86400;
    weekFirstDay = [[NSDate alloc]initWithTimeIntervalSince1970:dayZeor];
    CupRecord* record = [self.myCurrentDevice.volumes getRecordByDate:weekFirstDay];
   CustomThreeCircleView_EN* circleView = [[CustomThreeCircleView_EN alloc]initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) high:record.Temperature_High/(CGFloat)record.Count middle:record.Temperature_Mid/(CGFloat)record.Count low:record.Temperature_Low/(CGFloat)record.Count type:1];
    circleView.highScale = record.Temperature_High/(CGFloat)record.Count;
    circleView.middleScale = record.Temperature_Mid/(CGFloat)record.Count;
    circleView.lowScale = record.Temperature_Low/(CGFloat)record.Count;
    self.weekCircleView = circleView;
    circleView.hidden = YES;
    [self addSubview:circleView];
}

- (void)createMonthCircleView
{
    NSDate* monthFirstDay = [UToolBox dateStartOfMonth:[NSDate date]];
    //取整
    NSInteger monthZeor = ((int)[monthFirstDay timeIntervalSince1970])/86400*86400;
    monthFirstDay = [[NSDate alloc]initWithTimeIntervalSince1970:monthZeor];
    CupRecord* record = [self.myCurrentDevice.volumes getRecordByDate:monthFirstDay];
    CustomThreeCircleView_EN* circleView = [[CustomThreeCircleView_EN alloc]initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) high:record.Temperature_High/(CGFloat)record.Count middle:record.Temperature_Mid/(CGFloat)record.Count low:record.Temperature_Low/(CGFloat)record.Count type:1];
    circleView.highScale = record.Temperature_High/(CGFloat)record.Count;
    circleView.middleScale = record.Temperature_Mid/(CGFloat)record.Count;
    circleView.lowScale = record.Temperature_Low/(CGFloat)record.Count;
    self.monthCircleView = circleView;
    circleView.hidden = YES;
    [self addSubview:circleView];
}

- (void)switchChart:(UISegmentedControl *)sender
{
    if(self.currentType == 0)
    {
        switch (sender.selectedSegmentIndex)
        {
            case 0:
            {
                if(self.isShowCircle)
                {
                    self.myMonthBarView.hidden = YES;
                    self.myWeekBarView.hidden = YES;
                    self.myBarView.hidden = YES;
                    self.dayTDSCircleView.hidden = FALSE;
                    self.weekTDSCircleView.hidden = YES;
                    self.monthTDSCircleView.hidden = YES;
                }
                else
                {
                    self.myMonthBarView.hidden = YES;
                    self.myWeekBarView.hidden = YES;
                    self.myBarView.hidden = false;
                    [self.myBarView animate];
                    self.dayTDSCircleView.hidden = YES;
                    self.weekTDSCircleView.hidden = YES;
                    self.monthTDSCircleView.hidden = YES;
                }
                
                break;
            }
            case 1:
            {
                if(self.isShowCircle)
                {
                    self.dayTDSCircleView.hidden = YES;
                    self.weekTDSCircleView.hidden = FALSE;
                    self.monthTDSCircleView.hidden = YES;
                    self.myMonthBarView.hidden = YES;
                    self.myWeekBarView.hidden = YES;
                    self.myBarView.hidden = YES;
                }
                else
                {
                    self.myMonthBarView.hidden = YES;
                    self.myWeekBarView.hidden = false;
                    self.myBarView.hidden = YES;
                    [self.myWeekBarView animate];
                    self.dayTDSCircleView.hidden = YES;
                    self.weekTDSCircleView.hidden = YES;
                    self.monthTDSCircleView.hidden = YES;
                }
                
                break;
            }
            case 2:
            {
                if(self.isShowCircle)
                {
                    self.dayTDSCircleView.hidden = YES;
                    self.weekTDSCircleView.hidden = YES;
                    self.monthTDSCircleView.hidden = FALSE;
                    self.myMonthBarView.hidden = YES;
                    self.myWeekBarView.hidden = YES;
                    self.myBarView.hidden = YES;
                }
                else
                {
                    self.myMonthBarView.hidden = false;
                    self.myWeekBarView.hidden = YES;
                    self.myBarView.hidden = YES;
                    [self.myMonthBarView animate];
                    self.dayTDSCircleView.hidden = YES;
                    self.weekTDSCircleView.hidden = YES;
                    self.monthTDSCircleView.hidden = YES;
                }
                
                
                break;
            }
                
                
            default:
                break;
        }

    }
    else
    {
        switch (sender.selectedSegmentIndex)
        {
            case 0:
            {
                self.weekCircleView.hidden = YES;
                self.monthCircleView.hidden = YES;
                self.dayCircleView.hidden = false;
                break;
            }
            case 1:
            {
                self.dayCircleView.hidden = YES;
                self.weekCircleView.hidden = false;
                self.monthCircleView.hidden = YES;
                break;
            }
            case 2:
            {
                self.monthCircleView.hidden = false;
                self.weekCircleView.hidden = YES;
                self.dayCircleView.hidden = YES;
                break;
            }
            default:
                break;
        }

    }
}


@end
