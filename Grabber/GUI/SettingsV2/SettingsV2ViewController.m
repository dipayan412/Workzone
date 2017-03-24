//
//  SettingsV2ViewController.m
//  Grabber
//
//  Created by World on 4/7/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SettingsV2ViewController.h"
#import "AssociatePagesCell.h"
#import "SettingsV2Cell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "SelectEmailViewController.h"
#import "MyPointsViewController.h"
#import "LeaderboardViewController.h"
#import <Pinterest/Pinterest.h>
#import "ConfigureViewController.h"
#import "LogOutCell.h"
#import "LoginV2ViewController.h"

@interface SettingsV2ViewController () <AssociatePagesCellDelegate, MFMailComposeViewControllerDelegate, ASIHTTPRequestDelegate, LogOutCellDelegate, CLLocationManagerDelegate>
{
    AssociatePagesCell *faceBookCell;
    AssociatePagesCell *twitterCell;
    AssociatePagesCell *instagramCell;
    AssociatePagesCell *pinterestCell;
    
    NSMutableArray *emailArray;
    
    UIAlertView *loadingAlert;
    
    ASIHTTPRequest *getMyPointsRequest;
    
    LogOutCell *logOutCell;
    
    CLLocationManager *userLocationManeger;
    CLLocation *userLocation;
}

@end

@implementation SettingsV2ViewController

@synthesize proPic;

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
    
    userLocationManeger = [[CLLocationManager alloc] init];
    userLocationManeger.delegate = self;
    [userLocationManeger startUpdatingLocation];
    
    containerTableView.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:68.0f/255.0f blue:66.0f/255.0f alpha:1.0f];//[UIColor colorWithRed:164.0f/255.0f green:91.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    self.navigationItem.title = @"Settings";
    
    emailArray = [[NSMutableArray alloc] init];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles: nil];
    
    logOutCell = [[LogOutCell alloc] init];
    logOutCell.delegate = self;
    
    //Code to get user admin pages
    
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error)
                              {
                                  NSDictionary *permissions= [(NSArray *)[result data] objectAtIndex:0];
                                  if (![permissions objectForKey:@"manage_pages"])
                                  {
                                      [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObjects:@"manage_pages", nil] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error){
                                          
                                          [FBRequestConnection startWithGraphPath:@"/me/accounts"
                                                                       parameters:nil
                                                                       HTTPMethod:@"GET"
                                                                completionHandler:^(
                                                                                    FBRequestConnection *connection,
                                                                                    id result,
                                                                                    NSError *error
                                                                                    ) {
                                                                    /* handle the result */
                                                                    NSLog(@"results %@",[[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"name"]);
                                                                }];
                                      }];
                                  }
                                  else
                                  {
                                      [FBRequestConnection startWithGraphPath:@"/me/accounts"
                                                                   parameters:nil
                                                                   HTTPMethod:@"GET"
                                                            completionHandler:^(
                                                                                FBRequestConnection *connection,
                                                                                id result,
                                                                                NSError *error
                                                                                ) {
                                                                /* handle the result */
                                                                NSLog(@"results %@",result);
                                                                NSString *pageId = [[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"id"];
                                                                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                        @"abc", @"name",
                                                                                        @"This is a test message", @"message",
                                                                                        @"143754028991291", @"place",
                                                                                        @"http://ec2-54-186-77-78.us-west-2.compute.amazonaws.com/static/74c5eb68-8f52-406d-8d4a-87daf6e766f6image.jpeg", @"image",
                                                                                        @"Build great social apps and get more installs.", @"caption",
                                                                                        @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                                                                        nil
                                                                                        ];
                                                                /* make the API call */
                                                                [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/feed",pageId]
                                                                                             parameters:params
                                                                                             HTTPMethod:@"POST"
                                                                                      completionHandler:^(
                                                                                                          FBRequestConnection *connection,
                                                                                                          id result,
                                                                                                          NSError *error
                                                                                                          ) {
                                                                                          /* handle the result */
                                                                                          NSLog(@"id %@",result);
                                                                                      }];
                                                            }];
                                  }
                              }
                          }];
    
//    [FBRequestConnection startWithGraphPath:@"/me/objects/place"
//                                 parameters:nil
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              NSLog(@"result %@",result);
//                          }];
    
