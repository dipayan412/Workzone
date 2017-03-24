//
//  SettingController.m
//  RenoMate
//
//  Created by yogesh ahlawat on 18/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import "SettingController.h"
#import "AboutViewController.h"
#import "WhosinAppDelegate.h"
#import "ApplicationPreference.h"
#import "DataBaseManager.h"
#import "UINavigationController+Operations.h"
#import "InAppPurchaseManager.h"

@implementation SettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    settingTable.backgroundView = nil;
    
    UIActivityIndicatorView *busyIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    busyIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    busyIndicator.backgroundColor = [UIColor clearColor];
    busyIndicator.hidden = NO;
    [busyIndicator startAnimating];
    
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    loadingView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
    [loadingView addSubview:busyIndicator];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Connecting with appstore..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
}

-(void)showBusyScreen:(BOOL)_show
{
    if(_show)
    {
        [self.view addSubview:loadingView];
    }
    else
    {
        [loadingView removeFromSuperview];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark uitableview methods


// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
    
    if (section == 0)
    {
        [label setText:@"Sharing"];
    }
    else if(section == 1)
    {
        [label setText:@"Syncing"];
    }
//    else if(section == 2)
//    {
//       [label setText:@"Info"];
//    }
    
    [label setTextColor:[UIColor grayColor]];
    [label setBackgroundColor:[UIColor clearColor]];
   
    [view addSubview:label];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *TwitterCellId = @"TwitterCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TwitterCellId];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TwitterCellId];
                cell.textLabel.text = @"Twitter";
                cell.textLabel.textColor = [UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UISwitch *switchob = [[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 100, 10, 30, 20)];
                [switchob setOn:YES];
                [switchob addTarget:self action:@selector(twitterSwitchToggled:) forControlEvents: UIControlEventTouchUpInside];
                [cell addSubview:switchob];
            }
            
            return cell;
        }
        else if(indexPath.row == 1)
        {
            static NSString *FacebookCellId = @"FacebookCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FacebookCellId];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FacebookCellId];
                cell.textLabel.text = @"Facebook";
                cell.textLabel.textColor=[UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
                if (facebookSwitch == nil)
                {
                    facebookSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 100, 10, 30, 30)];
                    [facebookSwitch setOn:[ApplicationPreference facebookEnabled]];
                    [facebookSwitch addTarget:self action:@selector(facebookSwitchAction:) forControlEvents: UIControlEventValueChanged];
                    [cell addSubview:facebookSwitch];
                }
            }
            return cell;
        }
        
        return nil;
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *iPhoneCellId = @"iPhoneCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iPhoneCellId];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iPhoneCellId];
                cell.textLabel.text = @"Save to iPhone";
                cell.textLabel.textColor=[UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
                UISwitch *switchob=[[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 100, 10, 30, 30)];
                [switchob setOn:YES];
                [switchob addTarget:self action:@selector(iPhonePhotoSwitch:) forControlEvents: UIControlEventTouchUpInside];
                [cell addSubview:switchob];
            }
            return cell;
        }
        else
        {
            static NSString *DropboxCellId = @"DropboxCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DropboxCellId];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DropboxCellId];
                cell.textLabel.text=@"Save to Dropbox";
                cell.textLabel.textColor=[UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
                if (dropboxSwitch == nil)
                {
                    dropboxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 100, 10, 30, 30)];
                    [dropboxSwitch setOn:[ApplicationPreference dropboxEnabled]];
                    [dropboxSwitch addTarget:self action:@selector(dropboxSwitchAction:) forControlEvents: UIControlEventValueChanged];
                    [cell addSubview:dropboxSwitch];
                }
            }
            return cell;
        }
        return nil;
    }
    /*
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            static NSString *AboutCellId = @"AboutCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutCellId];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AboutCellId];
                cell.textLabel.text=@"About";
                cell.textLabel.textColor=[UIColor grayColor];
                
                UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 50, 10, 30, 30)];
                [btn addTarget:self action:@selector(aboutButtonPressed:) forControlEvents:UIControlEventTouchDown];
                [btn setImage:[UIImage imageNamed:@"about.png"] forState:UIControlStateNormal];
                [cell addSubview:btn];
            }
            return cell;
        }
        else if(indexPath.row==1)
        {
            static NSString *VersionCellId = @"VersionCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VersionCellId];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VersionCellId];
                cell.textLabel.text = @"App Version";
                cell.textLabel.textColor = [UIColor grayColor];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 90, 10, 70, 30)];
                [btn setImage:[UIImage imageNamed:@"virsion_1.0.png"] forState:UIControlStateNormal];
                [cell addSubview:btn];
            }
            return cell;
        }
        
        return nil;
    }
    */
  
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"header";
}// fixed font style. use custom view (UILabel) if you want something different

#pragma mark added methods
-(void)facebookButtonClicked:(id)sender
{
    UIButton *btn=sender;
    
    NSLog(@"%@", btn.currentTitle);
    
    if ([btn.currentTitle isEqualToString:@"Configure"])
    {
        [self showBusyScreen:YES];
        
        FacebookController *facebookController = [[FacebookController alloc] init];
        facebookController.faceBookShareDelegate = self;
        [facebookController initiateLogin];
    }
    else
    {
       NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:@"access"];
//        WhosinAppDelegate *appDelegate = (WhosinAppDelegate*) [[UIApplication sharedApplication] delegate];
//        [appDelegate logOutFromFB];
    }
    [settingTable reloadData];
}

-(void)facebookShareDidFinishWithSuccess:(BOOL)_success
{
    [ApplicationPreference setFacebookEnabled:YES];
    [self showBusyScreen:NO];
    [facebookSwitch setOn:YES animated:YES];
}
-(void)mailConfigurClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=ACCOUNT_SETTINGS"]];
}

