//
//  RightViewController.m
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

@synthesize drawerViewDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)openDrawerView
{
    [self.drawerViewDelegate showDrawerView];
}

-(void)closeDrawerView
{
    [self.drawerViewDelegate hideDrawerView];
}

@end
