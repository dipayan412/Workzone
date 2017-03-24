//
//  AlternateTableView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/13/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "AlternateTableView.h"

@interface AlternateTableView() <UITableViewDelegate, UITableViewDataSource>
{
    
}

@end

@implementation AlternateTableView

@synthesize dataArray;
@synthesize tableView;

-(id)initWithFrame:(CGRect)rect WithDataArray:(NSMutableArray*)_dataArray
{
    if ((self = [super initWithFrame:rect]))
    {
        self.dataArray = [[NSMutableArray alloc] initWithArray:_dataArray];
//        [self commonInitialization];
    }
    return self;
}

-(id)initWithDataArray:(NSMutableArray*)_dataArray
{
    if ((self = [super init]))
    {
        self.dataArray = [[NSMutableArray alloc] initWithArray:_dataArray];
        NSLog(@"dataArray %@", self.dataArray);
//        [self commonInitialization];
    }
    return self;
}

-(void)commonInitialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.hidden = YES;
    [self addSubview:tableView];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self commonInitialization];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];//[NSString stringWithFormat:@"%lu", indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

@end
