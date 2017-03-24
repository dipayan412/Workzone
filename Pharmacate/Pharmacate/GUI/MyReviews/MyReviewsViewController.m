//
//  MyReviewsViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/28/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "MyReviewsViewController.h"
#import "ReviewTableViewCell.h"
#import "ProductDetailV2ViewController.h"

@interface MyReviewsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *reviewTableView;
    NSMutableArray *reviewArray;
    NSDateFormatter *df1;
    NSDateFormatter *df2;
    UILabel *noDataLabel;
}

@end

@implementation MyReviewsViewController

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    reviewArray = [[NSMutableArray alloc] init];
    df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"MMMM'-'dd'-'y"];
    
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, customNavigationBar.frame.size.height/2 - 45/2, 45, 45);
    [backButton setBackgroundImage:[UIImage imageNamed:@"ThemeColorBackButton.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    [self.view addSubview:customNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backButton.frame.size.width, 0, [UIScreen mainScreen].bounds.size.width - 2 * backButton.frame.size.width, customNavigationBar.frame.size.height)];
    titleLabel.text = @"My Reviews";
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.minimumScaleFactor = 0.5f;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [customNavigationBar addSubview:titleLabel];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [customNavigationBar addSubview:separatorLine];
    
    reviewTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    reviewTableView.backgroundColor = [UIColor clearColor];
    reviewTableView.delegate = self;
    reviewTableView.dataSource = self;
    reviewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:reviewTableView];
    
    noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, 44.0f)];
    noDataLabel.text = NSLocalizedString(kMyReviewsNoData, nil);
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.hidden = YES;
    [self.view addSubview:noDataLabel];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(kMyReviewsLoading, nil);
    [self getReviewsFromServer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return reviewArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ReviewCellId";
    ReviewTableViewCell *cell;
    if(cell == nil)
    {
        cell = [[ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *reviewObject = [reviewArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [reviewObject objectForKey:@"PROPRIETARY_NAME"];
    cell.dateLabel.text = [df2 stringFromDate:[df1 dateFromString:[reviewObject objectForKey:@"REVIEW_DATE"]]];
    NSLog(@"DATE %@", [df2 stringFromDate:[df1 dateFromString:[reviewObject objectForKey:@"REVIEW_DATE"]]]);
    if([[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] integerValue] > 0)
    {
        cell.ratingLabel.text = [NSString stringWithFormat:@"Rating: %@ / 10",[reviewObject objectForKey:@"ORIGINAL_USER_RATING"]];
    }
    cell.contentLabel.text = [reviewObject objectForKey:@"CONTENT"];
    cell.userImageView.image = [UserDefaultsManager getProfilePicture];

    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.25f;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect r = [[[reviewArray objectAtIndex:indexPath.row] objectForKey:@"CONTENT"] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 1000)
                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                                                                 context:nil];
    if(indexPath.row == (reviewArray.count - 1))
    {
        reviewTableView.contentInset = UIEdgeInsetsMake(0, 0, r.size.height + 40.0f + r.size.height + 40.0f, 0);
    }
    
    return r.size.height + 40.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductDetailV2ViewController *vc = [[ProductDetailV2ViewController alloc] initWithNibName:@"ProductDetailV2ViewController" bundle:nil];
    vc.productId = [[reviewArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_ID"];
    vc.productName = [[reviewArray objectAtIndex:indexPath.row] objectForKey:@"PROPRIETARY_NAME"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
//        NSString *productId = [productArray objectAtIndex:indexPath.row];
//        for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
//        {
//            if([notification.userInfo objectForKey:@"PRODUCT_ID"] && [[notification.userInfo objectForKey:@"PRODUCT_ID"] isEqualToString:productId])
//            {
//                [[UIApplication sharedApplication] cancelLocalNotification:notification];
//            }
//        }
        [self deleteReviewByReviewId:[[reviewArray objectAtIndex:indexPath.row] objectForKey:@"USER_REVIEW_ID"]];
        [reviewArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if(reviewArray.count == 0)
        {
            noDataLabel.hidden = NO;
        }
        else
        {
            noDataLabel.hidden = YES;
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)getReviewsFromServer
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:getUserReviewsOfUser];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[UserDefaultsManager getUserId], @"USR_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"reviews %@",dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [reviewArray removeAllObjects];
                    NSArray *arr = [NSArray arrayWithArray:[dataJSON objectForKey:@"REVIEW_LIST"]];
                    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                        NSDate *d1 = [df1 dateFromString:obj1[@"REVIEW_DATE"]];
                        NSDate *d2 = [df1 dateFromString:obj2[@"REVIEW_DATE"]];
                        
                        return [d2 compare:d1]; // descending order
                    }];
                    [reviewArray addObjectsFromArray:arr];
                    
                    if(reviewArray.count == 0)
                    {
                        noDataLabel.hidden = NO;
                    }
                    else
                    {
                        noDataLabel.hidden = YES;
                    }
                    
                    [reviewTableView reloadData];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
            else
            {
                NSLog(@"%@",error);
            }
        }
    }];
    [dataTask resume];
}

-(void)deleteReviewByReviewId:(NSString*)reviewId
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:deleteReviewByUser];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:reviewId, @"USER_REVIEW_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"reviews %@",dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
            else
            {
                NSLog(@"%@",error);
            }
        }
    }];
    [dataTask resume];
}

@end
