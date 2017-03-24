//
//  MyActivityViewController.m
//  WakeUp
//
//  Created by World on 8/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "MyActivityViewController.h"

@interface MyActivityViewController ()
{
    NSMutableArray *myActivityArray;
    
    ASIHTTPRequest *getMyActivityRequest;
}

@end

@implementation MyActivityViewController

@synthesize drawerViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myActivityArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.drawerViewDelegate)
    {
        [self.drawerViewDelegate showDrawerView];
    }
}

-(IBAction)dismissFullScreenImage:(id)sender
{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myActivityArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

@end
