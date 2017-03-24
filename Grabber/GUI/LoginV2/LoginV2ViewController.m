//
//  LoginV2ViewController.m
//  Grabber
//
//  Created by World on 4/2/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "LoginV2ViewController.h"
#import "AppDelegate.h"
#import "HomeV3ViewController.h"
#import <Social/Social.h>
#import "STTwitter.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

#define twitterApiKey       @"EBo4HVYLQBKNf5yZ9lGw"
#define TwitterApiSecret    @"FgixoqvmFAO9xzsnPIfdRqE75d6XOWyDPG0bu96Dgg"

@interface LoginV2ViewController () <ASIHTTPRequestDelegate, FBLoginViewDelegate>
{
    UIAlertView *loadingAlert;
    NSString *userNameStr;
    UIImage *proPic;
}

@property (nonatomic, retain) ASIHTTPRequest *fbSessionTokenRequest;
@property (nonatomic, retain) STTwitterAPI *twitter;

@end

@implementation LoginV2ViewController

@synthesize fbSessionTokenRequest;
@synthesize isFirstTimeLoginDone;

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
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    
    userNameStr = @"";
    
    [keepMeSignedInSwitch setOn:[UserDefaultsManager isKeepMeSignedInOn]];
    [keepMeSignedInSwitch setOnTintColor:[UIColor colorWithRed:67.0f/255.0f green:158.0f/255.0f blue:215.0f/255.0f alpha:1.0f]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    
    self.screenName = @"Login Screen";
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App Launched"     // Event category (required)
                                                          action:@"Login Screen"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
//    statusLabel.text = @"You're logged in as";
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    if(!self.isFirstTimeLoginDone)
    {
        NSLog(@"user %@",[[user location] id]);
        
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
            if (error)
            {
                // Handle error
                NSLog(@"error %@", [error localizedDescription]);
                [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                self.isFirstTimeLoginDone = NO;
                return;
            }
            else
            {
//                NSString *username = [user objectForKey:@""];
                NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", [user objectForKey:@"username"]];
                NSLog(@"url -> %@",userImageURL);
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]];
                proPic = [UIImage imageWithData:data];
                
                [UserDefaultsManager setFbEmail:[user objectForKey:@"email"]];
                //                [UserDefaultsManager setFbUserName:[user objectForKey:@"username"]];
                
                [UserDefaultsManager setFacebookEnabled:YES];
                
                userNameStr = [NSString stringWithFormat:@"%@ %@",[user objectForKey:@"first_name"], [user objectForKey:@"last_name"]];
                [UserDefaultsManager setFbUserName:userNameStr];
                
                NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
                NSLog(@"fbToken %@",token);
                
                NSMutableString *urlStr = [[NSMutableString alloc] init];
                [urlStr appendFormat:@"%@",baseUrl];
                [urlStr appendFormat:@"%@",facebookLoginApi];
                [urlStr appendFormat:@"%@",[token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                self.fbSessionTokenRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                self.fbSessionTokenRequest.delegate = self;
                [self.fbSessionTokenRequest startAsynchronous];
            }
        }];
    }
    
    self.isFirstTimeLoginDone = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"logged out");
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == self.fbSessionTokenRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",request.responseString);
        
        [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        if([responseObject objectForKey:@"status"] != nil)
        {
            if([[responseObject objectForKey:@"status"] integerValue] == 0)
            {
                NSString *sessionToken = [responseObject objectForKey:@"session_token"];
                [UserDefaultsManager setSessionToken:sessionToken];
                
                NSString *userMerchant = [responseObject objectForKey:@"marchent"];
                [UserDefaultsManager setUserMerchant:[userMerchant boolValue]];
                
                [self gotoHome];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[responseObject objectForKey:@"message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"dismiss"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Something went wrong. Please try again later"
                                                           delegate:nil
                                                  cancelButtonTitle:@"dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:[request.error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)gotoHome
{
    if (keepMeSignedInSwitch.isOn)
    {
        [UserDefaultsManager setKeepMeSignedIn:YES];
    }
    HomeV3ViewController *vc = [[HomeV3ViewController alloc] initWithNibName:@"HomeV3ViewController" bundle:nil];
    vc.userNameStr = userNameStr;
    vc.proPic = proPic;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)signInWithFbButtonAction:(UIButton*)sender
{
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];
    
//    [FBSession.activeSession closeAndClearTokenInformation];
//    [FBSession.activeSession close];
//    [FBSession setActiveSession:nil];
    if([FBSession.activeSession isOpen])
    {
        NSLog(@"Open");
    }
    else
    {
        NSLog(@"close");
    }
    
//    if([[FBSession activeSession] isOpen])
//    {
//        NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
//        NSLog(@"fbToken %@",token);
//        
//        NSMutableString *urlStr = [[NSMutableString alloc] init];
//        [urlStr appendFormat:@"%@",baseUrl];
//        [urlStr appendFormat:@"%@",facebookLoginApi];
//        [urlStr appendFormat:@"%@",[token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        
//        self.fbSessionTokenRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
//        self.fbSessionTokenRequest.delegate = self;
//        [self.fbSessionTokenRequest startAsynchronous];
//    }
//    else
//    {
    fbLoginView = [[FBLoginView alloc] init];
//    fbLogin.frame = CGRectOffset(fbLogin.frame,
//                                 (self.view.center.x - (fbLogin.frame.size.width / 2)),
//                                 5);
//    fbLogin.frame = CGRectMake(100, 280, 40, 40);
    fbLoginView.readPermissions = [NSArray arrayWithObjects:@"basic_info", @"email", nil];
    fbLoginView.delegate = self;
    fbLoginView.center = self.view.center;
    fbLoginView.hidden = YES;
    [self.view addSubview:fbLoginView];
//        AppDelegate *apdl = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        apdl.delegate = self;
    
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
//    }
}

//-(void)cameBackToApp
//{
//    if([[FBSession activeSession] isOpen])
//    {
//        NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
//        NSLog(@"fbToken %@",token);
//        
//        NSMutableString *urlStr = [[NSMutableString alloc] init];
//        [urlStr appendFormat:@"%@",baseUrl];
//        [urlStr appendFormat:@"%@",facebookLoginApi];
//        [urlStr appendFormat:@"%@",[token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        
//        self.fbSessionTokenRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
//        self.fbSessionTokenRequest.delegate = self;
//        [self.fbSessionTokenRequest startAsynchronous];
//    }
//}

-(IBAction)twitterButtonAction:(UIButton*)sender
{
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:twitterApiKey
                                                 consumerSecret:TwitterApiSecret];
    
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        
        [[UIApplication sharedApplication] openURL:url];
    } forceLogin:@(YES)
                    screenName:nil
                 oauthCallback:@"myapp://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                    }];
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        
        /*
         At this point, the user can use the API and you can read his access tokens with:
         
         _twitter.oauthAccessToken;
         _twitter.oauthAccessTokenSecret;
         
         You can store these tokens (in user default, or in keychain) so that the user doesn't need to authenticate again on next launches.
         
         Next time, just instanciate STTwitter with the class method:
         
         +[STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:]
         
         Don't forget to call the -[STTwitter verifyCredentialsWithSuccessBlock:errorBlock:] after that.
         */
        
    } errorBlock:^(NSError *error) {
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

@end
