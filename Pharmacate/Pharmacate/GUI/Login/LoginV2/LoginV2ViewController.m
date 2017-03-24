//
//  LoginV2ViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/29/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "LoginV2ViewController.h"
#import "PageView.h"
#import "CredentialView.h"
#import "EmailRegistrationViewController.h"
#import "HomeViewController.h"
#import "TermsViewController.h"
#import "SearchResultWebViewController.h"

@interface LoginV2ViewController () <CredentialViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate, ChimpKitRequestDelegate, MBProgressHUDDelegate>
{
    NSString *emailStr;
    NSString *passWordStr;
    
    BOOL isDiseaseDownloadComplete;
}

@end

@implementation LoginV2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSString *temp = @"{
//    "maxRowCount": [
//                    1
//                    ],
//    "Data": [
//             {
//                 "NEWS_IMAGE_URL": "",
//                 "NEWS_URL": "http://www.webmd.com/alzheimers/news/20120415/drug-diagnoses-alzheimers-earlier",
//                 "NEWS_DATE": "2012-04-15 00:00:00",
//                 "DATA_SOURCE_ID": 302,
//                 "TITLE": "[Drug May Help Diagnose Alzheimer's Earlier]"
//             }
//             ]
//}"
    
//    [ServerCommunicationUser newsBingSearchApiCall];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text = @"Gathering Info...";
    
//    [ServerCommunicationUser getAllProductsFromServer];
//    [ServerCommunicationUser getAllDiseasesFromServer];
//    NSLog(@"numberOfProduct %ld",[ServerCommunicationUser getNumberOfProduct]);
//    NSLog(@"numberOfDisease %ld", [ServerCommunicationUser getNumberOfDisease]);
    
//    isProductDownloadComplete = NO;
    isDiseaseDownloadComplete = NO;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productDownloadComplete) name:kProductDownloadComplete object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(diseaseDownloadComplete) name:kProductDownloadComplete object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    PageView *pv = [[PageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2)];
    [self.view addSubview:pv];
    
    CredentialView *cv = [[CredentialView alloc] initWithFrame:CGRectMake(0, pv.frame.size.height, pv.frame.size.width, pv.frame.size.height)];
    cv.delegate = self;
    [self.view addSubview:cv];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showKeyBoardInfo:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeyBoard)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    if(![[UserDefaultsManager getUserToken] isEqualToString:@""])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(kCheckingTokenTextKey, nil);
        
        [ServerCommunicationUser checkUserToken:[UserDefaultsManager getUserToken] forViewController:self];
    }
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    
//    id<GAITracker> tracker =[[GAI sharedInstance] trackerWithTrackingId:@"UA-80778267-1"];
//    [tracker set:kGAIScreenName
//           value:@"LoginV2 Screen"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//    [GAI sharedInstance].trackUncaughtExceptions = YES;
//    [GAI sharedInstance].dispatchInterval = 0;
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
//                                                          action:@"touch"
//                                                           label:@"menuButton"
//                                                           value:nil] build]];
//    [tracker set:kGAIScreenName
//           value:nil];
    
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateMonitor:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"LoginV2"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)sensorStateMonitor:(NSNotificationCenter *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user.");
    }
    
    else
    {
        NSLog(@"Device is not closer to user.");
    }
}

-(void)productDownloadComplete
{
//    isProductDownloadComplete = YES;
}

-(void)diseaseDownloadComplete
{
    isDiseaseDownloadComplete = YES;
//    [self checkAllDownloadComplete];
}

-(void)checkAllDownloadComplete
{
    if(isDiseaseDownloadComplete)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)showKeyBoardInfo:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(0, -keyboardFrameBeginRect.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)hideKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma mark Google Sign In Delegate Methods

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    
    [ServerCommunicationUser insertDataToGoogleProfileWithResult:user forViewController:self];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    NSLog(@"4");
}

#pragma mark CredentialView Delegate Methods

-(void)emailFieldEndedEditing:(NSString*)emailString
{
    emailStr = emailString;
}

-(void)passWordFieldEndedEditing:(NSString*)passWordString
{
    passWordStr = passWordString;
}

