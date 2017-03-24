//
//  DrawerViewController.m
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "DrawerViewController.h"
#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "TimeLineViewController.h"
#import "ContactsViewController.h"
#import "NotificationViewController.h"
#import "NotificationScanner.h"
#import "TestViewController.h"
#import "RA_ImageCache.h"
#import "MessagesViewController.h"
#import "InboxSynchronizer.h"
#import "WakeWorldViewController.h"
#import "ProfileViewController.h"
#import "PhonebookManager.h"
#import <AddressBook/AddressBook.h>
#import "AppDelegate.h"
#import "MessageRoom.h"
#import "MessageRoomSynchronizer.h"

@interface DrawerViewController()
{
    TimeLineViewController *timeLineVC;
    ContactsViewController *contactVC;
    NotificationViewController *notificationVC;
    SettingsViewController *settingsVC;
    TestViewController *testVC;
    MessagesViewController *messageVC;
    WakeWorldViewController *wakeVC;
    ProfileViewController *profileVC;
    
    RA_ImageCache *imgCh;
}

@property (nonatomic, strong) UIViewController *rightViewController;

@end

@implementation DrawerViewController

@synthesize isWakeUpCallReceived;

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
    
    imgCh = [[RA_ImageCache alloc] init];
    
    settingsVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingsVC.delegate = self;
    
    contactVC = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
    contactVC.drawerViewDelegate = self;
    
    timeLineVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
    timeLineVC.drawerViewDelegate = self;
    self.rightViewController = timeLineVC;
    
    testVC = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    testVC.delegate = self;
    
    wakeVC = [[WakeWorldViewController alloc] initWithNibName:@"WakeWorldViewController" bundle:nil];
    wakeVC.delegate = self;
    
    notificationVC = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    notificationVC.delegate = self;
    
    messageVC = [[MessagesViewController alloc] initWithNibName:@"MessagesViewController" bundle:nil];
    messageVC.delegate = self;
    
    profileVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileVC.delegate = self;
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NotificationScanner getInstance] startNotificationScanner];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationCell:) name:kNotificationArrival object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIncomingMessageRemoteNotificationAction) name:kIncomingMessageArrivedRemoteNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContactWokenUpRemoteNotificationAction) name:kWokenUpRemoteNotificationArrived object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOtherTypeRemoteNotificationAction) name:kOtherTypeRemoteNotificationArrived object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlarmArrivedLocalNotification) name:kAlarmNotificationArrived object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kProfileUpdated object:nil];
    
    [[InboxSynchronizer getInstance] startSynchronizer];
//    [self getMessageRooms];
    
    if([UserDefaultsManager phoneBookArray].count < 1)
    {
        [[PhonebookManager getInstance] getPhoneBookContact];
    }
    
    CFErrorRef err;
    ABAddressBookRef ntificationaddressbook = ABAddressBookCreateWithOptions(NULL, &err);
    ABAddressBookRegisterExternalChangeCallback(ntificationaddressbook, MyAddressBookExternalChangeCallback, nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self showCurrentViewControllerAnimated:NO];
    open = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)getMessageRooms
{
    NSError *error = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate foregroundManagedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"MessageRoom" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    for(int i = 0; i < fetchedResult.count; i++)
    {
        MessageRoom *msgRoomObject = [fetchedResult objectAtIndex:i];
        
        [[MessageRoomSynchronizer getInstance] synchronizeOnce:msgRoomObject];
    }
}

void MyAddressBookExternalChangeCallback (ABAddressBookRef ntificationaddressbook,CFDictionaryRef info,void *context)
{
    [[PhonebookManager getInstance] getPhoneBookContact];
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactViewControllerToFront object:nil];
}

-(void)reloadTableView
{
    [containerTableView reloadData];
}

-(void)handleAlarmArrivedLocalNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kWakeUpAlertShow object:nil];
    
    if(!open)
    {
        [self hideCurrentViewController];
    }
    
    self.rightViewController = wakeVC;
    [self showCurrentViewControllerAnimated:NO];
    open = NO;
}

-(void)handleOtherTypeRemoteNotificationAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationViewControllerToFront object:nil];
    
    if(!open)
    {
        [self hideCurrentViewController];
    }
    
    self.rightViewController = notificationVC;
    [self showCurrentViewControllerAnimated:NO];
    open = NO;
}

-(void)handleContactWokenUpRemoteNotificationAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTimeLineViewControllerToFront object:nil];
    
    if(!open)
    {
        [self hideCurrentViewController];
    }
    
    self.rightViewController = timeLineVC;
    [self showCurrentViewControllerAnimated:NO];
    open = NO;
}

