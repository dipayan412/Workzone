//
//  UserDrawerView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/1/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "UserDrawerView.h"
#import "UserDrawerViewCell.h"

@interface UserDrawerView() <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    UITableView *userOptionTableView;
    float headerHeight;
}

@end

@implementation UserDrawerView

@synthesize delegate;
@synthesize userImage;

- (id)initWithFrame:(CGRect)rect
{
    if ((self = [super initWithFrame:rect]))
    {
        [self commonIntialization];
    }
    return self;
}

-(void)commonIntialization
{
    self.backgroundColor = [UIColor clearColor];
    headerHeight = 100.0f;
    
    UIControl *vacantControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height)];
    vacantControl.backgroundColor = [UIColor lightGrayColor];
    vacantControl.alpha = 0.7f;
    [vacantControl addTarget:self action:@selector(hideDrawerView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:vacantControl];
    
    userOptionTableView = [[UITableView alloc] initWithFrame:CGRectMake(vacantControl.frame.size.width, 0, 2 * self.frame.size.width/3, self.frame.size.height) style:UITableViewStylePlain];
    userOptionTableView.delegate = self;
    userOptionTableView.dataSource = self;
    userOptionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [userOptionTableView setShowsVerticalScrollIndicator:NO];
    [self addSubview:userOptionTableView];
}

-(void)hideDrawerView
{
    if(delegate)
    {
        [delegate hideDrawerView];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    else if(section == 1)
    {
        return 7;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    UserDrawerViewCell *cell;
    if(cell == nil)
    {
        cell = [[UserDrawerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.row == 0 && indexPath.section == 1)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerHistory, nil);
        cell.cellTitle.text = @"Info";
        cell.cellImageView.image = [UIImage imageNamed:@"info button icon.png"];
    }
    else if(indexPath.row == 1 && indexPath.section == 1)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerfaq, nil);
        cell.cellTitle.text = @"Conditions";
        cell.cellImageView.image = [UIImage imageNamed:@"conditions-icon.png"];
    }
    else if(indexPath.row == 2 && indexPath.section == 1)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerProfile, nil);
        cell.cellTitle.text = @"Allergies";
        cell.cellImageView.image = [UIImage imageNamed:@"Allergy.png"];
    }
    else if(indexPath.row == 3 && indexPath.section == 1)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerFeedback, nil);
        cell.cellTitle.text = @"Bookmarks";
        cell.cellImageView.image = [UIImage imageNamed:@"bookmark icon.png"];
    }
    else if(indexPath.row == 4 && indexPath.section == 1)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerPillReminder, nil);
        cell.cellTitle.text = @"Pill Reminder";
        cell.cellImageView.image = [UIImage imageNamed:@"Pill Reminder Icon.png"];
    }
    else if(indexPath.row == 5 && indexPath.section == 1)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerMyReviews, nil);
        cell.cellTitle.text = @"History";
        cell.cellImageView.image = [UIImage imageNamed:@"history icon.png"];
    }
    else if(indexPath.row == 6 && indexPath.section == 1)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerMyReviews, nil);
        cell.cellTitle.text = @"Reviews";
        cell.cellImageView.image = [UIImage imageNamed:@"review_icon_blue.png"];
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(10, cell.contentView.frame.size.height-10, tableView.frame.size.width - 20, 1)];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:separatorView];
    }
    else if(indexPath.row == 0 && indexPath.section == 2)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerMyReviews, nil);
        cell.cellTitle.text = @"FAQ";
        cell.cellImageView.image = [UIImage imageNamed:@"FAQ-icon.png"];
    }
    else if(indexPath.row == 1 && indexPath.section == 2)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerMyReviews, nil);
        cell.cellTitle.text = @"Feedback";
        cell.cellImageView.image = [UIImage imageNamed:@"feedback icon.png"];
    }
    else if(indexPath.row == 2 && indexPath.section == 2)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerMyReviews, nil);
        cell.cellTitle.text = @"Terms & Condition";
        cell.cellImageView.image = [UIImage imageNamed:@"termsIcon.png"];
//        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height-1, tableView.frame.size.width, 1)];
//        separatorView.backgroundColor = [UIColor lightGrayColor];
//        [cell.contentView addSubview:separatorView];
    }
    else if(indexPath.row == 3 && indexPath.section == 2)
    {
//        cell.textLabel.text = NSLocalizedString(kDrawerMyReviews, nil);
        cell.cellTitle.text = @"Signout";
        cell.cellImageView.image = [UIImage imageNamed:@"signout button icon.png"];
    }
