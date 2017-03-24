//
//  ProductDetailV2ViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ProductDetailV2ViewController.h"
#import "ProductDetailV2PanelView.h"
#import "OverViewView.h"
#import "ExplanationView.h"
#import "NewsView.h"
#import "AlternativeView.h"
#import "ReviewDetailViewController.h"
#import "ReminderViewController.h"
#import "SearchResultWebViewController.h"
#import "AddAlarmViewController.h"
#import "RecallViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "DotView.h"
#import "OverViewViewV2.h"
#import "ReviewView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>
#import "ActivityItemProvider.h"
#import "UserDrawerView.h"
#import "ReviewDetailViewController.h"
#import "HistoryViewController.h"
#import "UserFeedbackViewController.h"
#import "SearchResultWebViewController.h"
#import "UserProfileViewController.h"
#import "PillReminderViewController.h"
#import "MyReviewsViewController.h"

@interface ProductDetailV2ViewController () <ProductDetailV2PanelViewDelegate, UIGestureRecognizerDelegate, NewsViewDelegate, AlternateViewDelegate, UIScrollViewDelegate, DotViewDelegate, OverViewViewV2Delegate, ReviewViewDelegate, FBSDKSharingDelegate, UserDrawerViewDelegate, ExplanationViewDelegate>
{
    ProductDetailV2PanelView *panelView;
    OverViewViewV2 *overViewViewV2;
    OverViewView *overViewView;
    ExplanationView *explanationView;
    NewsView *newsView;
    AlternativeView *alternativeView;
    ReviewView *reviewView;
    UIView *bottomBar;
    
    UIView *productImageContainerView;
    UIImageView *productImageMainView;
    UIScrollView *productImageContainerScrollView;
    
    BOOL isProductImageAvailable;
    BOOL isBookmarkSelected;
    BOOL isAlarmSetForProduct;
    UIImageView *productImage;
    
    NSMutableArray *imageArray;
    NSMutableArray *dotArray;
    int imageIndex;
    UIView *dotContainerView;
    
    UIButton *menuButton;
    BOOL isMenuSelected;
    
    NSString *imageLink;
    
    UserDrawerView *userDrawerView;
    
//    UIButton *backButton;
    UIButton *bookmarkButton;
    UIButton *alarmButton;
    UIButton *postButton;
    UIButton *shareButton;
    UIButton *homeButton;

    float bottomBarHeight;
    
    NSString *selectedProfileSelection;
}

@end

@implementation ProductDetailV2ViewController

@synthesize productId;
@synthesize productName;

