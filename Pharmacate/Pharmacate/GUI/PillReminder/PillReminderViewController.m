//
//  PillReminderViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/22/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "PillReminderViewController.h"
#import "AddAlarmViewController.h"
#import "ProductDetailV2ViewController.h"

@interface PillReminderViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *productTableView;
    NSMutableArray *productArray;
    NSMutableArray *diseaseArray;
    NSMutableArray *allergeyArray;
    NSMutableArray *productAllergyArray;
    UILabel *noDataLabel;
}

@end

@implementation PillReminderViewController

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    productArray = [[NSMutableArray alloc] init];
    diseaseArray = [[NSMutableArray alloc] init];
    allergeyArray = [[NSMutableArray alloc] init];
    productAllergyArray = [[NSMutableArray alloc] init];
    
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, customNavigationBar.frame.size.height/2 - 45/2, 45, 45);
    [backButton setBackgroundImage:[UIImage imageNamed:@"ThemeColorBackButton.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 60, 60);
    [addButton setTitle:NSLocalizedString(kPillReminderAddButton, nil) forState:UIControlStateNormal];
    [addButton setTitleColor:themeColor forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [customNavigationBar addSubview:addButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backButton.frame.size.width, 5, [UIScreen mainScreen].bounds.size.width - 2 * addButton.frame.size.width, customNavigationBar.frame.size.height/2 - 5)];
    titleLabel.text = NSLocalizedString(kPillReminderTitle, nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [customNavigationBar addSubview:titleLabel];
    
    UILabel *subTitileLabel = [[UILabel alloc] initWithFrame:CGRectMake(backButton.frame.size.width, titleLabel.frame.size.height, [UIScreen mainScreen].bounds.size.width - 2 * addButton.frame.size.width, customNavigationBar.frame.size.height/2)];
    subTitileLabel.text = @"Swipe left to add alarm";
    subTitileLabel.textColor = [UIColor lightGrayColor];
    subTitileLabel.textAlignment = NSTextAlignmentCenter;
    [customNavigationBar addSubview:subTitileLabel];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [customNavigationBar addSubview:separatorLine];
    [self.view addSubview:customNavigationBar];
    
    productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - customNavigationBar.frame.size.height) style:UITableViewStylePlain];
    productTableView.dataSource = self;
    productTableView.delegate = self;
    productTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    productTableView.backgroundColor = [UIColor clearColor];
    productTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:productTableView];
    
    noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, 44.0f)];
    noDataLabel.text = NSLocalizedString(kPillReminderNoData, nil);
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.hidden = YES;
    [self.view addSubview:noDataLabel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(kPillReminderLoading, nil);
    [self getAllUserProducts];
}

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addButtonAction
{
    AddAlarmViewController *vc = [[AddAlarmViewController alloc] initWithNibName:@"AddAlarmViewController" bundle:nil];
    vc.productArray = productArray;
    vc.diseaseArray = diseaseArray;
    vc.allergyArray = allergeyArray;
    vc.productAllergeyArray = productAllergyArray;
//    [vc.productArray addObjectsFromArray:productArray];
//    [vc.diseaseArray addObjectsFromArray:diseaseArray];
//    [vc.allergyArray addObjectsFromArray:allergeyArray];
//    [vc.productAllergeyArray addObjectsFromArray:productAllergyArray];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return productArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    NSDictionary *productObject = [productArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [productObject objectForKey:@"PROPRIETARY_NAME"];
    cell.textLabel.minimumScaleFactor = 0.5f;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [[productObject objectForKey:@"PRODUCT_ID"] integerValue])
        {
            NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
            [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
            NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
            [df2 setDateFormat:@"MMMM'-'dd'-'y"];
            NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
            [df3 setDateFormat:@"hh':'mm' 'a"];
            
//            //                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", productId] , @"PRODUCT_ID", [df stringFromDate:startDate], @"START_DATE",  [df stringFromDate:endDate], @"END_DATE", [NSString stringWithFormat:@"%@",intervalTimeTextField.text], @"INTERVAL", nil];
//            startDateTextField.text = [df2 stringFromDate:[df1 dateFromString:[notification.userInfo objectForKey:@"START_DATE"]]];
//            startTimeTextField.text = [df3 stringFromDate:[df1 dateFromString:[notification.userInfo objectForKey:@"START_DATE"]]];
//            NSLog(@"%@", notification.userInfo);
//            intervalTimeTextField.text = [notification.userInfo objectForKey:@"INTERVAL"];
//            endDateTextField.text = [notification.userInfo objectForKey:@"DURATION"];
//            
//            startDatePicker.date = [df1 dateFromString:[notification.userInfo objectForKey:@"START_DATE"]];
            cell.detailTextLabel.text =  [NSString stringWithFormat:@"Next alarm: %@ %@",[df2 stringFromDate:[df1 dateFromString:[notification.userInfo objectForKey:@"START_DATE"]]], [df3 stringFromDate:[df1 dateFromString:[notification.userInfo objectForKey:@"START_DATE"]]]];
            break;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductDetailV2ViewController *vc = [[ProductDetailV2ViewController alloc] initWithNibName:@"ProductDetailV2ViewController" bundle:nil];
    vc.productId = [[productArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_ID"];
    vc.productName = [[productArray objectAtIndex:indexPath.row] objectForKey:@"PROPRIETARY_NAME"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        
//        NSString *productId = [[productArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_ID"];
//        for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
//        {
//            if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
//            {
//                [[UIApplication sharedApplication] cancelLocalNotification:notification];
//            }
//        }
//        [productArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        if(productArray.count == 0)
//        {
//            noDataLabel.hidden = NO;
//        }
//        else
//        {
//            noDataLabel.hidden = YES;
//        }
//        
//        [self changeInSelectedProductArray];
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert)
//    {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
//}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Action to perform with Button 1");
                                        
                                        NSString *productId = [[productArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_ID"];
                                        for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
                                        {
                                            if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
                                            {
                                                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                                            }
                                        }
                                        [productArray removeObjectAtIndex:indexPath.row];
                                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                        
                                        if(productArray.count == 0)
                                        {
                                            noDataLabel.hidden = NO;
                                        }
                                        else
                                        {
                                            noDataLabel.hidden = YES;
                                        }
                                        
                                        [self changeInSelectedProductArray];

                                    }];
    button.backgroundColor = [UIColor redColor]; //arbitrary color
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Alarm" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         NSLog(@"Action to perform with Button2!");
                                         
                                         AddAlarmViewController *vc = [[AddAlarmViewController alloc] initWithNibName:@"AddAlarmViewController" bundle:nil];
                                         vc.productId = [[productArray objectAtIndex:indexPath.row]
                                                         objectForKey:@"PRODUCT_ID"];
                                         vc.isFromProductDetail = YES;
                                         vc.productName = [[productArray objectAtIndex:indexPath.row]
                                                           objectForKey:@"PROPRIETARY_NAME"];
                                         [self.navigationController pushViewController:vc animated:YES];
                                     }];
    button2.backgroundColor = [UIColor blueColor]; //arbitrary color
    
    return @[button, button2]; //array with all the buttons you want. 1,2,3, etc...
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    NSLog(@"%ld",(long)editingStyle);
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //tableview must be editable or nothing will work...
}

-(void)changeInSelectedProductArray
{
    [self updateUserProductsWithProductArray:productArray DiseaseArray:diseaseArray AllergenArray:allergeyArray AllergicProductArray:productAllergyArray];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)getAllUserProducts
{
    NSURL *URL = [NSURL URLWithString:getUserProducts];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 30;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSMutableDictionary *queryDictionary = [[NSMutableDictionary alloc] init];
    [queryDictionary setObject:[UserDefaultsManager getUserId] forKey:@"USR_ID"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        
        if(!error)
        {
            NSLog(@"getUserProducts %@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                NSArray *productIdArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"PRODUCT_LIST"]];
                NSArray *diseaseIdArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"DISEASE_LIST"]];
                NSArray *allergenIdArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"ALLERGEN_LIST"]];
                NSArray *allergicProductIdArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"ALLERGIC_PRODUCT_LIST"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [productArray removeAllObjects];
                    [productArray addObjectsFromArray:productIdArray];
                    if(productArray.count == 0)
                    {
                        noDataLabel.hidden = NO;
                    }
                    else
                    {
                        noDataLabel.hidden = YES;
                    }
                    
                    [diseaseArray removeAllObjects];
                    [diseaseArray addObjectsFromArray:diseaseIdArray];
                    
                    [allergeyArray removeAllObjects];
                    [allergeyArray addObjectsFromArray:allergenIdArray];
                    
                    [productAllergyArray removeAllObjects];
                    [productAllergyArray addObjectsFromArray:allergicProductIdArray];
                    [productTableView reloadData];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        
    }];
    [dataTask resume];
}