//    [FBRequestConnection startForPostStatusUpdate:@"Awesome place!"
//                                            place:@"143754028991291"
//                                             tags:nil
//                                completionHandler:^(FBRequestConnection *connection,
//                                                    id result,
//                                                    NSError *error) {
//                                    //verify result
//                                }
//     ];
    
//    [FBRequestConnection startWithGraphPath:@"me/feed"
//                                 parameters:@{@"place":@"110506962309835"}
//                                 HTTPMethod:@"POST"
//                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                              //verify result
//                          }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(userLocation == nil)
    {
        userLocation = [locations lastObject];
        
        [FBRequestConnection startForPlacesSearchAtCoordinate:userLocation.coordinate
                                               radiusInMeters:1000
                                                 resultsLimit:5
                                                   searchText:nil
                                            completionHandler:^(FBRequestConnection *connection,id result,NSError *error){
                                                NSLog(@"results %@",result);
                                                
                                            }];
    }
}

-(void)logoutButtonAction
{
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    
    LoginV2ViewController *vc = (LoginV2ViewController*)[[self.navigationController viewControllers] objectAtIndex:0];
    vc.isFirstTimeLoginDone = NO;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    ConfigureViewController *vc = [[ConfigureViewController alloc] initWithNibName:@"ConfigureViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableView delegate stack

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 2;
            
        case 1:
            return 2;
            
        case 2:
            return 4;
            
        default:
            break;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            faceBookCell = [[AssociatePagesCell alloc] initWithSwitchValue:[UserDefaultsManager isFacebookEnabled] forCellType:kFacebookCell];
            faceBookCell.delegate = self;
            faceBookCell.cellIconImageView.image = [UIImage imageNamed:@"FacebookIcon.png"];
            faceBookCell.cellNameLabel.text = @"Facebook Connect";
            return faceBookCell;
        }
        else if(indexPath.row == 1)
        {
            twitterCell = [[AssociatePagesCell alloc] initWithSwitchValue:[UserDefaultsManager isTwitterEnabled] forCellType:kTwitterCell];
            twitterCell.delegate = self;
            twitterCell.cellIconImageView.image = [UIImage imageNamed:@"TwitterIcon2.png"];
            twitterCell.cellNameLabel.text = @"Twitter Connect";
            return twitterCell;
        }
        else if(indexPath.row == 2)
        {
            instagramCell = [[AssociatePagesCell alloc] initWithSwitchValue:[UserDefaultsManager isInstagramEnabled] forCellType:kInstagramCell];
            instagramCell.delegate = self;
            instagramCell.cellIconImageView.image = [UIImage imageNamed:@"instagramIcon.png"];
            instagramCell.cellNameLabel.text = @"Instagram Connect";
            return instagramCell;
        }
        else if(indexPath.row == 3)
        {
            pinterestCell = [[AssociatePagesCell alloc] initWithSwitchValue:[UserDefaultsManager isPinterestEnabled] forCellType:kPinterestCell];
            pinterestCell.delegate = self;
            pinterestCell.cellIconImageView.image = [UIImage imageNamed:@"pinterestIcon.png"];
            pinterestCell.cellNameLabel.text = @"Pinterest Connect";
            return pinterestCell;
        }
    }
    static NSString *identifier = @"SettingsCell";
    SettingsV2Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        if(indexPath.section == 0)
        {
            cell = [[SettingsV2Cell alloc] initWithCustomCellIndicator:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else if(indexPath.section == 2)
        {
            cell = [[SettingsV2Cell alloc] initWithCustomCellIndicator:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
            {
                case 0:
                    cell.cellIconImageView.image = self.proPic;
                    cell.cellIconImageView.contentMode = UIViewContentModeScaleAspectFit;
                    cell.cellNameLabel.text = [UserDefaultsManager fbUsername];
                    break;
                
                case 1:
                    cell.cellIconImageView.image = [UIImage imageNamed:@"MailBoxIcon.png"];
                    cell.cellNameLabel.text = [UserDefaultsManager fbEmail];
                    break;
                
                default:
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row)
            {
                case 0:
                    cell.cellIconImageView.image = [UIImage imageNamed:@"MyPointsIcon2.png"];
                    cell.cellNameLabel.text = @"My Points";
                    break;
                
                case 1:
                    cell.cellIconImageView.image = [UIImage imageNamed:@"LeaderBoardIcon2.png"];
                    cell.cellNameLabel.text = @"Leaderboard";
                    break;
                
                case 2:
                    cell.cellIconImageView.image = [UIImage imageNamed:@"ShareToWinIcon.png"];
                    cell.cellNameLabel.text = @"Share to Win";
                    break;
                    
                case 3:{
                    return logOutCell;
                }
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 30;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *hView = (UITableViewHeaderFooterView*)view;
    
    hView.textLabel.font = [UIFont systemFontOfSize:14];
    hView.textLabel.textColor = [UIColor colorWithRed:212.0f/255.0f green:185.0f/255.0f blue:184.0f/255.0f alpha:1.0f];
    
    hView.contentView.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:68.0f/255.0f blue:66.0f/255.0f alpha:1.0f];;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 2 && indexPath.row == 3)
    {
        ConfigureViewController *vc = [[ConfigureViewController alloc] initWithNibName:@"ConfigureViewController" bundle:nil];
        [self changeBackbuttonTitle];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 2 && indexPath.row == 2)
    {
        SelectEmailViewController *vc = [[SelectEmailViewController alloc] initWithNibName:@"SelectEmailViewController" bundle:nil];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.navigationBar.barTintColor = kNavigationBarColor;
        nc.navigationBar.translucent = NO;
        [self.navigationController presentViewController:nc animated:YES completion:nil];
    }
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        LeaderboardViewController *vc = [[LeaderboardViewController alloc] initWithNibName:@"LeaderboardViewController" bundle:nil];
        [self changeBackbuttonTitle];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        [loadingAlert show];
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"%@",baseUrl];
        [urlStr appendFormat:@"%@",getMyRewardPointsApi];
        [urlStr appendFormat:@"%@/",[UserDefaultsManager sessionToken]];
        
        NSLog(@"Request: %@", urlStr);
        
        getMyPointsRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        getMyPointsRequest.delegate = self;
        [getMyPointsRequest startAsynchronous];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifier = @"defaultHeader";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footerView)
    {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        
//        footerView.textLabel.frame = CGRectMake(10, 0, footerView.frame.size.width - 20, footerView.frame.size.height);
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 35)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:212.0f/255.0f green:185.0f/255.0f blue:184.0f/255.0f alpha:1.0f];
    
    switch (section)
    {
        case 0:{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"EDIT" forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(260, 7, 40, 20)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [btn addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:btn];
            
            label.text = @"PERSONAL INFORMATION";
            break;
        }
        case 1:
            label.text = @"SOCIAL NETWORK";
            break;
            
        case 2:
            label.text = @"POINTS AND REWARDS";
            break;
            
        default:
            break;
    }
    [footerView addSubview:label];
    return footerView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}

