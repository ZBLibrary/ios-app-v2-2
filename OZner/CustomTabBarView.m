//
//  MyTabBarView.m
//  CustomTab
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "CustomTabBarView.h"
#import "ImageUtil.h"

#define IMGVIEW_ITEM_TAG    109
#define LABEL_ITEM_TAG      110
#define PHOTO_BTN_TAG       2345

static CustomTabBarView*    g_CustomTabBar;

@interface CustomTabBarView()
{
    id <CustomTabDelegate> ndelegate;
    NSMutableArray* buttons;
    NSMutableArray* badgeLabels;
    int currentIndex;
    
    float lastHideOffset;
    CGFloat lastOffSet;
    
    BOOL         expand;
    UIView* mBackView;
}

@end

@implementation CustomTabBarView
@synthesize btnMuArr = buttons;
@synthesize currentSelectEdIndex_ZB;
@synthesize badgeMuArr = badgeLabels;
@synthesize notifyViewArr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        NSArray* itemArray = [NSArray arrayWithObjects:@"我的设备",@"商城", @"咨询", @"我", nil];
        int count = (int)[itemArray count];
        int widthScreen = [UIScreen mainScreen].bounds.size.width;
        self.frame = CGRectMake(0, UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT, widthScreen, UI_TAB_BAR_HEIGHT);
        IOS6_7_DELTA(self, 0, 20, 0, 0);
        
        buttons = [[NSMutableArray alloc] initWithCapacity:count];
        badgeLabels=[[NSMutableArray alloc] initWithCapacity:count];
        CGFloat width =SCREEN_WIDTH/[itemArray count];
        CGFloat horizontalOffset = 0;
        NSMutableArray* muArr = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0 ; i < count ; i++)
        {
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(horizontalOffset, 0, width, UI_TAB_BAR_HEIGHT)];
            [self addSubview:view];

            UIImageView* imgView = [self buttonAtIndex:i];
            imgView.tag = IMGVIEW_ITEM_TAG;
            imgView.frame = CGRectMake((width - imgView.frame.size.width)/2,(UI_TAB_BAR_HEIGHT-45)/2, imgView.frame.size.width, imgView.frame.size.height);
            
            [view addSubview:imgView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height, view.frame.size.width, view.frame.size.height-(imgView.frame.origin.y+imgView.frame.size.height))];
            label.tag = LABEL_ITEM_TAG;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
            label.highlightedTextColor = [UIColor colorWithRed:50.0/255.0 green:114.0/255.0 blue:201.0/255.0 alpha:1.0];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:12.0];
            label.text = [itemArray objectAtIndex:i];
            [view addSubview:label];
            [label release];
            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.frame = CGRectMake(0, 0, width, view.frame.size.height);
            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            [view addSubview:button];
            //badge
            UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake((width/2 + imgView.frame.size.width/4),4, 20, 20)];
            badgeLabel.textAlignment = NSTextAlignmentCenter;
            badgeLabel.textColor = [UIColor whiteColor];
            badgeLabel.backgroundColor = [UIColor redColor];
            badgeLabel.font = [UIFont systemFontOfSize:14.0];
            badgeLabel.text = @"0";
            [badgeLabel layer].cornerRadius=10;
            [badgeLabel layer].masksToBounds=YES;
            badgeLabel.hidden=YES;
            [view addSubview:badgeLabel];
            [badgeLabels addObject:badgeLabel];
            [badgeLabel release];
            [buttons addObject:button];
            horizontalOffset += width;
        }
        
        self.notifyViewArr = muArr;
        [muArr release];
        currentIndex=-1;
        lastHideOffset = self.frame.origin.y;
        lastOffSet = self.frame.origin.y;
        self.backgroundColor = [UIColor whiteColor];
        // 默认第一个
        [self selectItemAtIndex:0];
        
    }
    //tabBar的顶部线的颜色
    UIView * barToplineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    barToplineView.backgroundColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1];
    [self addSubview:barToplineView];
    [barToplineView release];
    return self;
}

- (void)onClickPhoto:(id)sender
{
    
}

