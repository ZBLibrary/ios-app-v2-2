//
//  TDSDetailSecondCell.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/10.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "TDSDetailSecondCell.h"
#import "CupRecord.h"

@implementation TDSDetailSecondCell

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
        label.text = @"今日饮水纯净指数分布";
        self.titleLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        [self addSubview:label];
        
        NSArray *arr = [[NSArray alloc]initWithObjects:@"日",@"周",@"月", nil];
        UISegmentedControl* controller = [[UISegmentedControl alloc]initWithItems:arr];
        controller.frame = CGRectMake(28*(SCREEN_WIDTH/375.0), 48, SCREEN_WIDTH-28*(SCREEN_WIDTH/375.0)*2, 25);
        controller.layer.borderColor = [UIColor colorWithRed:0.23 green:0.50 blue:0.92 alpha:1].CGColor;
        
        controller.layer.borderWidth = 1;
        controller.selectedSegmentIndex = 0;
        controller.layer.masksToBounds = YES;
        controller.layer.cornerRadius = 13;
        self.currentControl = controller;
        [controller addTarget:self action:@selector(switchChart:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:controller];
    }
    
    return self;
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
-(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
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

//tds
- (void)createDayTDSCircleView
{
    CupRecord* record = self.todayRecord;
    int Count = record.TDS_Good+record.TDS_Mid+record.TDS_Bad;
    CustomThreeCircleView* circleView = [[CustomThreeCircleView alloc]initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) high:record.TDS_Good/(CGFloat)Count middle:record.TDS_Mid/(CGFloat)Count low:record.TDS_Bad/(CGFloat)Count type:0];
    circleView.lowScale = record.TDS_Good/(CGFloat)Count;
    circleView.middleScale = record.TDS_Mid/(CGFloat)Count;
    circleView.highScale = record.TDS_Bad/(CGFloat)Count;
    self.dayTDSCircleView = circleView;
    circleView.hidden = FALSE;
    [self addSubview:circleView];
}

- (void)createWeekTDSCircleView
{
    CupRecord* record = self.weekRecord;
    int Count = record.TDS_Good+record.TDS_Mid+record.TDS_Bad;
    CustomThreeCircleView* circleView = [[CustomThreeCircleView alloc]initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) high:record.TDS_Good/(CGFloat)Count middle:record.TDS_Mid/(CGFloat)Count low:record.TDS_Bad/(CGFloat)Count type:0];
    circleView.lowScale = record.TDS_Good/(CGFloat)Count;
    circleView.middleScale = record.TDS_Mid/(CGFloat)Count;
    circleView.highScale = record.TDS_Bad/(CGFloat)Count;
    self.weekTDSCircleView = circleView;
    circleView.hidden = YES;
    [self addSubview:circleView];
}

- (void)createMonthTDSCircleView
{
    CupRecord* record = self.monthRecord;
    int Count = record.TDS_Good+record.TDS_Mid+record.TDS_Bad;
    CustomThreeCircleView* circleView = [[CustomThreeCircleView alloc]initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) high:record.TDS_Good/(CGFloat)Count middle:record.TDS_Mid/(CGFloat)Count low:record.TDS_Bad/(CGFloat)Count type:0];
    circleView.lowScale = record.TDS_Good/(CGFloat)Count;
    circleView.middleScale = record.TDS_Mid/(CGFloat)Count;
    circleView.highScale = record.TDS_Bad/(CGFloat)Count;
    self.monthTDSCircleView = circleView;
    circleView.hidden = YES;
    [self addSubview:circleView];
}