-(void)loadView
{
    [super loadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getProfileData:)
                                                 name:kGetProfileInfoNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadRevieTable)
                                                 name:kReviewPosted
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateProductImage:)
                                                 name:kProductImageReceived
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(descriptionReceived:)
                                                 name:@"ProductDetailReceived"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(facebookShareAction)
                                                 name:@"FacebookShare"
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isProductImageAvailable = NO;
    imageIndex = 0;
    imageArray = [[NSMutableArray alloc] init];
    dotArray = [[NSMutableArray alloc] init];
    imageLink = @"";
    selectedProfileSelection = @"";
    
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, customNavigationBar.frame.size.height/2 - 45/2, 45, 45);
    [backButton setBackgroundImage:[UIImage imageNamed:@"ThemeColorBackButton.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    [self.view addSubview:customNavigationBar];
    
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 13, 35, 35);
    [userButton setBackgroundImage:[UIImage imageNamed:@"hanbuger icon.png"] forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(openDrawerView) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:userButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backButton.frame.size.width, 0, [UIScreen mainScreen].bounds.size.width - 2 * backButton.frame.size.width, customNavigationBar.frame.size.height)];
    titleLabel.text = productName;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.minimumScaleFactor = 0.5f;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [customNavigationBar addSubview:titleLabel];
    
    productImage = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, 0, 60, 60)];
    productImage.contentMode = UIViewContentModeScaleAspectFit;
    productImage.image = [UIImage imageNamed:@"noImageAvailable.png"];
    //    [customNavigationBar addSubview:productImage];
    
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, 0, 60, 60);
    [menuButton setImage:[UIImage imageNamed:@"downButton.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:menuButton];
    
//    bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    bookmarkButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, menuButton.frame.origin.y + menuButton.frame.size.height + 2, 100, 20);
//    bookmarkButton.alpha = 0;
//    [bookmarkButton setTitle:@"Bookmark" forState:UIControlStateNormal];
//    if(!isBookmarkSelected)
//    {
//        [bookmarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [bookmarkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    }
//    [self.view addSubview:bookmarkButton];
    
//    alarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    alarmButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, bookmarkButton.frame.origin.y + bookmarkButton.frame.size.height + 2, 100, 20);
//    alarmButton.alpha = 0;
//    [alarmButton setTitle:@"Alarm" forState:UIControlStateNormal];
//    [alarmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    isAlarmSetForProduct = NO;
//    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
//    {
//        if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
//        {
//            [alarmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            isAlarmSetForProduct = YES;
//            break;
//        }
//    }
//    [alarmButton addTarget:self action:@selector(alarmButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:alarmButton];
    
//    postButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    postButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, alarmButton.frame.origin.y + alarmButton.frame.size.height + 2, 100, 20);
//    postButton.alpha = 0;
//    [postButton setTitle:@"Post review" forState:UIControlStateNormal];
//    [postButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [postButton addTarget:self action:@selector(postReviewButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:postButton];
    
    panelView = [[ProductDetailV2PanelView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, 60)];
    panelView.delegate = self;
    [self.view addSubview:panelView];
    
    bottomBarHeight = 40;
    
    alternativeView = [[AlternativeView alloc] initWithFrame:CGRectMake(0, panelView.frame.origin.y + panelView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - panelView.frame.size.height - customNavigationBar.frame.size.height - bottomBarHeight) WithProductId:self.productId];
    alternativeView.delegate = self;
    [self.view addSubview:alternativeView];
    
    reviewView = [[ReviewView alloc] initWithFrame:CGRectMake(0, panelView.frame.origin.y + panelView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - panelView.frame.size.height - customNavigationBar.frame.size.height - bottomBarHeight) WithProductId:self.productId];
    reviewView.delegate = self;
    [self.view addSubview:reviewView];
    
    newsView = [[NewsView alloc] initWithFrame:CGRectMake(0, panelView.frame.origin.y + panelView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - panelView.frame.size.height - customNavigationBar.frame.size.height - bottomBarHeight) WithProductId:self.productId];
    newsView.delegate = self;
    [self.view addSubview:newsView];
    
    explanationView = [[ExplanationView alloc] initWithFrame:CGRectMake(0, panelView.frame.origin.y + panelView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - panelView.frame.size.height - customNavigationBar.frame.size.height - bottomBarHeight) WithProductId:self.productId];
    explanationView.delegate = self;
    [self.view addSubview:explanationView];
    
    overViewViewV2 = [[OverViewViewV2 alloc] initWithFrame:CGRectMake(0, panelView.frame.origin.y + panelView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - panelView.frame.size.height - customNavigationBar.frame.size.height - bottomBarHeight) WithProductId:self.productId];
    overViewViewV2.delegate = self;
    [self.view addSubview:overViewViewV2];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkProductBookmark];
    
    bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, overViewViewV2.frame.origin.y + overViewViewV2.frame.size.height, [UIScreen mainScreen].bounds.size.width, bottomBarHeight)];
    bottomBar.backgroundColor = [UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f];
    [self.view addSubview:bottomBar];
    
    bottomBarHeight = 28;
    float buttonWidth = [UIScreen mainScreen].bounds.size.width / 5;
    float buttonGap = buttonWidth - bottomBarHeight;
    