-(void)editButtonAction
{
    
}

#pragma mark ASIHTTPRequest stack

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSLog(@"Response: %@", request.responseString);
    
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your total Reward Point"
                                                    message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[request.error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)logOutButtonTapped
{
    [self logoutButtonAction];
}

-(void)customSwitchTappedChangedValueTo:(BOOL)value forCellType:(kCellTypes)_cellType
{
    switch (_cellType)
    {
        case kFacebookCell:
            [UserDefaultsManager setFacebookEnabled:value];
            break;
        
        case kTwitterCell:{
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                [UserDefaultsManager setTwitterEnabled:value];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Configure your Twitter account in Settings page"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [twitterCell.fieldSwitch setOn:NO];
            }
        }
            
            break;
            
        case kInstagramCell:{
            NSURL *instagramURL = [NSURL URLWithString:@"instagram://location?id=1"];
            if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
            {
                [UserDefaultsManager setInstagramEnabled:value];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Install Instagram from Appstore to enable"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
            
            break;
            
        case kPinterestCell:{
            Pinterest *pin = [[Pinterest alloc] initWithClientId:kPinterestAppID];
            if([pin canPinWithSDK])
            {
                [UserDefaultsManager setPinterestEnabled:value];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Install Pinterest from Appstore to enable"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
            
            break;
            
        default:
            break;
    }
    
//    [containerTableView reloadData];
}

-(void)changeBackbuttonTitle
{
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

@end
