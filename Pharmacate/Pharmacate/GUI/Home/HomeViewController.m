//
//  HomeViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/21/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchTableViewCell.h"
#import "HomeTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ProductDetailViewController.h"
#import "UserDrawerView.h"
#import "HistoryViewController.h"
#import "UserProfileViewController.h"
#import "Product.h"
#import "Disease.h"
#import "UIImageView+WebCache.h"
#import "SearchResultWebViewController.h"
#import "SearchViewController.h"
#import "NewsTableViewCell.h"
#import "AppDelegate.h"
#import "UserFeedbackViewController.h"
#import "PillReminderViewController.h"
#import "MyReviewsViewController.h"
#import "SearchResultWebViewController.h"

#define insertUser  @"https://m6zbw2uc09.execute-api.us-west-2.amazonaws.com/dev/insert/single-user"

int maxPage = 20;

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UserDrawerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
{
    UIButton *homeButton;
    UIButton *searchButton;
    UIButton *alarmButton;
    
    UIView *drawerView;
    UIControl *controlHideDrawerView;
    
    UIView *homeView;
    UIView *searchView;
    UITableView *homeTableView;
    UITableView *searchTableView;
    
    UIButton *searchBoxDeleteTextButton;
    UITextField *searchTextField;
    
    UIView *indicatorView;
    
    NSMutableArray *searchProductArray;
    
    UserDrawerView *userDrawerView;
    
    UIActivityIndicatorView *spinner;
    UILabel *waitLabel;
    UIControl *busyControl;
    UIControl *topControl;
    UIView *containerTopView;
    
    NSArray *newsArray;
    NSString *selectedProfileSelection;
}

@end

@implementation HomeViewController

-(void)loadView
{
    [super loadView];
    
    NSLog(@"%@", [UserDefaultsManager getUserToken]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getProfileData:)
                                                 name:kGetProfileInfoNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(countCharacter)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(diseaseDownloadComplete)
                                                 name:kDiseaseDownloadComplete
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newsDownloadComplete:)
                                                 name:kNewsDownloadCompleteNotification
                                               object:nil];
    
    [[RefreshToken sharedInstance] startTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    newsArray = [[NSArray alloc] init];
    searchProductArray = [[NSMutableArray alloc] init];
    selectedProfileSelection = @"";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    topView.backgroundColor = [UIColor clearColor];
    
    homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0, 0, 60, 60);
    [homeButton setBackgroundImage:[UIImage imageNamed:@"homeIconSelected.png"] forState:UIControlStateNormal];
    homeButton.tag = 1;
    [homeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(homeButton.frame.size.width, 0, 60, 60);
    [searchButton setBackgroundImage:[UIImage imageNamed:@"searchButtonDeselected@2x.png"] forState:UIControlStateNormal];
    searchButton.tag = 2;
    [searchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height - 5, homeButton.frame.size.width, 5)];
    indicatorView.backgroundColor = [UIColor colorWithRed:227.0f/255 green:69.0f/255 blue:84.0f/255 alpha:1.0f];
    [topView addSubview:indicatorView];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, indicatorView.frame.origin.y + indicatorView.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:separatorLine];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 13, 35, 35);
    [userButton setBackgroundImage:[UIImage imageNamed:@"hanbuger icon.png"] forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(openDrawerView) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:userButton];
    //    [topView addSubview:searchButton];
    [topView addSubview:alarmButton];
    [topView addSubview:homeButton];
