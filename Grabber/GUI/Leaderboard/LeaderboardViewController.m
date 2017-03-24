//
//  LeaderboardViewController.m
//  Grabber
//
//  Created by World on 4/12/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LeaderboardObject.h"

@interface LeaderboardViewController () <ASIHTTPRequestDelegate>
{
    ASIHTTPRequest *getLeaderBoardRequest;
    
    NSMutableArray *leaderBoardObjectArray;
    
    UIAlertView *loadingAlert;
}

@end

@implementation LeaderboardViewController

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
    
    leaderBoardObjectArray = [[NSMutableArray alloc] init];
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationItem.title = @"Leaderboard";
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",baseUrl];
    [urlStr appendFormat:@"%@",leaderBoardApi];
    [urlStr appendFormat:@"%@",[UserDefaultsManager sessionToken]];
    NSLog(@"urlStr %@",urlStr);
    
    getLeaderBoardRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    getLeaderBoardRequest.delegate = self;
    [getLeaderBoardRequest setTimeOutSeconds:60];
    [getLeaderBoardRequest startAsynchronous];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..." message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [loadingAlert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"%@",request.responseString);
    NSArray *data = [responseObject objectForKey:@"data"];
    for(int i = 0; i < data.count; i++)
    {
        NSDictionary *tmpDic = [data objectAtIndex:i];
        
        LeaderboardObject *lo = [[LeaderboardObject alloc] init];
        lo.point = [[tmpDic objectForKey:@"reward"] intValue];
        lo.name = [tmpDic objectForKey:@"name"];
        
        [leaderBoardObjectArray addObject:lo];
    }
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"point"
                                                                    ascending:NO];
    NSArray *sortDescriptors2 = [NSArray arrayWithObject:sortDescriptor2];
    NSArray *sortedArray2 = [leaderBoardObjectArray sortedArrayUsingDescriptors:sortDescriptors2];
    [leaderBoardObjectArray removeAllObjects];
    [leaderBoardObjectArray addObjectsFromArray:sortedArray2];
    [containerTableView reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Could not connect to server"
                               delegate:nil
                      cancelButtonTitle:@"Dismiss"
                      otherButtonTitles:nil]
     show];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return leaderBoardObjectArray.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:131.0f/255.0f green:73.0f/255.0f blue:71.0f/255.0f alpha:1.0f];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LeaderboardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LeaderboardObject *lo = [leaderBoardObjectArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = lo.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", lo.point];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifier = @"defaultHeader";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footerView)
    {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    v.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:v];
    
    UIImageView *leaderBoardIcon = [[UIImageView alloc] initWithFrame:CGRectMake(160 - 25, 10, 50, 50)];
    leaderBoardIcon.image = [UIImage imageNamed:@"LeaderBoardIconHeader.png"];
    [footerView addSubview:leaderBoardIcon];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65.0f;
}

@end