-(void)updateUserProductsWithProductArray:(NSArray*)_productArray DiseaseArray:(NSArray*)_diseaseArray AllergenArray:(NSArray*)allergenArray AllergicProductArray:(NSArray*)allergicProductArray
{
    NSURL *URL = [NSURL URLWithString:updateUserProducts];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 30;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *productIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *diseaseIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *allergenIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *allergicProductIdArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dict in _productArray)
    {
        [productIdArray addObject:[dict objectForKey:@"PRODUCT_ID"]];
    }
    
    for(NSDictionary *dict in _diseaseArray)
    {
        [diseaseIdArray addObject:[dict objectForKey:@"DISEASE_ID"]];
    }
    
    for(NSDictionary *dict in allergenArray)
    {
        [allergenIdArray addObject:[dict objectForKey:@"ENTITY_ID"]];
    }
    
    for(NSDictionary *dict in allergicProductArray)
    {
        [allergicProductIdArray addObject:[dict objectForKey:@"ENTITY_ID"]];
    }
    
    NSError *error;
    NSMutableDictionary *queryDictionary = [[NSMutableDictionary alloc] init];
    [queryDictionary setObject:[UserDefaultsManager getUserId] forKey:@"USR_ID"];
    [queryDictionary setObject:productIdArray forKey:@"PRODUCT_ID_LIST"];
    [queryDictionary setObject:diseaseIdArray forKey:@"DISEASE_ID_LIST"];
    [queryDictionary setObject:allergenIdArray forKey:@"ALLERGEN_ID_LIST"];
    [queryDictionary setObject:allergicProductIdArray forKey:@"ALLERGIC_PRODUCT_ID_LIST"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            
        }
        
        if(!error)
        {
            NSLog(@"updateUserProducts %@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                
            }
            else
            {
                
            }
        }
        else
        {
            NSLog(@"%@",error);
        }
        
    }];
    [dataTask resume];
}

@end