//    [self.view addSubview:topView];
    
    drawerView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    controlHideDrawerView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, drawerView.frame.size.width/3, drawerView.frame.size.height)];
    controlHideDrawerView.backgroundColor = [UIColor lightGrayColor];
    controlHideDrawerView.alpha = 0.7;
    //    [controlHideDrawerView addTarget:self action:@selector(closeDrawerView) forControlEvents:UIControlEventTouchUpInside];
    [drawerView addSubview:controlHideDrawerView];
    
    UIImageView *tempUserImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tempUserDetailedView.png"]];
    tempUserImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/3, 0, [UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width/3, [UIScreen mainScreen].bounds.size.height);
    [drawerView addSubview:tempUserImageView];
    
    UIControl *logoutControl = [[UIControl alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 341, [UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width/3, 56)];
    logoutControl.backgroundColor = [UIColor redColor];
    //    [logoutControl addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [drawerView addSubview:logoutControl];
    
    homeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    homeView.backgroundColor = [UIColor colorWithRed:225.0f/255 green:220.0f/255 blue:219.0f/255 alpha:1.0];
    
    homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, homeView.frame.size.width, homeView.frame.size.height)];
    homeTableView.backgroundColor = [UIColor clearColor];
    homeTableView.delegate = self;
    homeTableView.dataSource = self;
    CGFloat dummyViewHeight = [UIScreen mainScreen].bounds.size.height;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, homeTableView.bounds.size.width, dummyViewHeight)];
    homeTableView.tableHeaderView = dummyView;
    homeTableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 44, 0);
    homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    searchView.backgroundColor = [UIColor colorWithRed:225.0f/255 green:220.0f/255 blue:219.0f/255 alpha:1.0];
    
    UIView *searchBoxView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 60)];
    searchBoxView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *searchBoxIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBoxIcon.png"]];
    searchBoxIconImageView.frame = CGRectMake(5, searchBoxView.frame.size.height / 2 - 14 , 33, 28);
    searchBoxIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [searchBoxView addSubview:searchBoxIconImageView];
    
    searchBoxDeleteTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBoxDeleteTextButton.frame = CGRectMake(searchBoxView.frame.size.width - 36, searchBoxView.frame.size.height / 2 - 11, 18, 22);
    [searchBoxDeleteTextButton setBackgroundImage:[UIImage imageNamed:@"searchBoxDeleteTextIcon.png"] forState:UIControlStateNormal];
    [searchBoxDeleteTextButton addTarget:self action:@selector(searchBoxDeleteTextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchBoxView addSubview:searchBoxDeleteTextButton];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(searchBoxIconImageView.frame.size.width + 5 + 10, 0, searchBoxView.frame.size.width - 2 * (searchBoxIconImageView.frame.size.width + 5 + 10) - 10, searchBoxView.frame.size.height)];
    searchTextField.placeholder = NSLocalizedString(kSearchTextFieldPlaceholder, nil);
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.delegate = self;
    
    searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(searchBoxView.frame.origin.x, searchBoxView.frame.origin.y + searchBoxView.frame.size.height + 1, searchBoxView.frame.size.width, searchView.frame.size.height - 2 * (searchBoxView.frame.origin.y + searchBoxView.frame.size.height))];
    searchTableView.backgroundColor = [UIColor clearColor];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.scrollEnabled = YES;
    searchTableView.hidden = YES;
    
    [searchBoxView addSubview: searchTextField];
    [searchView addSubview:searchBoxView];
    [searchView addSubview:searchTableView];
    
    [homeView addSubview:homeTableView];
    [self.view addSubview:searchView];
    [self.view addSubview:homeView];
    [self.view addSubview:drawerView];
    
    [ServerCommunicationUser newsBingSearchApiCall];
