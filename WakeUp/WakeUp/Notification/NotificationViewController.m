//
//  NotificationViewController.m
//  WakeUp
//
//  Created by World on 6/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"

@interface NotificationViewController () <ASIHTTPRequestDelegate, NotificationCellDelegate>
{
    ASIHTTPRequest *notificationRequest;
    ASIHTTPRequest *acceptRequest;
    ASIHTTPRequest *denyRequest;
    
    NotificationCell *selectedCell;
    
    NSDictionary *notificationDictionary;
}

@end

@implementation NotificationViewController

@synthesize delegate;

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
    
    [self notificationCall];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadController) name:kNotificationViewControllerToFront object:nil];
    
    notificationDictionary = [[NSDictionary alloc] init];
    
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)reloadController
{
    [self notificationCall];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.delegate)
    {
        [self.delegate showDrawerView];
    }
}

-(void)notificationCall
{
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Loading..."];
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@&",kNotificationApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    
    NSLog(@"notificationUrlStr %@",urlStr);
    
    notificationRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    notificationRequest.delegate = self;
    [notificationRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == notificationRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"notificationRequest return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
        notificationDictionary = responseObject;
        
        [UserDefaultsManager hideBusyScreenToView:self.view];
        
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            [containerTableView reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(request == acceptRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"acceptRequest return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
        
        [UserDefaultsManager hideBusyScreenToView:self.view];
        
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            [selectedCell contactRequestPerformAction:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(request == denyRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"denyRequest return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
        
        [UserDefaultsManager hideBusyScreenToView:self.view];
        
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            [selectedCell contactRequestPerformAction:NO];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[notificationDictionary objectForKey:@"body"] objectForKey:@"notifications"] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellId";
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    cell.textLabel.text = [[[[notificationDictionary objectForKey:@"body"] objectForKey:@"notifications"] objectAtIndex:indexPath.row] objectForKey:@"message"];
    cell.textLabel.font = [UIFont systemFontOfSize:9.0];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)acceptButtonActionAtRow:(int)_row
{
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Accepting Request"];
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kAcceptContactApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&rid=%@",[[[[notificationDictionary objectForKey:@"body"] objectForKey:@"notifications"] objectAtIndex:_row] objectForKey:@"rid"]];
    [urlStr appendFormat:@"&nid=%@",[[[[notificationDictionary objectForKey:@"body"] objectForKey:@"notifications"] objectAtIndex:_row] objectForKey:@"id"]];
    
    NSLog(@"acptCntctUrl %@",[[[[notificationDictionary objectForKey:@"body"] objectForKey:@"notifications"] objectAtIndex:_row] objectForKey:@"message"]);
    NSLog(@"acptCntctUrl %@",urlStr);
    
    selectedCell = (NotificationCell*)[containerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_row inSection:0]];
    
    acceptRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    acceptRequest.delegate = self;
    [acceptRequest startAsynchronous];
}

-(void)denyButtonActionAtRow:(int)_row
{
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Declining Request"];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@&",kDeclineContactApi];
    [urlStr appendFormat:@"phone=%@&",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"rid=%@",[[[[notificationDictionary objectForKey:@"body"] objectForKey:@"notifications"] objectAtIndex:_row] objectForKey:@"rid"]];
    
    NSLog(@"denyCntctUrl %@",[[[[notificationDictionary objectForKey:@"body"] objectForKey:@"notifications"] objectAtIndex:_row] objectForKey:@"message"]);
    NSLog(@"denyCntctUrl %@",urlStr);
    
    selectedCell = (NotificationCell*)[containerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_row inSection:0]];
    
    denyRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    denyRequest.delegate = self;
    [denyRequest startAsynchronous];
}

@end
