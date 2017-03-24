//
//  ShopListViewController.m
//  iOS Prototype
//
//  Created by World on 3/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopObject.h"
#import "ShopViewController.h"
#import "CreateShopViewController.h"
#import "HomeCell.h"

@interface ShopListViewController () <ASIHTTPRequestDelegate>
{
    NSMutableArray *shopListArray;
    UIAlertView *loadingAlert;
}
@property (nonatomic, retain) ASIHTTPRequest *getShopListRequest;

@end

@implementation ShopListViewController

@synthesize getShopListRequest;

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
    
    self.navigationItem.title = @"MY STORES";
    
    shopListArray = [[NSMutableArray alloc] init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:btn];

    addButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [shopListArray removeAllObjects];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    
    [urlStr appendFormat:@"%@",baseUrl];
    [urlStr appendFormat:@"%@",getShopListApi];
    [urlStr appendFormat:@"%@/",[UserDefaultsManager sessionToken]];
    
    NSLog(@"%@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    self.getShopListRequest = [ASIHTTPRequest requestWithURL:url];
    self.getShopListRequest.delegate = self;
    [self.getShopListRequest startAsynchronous];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
    NSLog(@"%@",tmpArray);
    for(int i = 0; i < tmpArray.count; i++)
    {
        NSDictionary *tmpDictionary = [tmpArray objectAtIndex:i];
        
        ShopObject *shop = [[ShopObject alloc] init];
        
        shop.registeredOn = [tmpDictionary objectForKey:@"registered_on"];
        shop.shopId = [tmpDictionary objectForKey:@"shop_id"];
        shop.shopName = [tmpDictionary objectForKey:@"shop_name"];
        shop.userId = [tmpDictionary objectForKey:@"user_id"];
        shop.shopBeaconId = [tmpDictionary objectForKey:@"device_token"];
        shop.latitude = [[tmpDictionary objectForKey:@"lat"] floatValue];
        shop.longitude = [[tmpDictionary objectForKey:@"lon"] floatValue];
        
        if([shop.shopBeaconId isEqual:[NSNull null]])
        {
            shop.shopBeaconId = @"undefined";
        }
//        if([[tmpDictionary objectForKey:@"lat"] isEqual:[NSNull null]])
//        {
//            shop.latitude = 0.0f;
//        }
//        if([[tmpDictionary objectForKey:@"lon"] isEqual:[NSNull null]])
//        {
//            shop.latitude = 0.0f;
//        }
        
        [shopListArray addObject:shop];
    }
    
    [containerTableView reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:[request.error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shopListArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifier = @"CellId";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if(cell == nil)
    {
        cell = [[HomeCell alloc] initWithAccessoryView:NO];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    ShopObject *shop = [shopListArray objectAtIndex:indexPath.row];
    cell.cellName.text = [NSString stringWithFormat:@"%@",shop.shopName];
    cell.cellImageView.image = [UIImage imageNamed:@"ActivityIcon.png"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopObject *shop = [shopListArray objectAtIndex:indexPath.row];
    
    ShopViewController *vc = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    vc.shopObject = shop;
    [self changeBackbuttonTitle];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addButtonAction
{
    CreateShopViewController *vc = [[CreateShopViewController alloc] initWithNibName:@"CreateShopViewController" bundle:nil];
    [self changeBackbuttonTitle];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)changeBackbuttonTitle
{
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

@end
