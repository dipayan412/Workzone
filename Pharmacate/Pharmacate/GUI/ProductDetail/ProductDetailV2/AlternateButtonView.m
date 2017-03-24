//
//  AlternateButtonView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/12/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "AlternateButtonView.h"

@interface AlternateButtonView() <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
    UILabel *noDataLabel;
    UIView *parentView;
    UITableView *tableView;
    CGRect viewRect;
    UIButton *backButton;
    UIControl *containerControl;
}

@end

@implementation AlternateButtonView

@synthesize buttonLabel;

-(id)initWithFrame:(CGRect)rect WithArray:(NSMutableArray*)_dataArray ParentView:(UIView*)_parentView
{
    if ((self = [super initWithFrame:rect]))
    {
        viewRect = rect;
        dataArray = [[NSMutableArray alloc] initWithArray:_dataArray];
        parentView = _parentView;
        [self commonIntialization];
    }
    return self;
}

-(void)commonIntialization
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 3 * self.frame.size.height/4)];
    buttonLabel.backgroundColor = [UIColor redColor];
    buttonLabel.textAlignment = NSTextAlignmentCenter;
    buttonLabel.textColor = [UIColor whiteColor];
    buttonLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    buttonLabel.hidden = NO;
    [self addSubview:buttonLabel];
    
    noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height/4)];
    noDataLabel.backgroundColor = [UIColor lightGrayColor];
    noDataLabel.textColor = [UIColor whiteColor];
    noDataLabel.text = @"No data";
    noDataLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.hidden = NO;
    [self addSubview:noDataLabel];
    
    containerControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    containerControl.backgroundColor = [UIColor clearColor];
    [containerControl addTarget:self action:@selector(containerControlAction) forControlEvents:UIControlEventTouchUpInside];
    containerControl.hidden = NO;
    [self addSubview:containerControl];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width - 40, parentView.frame.size.height - 40) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.hidden = YES;
    [self addSubview:tableView];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setTitle:@"Close" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 30);
    backButton.hidden = YES;
    [self addSubview:backButton];
}

-(void)containerControlAction
{
    if(dataArray.count == 0)
    {
        [self showNoDataLabel];
    }
    else
    {
        [parentView bringSubviewToFront:self];
        noDataLabel.hidden = YES;
        containerControl.hidden = YES;
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            buttonLabel.hidden = YES;
            tableView.hidden = NO;
            backButton.hidden = NO;
            CGRect frame = self.frame;
            frame.origin.x = 20;
            frame.origin.y = 20;
            frame.size.width = [UIScreen mainScreen].bounds.size.width - 40;
            frame.size.height = parentView.frame.size.height - 40;
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self setNeedsDisplay];
        }];
    }
}

-(void)showNoDataLabel
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = noDataLabel.frame;
        frame.origin.y = 3 * self.frame.size.height/4;
        noDataLabel.frame = frame;
    } completion:^(BOOL finished) {
        if(finished)
        {
            [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(hideNoDataLabel)
                                           userInfo:nil
                                            repeats:NO];
        }
    }];
}

-(void)hideNoDataLabel
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = noDataLabel.frame;
        frame.origin.y = self.frame.size.height;
        noDataLabel.frame = frame;
    } completion:^(BOOL finished) {
        if(finished)
        {
            
        }
    }];
}

-(void)closeButtonAction
{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        tableView.hidden = YES;
        backButton.hidden = YES;
        CGRect frame = self.frame;
        frame = viewRect;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if(finished)
        {
            buttonLabel.hidden = NO;
            noDataLabel.hidden = NO;
            containerControl.hidden = NO;
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
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