-(void)aboutButtonPressed:(id)sender
{
    AboutViewController *ob=[[AboutViewController alloc] init];
    [self.navigationController pushViewController:ob animated:YES];
}

#pragma mark switch selectors

-(void)twitterSwitchToggled:(id)sender
{
    UISwitch *swit=(UISwitch *)sender;
    if(swit.isOn)
    {
           NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"set" forKey:@"twitterSwitch"];
    }
    else
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"reset" forKey:@"twitterSwitch"];
    }
}

-(void)iPhonePhotoSwitch:(id)sender
{
    UISwitch *swit = (UISwitch *)sender;
    if(swit.isOn)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"set" forKey:@"iPhonePhotoSwitch"];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"reset" forKey:@"iPhonePhotoSwitch"];
    }
}

-(void)dropboxSwitchAction:(id)sender
{
    if (dropboxSwitch.on && ![ApplicationPreference dropboxEnabled])
    {
        if([ApplicationPreference isProUpgradePurchaseDone])
        {
            NSLog(@"5");
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxDidLogin) name:kDropboxDidLoginNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxFailedLogin) name:kDropboxFailedLoginNotification object:nil];
            [[DBAccountManager sharedManager] linkFromController:self];
        }
        else
        {
            [loadingAlert show];
            
            NSLog(@"1");
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPurchaseNow) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [[InAppPurchaseManager getInstance] loadStore];
        }
    }
    else
    {
        [ApplicationPreference setDropboxEnabled:NO];
    }
}

#pragma mark -
#pragma mark - InAppPurchase Methods

-(void)canPurchaseNow
{
    NSLog(@"4");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    if ([[InAppPurchaseManager getInstance] canMakePurchases])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade to FamilyPhoto Plus?" message:nil delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Upgrade Now", @"Restore Purchases", nil];
        [alert show];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Failed" message:@"Cannot connection to appstore. Try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
        
        [[InAppPurchaseManager getInstance] purchaseProUpgrade];
        
        [loadingAlert show];
    }
    
    if(buttonIndex == 2)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreFailed) name:kInAppPurchaseManagerInvalidRestoreNotification object:nil];
        
        [[InAppPurchaseManager getInstance] checkPurchasedItems];
        
        [loadingAlert show];
    }
    
    if(buttonIndex == 0)
    {
        [dropboxSwitch setOn:NO animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

-(void)transactionCancelled
{
    NSLog(@"Transaction cancelled...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    [dropboxSwitch setOn:NO animated:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)paymentFailed
{
    NSLog(@"Payment failed...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    [dropboxSwitch setOn:NO animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Failed" message:@"Payment failed. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)restoreFailed
{
    NSLog(@"Restore failed...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    [dropboxSwitch setOn:NO animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Failed" message:@"Failed to restore. Please try later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)paymentSucceeded
{
    NSLog(@"Payment succeeded...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    [ApplicationPreference setProUpgradePurchaseDone:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxDidLogin) name:kDropboxDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxFailedLogin) name:kDropboxFailedLoginNotification object:nil];
    [[DBAccountManager sharedManager] linkFromController:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)dropboxDidLogin
{
    NSArray *categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    for (int i = 0; i < categoryArray.count; i++)
    {
        NSString *categoryName = [categoryArray objectAtIndex:i];
        
        DBPath *folderPath = [[DBPath root] childPath:categoryName];
        BOOL success = [[DBFilesystem sharedFilesystem] createFolder:folderPath error:nil];
        
//        DBPath *infoFolderPath = [folderPath childPath:@"Info"];
//        [[DBFilesystem sharedFilesystem] createFolder:infoFolderPath error:nil];
        
        if (success)
        {
            NSArray *subCatArray = [[DataBaseManager getInstance] getSubCat:categoryName];
            for (int j = 0; j < subCatArray.count; j++)
            {
                CategoryDescriptionDB *subCat = [subCatArray objectAtIndex:j];
                
                NSString *fileName = [subCat.PhotoRef lastPathComponent];
                
//                DBPath *textFilePath = [infoFolderPath childPath:[NSString stringWithFormat:@"%@.txt", fileName]];
//                DBFile *textFile = [[DBFilesystem sharedFilesystem] createFile:textFilePath error:nil];
//                
//                if (textFile)
//                {
//                    [textFile writeString:[NSString stringWithFormat:@"%f\n%f\n%@\n%@\n", subCat.latitute, subCat.latitute, subCat.location, subCat.notes] error:nil];
//                }
                
                DBPath *imageFilePath = [folderPath childPath:fileName];
                DBFile *imageFile = [[DBFilesystem sharedFilesystem] createFile:imageFilePath error:nil];
                
                UIImage *img = [UIImage imageWithContentsOfFile:subCat.PhotoRef];
                
                [imageFile writeData:UIImagePNGRepresentation(img) error:nil];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [ApplicationPreference setDropboxEnabled:YES];
}

-(void)dropboxFailedLogin
{
    [dropboxSwitch setOn:NO animated:YES];
}

-(void)facebookSwitchAction:(id)sender
{
    FacebookController *facebookController = [[FacebookController alloc] init];
    facebookController.faceBookShareDelegate = self;
    
    if (facebookSwitch.on)
    {
        [self showBusyScreen:YES];
        
        [facebookController initiateLogin];
    }
    else
    {
        [self showBusyScreen:YES];
        [facebookController logOutFromFB];
    }
}

-(void)faceBookDidNotLoginFromController
{
    [self showBusyScreen:NO];
    facebookSwitch.on = !facebookSwitch.on;
}

-(void)faceBookDidLogOutFromController
{
    [self showBusyScreen:NO];
    [ApplicationPreference setFacebookEnabled:NO];
    [facebookSwitch setOn:NO animated:YES];
}

@end
