//
//  LeftViewController.m
//  StarShow
//
//  Created by 常 贤明 on 4/30/14.
//  Copyright (c) 2014 常 贤明. All rights reserved.
//

#import "LeftViewController.h"


@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*        mTableView;
    NSArray*            mItemArray;
}
@end

@implementation LeftViewController
@synthesize cellArr = mCellArr;
@synthesize cellBgArr = mCellBgArr;

- (void)dealloc
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark- tableviewdatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [mItemArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return FIRST_CELL_HEIGHT;
    }
    else
    {
        return DEFAULT_CELL_HEIGHT;
    }
}

#pragma mark- tableviewdelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"RoomCell";
   
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        if (self.iDelegate && [self.iDelegate respondsToSelector:@selector(dSelectItemIndex:)])
        {
            [self.iDelegate dSelectItemIndex:indexPath.row];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
