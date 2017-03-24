//
//  RA_SettingsViewController.m
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_SettingsViewController.h"
#import "RA_SettingsCell.h"
#import "RA_LanguageSwitchCell.h"
#import <Social/Social.h>
#import "RA_AppDelegate.h"

@interface RA_SettingsViewController () <SettingsCellDelegate, LanguageCellDelegate>
{
    RA_SettingsCell *fbCell;
    RA_SettingsCell *twitterCell;
    RA_LanguageSwitchCell *languageCell;
}

@end

@implementation RA_SettingsViewController

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
    
    self.view.backgroundColor = kPageBGColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    containerTableview.backgroundColor = [UIColor whiteColor];
    containerTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    containerTableview.layer.cornerRadius = 2.0f;
    containerTableview.layer.borderColor = kBorderColor;
    containerTableview.layer.borderWidth = 1.0f;
    containerTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [containerTableview setSeparatorInset:UIEdgeInsetsZero];
    containerTableview.scrollEnabled = NO;
    
    [self cellConfiguration];
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
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            fbCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return fbCell;
            
        case 1:
            twitterCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return twitterCell;
            
        case 2:
            languageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return languageCell;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    
    UIView *headerView = [[UIView alloc] init];
    UILabel *tableViewSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 23)];
    tableViewSectionTitle.text = AMLocalizedString(@"kAccountSetting", nil);
    tableViewSectionTitle.textColor = kSettingsPageCommonColor;
    tableViewSectionTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0f];
    tableViewSectionTitle.font = [UIFont boldSystemFontOfSize:13.0f];
    [headerView addSubview:tableViewSectionTitle];
    headerView.backgroundColor = [UIColor lightGrayColor];
    return headerView;
}

/**
 * Method name: cellConfiguration
 * Description: static cells initialized (connect to facebook and connect to twitter)
 * Parameters: none
 */

-(void)cellConfiguration
{
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        [RA_UserDefaultsManager setFacebookConnected:NO];
    }
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        [RA_UserDefaultsManager setTwitterConnected:NO];
    }
    
    fbCell = [[RA_SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCellID" checkBoxSelected:[RA_UserDefaultsManager isFacebookConnected] action:kFacebook];
    fbCell.delegate = self;
    
    twitterCell = [[RA_SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCellID" checkBoxSelected:[RA_UserDefaultsManager isTwitterConnected] action:kTwitter];
    twitterCell.delegate = self;
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    fbCell.actionNameLabel.text = AMLocalizedString(@"kConnectFacebook", nil);
    twitterCell.actionNameLabel.text = AMLocalizedString(@"kConnectTwitter", nil);
    
    languageCell = [[RA_LanguageSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCellID"];
    languageCell.delegate = self;
}

/**
 * Method name: checkBoxIsSelected
 * Description: uses social framework to publish on facebook/twitter (according to the action)
 * Parameters: checkbox selected or not and the action corresponding to the checkbox
 */

-(void)checkBoxIsSelected:(BOOL)isSelected action:(kSettingsOptions)action
{
    if(action == kFacebook)
    {
        if(isSelected)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                NSLog(@"user logged in FB");
                
                SLComposeViewController * composeVC = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
                //            [composeVC addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
                [composeVC addImage:[UIImage imageNamed:kRestaurantSlide4]];
                if(composeVC)
                {
                    // assume everything validates
                    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
                    {
                        if (result == SLComposeViewControllerResultCancelled)
                        {
                            NSLog(@"Cancelled");
                            
                        }
                        else
                        {
                            NSLog(@"Post");
                        }
                        
                        [composeVC dismissViewControllerAnimated:YES completion:Nil];
                    };
                    
                    composeVC.completionHandler =myBlock;
                    [self presentViewController: composeVC animated: YES completion: nil];
                }
                
                [RA_UserDefaultsManager setFacebookConnected:isSelected];
            }
            else
            {
                NSLog(@"user not logged in FB");
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                controller.view.hidden = YES;
                [self presentViewController:controller animated:NO completion:nil];
                
                [fbCell deselectCheckBox];
                
                [RA_UserDefaultsManager setFacebookConnected:NO];
            }
        }
        else
        {
            [RA_UserDefaultsManager setFacebookConnected:NO];
        }
    }
    
    if(action == kTwitter)
    {
        if(isSelected)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                NSLog(@"user logged in TWITTER");
                
                SLComposeViewController * composeVC = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
                [composeVC addImage:[UIImage imageNamed:kRestaurantSlide4]];
                if(composeVC)
                {
                    // assume everything validates
                    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
                    {
                        if (result == SLComposeViewControllerResultCancelled)
                        {
                            NSLog(@"Cancelled");
                            
                        }
                        else
                        {
                            NSLog(@"Post");
                        }
                        
                        [composeVC dismissViewControllerAnimated:YES completion:Nil];
                    };
                    
                    composeVC.completionHandler = myBlock;
                    [self presentViewController: composeVC animated: YES completion: nil];
                }
                [RA_UserDefaultsManager setTwitterConnected:isSelected];
            }
            else
            {
                NSLog(@"user not logged in TWITTER");
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                controller.view.hidden = YES;
                [self presentViewController:controller animated:NO completion:nil];
                
                [twitterCell deselectCheckBox];
                [RA_UserDefaultsManager setTwitterConnected:NO];
            }
        }
        else
        {
            [RA_UserDefaultsManager setTwitterConnected:NO];
        }
    }
}

/**
 * Method name: languageChanged
 * Description: update the language of the app
 * Parameters: italian is on or off
 */

-(void)languageChanged:(BOOL)_isOn
{
    [RA_UserDefaultsManager setLanguageToItalian:_isOn];
    if([RA_UserDefaultsManager isLanguageItalian])
    {
        [RA_UserDefaultsManager setAppLanuage:@"it"];
    }
    else
    {
        [RA_UserDefaultsManager setAppLanuage:@"en"];
    }
    
    RA_AppDelegate *apdl = (RA_AppDelegate*) [[UIApplication sharedApplication] delegate];
    [apdl changeLanguages];
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    fbCell.actionNameLabel.text = AMLocalizedString(@"kConnectFacebook", nil);
    twitterCell.actionNameLabel.text = AMLocalizedString(@"kConnectTwitter", nil);
    self.title = AMLocalizedString(@"kSettings", nil);
    [languageCell changeLang];
    [containerTableview reloadData];
    
    if(delegate)
    {
        [delegate updateBackButton];
    }
}

@end
