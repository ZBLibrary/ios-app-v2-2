//
//  NSAttributedStringView.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-12-18.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "NSAttributedStringView.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedStringView
@synthesize mySourceString;
@synthesize contentMuArr;
@synthesize textFont;

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        textFont = 0;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)toAssinMySourceString:(NSString*)string muArr:(NSMutableArray*)muArr font:(int)font
{
    self.mySourceString = string;
    self.contentMuArr = muArr;
    self.textFont = font;
    [self setNeedsDisplay];
}

/*
 kCTParagraphStyleSpecifierAlignment = 0,                 //对齐属性
 kCTParagraphStyleSpecifierFirstLineHeadIndent = 1,       //首行缩进
 kCTParagraphStyleSpecifierHeadIndent = 2,                //段头缩进
 kCTParagraphStyleSpecifierTailIndent = 3,                //段尾缩进
 kCTParagraphStyleSpecifierTabStops = 4,                  //制表符模式
 kCTParagraphStyleSpecifierDefaultTabInterval = 5,        //默认tab间隔
 kCTParagraphStyleSpecifierLineBreakMode = 6,             //换行模式
 kCTParagraphStyleSpecifierLineHeightMultiple = 7,        //多行高
 kCTParagraphStyleSpecifierMaximumLineHeight = 8,         //最大行高
 kCTParagraphStyleSpecifierMinimumLineHeight = 9,         //最小行高
 kCTParagraphStyleSpecifierLineSpacing = 10,              //行距
 kCTParagraphStyleSpecifierParagraphSpacing = 11,         //段落间距  在段的未尾（Bottom）加上间隔，这个值为负数。
 kCTParagraphStyleSpecifierParagraphSpacingBefore = 12,   //段落前间距 在一个段落的前面加上间隔。TOP
 kCTParagraphStyleSpecifierBaseWritingDirection = 13,     //基本书写方向
 kCTParagraphStyleSpecifierMaximumLineSpacing = 14,       //最大行距
 kCTParagraphStyleSpecifierMinimumLineSpacing = 15,       //最小行距
 kCTParagraphStyleSpecifierLineSpacingAdjustment = 16,    //行距调整
 kCTParagraphStyleSpecifierCount = 17,        //
 */
- (NSAttributedString*)getAttributedString:(NSString*)sourceStr
{
    NSMutableAttributedString* atttiString = [[NSMutableAttributedString alloc] initWithString:sourceStr];
    if([self.contentMuArr count] > 0)
    {
        //从零开始
        int nIdex = 0;
        for(int i=0;i<[self.contentMuArr count];i++)
        {
            TextColorClass* textClass = [self.contentMuArr objectAtIndex:i];
            //更改 颜色
            [atttiString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[UIColor colorWithRed:textClass.red/255.0 green:textClass.green/255.0 blue:textClass.blue/255.0 alpha:1.0].CGColor range:NSMakeRange(nIdex, textClass.text.length)];
            if(self.textFont == 0)
            {
               [atttiString addAttribute:(NSString*)kCTFontAttributeName value:(id)[UIFont systemFontOfSize:textClass.font] range:NSMakeRange(nIdex, textClass.text.length)];
            }
            
            nIdex += textClass.text.length;
        }
    }
    
    if(self.textFont != 0)
    {
        [atttiString addAttribute:(NSString*)kCTFontAttributeName value:(id)[UIFont systemFontOfSize:self.textFont] range:NSMakeRange(0, atttiString.length)];
    }
    
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping; //换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    //行间距
    CTParagraphStyleSetting LineSpacing;
    CGFloat spacing = 2.0;  //指定间距
    LineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    LineSpacing.value = &spacing;
    LineSpacing.valueSize = sizeof(CGFloat);
    
    //多行高
    CGFloat MutiHeight = 1.0f;
    CTParagraphStyleSetting Muti;
    Muti.spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    Muti.value = &MutiHeight;
    Muti.valueSize = sizeof(float);
    
    CTParagraphStyleSetting settings[] = {lineBreakMode,LineSpacing,Muti};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 3);   //第二个参数为settings的长度
    [atttiString addAttribute:(NSString *)kCTParagraphStyleAttributeName
                             value:(id)paragraphStyle
                             range:NSMakeRange(0, atttiString.length)];
    CFRelease(paragraphStyle);
    
    return atttiString;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSAttributedString* attiString = [self getAttributedString:self.mySourceString];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attiString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    CFRelease(path);
    CFRelease(framesetter);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
}

- (void)dealloc
{
    self.mySourceString = nil;
    self.contentMuArr = nil;
}

@end
