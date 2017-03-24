//
//  ManageStoresViewController.m
//  iOS Prototype
//
//  Created by World on 3/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ManageStoresViewController.h"
#import "CreateShopViewController.h"
#import "ShopListViewController.h"

@interface ManageStoresViewController ()

@end

@implementation ManageStoresViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)createShopButtonAction:(UIButton*)btn
{
    CreateShopViewController *vc = [[CreateShopViewController alloc] initWithNibName:@"CreateShopViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)getShopButtonAction:(UIButton*)btn
{
    ShopListViewController *vc = [[ShopListViewController alloc] initWithNibName:@"ShopListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