+ (id)sharedCustomTabBar
{
    @synchronized(self)
    {
        if (g_CustomTabBar == nil)
        {
            g_CustomTabBar = [[CustomTabBarView alloc] init];
        }
    }
    
    return g_CustomTabBar;
}

- (void) bindingDelegate:(id <CustomTabDelegate>)mainTabBarDelegate
{
    ndelegate = mainTabBarDelegate;
}

//彻底隐藏
- (void)hideOverTabBar
{
    CGRect rect = self.frame;
    lastHideOffset = rect.origin.y;
    
    // 隐藏
    rect.origin.y = UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_MY_TAB_BAR_HEIGHT+ASSIST_HEIGHT;
    IOS7_Y_DELTA(rect.origin.y);
    
    expand = NO;
    [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.frame = rect;
    } completion:nil];
}
//显示
- (void)showAllMyTabBar
{
    CGRect rect = self.frame;
    
    // 显示bar
    rect.origin.y = UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT;
    IOS7_Y_DELTA(rect.origin.y);
    
    lastOffSet = rect.origin.y;
    [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.frame = rect;
    } completion:nil];
}

- (UIImage*) backgroundImage
{
    UIImage* image = [UIImage imageNamed:@"bottomBarBackground.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width, self.bounds.size.height), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImageView*) buttonAtIndex:(NSUInteger)itemIndex
{
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"bar_normal_%d",(int)itemIndex]];
    UIImage* imageSelected = [UIImage imageNamed:[NSString stringWithFormat:@"bar_select_%d",(int)itemIndex]];
    UIImageView* imgView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imgView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    imgView.highlightedImage = imageSelected;
    return imgView;
}

- (void) selectItemAtIndex:(NSInteger)index
{
    currentIndex = (int)index;
    currentSelectEdIndex_ZB =  (int)index;
    UIButton* button = [buttons objectAtIndex:index];
    [self dimAllButtonsExcept:button];
}

- (void) unselectItems
{
    if (currentIndex < 0)
    {
        return;
    }
    UIButton* button = [buttons objectAtIndex:currentIndex];
    button.selected = NO;
    currentIndex = -1;
}

-(void) dimAllButtonsExcept:(UIButton*)selectedButton
{
    for (UIButton* button in buttons)
    {
        UIView* view = [button superview];
        UIImageView* imgview = (UIImageView* )[view viewWithTag:IMGVIEW_ITEM_TAG];
        UILabel* label = (UILabel* )[view viewWithTag:LABEL_ITEM_TAG];
        if (button == selectedButton)
        {
            imgview.highlighted = YES;
            label.highlighted = YES;
        }
        else
        {
            imgview.highlighted = NO;
            label.highlighted = NO;
        }
    }
}

-(void)dimAllButtonsByIdex:(int)nIdex
{
    currentIndex = nIdex;
    
    UIButton* button = [buttons objectAtIndex:nIdex];
    [self dimAllButtonsExcept:button];
}

// 隐藏
- (void)hideMyTabBar
{
    CGRect rect = self.frame;
    rect.origin.x = 0-UI_SCREEN_WIDTH;
    [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.frame = rect;
    } completion:nil];
}

//显示
- (void)showMyTabBar
{
    CGRect rect = self.frame;
    rect.origin.x = 0;
    
    [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.frame = rect;
    } completion:nil];
}

- (void)touchDownAction:(UIButton*)button
{
    int selectedIndex=(int)[buttons indexOfObject:button];
    if(currentIndex==selectedIndex)
    {
        return;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideCustomViewFrame" object:nil];
    
    currentIndex=selectedIndex;
    currentSelectEdIndex_ZB=selectedIndex;
    [self dimAllButtonsExcept:button];
    
    if ([ndelegate respondsToSelector:@selector(mainTabBar:touchDownAtItemAtIndex:)])
        [ndelegate mainTabBar:self touchDownAtItemAtIndex:selectedIndex];
    
}

- (void)touchUpInsideAction:(UIButton*)button
{
    
}

-(void)dealloc
{
    self.notifyViewArr = nil;
    [buttons release];
    [super dealloc];
}

@end