//    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(buttonGap/2, 0, bottomBarHeight, bottomBarHeight);
//    backButton.backgroundColor = [UIColor clearColor];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"backButtonBlack.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomBar addSubview:backButton];
    
    bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookmarkButton.frame = CGRectMake(buttonGap/2, 6, bottomBarHeight, bottomBarHeight);
    if(!isBookmarkSelected)
    {
        [bookmarkButton setImage:[UIImage imageNamed:@"bookmark-icon-Recovered.png"] forState:UIControlStateNormal];
    }
    else
    {
        [bookmarkButton setImage:[UIImage imageNamed:@"bookmark-icon-Recovered (1).png"] forState:UIControlStateNormal];
    }
    [bookmarkButton addTarget:self action:@selector(bookmarkButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:bookmarkButton];
    
    alarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alarmButton setImage:[UIImage imageNamed:@"Pill Reminder Icon.png"] forState:UIControlStateNormal];
    alarmButton.frame = CGRectMake(bookmarkButton.frame.origin.x + bottomBarHeight + buttonGap, 6, bottomBarHeight, bottomBarHeight);
    isAlarmSetForProduct = NO;
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
        {
            [alarmButton setImage:[UIImage imageNamed:@"pill-reminder-icon-two.png"] forState:UIControlStateNormal];
            isAlarmSetForProduct = YES;
            break;
        }
    }
    [alarmButton addTarget:self action:@selector(alarmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:alarmButton];
    
    homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(alarmButton.frame.origin.x + bottomBarHeight + buttonGap -5, 0, 40, 40);
    [homeButton setImage:[UIImage imageNamed:@"appIcon180.png"] forState:UIControlStateNormal];
    homeButton.layer.cornerRadius = homeButton.frame.size.width/2;
    homeButton.layer.borderWidth = 0.5f;
    homeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [homeButton setClipsToBounds:YES];
    [homeButton addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:homeButton];
    
    postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(homeButton.frame.origin.x + bottomBarHeight + buttonGap + 15, 3, bottomBarHeight, bottomBarHeight);
    [postButton setImage:[UIImage imageNamed:@"review_icon_blue.png"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postReviewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:postButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"Share_Icon.png"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(postButton.frame.origin.x + bottomBarHeight + buttonGap, 3, bottomBarHeight, bottomBarHeight);
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:shareButton];
    
    userDrawerView = [[UserDrawerView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    userDrawerView.delegate = self;
    [self.view addSubview:userDrawerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)openDrawerView
{
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

-(void)descriptionReceived:(NSNotification*)_notification
{
    if(![[_notification.userInfo objectForKey:@"PRODUCT_IMAGE"] isEqualToString:@""])
    {
        imageLink = [_notification.userInfo objectForKey:@"PRODUCT_IMAGE"];
    }
}

-(void)menuButtonAction
{
    isMenuSelected = !isMenuSelected;
    if(isMenuSelected)
    {
        [self.view bringSubviewToFront:bookmarkButton];
        [self.view bringSubviewToFront:alarmButton];
        [self.view bringSubviewToFront:postButton];
        [menuButton setImage:[UIImage imageNamed:@"upButton.png"] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        bookmarkButton.alpha = 1;
        alarmButton.alpha = 1;
        postButton.alpha = 1;
        
        [UIView commitAnimations];
    }
    else
    {
        [menuButton setImage:[UIImage imageNamed:@"downButton.png"] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        bookmarkButton.alpha = 0;
        alarmButton.alpha = 0;
        postButton.alpha = 0;
        
        [UIView commitAnimations];
    }
}

-(void)backButtonAction:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)overViewButtonAction
{
    [self.view bringSubviewToFront:overViewViewV2];
    [self.view bringSubviewToFront:bottomBar];
}

-(void)explanataionButtonAction
{
    [self.view bringSubviewToFront:explanationView];
    [self.view bringSubviewToFront:bottomBar];
}

-(void)newsButtonAction
{
    [self.view bringSubviewToFront:newsView];
    [self.view bringSubviewToFront:bottomBar];
}

-(void)reviewButtonAction
{
    [self.view bringSubviewToFront:reviewView];
    [self.view bringSubviewToFront:bottomBar];
}

-(void)alternativeButtonAction
{
    [self.view bringSubviewToFront:alternativeView];
    [self.view bringSubviewToFront:bottomBar];
}

-(void)whyButtonAction
{
    for (UIView *view in panelView.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)view;
            if(button.tag == 1)
            {
                [panelView explanationButtonAction:button];
            }
        }
    }
}

-(void)homeButtonAction
{
//    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:[self.navigationController viewControllers].count - 3] animated:YES];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}

-(void)checkProductBookmark
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:checkBookmark];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:productId, @"PRODUCT_ID", [UserDefaultsManager getUserId], @"USR_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    //    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"check %@",dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([[dataJSON objectForKey:@"COMMENTS"] isEqualToString:@"TRACKED"])
                    {
                        isBookmarkSelected = YES;
                        //                        [bookmarkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [bookmarkButton setImage:[UIImage imageNamed:@"bookmark-icon-Recovered (1).png"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        isBookmarkSelected = NO;
                        //                        [bookmarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        [bookmarkButton setImage:[UIImage imageNamed:@"bookmark-icon-Recovered.png"] forState:UIControlStateNormal];
                    }
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

-(void)bookmarkButtonAction
{
    if([[UserDefaultsManager getUserName] isEqualToString:@""])
    {
        [self bookmarkButtonActionForceLogin];
    }
    else
    {
        isBookmarkSelected = !isBookmarkSelected;
        if(!isBookmarkSelected)
        {
            if(isAlarmSetForProduct)
            {
                [self bookmarkDeleteActionConfirmation];
            }
            else
            {
                [self bookmarkDeleteCall];
            }
        }
        else
        {
            [bookmarkButton setImage:[UIImage imageNamed:@"bookmark-icon-Recovered (1).png"] forState:UIControlStateNormal];
            
            NSMutableString *urlStr = [[NSMutableString alloc] init];
            [urlStr appendString:updateUserProducts2];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
            [request setHTTPMethod:@"POST"];
            
            NSError *error;
            NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:productId, @"PRODUCT_ID", [UserDefaultsManager getUserId], @"USR_ID", nil];
            
            NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
            //    NSLog(@"%@",mapData);
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
            [request setHTTPBody:postData];
            
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSDictionary *dataJSON;
                if(data)
                {
                    dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    NSLog(@"insert %@",dataJSON);
                    if(!error)
                    {
                        
                    }
                    else
                    {
                        NSLog(@"%@",error);
                    }
                }
            }];
            [dataTask resume];
        }
    }
}

-(void)bookmarkDeleteCall
{
    //    [bookmarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //    [alarmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [bookmarkButton setImage:[UIImage imageNamed:@"bookmark-icon-Recovered.png"] forState:UIControlStateNormal];
    [alarmButton setImage:[UIImage imageNamed:@"Pill Reminder Icon.png"] forState:UIControlStateNormal];
    isAlarmSetForProduct = NO;
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:deleteBookmark];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:productId, @"PRODUCT_ID", [UserDefaultsManager getUserId], @"USR_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    //    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"delete %@",dataJSON);
            if(!error)
            {
                
            }
            else
            {
                NSLog(@"%@",error);
            }
        }
    }];
    [dataTask resume];
}