//当天
- (void)dayGraphView
{
    MPGraphView* graph=[[MPGraphView alloc] initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:0];
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    NSMutableArray* zongArr = [[NSMutableArray alloc]init];
    
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
                [originArr1 replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
            }
        }
        
        [muArr addObject:[NSNumber numberWithFloat:length]];
        [zongArr addObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
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
    self.dayMpGraphView = graph;
    if(self.todayRecord)
    {
        

        
        graph.firstLabel.text = [NSString stringWithFormat:@"健康(%d%%)",0];
        graph.secondLabel.text = [NSString stringWithFormat:@"一般(%d%%)",0];
        graph.secondLabel.text = [NSString stringWithFormat:@"较差(%d%%)",0];
    }
    else
    {

        graph.firstLabel.text = [NSString stringWithFormat:@""];
        float totalCount = self.todayRecord.Count;
        float highF = self.todayRecord.TDS_Good / totalCount;
        int high = highF*100;
        graph.firstLabel.text = [NSString stringWithFormat:@"健康(%d%%)",high];
        
        highF = self.todayRecord.TDS_Mid/totalCount;
        high = highF*100;
        graph.secondLabel.text = [NSString stringWithFormat:@"一般(%d%%)",high];
        
        highF = self.todayRecord.TDS_Bad/totalCount;
        high = highF*100;
        graph.secondLabel.text = [NSString stringWithFormat:@"较差(%d%%)",high];
      

    }
    [self addSubview:graph];
    graph.hidden = YES;
}
//当周
- (void)weekGraphView
{
    NSDate* weekFirstDay = [UToolBox dateStartOfWeek:[NSDate date]];
    NSString* firstDayStr = [UToolBox stringFromDate:weekFirstDay format:@"yyyy-MM-dd HH:mm:ss"];
    firstDayStr = [[firstDayStr componentsSeparatedByString:@" "] objectAtIndex:0];
    firstDayStr = [[firstDayStr componentsSeparatedByString:@"-"] objectAtIndex:2];
    
    int firstDay = [firstDayStr intValue];
    
    NSMutableArray* originArr = [self originDataSource:7];
    NSMutableArray* originArr1 = [self originDataSourceZong:7];
    
    MPGraphView* graph=[[MPGraphView alloc] initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:1];
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    NSMutableArray* zongArr = [[NSMutableArray alloc]init];
    for(int i=0;i<self.weekArr.count;i++)
    {
        CupRecord* record = [self.weekArr objectAtIndex:i];
        NSString* nowStr = [UToolBox stringFromDate:record.start format:@"yyyy-MM-dd HH:mm:ss"];
        nowStr = [[nowStr componentsSeparatedByString:@" "] objectAtIndex:0];
        nowStr = [[nowStr componentsSeparatedByString:@"-"] objectAtIndex:2];
        int nowDay = [nowStr intValue];
        float totalWidth = SCREEN_WIDTH- 14*(SCREEN_WIDTH/375.0)*2 - 35-15;
        float scale = ((nowDay-firstDay)/6.0);
        float length = totalWidth*scale;
        for(int i =0;i<7;i++)
        {
            if(i== nowDay-firstDay)
            {
                [originArr replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:length]];
                [originArr1 replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
            }
        }
        
        [muArr addObject:[NSNumber numberWithFloat:length]];
        [zongArr addObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
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
    self.weekMpGraphView = graph;
    graph.hidden = YES;
    if(self.weekRecord)
    {
        
        
        graph.firstLabel.text = [NSString stringWithFormat:@""];
        float totalCount = self.weekRecord.Count;
        float highF = self.weekRecord.TDS_Good / totalCount;
        int high = highF*100;
        graph.firstLabel.text = [NSString stringWithFormat:@"健康(%d%%)",high];
        
        highF = self.weekRecord.TDS_Mid/totalCount;
        high = highF*100;
        graph.secondLabel.text = [NSString stringWithFormat:@"一般(%d%%)",high];
        
        highF = self.weekRecord.TDS_Bad/totalCount;
        high = highF*100;
        graph.secondLabel.text = [NSString stringWithFormat:@"较差(%d%%)",high];

    }
    else
    {
        graph.firstLabel.text = [NSString stringWithFormat:@"健康(%d%%)",0];
        graph.secondLabel.text = [NSString stringWithFormat:@"一般(%d%%)",0];
        graph.secondLabel.text = [NSString stringWithFormat:@"较差(%d%%)",0];


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
    firstDayStr = [[firstDayStr componentsSeparatedByString:@"-"] objectAtIndex:2];
    
    
    int firstDay = [firstDayStr intValue];
    
    NSMutableArray* originArr = [self originDataSource:[UToolBox monthCount:month]];
    NSMutableArray* originArr1 = [self originDataSourceZong:[UToolBox monthCount:month]];
    
    MPGraphView* graph=[[MPGraphView alloc] initWithFrame:CGRectMake(14*(SCREEN_WIDTH/375.0),96, SCREEN_WIDTH-14*(SCREEN_WIDTH/375.0)*2, 150) timeType:2];
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    NSMutableArray* zongArr = [[NSMutableArray alloc]init];
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
                [originArr1 replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
            }
        }
        
        [muArr addObject:[NSNumber numberWithFloat:length]];
        [zongArr addObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
        [muArr addObject:[NSNumber numberWithFloat:length]];
        [zongArr addObject:[NSNumber numberWithInt:record.TDS_High/400.0*(150-23-44-2)]];
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
    graph.hidden = YES;
    self.monthMpGraphView = graph;
    if(self.monthRecord)
    {
        graph.firstLabel.text = [NSString stringWithFormat:@""];
        float totalCount = self.weekRecord.Count;
        float highF = self.monthRecord.TDS_Good / totalCount;
        int high = highF*100;
        graph.firstLabel.text = [NSString stringWithFormat:@"健康(%d%%)",high];
        
        highF = self.monthRecord.TDS_Mid/totalCount;
        high = highF*100;
        graph.secondLabel.text = [NSString stringWithFormat:@"一般(%d%%)",high];
        
        highF = self.monthRecord.TDS_Bad/totalCount;
        high = highF*100;
        graph.secondLabel.text = [NSString stringWithFormat:@"较差(%d%%)",high];
    }
    else
    {
        graph.firstLabel.text = [NSString stringWithFormat:@"健康(%d%%)",0];
        graph.secondLabel.text = [NSString stringWithFormat:@"一般(%d%%)",0];
        graph.secondLabel.text = [NSString stringWithFormat:@"较差(%d%%)",0];
    }
    
    graph.currentMonthLabel.text = [NSString stringWithFormat:@"%d月1日",month];
    graph.endMonthLabel.text = [NSString stringWithFormat:@"%d",[UToolBox monthCount:month]];

    [self addSubview:graph];
}
- (void)layOUtTDSCell:(int)type
{
    [self dayGraphView];
    [self weekGraphView];
    [self monthGraphView];
    [self createDayTDSCircleView];
    [self createMonthTDSCircleView];
    [self createWeekTDSCircleView];
    [self showCircle:FALSE type:type];
}

- (void)showCircle:(BOOL)isShowCircle type:(int)type
{
    self.currentType = type;
    self.isShowCircle = isShowCircle;
    [self switchChart:self.currentControl];
}


- (void)switchChart:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
        {
            if(self.isShowCircle)
            {
                
                self.weekMpGraphView.hidden = YES;
                self.monthMpGraphView.hidden = YES;
                self.dayMpGraphView.hidden = false;
                [self.dayMpGraphView animate];
                self.dayTDSCircleView.hidden = YES;
                self.weekTDSCircleView.hidden = YES;
                self.monthTDSCircleView.hidden = YES;

            }
            else
            {
                self.weekMpGraphView.hidden = YES;
                self.monthMpGraphView.hidden = YES;
                self.dayMpGraphView.hidden = YES;
                self.dayTDSCircleView.hidden = FALSE;
                self.weekTDSCircleView.hidden = YES;
                self.monthTDSCircleView.hidden = YES;

                            }
            self.titleLabel.text = @"今日饮水纯净指数分布";
            
            break;
        }
        case 1:
        {
            if(self.isShowCircle)
            {
                
                self.weekMpGraphView.hidden = FALSE;
                self.monthMpGraphView.hidden = YES;
                self.dayMpGraphView.hidden = YES;
                [self.weekMpGraphView animate];
                self.dayTDSCircleView.hidden = YES;
                self.weekTDSCircleView.hidden = YES;
                self.monthTDSCircleView.hidden = YES;

            }
            else
            {
                self.dayTDSCircleView.hidden = YES;
                self.weekTDSCircleView.hidden = FALSE;
                self.monthTDSCircleView.hidden = YES;
                self.weekMpGraphView.hidden = YES;
                self.monthMpGraphView.hidden = YES;
                self.dayMpGraphView.hidden = YES;

            }
            self.titleLabel.text = @"本周饮水纯净指数分布";
            break;
        }
        case 2:
        {
            if(self.isShowCircle)
            {
                self.weekMpGraphView.hidden = YES;
                self.monthMpGraphView.hidden = FALSE;
                self.dayMpGraphView.hidden = YES;
                [self.monthMpGraphView animate];
                self.dayTDSCircleView.hidden = YES;
                self.weekTDSCircleView.hidden = YES;
                self.monthTDSCircleView.hidden = YES;

            }
            else
            {
                
                self.dayTDSCircleView.hidden = YES;
                self.weekTDSCircleView.hidden = YES;
                self.monthTDSCircleView.hidden = FALSE;
                self.weekMpGraphView.hidden = YES;
                self.monthMpGraphView.hidden = YES;
                self.dayMpGraphView.hidden = YES;

            }
            
            self.titleLabel.text = @"本月饮水纯净指数分布";
            break;
        }
            
        default:
            break;
    }
  
}

@end