//    [self newsBingSearchApiCall];
    
    containerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.0f)];
    containerTopView.backgroundColor = [UIColor clearColor];
    containerTopView.hidden = YES;
    [self.view addSubview:containerTopView];
    
    topControl = [[UIControl alloc] initWithFrame:containerTopView.frame];
    topControl.backgroundColor = [UIColor blackColor];
    topControl.alpha = 0.2f;
    [topControl addTarget:self action:@selector(topControlAction) forControlEvents:UIControlEventTouchUpInside];
    [containerTopView addSubview:topControl];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:containerTopView.frame];
    topLabel.text = NSLocalizedString(kNewsTopText, nil);
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.font = [UIFont systemFontOfSize:17.0f];
    topLabel.backgroundColor = [UIColor clearColor];
    [containerTopView addSubview:topLabel];
    
    NSLog(@"userName %@",[UserDefaultsManager getUserName]);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userDrawerView = [[UserDrawerView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    userDrawerView.delegate = self;
    [self.view addSubview:userDrawerView];
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Home"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= ([UIScreen mainScreen].bounds.size.height * 2))
    {
        containerTopView.hidden = NO;
    }
    else
    {
        containerTopView.hidden = YES;
    }
}

-(void)topControlAction
{
    [homeTableView setContentOffset:CGPointMake(0.0f, -homeTableView.contentInset.top) animated:YES];
}

-(void)newsControlAction
{
//    [homeTableView setContentOffset:CGPointMake(0.0f, -homeTableView.contentInset.top) animated:YES];
    if(newsArray.count > 0)
    {
        [homeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)diseaseDownloadComplete
{
    NSLog(@"download complete");

    [ServerCommunicationUser newsBingSearchApiCall];
    
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObjectContext *private = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [private setParentContext:context];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    NSMutableArray *productIdArray = [[NSMutableArray alloc] init];
    NSString *highestProductIdInDB;
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        for (Product *product in fetchedResult)
        {
            [productIdArray addObject:[NSNumber numberWithInteger:[product.productId integerValue]]];
        }
        int max = [[productIdArray valueForKeyPath:@"@max.intValue"] intValue];
        highestProductIdInDB = [NSString stringWithFormat:@"%d",max];
    }
    else
    {
        highestProductIdInDB = @"1000000000";
    }
    
    NSMutableArray *fetchedTempResult = [UserDefaultsManager getTempProductArray];
    [context performBlock:^{
        if (fetchedTempResult && [fetchedTempResult count] > 0)
        {
            for (NSDictionary *dict in fetchedTempResult)
            {
                if([[dict objectForKey:@"PRODUCT_ID"] integerValue] > [highestProductIdInDB integerValue])
                {
                    Product *product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
                    
                    product.productId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"PRODUCT_ID"]];
                    product.productName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"PRODUCT_NAME"]];
                    product.productIngredientName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"PRODUCT_INGREDIENT_NAME"]];
                }
            }
        }
        NSError *error = nil;
        if(![context save:&error])
        {
            NSLog(@"error");
        }
        
        [fetchedResult removeAllObjects];
        NSMutableArray *arr = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
        NSLog(@"total products %lu", (unsigned long)[arr count]);
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [UserDefaultsManager setDownloadComplete:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            waitLabel.hidden = YES;
            busyControl.hidden = YES;
        });
    }];
}

-(void)newsDownloadComplete:(NSNotification*)notification
{
    newsArray = [[notification userInfo] valueForKey:@"news"];
    [homeTableView reloadData];
}

-(void)countCharacter
{
    if([searchTextField.text length] >= 4)
    {
        [self getProductsByName:[NSString stringWithFormat:@"%@",searchTextField.text]];
    }
}

-(void)openDrawerView
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Home_Drawer_Button_Pressed"
                                                           label:@"Home_Drawer_Button"
                                                           value:nil] build]];
    
    [self.view bringSubviewToFront:userDrawerView];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = userDrawerView.frame;
        frame.origin.x = 0;
        userDrawerView.frame = frame;
    } completion:^(BOOL finished) {
        if(finished)
        {
        }
    }];
}

-(void)hideDrawerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = userDrawerView.frame;
        frame.origin.x = [UIScreen mainScreen].bounds.size.width;
        userDrawerView.frame = frame;
    } completion:^(BOOL finished) {
        if(finished)
        {
            [self.view sendSubviewToBack:userDrawerView];
        }
    }];
}

-(void)historyButtonAction:(NSArray*)historyArray withDates:(NSArray *)dates
{
//    if(![[UserDefaultsManager getUserName] isEqualToString:@""])
//    {
//        
//    }
//    else
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please login to use this feature" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
//        UIAlertAction* login = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            if([FBSDKAccessToken currentAccessToken])
//            {
//                
//            }
//            [UserDefaultsManager setUserToken:@""];
//            [UserDefaultsManager setUserName:@""];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }];
//        [alertController addAction:dismiss];
//        [alertController addAction:login];
//        
//        [self presentViewController:alertController animated:YES completion:^{
//            
//            return;
//        }];
//    }
    [self hideDrawerView];
    HistoryViewController *vc = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil withHistoryArray:historyArray DateArray:dates];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)infoButtonAction
{
    selectedProfileSelection = @"INFO";
    [self userProfileButtonAction];
}

-(void)conditionButtonAction
{
    selectedProfileSelection = @"CONDITION";
    [self userProfileButtonAction];
}

-(void)allergyButtonAction
{
    selectedProfileSelection = @"ALLERGY";
    [self userProfileButtonAction];
}


