//
//  AssociateAccountsViewController.m
//  iOS Prototype
//
//  Created by World on 3/5/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SocialViewController.h"
#import "CommonSwitchCell.h"

@interface SocialViewController () <CommonSwitchCellDelegate>
{
    UITableViewCell *topCell;
    CommonSwitchCell *facebookCell;
    CommonSwitchCell *twitterCell;
    CommonSwitchCell *instagramCell;
    CommonSwitchCell *renRenCell;
    CommonSwitchCell *weiboCell;
    CommonSwitchCell *googlePlusCell;
}

@end

@implementation SocialViewController

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
    
    self.navigationItem.title = @"GRABBER";
    
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
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return topCell;
            
        case 1:
            return facebookCell;
            
        case 2:
            return twitterCell;
            
        case 3:
            return instagramCell;
            
        case 4:
            return renRenCell;
            
        case 5:
            return weiboCell;
            
        case 6:
            return googlePlusCell;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 135;
    }
    return 50.0f;
}

-(void)cellConfiguration
{
    topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCell"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.accessoryType = UITableViewCellAccessoryNone;
    
    facebookCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isFacebookEnabled] withTitle:@"Facebook" withSubtitle:[UserDefaultsManager isFacebookEnabled] ? @"YES" : @"NO" withCellTypes:kFacebookCell];
    facebookCell.delegate = self;
    
    twitterCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isTwitterEnabled] withTitle:@"Twitter" withSubtitle:[UserDefaultsManager isTwitterEnabled] ? @"YES" : @"NO" withCellTypes:kTwitterCell];
    twitterCell.delegate = self;
    
    instagramCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isInstagramEnabled] withTitle:@"Instagram" withSubtitle:[UserDefaultsManager isInstagramEnabled] ? @"YES" : @"NO" withCellTypes:kInstagramCell];
    instagramCell.delegate = self;
    
    renRenCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isRenRenEnabled] withTitle:@"RenRen" withSubtitle:[UserDefaultsManager isRenRenEnabled] ? @"YES" : @"NO" withCellTypes:kRenRenCell];
    renRenCell.delegate = self;
    
    weiboCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isWeiboEnabled] withTitle:@"Weibo" withSubtitle:[UserDefaultsManager isWeiboEnabled] ? @"YES" : @"NO" withCellTypes:kWeiboCell];
    weiboCell.delegate = self;
    
    googlePlusCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isGooglePlusEnabled] withTitle:@"Google+" withSubtitle:[UserDefaultsManager isGooglePlusEnabled] ? @"YES" : @"NO" withCellTypes:kGooglePlusCell];
    googlePlusCell.delegate = self;
}

-(void)switchValueChangedTo:(BOOL)value forCellType:(kCellTypes)_type
{
    switch (_type)
    {
        case kFacebookCell:
            [UserDefaultsManager setFacebookEnabled:value];
            facebookCell.subtitleString = [UserDefaultsManager isFacebookEnabled] ? @"YES" : @"NO";
            break;
            
        case kTwitterCell:
            [UserDefaultsManager setTwitterEnabled:value];
            twitterCell.subtitleString = [UserDefaultsManager isTwitterEnabled] ? @"YES" : @"NO";
            break;
            
        case kInstagramCell:
            [UserDefaultsManager setInstagramEnabled:value];
            instagramCell.subtitleString = [UserDefaultsManager isInstagramEnabled] ? @"YES" : @"NO";
            break;
            
        case kRenRenCell:
            [UserDefaultsManager setRenRenEnabled:value];
            renRenCell.subtitleString = [UserDefaultsManager isRenRenEnabled] ? @"YES" : @"NO";
            break;
            
        case kWeiboCell:
            [UserDefaultsManager setWeiboEnabled:value];
            weiboCell.subtitleString = [UserDefaultsManager isWeiboEnabled] ? @"YES" : @"NO";
            break;
            
        case kGooglePlusCell:
            [UserDefaultsManager setGooglePlusEnabled:value];
            googlePlusCell.subtitleString = [UserDefaultsManager isGooglePlusEnabled] ? @"YES" : @"NO";
            break;
            
        default:
            break;
    }
    [containerTableView reloadData];
}

@end
