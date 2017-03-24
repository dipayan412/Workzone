//
//  PromoListViewController.m
//  iOS Prototype
//
//  Created by World on 3/17/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "PromoListViewController.h"
#import "CreatePromoViewController.h"
#import "PromoObject.h"
#import "PromoDetailsViewController.h"

@interface PromoListViewController () <ASIHTTPRequestDelegate>
{
    UIAlertView *loadingAlert;
    NSMutableArray *promoArray;
}

@property (nonatomic, retain) ASIHTTPRequest *promoListRequest;

@end

@implementation PromoListViewController

@synthesize shopObject;
@synthesize promoListRequest;

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
    
    self.navigationController.title = @"PROMO LIST";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(addPromoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    addButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    promoArray = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [promoArray removeAllObjects];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@%@%@/", baseUrl,getStorePromoApi,self.shopObject.shopId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url -> %@",urlStr);
    self.promoListRequest = [ASIHTTPRequest requestWithURL:url];
    self.promoListRequest.delegate = self;
    [self.promoListRequest startAsynchronous];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addPromoButtonAction
{
    CreatePromoViewController *vc = [[CreatePromoViewController alloc] initWithNibName:@"CreatePromoViewController" bundle:nil];
    vc.shopObject = self.shopObject;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"%@",request.responseString);
    if([responseObject objectForKey:@"data"] != nil)
    {
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        for(int i = 0; i < dataArray.count; i++)
        {
            NSDictionary *tmp = [dataArray objectAtIndex:i];
            
            PromoObject *promo = [[PromoObject alloc] init];
            
            promo.promoId = [tmp objectForKey:@"_id"];
            promo.promoName = [tmp objectForKey:@"name"];
            promo.shopName = [tmp objectForKey:@"shop_name"];
            promo.promoDetails = [tmp objectForKey:@"text"];
            
            if([promo.promoDetails isEqual:[NSNull null]])
            {
                promo.promoDetails = @"undefined";
            }
            if([promo.promoId isEqual:[NSNull null]])
            {
                promo.promoId = @"undefined";
            }
            if([promo.shopName isEqual:[NSNull null]])
            {
                promo.shopName = @"undefined";
            }
            if([promo.promoName isEqual:[NSNull null]])
            {
                promo.promoName = @"undefined";
            }
            
            [promoArray addObject:promo];
        }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return promoArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PromoListShopID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    PromoObject *promo = [promoArray objectAtIndex:indexPath.row];
    cell.textLabel.text = promo.promoName;
    cell.detailTextLabel.text = promo.promoDetails;
    cell.imageView.image = [UIImage imageNamed:@"ManageStoreIcon.png"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PromoObject *promo = [promoArray objectAtIndex:indexPath.row];
    PromoDetailsViewController *vc = [[PromoDetailsViewController alloc] initWithNibName:@"PromoDetailsViewController" bundle:nil];
    vc.promo = promo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
