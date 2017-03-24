//
//  OffersViewController.m
//  iOS Prototype
//
//  Created by World on 3/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "OffersViewController.h"
#import "OfferDetailsViewController.h"
#import "PromoObject.h"
#import "PromoDetailsViewController.h"

@interface OffersViewController ()
{
    NSMutableArray *offersArray;
}
@property (nonatomic, retain) ASIHTTPRequest *getMyOffersRequest;

@end

@implementation OffersViewController

@synthesize getMyOffersRequest;

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
    
    self.navigationItem.title = @"OFFERS";
    
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    offersArray = [[NSMutableArray alloc] init];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [offersArray removeAllObjects];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@%@%@", baseUrl,getmyoffer,[UserDefaultsManager sessionToken]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url -> %@",urlStr);
    self.getMyOffersRequest = [ASIHTTPRequest requestWithURL:url];
    self.getMyOffersRequest.delegate = self;
    [self.getMyOffersRequest startAsynchronous];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@""
                                              message:@"Loading..."
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];
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
    return offersArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"offerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    PromoObject *promo = [offersArray objectAtIndex:indexPath.row];
    NSLog(@"%@",promo.promoId);
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
    
    PromoObject *promo = [offersArray objectAtIndex:indexPath.row];
    PromoDetailsViewController *vc = [[PromoDetailsViewController alloc] initWithNibName:@"PromoDetailsViewController" bundle:nil];
    vc.promo = promo;
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
        NSArray *data = [responseObject objectForKey:@"data"];
        for(int i = 0; i < data.count; i++)
        {
            NSDictionary *tmp = [data objectAtIndex:i];
            PromoObject *promo = [[PromoObject alloc] init];
            
            promo.promoId = [tmp objectForKey:@"promo_id"];
            promo.promoName = [tmp objectForKey:@"name"];
            promo.shopName = [tmp objectForKey:@"shop_name"];
            promo.promoDetails = [tmp objectForKey:@"text"];
            
            //very very important code to handle null object
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
            
            [offersArray addObject:promo];
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
@end