//    if(indexPath.row == 0 && indexPath.section == 1)
//    {
//        cell.textLabel.text = @"Logout";
//        cell.imageView.image = [UIImage imageNamed:@"LogOutIcon.png"];
//    }
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    cell.imageView.contentScaleFactor = 0.5f;
//    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
//    UIImageView *sv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
//    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
//    if(indexPath.row == 4 && indexPath.section == 0)
//    {
//        cell.contentView.layer.borderWidth = 0.5f;
//    }
//    else if(indexPath.row == 0 && indexPath.section == 1)
//    {
//        cell.contentView.layer.borderWidth = 0.5f;
//    }
//    else
//    {
//        cell.contentView.layer.borderWidth = 0.25f;
//    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return headerHeight;
    }
    return 40.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    if (section == 0)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [tableView rectForSection:0].size.height)];
//        [headerView setBackgroundColor:[UIColor colorWithRed:46.0f/255 green:45.0f/255 blue:51.0f/255 alpha:1.0f]];
        [headerView setBackgroundColor:themeColor];
        
        if(![[UserDefaultsManager getUserName] isEqualToString:@""])
        {
            float userImageHeight = 50;
            UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, headerHeight/2 - userImageHeight/2 , userImageHeight, userImageHeight)];
            userImageView.backgroundColor = [UIColor redColor];
            userImageView.layer.cornerRadius = userImageHeight/2;
            userImageView.clipsToBounds = YES;
            userImageView.contentMode = UIViewContentModeScaleAspectFill;
            if([UserDefaultsManager getProfilePicture])
            {
                userImageView.image = [UserDefaultsManager getProfilePicture];
            }
            [headerView addSubview:userImageView];
            
            UIButton *captureImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            captureImageButton.backgroundColor = [UIColor clearColor];
            captureImageButton.frame = userImageView.frame;
            [captureImageButton addTarget:self action:@selector(captureImageButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:captureImageButton];
            
            UILabel *userFullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImageView.frame.origin.x + userImageView.frame.size.width + 15, userImageView.frame.origin.y, headerView.frame.size.width - userImageView.frame.origin.x - userImageView.frame.size.width - 15, userImageView.frame.size.height/2)];
            userImageView.backgroundColor = [UIColor redColor];
            userFullNameLabel.text = [UserDefaultsManager getUserFullName];
            userFullNameLabel.textColor = [UIColor whiteColor];
            userFullNameLabel.numberOfLines = 1;
            userFullNameLabel.minimumScaleFactor = 0.5f;
            userFullNameLabel.adjustsFontSizeToFitWidth = YES;
            [headerView addSubview:userFullNameLabel];
            
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userFullNameLabel.frame.origin.x, userFullNameLabel.frame.origin.y + userFullNameLabel.frame.size.height, headerView.frame.size.width - userImageView.frame.origin.x - userImageView.frame.size.width - 15, userImageView.frame.size.height/2)];
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.text = [UserDefaultsManager getUserName];
            userNameLabel.textColor = [UIColor whiteColor];
            userNameLabel.numberOfLines = 1;
            userNameLabel.minimumScaleFactor = 0.5f;
            userNameLabel.adjustsFontSizeToFitWidth = YES;
            [headerView addSubview:userNameLabel];
        }
        else
        {
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            loginButton.backgroundColor = [UIColor blueColor];
            [loginButton setTitle:@"Sign In" forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginButton.frame = CGRectMake(userOptionTableView.frame.size.width/2 - 50, 25, 100, 50);
            loginButton.layer.cornerRadius = 5.0f;
            [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:loginButton];
        }
    }
    else if(section == 1)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        
        UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
        sectionTitle.textColor = [UIColor lightGrayColor];
        sectionTitle.text = @"Profile";
        [headerView addSubview:sectionTitle];
    }
    else if(section == 2)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        
        UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
        sectionTitle.textColor = [UIColor lightGrayColor];
        sectionTitle.text = @"Application";
        [headerView addSubview:sectionTitle];
    }
//    else if(section == 3)
//    {
//        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 80)];
//        headerView.backgroundColor = [UIColor clearColor];
//    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0 && indexPath.section == 1)
    {
        [self infoButtonAction];
    }
    else if(indexPath.row == 1 && indexPath.section == 1)
    {
        [self conditionButtonAction];
    }
    else if(indexPath.row == 2 && indexPath.section == 1)
    {
        [self allergyButtonAction];
    }
    else if(indexPath.row == 3 && indexPath.section == 1)
    {
        [self pillReminderButtonAction];
    }
    else if(indexPath.row == 4 && indexPath.section == 1)
    {
        [self pillReminderButtonAction];
    }
    else if(indexPath.row == 5 && indexPath.section == 1)
    {
        [self historyButtonAction];
    }
    else if(indexPath.row == 6 && indexPath.section == 1)
    {
        [self myReviewsButtonAction];
    }
    else if(indexPath.row == 0 && indexPath.section == 2)
    {
        [self faqButtonAction];
    }
    else if(indexPath.row == 1 && indexPath.section == 2)
    {
        [self feedbackButtonAction];
    }
    else if(indexPath.row == 2 && indexPath.section == 2)
    {
        [self termsButtonAction];
    }
    else if(indexPath.row == 3 && indexPath.section == 2)
    {
        [self signOutButtonAction];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void)infoButtonAction
{
    if(delegate)
    {
        [delegate infoButtonAction];
    }
}