-(void)bookmarkButtonActionForceLogin
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(kForceLogin, nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(kAlertDismess, nil) style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction* login = [UIAlertAction actionWithTitle:NSLocalizedString(kAlertLogin, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
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

-(void)bookmarkDeleteActionConfirmation
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Removing this bookmark will delete alarm for this medicine too. Do you want to proceed?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction* login = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self bookmarkDeleteCall];
    }];
    [alertController addAction:dismiss];
    [alertController addAction:login];
    
    [self presentViewController:alertController animated:YES completion:^{
        
        return;
    }];
}

-(void)alarmButtonAction
{
    if(![[UserDefaultsManager getUserName] isEqualToString:@""])
    {
        AddAlarmViewController *vc = [[AddAlarmViewController alloc] initWithNibName:@"AddAlarmViewController" bundle:nil];
        vc.productId = self.productId;
        vc.isFromProductDetail = YES;
        vc.productName = self.productName;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(kForceLogin, nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(kAlertDismess, nil) style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction* login = [UIAlertAction actionWithTitle:NSLocalizedString(kAlertLogin, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
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

-(void)postReviewButtonAction
{
    if(![[UserDefaultsManager getUserName] isEqualToString:@""])
    {
        ReviewDetailViewController *vc = [[ReviewDetailViewController alloc] initWithNibName:@"ReviewDetailViewController" bundle:nil ProductId:self.productId];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(kForceLogin, nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(kAlertDismess, nil) style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction* login = [UIAlertAction actionWithTitle:NSLocalizedString(kAlertLogin, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
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

-(void)newsCellActionUrlString:(NSString *)urlStr
{
    SearchResultWebViewController *vc = [[SearchResultWebViewController alloc] initWithNibName:@"SearchResultWebViewController" bundle:nil];
    vc.urlString = urlStr;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)recallCellActionForDictionary:(NSDictionary *)dictionary
{
    RecallViewController *vc = [[RecallViewController alloc] initWithNibName:@"RecallViewController" bundle:nil];
    vc.recallDictionary = dictionary;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)similarProductSelectionAction:(NSString *)_productId productName:(NSString *)_productName
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Alternative Product Selection"
                                                           label:_productName
                                                           value:nil] build]];
    
    ProductDetailV2ViewController *vc = [[ProductDetailV2ViewController alloc] initWithNibName:@"ProductDetailV2ViewController" bundle:nil];
    vc.productId = _productId;
    vc.productName = _productName;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)intersectSelectionAction:(NSString*)_productId productName:(NSString*)_productName
{
    ProductDetailV2ViewController *vc = [[ProductDetailV2ViewController alloc] initWithNibName:@"ProductDetailV2ViewController" bundle:nil];
    vc.productId = _productId;
    vc.productName = _productName;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)reloadRevieTable
{
    [reviewView getReviewsFromServer];
}

-(void)updateProductImage:(NSNotification*)notification
{
    NSArray *productImageUrlArray = [[notification userInfo] objectForKey:@"PRODUCT_IMAGE_URL_ARRAY"];
    
    [imageArray removeAllObjects];
    for(NSDictionary *dict in productImageUrlArray)
    {
        [imageArray addObject:[dict objectForKey:@"image_link"]];
    }
    
//    if(imageArray && imageArray.count > 0)
//    {
//        isProductImageAvailable = YES;
//        [self setProductImageButton];
//    }
//    imageIndex = 0;
//    [productImage sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"noImageAvailable.png"]];
}

-(void)imageButtonAction
{
//    [imageArray removeAllObjects];
//    for(NSDictionary *dict in _imageArray)
//    {
//        [imageArray addObject:[dict objectForKey:@"image_link"]];
//    }
    if(imageArray && imageArray.count > 0)
    {
        isProductImageAvailable = YES;
        imageIndex = 0;
        [self productImageButtonAction];
    }
}

-(void)setProductImageButton
{
    if(isProductImageAvailable)
    {
        UIButton *productImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        productImageButton.frame = CGRectMake(productImage.frame.origin.x, productImage.frame.origin.y, productImage.frame.size.width, productImage.frame.size.height);
        productImageButton.backgroundColor = [UIColor clearColor];
        [productImageButton addTarget:self action:@selector(productImageButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:productImageButton];
    }
}

-(void)productImageButtonAction
{
    imageIndex = 0;
    
    productImageContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    productImageContainerView.backgroundColor = [UIColor clearColor];
    productImageContainerView.alpha = 0;
    [self.view addSubview:productImageContainerView];
    
    UIControl *productImageControl = [[UIControl alloc] initWithFrame:productImageContainerView.frame];
    productImageControl.backgroundColor = [UIColor lightGrayColor];
    productImageControl.alpha = 0.3f;
    [productImageControl addTarget:self action:@selector(dismissProductImageContainerView) forControlEvents:UIControlEventTouchUpInside];
    [productImageContainerView addSubview:productImageControl];
    
//    [productImageContainerView addSubview:productImageMainView];
    
    productImageContainerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2 - [UIScreen mainScreen].bounds.size.height/4, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    productImageContainerScrollView.contentSize = productImageMainView.image.size;
    productImageContainerScrollView.showsVerticalScrollIndicator = NO;
    productImageContainerScrollView.showsHorizontalScrollIndicator = NO;
    productImageContainerScrollView.minimumZoomScale = 1.0f;
    productImageContainerScrollView.maximumZoomScale = 5.0f;
    productImageContainerScrollView.clipsToBounds = YES;
    productImageContainerScrollView.scrollEnabled = NO;
    productImageContainerScrollView.backgroundColor = [UIColor lightGrayColor];
//    productImageContainerScrollView.zoomScale = 1.01;
    productImageContainerScrollView.delegate = self;
//    [productImageContainerScrollView addSubview:productImageControl];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.delegate = self;
    [productImageContainerScrollView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.delegate = self;
    [productImageContainerScrollView addGestureRecognizer:swipeLeft];
    
    productImageMainView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, productImageContainerScrollView.frame.size.width, productImageContainerScrollView.frame.size.height)];
    [productImageMainView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:imageIndex]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    productImageMainView.backgroundColor = [UIColor clearColor];
    productImageMainView.contentMode = UIViewContentModeScaleAspectFit;
    [productImageContainerScrollView addSubview:productImageMainView];
    [productImageContainerView addSubview:productImageContainerScrollView];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
         productImageContainerView.alpha = 1;
     }
    completion:nil];
    
    dotContainerView = [[UIView alloc] init];
    dotContainerView.backgroundColor = [UIColor clearColor];
    CGFloat dotWidth = 10;
    CGFloat dotContainerWidth = imageArray.count * dotWidth;
    dotContainerView.frame = CGRectMake(productImageContainerView.frame.size.width/2 - dotContainerWidth/2, productImageContainerScrollView.frame.origin.y + productImageContainerScrollView.frame.size.height + 10, dotContainerWidth, dotWidth);
    [productImageContainerView addSubview:dotContainerView];
    
    int xMarginDot = 0;
    for(int i = 0; i < imageArray.count; i++)
    {
        DotView *dotView = [[DotView alloc] initWithFrame:CGRectMake(xMarginDot, 0, dotWidth, dotWidth) withIndex:i];
        dotView.delegate = self;
        dotView.backgroundColor = [UIColor clearColor];
        if(i == 0)
        {
            dotView.circleView.backgroundColor = [UIColor grayColor];
        }
        [dotArray addObject:dotView];
        [dotContainerView addSubview:dotView];
        xMarginDot += dotWidth;
    }
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return productImageMainView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if(scrollView.zoomScale != scrollView.minimumZoomScale)
    {
        scrollView.scrollEnabled = YES;
    }
    else
    {
        scrollView.scrollEnabled = NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x > 0 && scrollView.zoomScale == scrollView.minimumZoomScale)
    {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }
    if(scrollView.contentOffset.y > 0 && scrollView.zoomScale == scrollView.minimumZoomScale)
    {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

-(void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer
{
    if(imageIndex > 0)
    {
        DotView *dotView = [dotArray objectAtIndex:imageIndex];
        dotView.circleView.backgroundColor = [UIColor whiteColor];
        
        imageIndex--;
        NSLog(@"url %@", [imageArray objectAtIndex:imageIndex]);
        [productImageMainView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:imageIndex]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        for(DotView *dotView in dotArray)
        {
            if(dotView.index == imageIndex)
            {
                dotView.circleView.backgroundColor = [UIColor grayColor];
                break;
            }
        }
    }
}

-(void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer
{
    if(imageIndex < imageArray.count - 1)
    {
        DotView *dotView = [dotArray objectAtIndex:imageIndex];
        dotView.circleView.backgroundColor = [UIColor whiteColor];
        
        imageIndex++;
        NSLog(@"url %@", [imageArray objectAtIndex:imageIndex]);
        [productImageMainView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:imageIndex]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        for(DotView *dotView in dotArray)
        {
            if(dotView.index == imageIndex)
            {
                dotView.circleView.backgroundColor = [UIColor grayColor];
                break;
            }
        }
    }
}

-(void)dotViewClickedWithIndex:(int)index
{
    DotView *dotView = [dotArray objectAtIndex:imageIndex];
    dotView.circleView.backgroundColor = [UIColor whiteColor];
    
    imageIndex = index;
    
    [productImageMainView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:imageIndex]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    for(DotView *dotView in dotArray)
    {
        if(dotView.index == imageIndex)
        {
            dotView.circleView.backgroundColor = [UIColor grayColor];
            break;
        }
    }
}

-(void)dismissProductImageContainerView
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        productImageContainerView.alpha = 0;
    }
                     completion:^(BOOL finished){
                         if(finished)
                         {
                             [productImageContainerView removeFromSuperview];
                             [dotArray removeAllObjects];
                         }
                     }];
}

-(void)fbShareActionWithImage:(NSString *)_imageLink
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/pharmacate/id1109769271?ls=1&mt=8"];
    content.contentTitle = [NSString stringWithFormat:@"Checkout this medicine %@ at Pharmacate", self.productName];
    if(_imageLink && ![_imageLink isEqualToString:@""])
    {
        content.imageURL = [NSURL URLWithString:_imageLink];
    }
    
    FBSDKShareDialog* dialog = [[FBSDKShareDialog alloc] init];
    dialog.mode = FBSDKShareDialogModeFeedWeb;
    dialog.shareContent = content;
    dialog.fromViewController = self;
    [dialog show];
}

-(void)facebookShareAction
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/pharmacate/id1109769271?ls=1&mt=8"];
    content.contentTitle = [NSString stringWithFormat:@"Checkout this medicine %@ at Pharmacate", self.productName];
    if(imageLink && ![imageLink isEqualToString:@""])
    {
        content.imageURL = [NSURL URLWithString:imageLink];
    }
    
    FBSDKShareDialog* dialog = [[FBSDKShareDialog alloc] init];
    dialog.mode = FBSDKShareDialogModeFeedWeb;
    dialog.shareContent = content;
    dialog.fromViewController = self;
    [dialog show];
}

//-(void)shareButtonActionWithImage:(NSString *)_imageLink
//{
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//    dialog.fromViewController = self;
////    dialog.shareContent = [FBSDKShareLinkContent alloc] initwit;
//    dialog.mode = FBSDKShareDialogModeNative; // if you don't set this before canShow call, canShow would always return YES
//    if (![dialog canShow]) {
//        // fallback presentation when there is no FB app
//        dialog.mode = FBSDKShareDialogModeFeedBrowser;
//    }
//    [dialog show];
    
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        
//        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        
//        [controller setInitialText:@"First post from my iPhone app"];
//        [controller addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
//        [controller addImage:_image];
//        
//        [self presentViewController:controller animated:YES completion:Nil];
//        
//    }
    
    
//    content.contentDescription = [NSString stringWithFormat:@"Checkout this medice %@ at Pahrmacate", self.productName];
    
//    FBSDKShareButton *btn = 
    
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//    dialog.fromViewController = self;
//    dialog.content = content;
//    dialog.mode = FBSDKShareDialogModeShareSheet;
//    [dialog show];
//    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    
    
//    NSDictionary *properties = @{
//                                 @"og:type": @"fitness.course",
//                                 @"og:title": @"Sample Course",
//                                 @"og:description": @"This is a sample course.",
//                                 @"fitness:duration:value": @100,
//                                 @"fitness:duration:units": @"s",
//                                 @"fitness:distance:value": @12,
//                                 @"fitness:distance:units": @"km",
//                                 @"fitness:speed:value": @5,
//                                 @"fitness:speed:units": @"m/s",
//                                 };
//    FBSDKShareOpenGraphObject *object = [FBSDKShareOpenGraphObject objectWithProperties:properties];
//    FBSDKShareOpenGraphAction *action = [[FBSDKShareOpenGraphAction alloc] init];
//    action.actionType = @"fitness.runs";
//    [action setObject:object forKey:@"fitness:course"];
//    FBSDKShareOpenGraphContent *content = [[FBSDKShareOpenGraphContent alloc] init];
//    content.action = action;
//    content.previewPropertyName = @"fitness:course";
//}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"results %@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"error %@", error);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    
}

-(void)shareButtonActionWithImage:(UIImage *)_image
{
    // create a message
//    NSString *theMessage = @"Some text we're sharing with an activity controller";
    ActivityItemProvider *activityItem = [[ActivityItemProvider alloc] initWithPlaceholderItem:@""];
    NSArray *items = [NSArray arrayWithObjects:activityItem, [NSString stringWithFormat:@"Checkout this medicine %@ at Pharmacate", self.productName], [NSURL URLWithString:@"https://itunes.apple.com/us/app/pharmacate/id1109769271?ls=1&mt=8"], _image, nil];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    activityItem.activityController = controller;
//    controller.excludedActivityTypes = @[UIActivityTypePostToFacebook];
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        
        if([activityType isEqualToString: UIActivityTypePostToFacebook])
        {
            return;
        }
        //        NSLog(@"returnedItems %@", returnedItems);
        // react to the completion
        if (completed) {
            
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
            
        } else {
            
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
    // and present it
    [self presentActivityController:controller];
}

-(void)shareButtonAction
{
    ActivityItemProvider *activityItem = [[ActivityItemProvider alloc] initWithPlaceholderItem:@""];
    UIImage *_productImage;
    if(imageLink && ![imageLink isEqualToString:@""])
    {
        _productImage = overViewViewV2.productImageView.image;
    }
    NSArray *items = [NSArray arrayWithObjects:activityItem, [NSString stringWithFormat:@"Checkout this medicine %@ at Pharmacate", self.productName], [NSURL URLWithString:@"https://itunes.apple.com/us/app/pharmacate/id1109769271?ls=1&mt=8"], _productImage, nil];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    activityItem.activityController = controller;
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks, @"com.apple.reminders.RemindersEditorExtension", @"com.apple.mobilenotes.SharingExtension"];
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        
        if([activityType isEqualToString: UIActivityTypePostToFacebook])
        {
            return;
        }
        //        NSLog(@"returnedItems %@", returnedItems);
        // react to the completion
        if (completed) {
            
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
            
        } else {
            
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
    // and present it
    [self presentActivityController:controller];
}

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
}


-(void)historyButtonAction:(NSArray*)historyArray withDates:(NSArray *)dates
{
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

-(void)captureImageButtonAction
{
    
}

-(void)logOutButtonAction
{
    
}

-(void)getProfileData:(NSNotification*)notification
{
    NSArray *productIdArray = [[notification userInfo] valueForKey:@"PRODUCT_LIST"];
    NSArray *diseaseIdArray = [[notification userInfo] valueForKey:@"DISEASE_LIST"];
    NSArray *allergenIdArray = [[notification userInfo] valueForKey:@"ALLERGEN_LIST"];
    NSArray *allergicProductIdArray = [[notification userInfo] valueForKey:@"ALLERGIC_PRODUCT_LIST"];
    
    [self hideDrawerView];
    UserProfileViewController *vc = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    vc.selectedProductsArray = productIdArray;
    vc.selectedDiseasesArray = diseaseIdArray;
    vc.selectedAllergenArray = allergenIdArray;
    vc.selectedAllergicProductArray = allergicProductIdArray;
    vc.selectedProfileSection = selectedProfileSelection;
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