-(void)userProfileButtonAction
{
    if(![[UserDefaultsManager getUserName] isEqualToString:@""])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(kUserInfoLoading, nil);
        [ServerCommunicationUser getUserProductsViewController:self];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(kForceLoginAlertMessage, nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(kForceLoginAlertDismiss, nil) style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction* login = [UIAlertAction actionWithTitle:NSLocalizedString(kForceLoginAlertLogin, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if([FBSDKAccessToken currentAccessToken])
            {
                
            }
            [UserDefaultsManager setUserToken:@""];
            [UserDefaultsManager setUserName:@""];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:dismiss];
        [alertController addAction:login];
        
        [self presentViewController:alertController animated:YES completion:^{
            
            return;
        }];
    }
}

-(void)feedbackButtonAction
{
    [self hideDrawerView];
    UserFeedbackViewController *vc = [[UserFeedbackViewController alloc] initWithNibName:@"UserFeedbackViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)faqButtonAction
{
    [self hideDrawerView];
    SearchResultWebViewController *vc = [[SearchResultWebViewController alloc] initWithNibName:@"SearchResultWebViewController" bundle:nil];
    vc.urlString = faqLink;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)pillReminderButtonAction
{
    if(![[UserDefaultsManager getUserName] isEqualToString:@""])
    {
        [self hideDrawerView];
        PillReminderViewController *vc = [[PillReminderViewController alloc] initWithNibName:@"PillReminderViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(kForceLoginAlertMessage, nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(kForceLoginAlertDismiss, nil) style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction* login = [UIAlertAction actionWithTitle:NSLocalizedString(kForceLoginAlertLogin, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if([FBSDKAccessToken currentAccessToken])
            {
                
            }
            [UserDefaultsManager setUserToken:@""];
            [UserDefaultsManager setUserName:@""];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:dismiss];
        [alertController addAction:login];
        
        [self presentViewController:alertController animated:YES completion:^{
            
            return;
        }];
    }
}

-(void)myReviewsButtonAction
{
    if(![[UserDefaultsManager getUserName] isEqualToString:@""])
    {
        [self hideDrawerView];
        MyReviewsViewController *vc = [[MyReviewsViewController alloc] initWithNibName:@"MyReviewsViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(kForceLoginAlertMessage, nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(kForceLoginAlertDismiss, nil) style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction* login = [UIAlertAction actionWithTitle:NSLocalizedString(kForceLoginAlertLogin, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if([FBSDKAccessToken currentAccessToken])
            {
                
            }
            [UserDefaultsManager setUserToken:@""];
            [UserDefaultsManager setUserName:@""];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:dismiss];
        [alertController addAction:login];
        
        [self presentViewController:alertController animated:YES completion:^{
            
            return;
        }];
    }
}

-(void)termsButtonAction
{
    [self hideDrawerView];
    SearchResultWebViewController *vc = [[SearchResultWebViewController alloc] initWithNibName:@"SearchResultWebViewController" bundle:nil];
    vc.urlString = termsLink;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)signOutButtonAction
{
    if([FBSDKAccessToken currentAccessToken])
    {
        
    }
    [UserDefaultsManager setUserToken:@""];
    [UserDefaultsManager setUserName:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)logOutButtonAction
{
    if([FBSDKAccessToken currentAccessToken])
    {
        //        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        //        [loginManager logOut];
        //        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    [UserDefaultsManager setUserToken:@""];
    [UserDefaultsManager setUserName:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)getProfileData:(NSNotification*)notification
{
    NSArray *productIdArray = [[notification userInfo] valueForKey:@"PRODUCT_LIST"];
    NSArray *diseaseIdArray = [[notification userInfo] valueForKey:@"DISEASE_LIST"];
    NSArray *allergenIdArray = [[notification userInfo] valueForKey:@"ALLERGEN_LIST"];
    NSArray *allergicProductIdArray = [[notification userInfo] valueForKey:@"ALLERGIC_PRODUCT_LIST"];
    
    for(NSString *str in productIdArray)
    {
        NSLog(@"product %@", str);
    }
    
    for(NSString *str in diseaseIdArray)
    {
        NSLog(@"disease %@", str);
    }
    
    for(NSString *str in allergenIdArray)
    {
        NSLog(@"allergen %@", str);
    }
    
    for(NSString *str in allergicProductIdArray)
    {
        NSLog(@"allergyProduct %@", str);
    }
    
    [self hideDrawerView];
    UserProfileViewController *vc = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    vc.selectedProductsArray = productIdArray;
    vc.selectedDiseasesArray = diseaseIdArray;
    vc.selectedAllergenArray = allergenIdArray;
    vc.selectedAllergicProductArray = allergicProductIdArray;
    vc.selectedProfileSection = selectedProfileSelection;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)captureImageButtonAction
{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else
//    {
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    
//    [self hideDrawerView];
//    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [UserDefaultsManager saveProfilePicture:chosenImage];
    [userDrawerView userDrawerViewReloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)buttonAction:(UIButton*)button
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = indicatorView.frame;
    frame.origin.x = button.frame.origin.x;
    indicatorView.frame = frame;
    
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    if(button.tag == 1)
    {
        [homeButton setBackgroundImage:[UIImage imageNamed:@"homeIconSelected.png"] forState:UIControlStateNormal];
        [searchButton setBackgroundImage:[UIImage imageNamed:@"searchButtonDeselected@2x.png"] forState:UIControlStateNormal];
        [alarmButton setBackgroundImage:[UIImage imageNamed:@"searchButtonDeselected@2x.png"] forState:UIControlStateNormal];
        
        [self.view bringSubviewToFront:homeView];
    }
    else if(button.tag == 2)
    {
        [homeButton setBackgroundImage:[UIImage imageNamed:@"homeIconDeselected.png"] forState:UIControlStateNormal];
        [searchButton setBackgroundImage:[UIImage imageNamed:@"searchButton@2x.png"] forState:UIControlStateNormal];
        //        [alarmButton setBackgroundImage:[UIImage imageNamed:@"searchButtonDeselected@2x.png"] forState:UIControlStateNormal];
        
        [self.view bringSubviewToFront:searchView];
    }
    else if(button.tag == 3)
    {
        [homeButton setBackgroundImage:[UIImage imageNamed:@"searchButtonDeselected@2x.png"] forState:UIControlStateNormal];
        [searchButton setBackgroundImage:[UIImage imageNamed:@"searchButtonDeselected@2x.png"] forState:UIControlStateNormal];
        //        [alarmButton setBackgroundImage:[UIImage imageNamed:@"searchButton@2x.png"] forState:UIControlStateNormal];
    }
}

-(void)searchBoxDeleteTextButtonAction:(UIButton*)button
{
    searchTextField.text = @"";
    searchTableView.hidden = YES;
}

#pragma mark tableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == searchTableView)
    {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == searchTableView)
    {
        return [searchProductArray count];
    }
    if(newsArray.count == 0)
    {
        return 1;
    }
    return [newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchTableView)
    {
        static NSString *cellIdentifier = @"cellID";
        SearchTableViewCell *cell;
        if(cell == nil)
        {
            cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.productName.text = [NSString stringWithFormat:@"%@",[[searchProductArray objectAtIndex:indexPath.row] objectForKey:@"PROPRIETARY_NAME"]];
        cell.genericName.text = [NSString stringWithFormat:@"%@",[[searchProductArray objectAtIndex:indexPath.row] objectForKey:@"NONPROPRIETARY_NAME"]];
        //        NSLog(@"%@", [[searchProductArray objectAtIndex:indexPath.row] objectForKey:@"PROPRIETARY_NAME"]);
        
        if(indexPath.row == 0)
        {
            NSString *str1 = [NSString stringWithFormat:@"%@",[[searchProductArray objectAtIndex:indexPath.row] objectForKey:@"PROPRIETARY_NAME"]];
            NSString *str2 = @" TEMP";
            cell.productName.text = [NSString stringWithFormat:@"%@%@", str1, str2];
        }
        
        if (indexPath.row == [searchProductArray count] - 1 && [searchProductArray count] == maxPage)
        {
            maxPage += 20;
            [self getProductsByName:searchTextField.text];
        }
        
        return cell;
    }
    static NSString *cellIdentifier = @"cellID";
    NewsTableViewCell *cell;
    if(cell == nil)
    {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(newsArray.count == 0)
    {
        cell.textLabel.text = @"No news found";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        cell.newsTitleLabel.text = [[newsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.newsImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if([[newsArray objectAtIndex:indexPath.row] objectForKey:@"image"])
        {
            NSString *urlString = [[newsArray objectAtIndex:indexPath.row] objectForKey:@"image"];
            [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"noImageAvailable.png"]];
        }
        else
        {
            //        cell.newsImageView.image = [UIImage imageNamed:@"fdaSymbol1.png"];
        }
        [cell.newsImageView setClipsToBounds:YES];
        cell.layer.borderWidth = 0.5f;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(newsArray.count == 0)
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchTableView)
    {
        return 65;
    }
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    if(tableView == searchTableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ProductDetailViewController *vc;
        if(indexPath.row == 0)
        {
            vc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil isTempValue:YES numRows:4];
        }
        else
        {
            vc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil isTempValue:NO numRows:1];
        }
        
        
        [ServerCommunicationUser insertIntoSearchHistoryByProductId:[[searchProductArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_ID"] byUserId:[UserDefaultsManager getUserId]];
        vc.productId = [[searchProductArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    id<GAITracker> tracker =[[GAI sharedInstance] trackerWithTrackingId:@"UA-80778267-1"];
//    
//    NSLog(@"%@", [NSNumber numberWithFloat:tableView.contentOffset.y]);
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Event"
//                                                          action:@"News Select Action"
//                                                           label:@"News scroll"
//                                                           value:nil] build]];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"News Selection"
                                                           label:[[newsArray objectAtIndex:indexPath.row] objectForKey:@"name"]
                                                           value:nil] build]];
    
    SearchResultWebViewController *vc = [[SearchResultWebViewController alloc] initWithNibName:@"SearchResultWebViewController" bundle:nil];
    vc.urlString = [[newsArray objectAtIndex:indexPath.row] objectForKey:@"url"];
    [self presentViewController:vc animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == searchTableView)
    {
        return 0;
    }
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == searchTableView)
    {
        return 0;
    }
    else
    {
        if(section == 0)
        {
            return [UIScreen mainScreen].bounds.size.height;
        }
    }
    return 25;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(tableView == searchTableView)
    {
        return NULL;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    return footerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == searchTableView)
    {
        return NULL;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
    if (section == 0)
    {
        [headerView setBackgroundColor:[UIColor whiteColor]];
        CGRect frame = headerView.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height - 60.0f;
        headerView.frame = frame;
        
        homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        homeButton.frame = CGRectMake(0, 0, 60, 60);
        homeButton.tintColor = [UIColor blueColor];
        [homeButton setBackgroundImage:[UIImage imageNamed:@"homeIconSelected.png"] forState:UIControlStateNormal];
        homeButton.tag = 1;
        [homeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:homeButton];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pharmacate text.png"]];
        iconImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 90, 1.25*[UIScreen mainScreen].bounds.size.height/4, 180, 27);
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [headerView addSubview:iconImageView];
        
        UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        userButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 13, 35, 35);
        [userButton setBackgroundImage:[UIImage imageNamed:@"hanbuger icon.png"] forState:UIControlStateNormal];
        [userButton addTarget:self action:@selector(openDrawerView) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:userButton];
        
        UIImageView *leafImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leaf.png"]];
        leafImageView.frame = frame;
        leafImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [headerView addSubview:leafImageView];
        
        float searchButtonImageHeight = 100;
        float searchButtonImageWidth = searchButtonImageHeight;
        UIImageView *searchButtonImage = [[UIImageView alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2 - searchButtonImageWidth/2, headerView.frame.size.height/4 - searchButtonImageHeight/2 - 50, searchButtonImageWidth, searchButtonImageHeight)];
        searchButtonImage.backgroundColor = [UIColor lightGrayColor];
        searchButtonImage.alpha = 0.7f;
        searchButtonImage.layer.cornerRadius = searchButtonImageHeight/2;
        searchButtonImage.clipsToBounds = YES;
//        [headerView addSubview:searchButtonImage];
        
        UIImageView *insideSearchButton = [[UIImageView alloc] initWithFrame:CGRectMake(searchButtonImageWidth/2 - 35/2, searchButtonImageHeight/2 - 35/2, 35, 35)];
        insideSearchButton.image = [UIImage imageNamed:@"searchButton2.png"];
        insideSearchButton.backgroundColor = [UIColor clearColor];
//        [searchButtonImage addSubview:insideSearchButton];
        
        UIButton *tableSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tableSearchButton.backgroundColor = [UIColor clearColor];
        tableSearchButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, iconImageView.frame.origin.y + iconImageView.frame.size.height + 20, 300, 45);
        [tableSearchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [tableSearchButton setBackgroundImage:[UIImage imageNamed:@"SearchButtonTextField.png"] forState:UIControlStateNormal];
        tableSearchButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tableSearchButton.layer.borderWidth = 0.5f;
        [headerView addSubview:tableSearchButton];
        
        UILabel *buttonTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(147*tableSearchButton.frame.size.width/1658, 0, tableSearchButton.frame.size.width - 147*tableSearchButton.frame.size.width/1658, tableSearchButton.frame.size.height)];
        buttonTitleLabel.backgroundColor = [UIColor whiteColor];
        buttonTitleLabel.text = @"Search by drugs, supplements and uses";
        buttonTitleLabel.textColor = [UIColor lightGrayColor];
        buttonTitleLabel.textAlignment = NSTextAlignmentCenter;
        buttonTitleLabel.font = [UIFont systemFontOfSize:13.0f];
        [tableSearchButton addSubview:buttonTitleLabel];
        
        UIView *newsTitleBGView = [[UIView alloc] initWithFrame:CGRectMake(headerView.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 60.0f, headerView.frame.size.width, 60.0f)];
        newsTitleBGView.backgroundColor = [UIColor blackColor];
        newsTitleBGView.alpha = 0.9f;
        [headerView addSubview:newsTitleBGView];
        
        UILabel *newsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(newsTitleBGView.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 60.0f, headerView.frame.size.width, 60.0f)];
        newsTitleLabel.backgroundColor = [UIColor clearColor];
        newsTitleLabel.textColor = [UIColor whiteColor];
        newsTitleLabel.text = NSLocalizedString(kNewsBottomText, nil);
        newsTitleLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:newsTitleLabel];
        
        UIControl *newsTitleControl = [[UIControl alloc] initWithFrame:CGRectMake(headerView.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 60.0f, headerView.frame.size.width, 60.0f)];
        newsTitleControl.backgroundColor = [UIColor clearColor];
        [newsTitleControl addTarget:self action:@selector(newsControlAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:newsTitleControl];
    }
    else
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

-(void)searchButtonAction
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Home_Search_Button_Pressed"
                                                           label:@"Home_Search_Button"
                                                           value:nil] build]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(kHistoryLoading, nil);
    [ServerCommunicationUser getSearchHistoyForUserId:[UserDefaultsManager getUserId] completion:^(NSArray *arr) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            SearchViewController *vc = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
            vc.historyArray = arr;
            [self.navigationController pushViewController:vc animated:YES];
        });
        
    }];
    
}

