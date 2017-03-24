//
//  HistoryViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/6/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "HistoryViewController.h"
#import "ProductDetailViewController.h"
#import "ProductDetailV2ViewController.h"

@interface HistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *historyArray;
@property(nonatomic, strong) NSArray *dateArray;

@end

@implementation HistoryViewController
{
    float headerViewHeight;
}

@synthesize historyArray;
@synthesize dateArray;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withHistoryArray:(NSArray*)_historyArray DateArray:(NSArray*)_dateArray
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.historyArray = _historyArray;
        self.dateArray = _dateArray;
        
        headerViewHeight = 60.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarView.frame.size.height + 1, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    historyTableView.dataSource = self;
    historyTableView.delegate = self;
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    historyTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:historyTableView];
    
//    [self getHistoryDataCompletion:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [historyTableView reloadData];
//        });
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"number of section %lu",self.historyArray.count);
    return self.historyArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"number of rows in section %lu", [[[[historyArray objectAtIndex:section] objectForKey:[dateArray objectAtIndex:section]] objectForKey:@"productName"] count]);
    return [[[[historyArray objectAtIndex:section] objectForKey:[dateArray objectAtIndex:section]] objectForKey:@"productName"] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [[[[historyArray objectAtIndex:indexPath.section] objectForKey:[dateArray objectAtIndex:indexPath.section]] objectForKey:@"productName"] objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.detailTextLabel.text = [[[[historyArray objectAtIndex:indexPath.section] objectForKey:[dateArray objectAtIndex:indexPath.section]] objectForKey:@"time"] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 0.5f)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lineView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerViewHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, headerViewHeight)];
    headerView.backgroundColor = [UIColor colorWithRed:239.0f/255 green:239.0f/255 blue:244.0f/255 alpha:1.0f];
    
    NSString *dateString = [dateArray objectAtIndex:section];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMM'-'dd'-'y"];
    NSString *todayString = [df stringFromDate:[NSDate date]];
    NSString *yesterDayString = [df stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-86400]];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:headerView.frame];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor lightGrayColor];
    if([dateString isEqualToString:todayString])
    {
        dateLabel.text = @"TODAY";
    }
    else if([dateString isEqualToString:yesterDayString])
    {
        dateLabel.text = @"YESTERDAY";
    }
    else
    {
        dateLabel.text = dateString;
    }
    
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:dateLabel];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [ServerCommunicationUser insertIntoSearchHistoryByProductId:[[[[historyArray objectAtIndex:indexPath.section] objectForKey:[dateArray objectAtIndex:indexPath.section]] objectForKey:@"productId"] objectAtIndex:indexPath.row] byUserId:[UserDefaultsManager getUserId]];
    
    ProductDetailV2ViewController *vc = [[ProductDetailV2ViewController alloc] initWithNibName:@"ProductDetailV2ViewController" bundle:nil];
    vc.productId = [[[[historyArray objectAtIndex:indexPath.section] objectForKey:[dateArray objectAtIndex:indexPath.section]] objectForKey:@"productId"] objectAtIndex:indexPath.row];
    vc.productName = [[[[historyArray objectAtIndex:indexPath.section] objectForKey:[dateArray objectAtIndex:indexPath.section]] objectForKey:@"productName"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)resetButtonAction:(UIButton*)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:NSLocalizedString(kHistoryAlertMessage, nil)
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(kHistoryAlertOk, nil) style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [ServerCommunicationUser deleteSearchHistoyForUserId:[UserDefaultsManager getUserId]];
                                                   historyArray = nil;
                                                   [historyTableView reloadData];
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(kHistoryAlertDismiss, nil) style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

//-(void)getHistoryDataCompletion:(void (^)(void))completionBlock
//{
//    [ServerCommunicationUser getSearchHistoyForUserId:[UserDefaultsManager getUserId] completion:^(NSArray *arr) {
//        NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
//        [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
//        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
//        [df2 setDateFormat:@"MMMM'-'dd'-'y"];
//        NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
//        [df3 setDateFormat:@"HH':'mm' 'a"];
//        
//        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
//            NSDate *d1 = [df1 dateFromString:obj1[@"Date"]];
//            NSDate *d2 = [df1 dateFromString:obj2[@"Date"]];
//            
//            return [d2 compare:d1]; // descending order
//        }];
//        NSMutableArray *datesArray = [[NSMutableArray alloc] init];
//        NSMutableArray *uniqueDateArray = [NSMutableArray array];
//        NSMutableSet *processedSet = [[NSMutableSet alloc] init];
//        for(NSDictionary *dict in arr)
//        {
//            NSDate *date = [df1 dateFromString: [dict objectForKey:@"Date"]];
//            [datesArray addObject:[df2 stringFromDate:date]];
//        }
//        
//        for(NSString *str in datesArray)
//        {
//            if(![processedSet containsObject:str])
//            {
//                [uniqueDateArray addObject:str];
//                [processedSet addObject:str];
//            }
//        }
//        
//        NSMutableArray *finalArray = [[NSMutableArray alloc] init];
//        for(int i = 0; i < [uniqueDateArray count]; i++)
//        {
//            NSMutableArray *tmpProdArr = [[NSMutableArray alloc] init];
//            NSMutableArray *tmpProdIdArr = [[NSMutableArray alloc] init];
//            NSMutableArray *timeArr = [[NSMutableArray alloc] init];
//            
//            for(NSDictionary *dict in arr)
//            {
//                if([[uniqueDateArray objectAtIndex:i] isEqualToString:[df2 stringFromDate:[df1 dateFromString:[dict objectForKey:@"Date"]]]])
//                {
//                    [tmpProdArr addObject:[dict objectForKey:@"PROPRIETARY_NAME"]];
//                    [tmpProdIdArr addObject:[dict objectForKey:@"PRODUCT_ID"]];
//                    [timeArr addObject:[df3 stringFromDate:[df1 dateFromString:[dict objectForKey:@"Date"]]]];
//                }
//            }
//            NSDictionary *totalObjectDict = [[NSDictionary alloc] initWithObjectsAndKeys:tmpProdArr, @"productName", tmpProdIdArr, @"productId", timeArr, @"time", nil];
//            NSDictionary *tmpDic = [[NSDictionary alloc] initWithObjectsAndKeys:totalObjectDict, [uniqueDateArray objectAtIndex:i], nil];
//            [finalArray addObject:tmpDic];
//        }
//        
////        for(NSDictionary *dict in finalArray)
////        {
////            NSLog(@"%@",dict);
////        }
//        historyArray = finalArray;
//        dateArray = uniqueDateArray;
//        completionBlock();
////        dispatch_async(dispatch_get_main_queue(), ^{
////            [historyTableView reloadData];
////        });
//    }];
//}

@end