-(void)handleIncomingMessageRemoteNotificationAction
{
    if(!open)
    {
        [self hideCurrentViewController];
    }
    
    self.rightViewController = messageVC;
    [self showCurrentViewControllerAnimated:NO];
    open = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 1;
    }
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell.imageView.image = [UIImage imageNamed:@"TimeLineIcon.png"];
            cell.textLabel.text = @"Timeline";
        }
        else if(indexPath.row == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"ContactsIcon.png"];
            cell.textLabel.text = @"Contacts";
        }
        else if(indexPath.row == 2)
        {
            cell.imageView.image = [UIImage imageNamed:@"WakeWorldIcon.png"];
            cell.textLabel.text = @"Notification";
        }
        else if(indexPath.row == 3)
        {
            cell.imageView.image = [UIImage imageNamed:@"WakeWorldIcon.png"];
            cell.textLabel.text = @"Wake World";
        }
        else if(indexPath.row == 4)
        {
            cell.imageView.image = [UIImage imageNamed:@"InboxIcon.png"];
            cell.textLabel.text = @"Inbox";
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            cell.imageView.image = [UIImage imageNamed:@"SettingsIcon.png"];
            cell.textLabel.text = @"Settings";
        }
        else if(indexPath.row == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"TimeLineIcon.png"];
            cell.textLabel.text = @"Logout";
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        if(kIsThreePointFiveInch)
        {
            return 76;
        }
        return 160;
    }
    return 140;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        static NSString *identifier = @"defaultHeader";
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (!footerView)
        {
            footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        }
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 140)];
        v.backgroundColor = [UIColor clearColor];
        [footerView addSubview:v];
        
        UIImageView *profilePicIcon = [[UIImageView alloc] initWithFrame:CGRectMake(125 - 35, 10, 71, 71)];
        profilePicIcon.layer.cornerRadius = 35;
        profilePicIcon.layer.masksToBounds = YES;
        profilePicIcon.contentMode = UIViewContentModeScaleAspectFit;
        if(![[UserDefaultsManager userProfilePicId] isEqualToString:@""])
        {
            NSMutableString *downloadImageUrlStr = [[NSMutableString alloc] init];
            [downloadImageUrlStr appendFormat:@"%@/",kRootUrl];
            [downloadImageUrlStr appendFormat:@"%@?",kDownloadImageApi];
            
            profilePicIcon.image = [imgCh getImage:[NSString stringWithFormat:@"%@imgid=%@",downloadImageUrlStr,[UserDefaultsManager userProfilePicId]]];
        }
        else
        {
            profilePicIcon.image = [UIImage imageNamed:@"ProPicUploadIcon.png"];
        }
        
        profilePicIcon.layer.borderColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]].CGColor;
        profilePicIcon.layer.borderWidth = 3.0f;
        
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(125 - 50, 100, 100, 20)];
        userNameLabel.text = [UserDefaultsManager userName];
        userNameLabel.textColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]];
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        
        UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        profileButton.backgroundColor = [UIColor clearColor];
        profileButton.frame = CGRectMake(125 - 50, 10, 100, 111);
        [profileButton addTarget:self action:@selector(profileButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:profileButton];
        
        [footerView addSubview:profilePicIcon];
        [footerView addSubview:userNameLabel];
        
        return footerView;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            self.rightViewController = timeLineVC;
            [[NSNotificationCenter defaultCenter] postNotificationName:kTimeLineViewControllerToFront object:nil];
        }
        else if(indexPath.row == 1)
        {
            self.rightViewController = contactVC;
        }
        else if(indexPath.row == 2)
        {
            self.rightViewController = notificationVC;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationViewControllerToFront object:nil];
            
            UITableViewCell *cell = [containerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            cell.accessoryView = nil;
        }
        else if(indexPath.row == 3)
        {
            self.rightViewController = wakeVC;
        }
        else if(indexPath.row == 4)
        {
            self.rightViewController = messageVC;
            [[NSNotificationCenter defaultCenter] postNotificationName:kMessageViewControllerToFront object:nil];
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            self.rightViewController = settingsVC;
        }
        else if(indexPath.row == 1)
        {
            [UserDefaultsManager setKeepMeLoggedIn:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    
    [self showCurrentViewControllerAnimated:YES];
    open = NO;
}

-(void)profileButtonAction
{
    self.rightViewController = profileVC;
    
    [self showCurrentViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProfileViewControllerComeToFront object:nil];
    open = NO;
}

-(void)updateNotificationCell:(NSNotification*)_notification
{
    NSDictionary *userInfo = _notification.userInfo;
    NSLog(@"totalNotification %@",[userInfo objectForKey:kNotificationArrivalTotalKey]);
    
    if([[userInfo objectForKey:kNotificationArrivalTotalKey] intValue] > 0)
    {
        UITableViewCell *cell = [containerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        UILabel *totalNotificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        totalNotificationLabel.text = [userInfo objectForKey:kNotificationArrivalTotalKey];
        totalNotificationLabel.textColor = [UIColor lightGrayColor];
        totalNotificationLabel.backgroundColor = [UIColor clearColor];
        totalNotificationLabel.textAlignment = NSTextAlignmentCenter;
        totalNotificationLabel.font = [UIFont systemFontOfSize:11.0f];
        
        UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YellowCircle.png"]];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [rightView addSubview:bgImgView];
        [rightView addSubview:totalNotificationLabel];
        
        cell.accessoryView = rightView;
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer*)r
{
//    [self showCurrentViewControllerAnimated:YES];
    open = YES;
    [self showDrawerView];
}

-(void)showCurrentViewControllerAnimated:(BOOL)animated
{
    [self.rightViewController.view removeGestureRecognizer:tapRecognizer];
    
    if (animated)
    {
        self.rightViewController.view.frame = CGRectMake(250, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [self.view addSubview:self.rightViewController.view];
    [self.view bringSubviewToFront:self.rightViewController.view];
    
    if (animated)
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.rightViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    else
    {
        self.rightViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.rightViewController.view.alpha = 1.0;
    
    if(self.rightViewController == contactVC)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kContactViewControllerToFront object:nil];
    }
}

-(void)hideCurrentViewController
{
    self.rightViewController.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.rightViewController.view.layer.shadowOpacity = 0.5f;
    self.rightViewController.view.layer.shadowOffset = CGSizeMake(-5.0f, 0);
    self.rightViewController.view.layer.shadowRadius = 7.0f;
    
    [self.rightViewController.view addGestureRecognizer:tapRecognizer];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.rightViewController.view.frame = CGRectMake(250, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)showDrawerView
{
    if (open)
    {
        [self showCurrentViewControllerAnimated:YES];
        open = NO;
    }
    else
    {
        [self hideCurrentViewController];
        open = YES;
    }
}

-(void)hideDrawerView
{
    [self showCurrentViewControllerAnimated:YES];
}

@end