-(void)conditionButtonAction
{
    if(delegate)
    {
        [delegate conditionButtonAction];
    }
}

-(void)allergyButtonAction
{
    if(delegate)
    {
        [delegate allergyButtonAction];
    }
}

-(void)userProfileButtonAction
{
    if(delegate)
    {
        [delegate userProfileButtonAction];
    }
}

-(void)captureImageButtonAction
{
    if(delegate)
    {
        [delegate captureImageButtonAction];
    }
}

-(void)feedbackButtonAction
{
    if(delegate)
    {
        [delegate feedbackButtonAction];
    }
}

-(void)pillReminderButtonAction
{
    if(delegate)
    {
        [delegate pillReminderButtonAction];
    }
}

-(void)myReviewsButtonAction
{
    if(delegate)
    {
        [delegate myReviewsButtonAction];
    }
}

-(void)loginButtonAction
{
    if(delegate)
    {
        [delegate logOutButtonAction];
    }
}

-(void)setUserImage:(UIImage *)_userImage
{
    userImage = _userImage;
    [userOptionTableView reloadData];
}

-(void)userDrawerViewReloadData
{
    [userOptionTableView reloadData];
}

-(void)faqButtonAction
{
    if(delegate)
    {
        [delegate faqButtonAction];
    }
}

-(void)historyButtonAction
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.text = NSLocalizedString(kHistoryLoading, nil);
    [ServerCommunicationUser getSearchHistoyForUserId:[UserDefaultsManager getUserId] completion:^(NSArray *arr) {
        NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
        [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
        [df2 setDateFormat:@"MMMM'-'dd'-'y"];
        NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
        [df3 setDateFormat:@"hh':'mm' 'a"];

        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSDate *d1 = [df1 dateFromString:obj1[@"Date"]];
            NSDate *d2 = [df1 dateFromString:obj2[@"Date"]];
            
            return [d2 compare:d1]; // descending order
        }];
        NSMutableArray *dateArray = [[NSMutableArray alloc] init];
        NSMutableArray *uniqueDateArray = [NSMutableArray array];
        NSMutableSet *processedSet = [[NSMutableSet alloc] init];
        for(NSDictionary *dict in arr)
        {
            NSDate *date = [df1 dateFromString: [dict objectForKey:@"Date"]];
            [dateArray addObject:[df2 stringFromDate:date]];
        }
        
        for(NSString *str in dateArray)
        {
            if(![processedSet containsObject:str])
            {
                [uniqueDateArray addObject:str];
                [processedSet addObject:str];
            }
        }
        
        NSMutableArray *finalArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < [uniqueDateArray count]; i++)
        {
            NSMutableArray *tmpProdArr = [[NSMutableArray alloc] init];
            NSMutableArray *tmpProdIdArr = [[NSMutableArray alloc] init];
            NSMutableArray *timeArr = [[NSMutableArray alloc] init];
            
            for(NSDictionary *dict in arr)
            {
                if([[uniqueDateArray objectAtIndex:i] isEqualToString:[df2 stringFromDate:[df1 dateFromString:[dict objectForKey:@"Date"]]]])
                {
                    [tmpProdArr addObject:[dict objectForKey:@"PROPRIETARY_NAME"]];
                    [tmpProdIdArr addObject:[dict objectForKey:@"PRODUCT_ID"]];
                    [timeArr addObject:[df3 stringFromDate:[df1 dateFromString:[dict objectForKey:@"Date"]]]];
                }
            }
            NSDictionary *totalObjectDict = [[NSDictionary alloc] initWithObjectsAndKeys:tmpProdArr, @"productName", tmpProdIdArr, @"productId", timeArr, @"time", nil];
            NSDictionary *tmpDic = [[NSDictionary alloc] initWithObjectsAndKeys:totalObjectDict, [uniqueDateArray objectAtIndex:i], nil];
            [finalArray addObject:tmpDic];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(delegate)
            {
                [MBProgressHUD hideHUDForView:self animated:YES];
                [delegate historyButtonAction:finalArray withDates:uniqueDateArray];
            }
        });
    }];
}

-(void)termsButtonAction
{
    if(delegate)
    {
        [delegate termsButtonAction];
    }
}

-(void)signOutButtonAction
{
    if(delegate)
    {
        [delegate signOutButtonAction];
    }
}

-(void)getHistoryData
{
    
}

@end