#pragma mark textField delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.placeholder = @"";
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if([textField.text isEqual: @""])
    {
        textField.placeholder = NSLocalizedString(kSearchTextFieldPlaceholder, nil);
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(![textField.text isEqualToString:@""])
    {
        maxPage = 20;
        [self getProductsByName:textField.text];
    }
    return YES;
}

-(void)getProductsByName:(NSString*)name
{
    NSURL *URL = [NSURL URLWithString:searchProduct];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"PROPRIETARY_NAME", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:maxPage], @"maxPerPage", queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if(!error)
            {
                //            NSLog(@"%@",dataJSON);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    searchProductArray = [dataJSON objectForKey:@"Data"];
                    [searchTableView reloadData];
                    searchTableView.hidden = NO;
                });
            }
            else
            {
                NSLog(@"%@",error);
            }
            
        }
        
        
    }];
    [dataTask resume];
}

-(void)newsBingSearchApiCall
{
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:getBingNews];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = 30;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            
        }
        //        NSLog(@"bingnNews %@", dataJSON);
        if(!error)
        {
            NSArray *dataArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"NEWS_LIST"]];
            NSMutableArray *newsMutableArray = [[NSMutableArray alloc] init];
            for(NSDictionary *dict in dataArray)
            {
                NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
                [tmpDic setObject:[dict objectForKey:@"TITLE"] forKey:@"name"];
                [tmpDic setObject:[dict objectForKey:@"URL"] forKey:@"url"];
                [tmpDic setObject:[dict objectForKey:@"IMAGE_LINK"] forKey:@"image"];
                [tmpDic setObject:@"bing" forKey:@"type"];
                [newsMutableArray addObject:tmpDic];
            }
            newsArray = newsMutableArray;
            [homeTableView reloadData];
//            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:newsArray, @"news", nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNewsDownloadCompleteNotification object:nil userInfo:userInfo];
//            });
        }
        else
        {
            NSLog(@"error %@",error);
        }
        
    }];
    [dataTask resume];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if(![textField.text isEqualToString:@""])
//    {
//        searchTableView.hidden = NO;
//        [searchTableView reloadData];
//    }
//    else
//    {
//        searchTableView.hidden = YES;
//    }
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