-(void)facebookButtonAction
{
    if([FBSDKAccessToken currentAccessToken].expirationDate.timeIntervalSinceNow > 0.0f)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(kLoadingSocialAccounts, nil);
        hud.delegate = self;
        
        [self fetchUserInfoFromFBProfile];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(kLoadingSocialAccounts, nil);
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile",@"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                NSLog(@"error %@",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
            else if (result.isCancelled)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
            else
            {
                [self fetchUserInfoFromFBProfile];
            }
        }];
    }
}

-(void)googleButtonAction
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(kLoadingSocialAccounts, nil);
    [[GIDSignIn sharedInstance] signIn];
}

-(void)twitterButtonAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"This feature will be coming soon!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:dismiss];
    
    [self presentViewController:alertController animated:YES completion:^{
        
        return;
    }];
}

-(void)skipSignInButtonAction
{
    NSString *alertStr = @"By signing in you will be able to use unique pill reminder feature and bookmark medicines you want to follow";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You are missing out" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *later = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(kLoadingSocialAccounts, nil);
        [ServerCommunicationUser skipSignInforViewController:self];
    }];
    
    UIAlertAction *signIn = [UIAlertAction actionWithTitle:@"Sign in" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    
    [alertController addAction:later];
    [alertController addAction:signIn];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)forgotPassWordButtonAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"This feature will be coming soon!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:dismiss];
    
    [self presentViewController:alertController animated:YES completion:^{
        
        return;
    }];
}

-(void)signInButtonAction
{
    if([emailStr isEqualToString:@""] || !emailStr)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your email address!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:dismiss];
        
        [self presentViewController:alertController animated:YES completion:^{
            
            return;
        }];
    }
    else if([passWordStr isEqualToString:@""] || !passWordStr)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please give your password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:dismiss];
        
        [self presentViewController:alertController animated:YES completion:^{
            
            return;
        }];
    }
    else if(![emailStr isEqualToString:@""] && ![passWordStr isEqualToString:@""])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading..";
        
        [ServerCommunicationUser signInUserWithUserName:emailStr andPassWord:passWordStr forViewController:self];
    }
}

-(void)signUpButtonAction
{
    EmailRegistrationViewController *vc = [[EmailRegistrationViewController alloc] initWithNibName:@"EmailRegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)termsButtonAction
{
    SearchResultWebViewController *vc = [[SearchResultWebViewController alloc] initWithNibName:@"SearchResultWebViewController" bundle:nil];
    vc.urlString = termsLink;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark CommunicateWithServer

-(void)fetchUserInfoFromFBProfile
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email, first_name, last_name, gender, name, locale, picture"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             
             if (!error)
             {
                 NSDictionary *params = @{@"id": mailChimpListId, @"email": @{@"email": [result objectForKey:@"email"]}, @"merge_vars": @{@"FNAME": [result objectForKey:@"first_name"], @"LName":[result objectForKey:@"last_name"]}};
                 [[ChimpKit sharedKit] callApiMethod:@"lists/subscribe" withParams:params andDelegate:self];
                 
                 [ServerCommunicationUser insertDataToFbProfileWithResult:result forViewController:self];
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 });
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please connect to internet" preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(kForceLoginAlertDismiss, nil) style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:dismiss];
                 
                 [self presentViewController:alertController animated:YES completion:^{
                     
                     return;
                 }];
             }
         }];
    }
}

- (void)ckRequestIdentifier:(NSUInteger)requestIdentifier didSucceedWithResponse:(NSURLResponse *)response andData:(NSData *)data
{
//    NSLog(@"HTTP Status Code: %@", response);
    NSError *error;
    NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSLog(@"ck %@",dataJSON);
}

- (void)ckRequestFailedWithIdentifier:(NSUInteger)requestIdentifier andError:(NSError *)anError
{
    NSLog(@"ckError %@", anError);
}

-(void)goToHomeViewController
{
//    [ServerCommunicationUser getAllProductsFromServer];
    HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"yes %@",hud.label.text);
}

@end
