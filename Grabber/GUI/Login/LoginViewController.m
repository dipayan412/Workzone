//
//  LoginViewController.m
//  iOS Prototype
//
//  Created by World on 2/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "HomeViewController.h"
#import "ReceiverSide.h"
#import "DrawerViewController.h"
#import "SettingsViewController.h"
#import "HomeV2ViewController.h"
#import "ForgotPasswordViewController.h"
#import "GPSTracker.h"
#import "AppDelegate.h"
#import "HomeV3ViewController.h"

@interface LoginViewController () <FBLoginViewDelegate, ASIHTTPRequestDelegate,AppDelegateProtocol>
{
    UIAlertView *loadingAlert;
    PKPassLibrary *pasLib;
}

@property (nonatomic, retain) ASIHTTPRequest *loginRequest;
@property (nonatomic, retain) ASIHTTPRequest *fbSessionTokenRequest;

@end

@implementation LoginViewController

@synthesize loginRequest;
@synthesize fbSessionTokenRequest;

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
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"GRABBER";

    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([UserDefaultsManager isKeepMeSignedInOn] && ![[UserDefaultsManager sessionToken] isEqualToString:@""])
    {
        [self gotoHomeForKeppMeSignedin];
    }
    
    registerButton.layer.borderWidth = 1.0f;
    registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    registerButton.layer.cornerRadius = 2.0f;
    
    usernameBGView.backgroundColor = [UIColor whiteColor];
    passwordBGView.backgroundColor = [UIColor whiteColor];
    
    usernameBGView.layer.cornerRadius = 2.0f;
    passwordBGView.layer.cornerRadius = 2.0f;
    
    passwordField.secureTextEntry = YES;
    
    keepLoggedIn = [UserDefaultsManager isKeepMeSignedInOn];
    [self updateAutoLoginButton];
    [self updateSavePasswordButton];
    
    FBLoginView *fbLogin = [[FBLoginView alloc] init];
    fbLogin.frame = CGRectOffset(fbLogin.frame,
                                 (self.view.center.x - (fbLogin.frame.size.width / 2)),
                                 5);
    fbLogin.frame = CGRectMake(100, 280, 40, 40);
    fbLogin.readPermissions = [NSArray arrayWithObjects:@"basic_info", @"email", @"user_likes", @"publish_actions", nil];
    fbLogin.delegate = self;
    fbLogin.center = self.view.center;
    fbLogin.hidden = YES;
    [self.view addSubview:fbLogin];
    
//    usernameField.text = @"hamba.hambs@gmail.com";//@"dipayan412@gmail.com";//@"salman2312@gmail.com";//@"dipayan412@gmail.com";//@"mnsalim.cse@gmail.com";
//    passwordField.text = @"BYDX5I";//@"QOMKID";//@"R2H7C3";//@"IVIRMC";//@"HVG7XD";
    
//    usernameField.text = @"dipayan412@gmail.com";//@"salman2312@gmail.com";//@"dipayan412@gmail.com";//@"mnsalim.cse@gmail.com";
//    passwordField.text = @"QOMKID";//@"R2H7C3";//@"IVIRMC";//@"HVG7XD";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"name %@ ... pass %@",[UserDefaultsManager savedUsername], [UserDefaultsManager savedPassword]);
    if([UserDefaultsManager isSavePasswordOn])
    {
        usernameField.text = [UserDefaultsManager savedUsername];
        passwordField.text = [UserDefaultsManager savedPassword];
    }
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
    NSLog(@"authenticated");
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    //    fbProfilePicture.profileID = nil;
    //    nameLabel.text = @"";
    //    statusLabel.text= @"You're not logged in!";
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    
}

-(IBAction)keepMeLoginButtonAction:(UIButton*)sender
{
    keepLoggedIn = !keepLoggedIn;
    [self updateAutoLoginButton];
}

-(IBAction)savePasswordButtonAction:(UIButton*)sender
{
    [UserDefaultsManager setSavePasswordOn:![UserDefaultsManager isSavePasswordOn]];
    [self updateSavePasswordButton];
}

-(IBAction)loginButtonAction:(UIButton*)sender
{
    [self login];
}

-(void)login
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    if([usernameField.text isEqualToString:@""] || [passwordField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please fill up username/password field"
                                                       delegate:nil
                                              cancelButtonTitle:@"dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    
    [urlStr appendFormat:@"%@", baseUrl];
    [urlStr appendFormat:@"%@", loginApi];
    [urlStr appendFormat:@"%@/", [usernameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlStr appendFormat:@"%@/", [passwordField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"url -> %@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    self.loginRequest = [ASIHTTPRequest requestWithURL:url];
    self.loginRequest.delegate = self;
    [self.loginRequest startAsynchronous];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == self.loginRequest)
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
                
                if (keepLoggedIn)
                {
                    [UserDefaultsManager setKeepMeSignedIn:YES];
                }
                
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
    else if(request == self.fbSessionTokenRequest)
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
                
                if (keepLoggedIn)
                {
                    [UserDefaultsManager setKeepMeSignedIn:YES];
                }
                
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
//    DrawerViewController *drawerVC = [[DrawerViewController alloc] initWithNibName:@"DrawerViewController" bundle:nil];
//
//    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
//    vc.drawerViewDelegate = drawerVC;
//
//    drawerVC.currentViewController = vc;
    if(![UserDefaultsManager isMerchantModeOn] || ![UserDefaultsManager isUserMerchant])
    {
        [UserDefaultsManager setBeaconsEnabledOn:YES];
    }
    
//    if([UserDefaultsManager isBeaconsEnabledOn])
//    {
//        [[PromoScanner getInstance] startUpdatingLocation];
//    }
//    else
//    {
//        [[PromoScanner getInstance] stopUpdateingLocation];
//    }
    [[PromoScanner getInstance] startPromoScanner];
    
    if([UserDefaultsManager isSavePasswordOn])
    {
        [UserDefaultsManager setSaveUsername:usernameField.text];
        [UserDefaultsManager setSavePassword:passwordField.text];
    }
//    HomeV2ViewController *vc = [[HomeV2ViewController alloc] initWithNibName:@"HomeV2ViewController" bundle:nil];
    HomeV3ViewController *vc = [[HomeV3ViewController alloc] initWithNibName:@"HomeV3ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoHomeForKeppMeSignedin
{
//    HomeV2ViewController *vc = [[HomeV2ViewController alloc] initWithNibName:@"HomeV2ViewController" bundle:nil];
    HomeV3ViewController *vc = [[HomeV3ViewController alloc] initWithNibName:@"HomeV3ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)registerButtonAction:(UIButton*)sender
{
    RegistrationViewController *vc = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backgroundTap:(UIControl *)sender
{
    [self.view endEditing:YES];
}

-(void)updateAutoLoginButton
{
    if(keepLoggedIn)
    {
        [keepMeSignedInButton setImage:[UIImage imageNamed:@"RadioButton_On.png"] forState:UIControlStateNormal];
    }
    else
    {
        [keepMeSignedInButton setImage:[UIImage imageNamed:@"RadioButton_Off.png"] forState:UIControlStateNormal];
    }
}

-(void)updateSavePasswordButton
{
    if([UserDefaultsManager isSavePasswordOn])
    {
        [savePasswordButton setImage:[UIImage imageNamed:@"RadioButton_On.png"] forState:UIControlStateNormal];
    }
    else
    {
        [savePasswordButton setImage:[UIImage imageNamed:@"RadioButton_Off.png"] forState:UIControlStateNormal];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == usernameField)
    {
//        usernameBGView.layer.contents = (id)[UIImage imageNamed:@"TextBG.png"].CGImage;
//        usernameBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TextBG.png"]];
//        usernameLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        if([UIScreen mainScreen].bounds.size.height <= 568)
        {
            [self commitAnimations:-60];
        }
        else
        {
            [self commitAnimations:0];
        }
//        passwordBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TextBG.png"]];
//        passwordLabel.textColor = [UIColor whiteColor];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == usernameField)
    {
        [passwordField becomeFirstResponder];
    }
    else if (textField == passwordField)
    {
        [self login];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == usernameField)
    {
//        usernameBGView.backgroundColor = [UIColor whiteColor];
//        usernameLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {
        [self commitAnimations:64];
//        passwordBGView.backgroundColor = [UIColor whiteColor];
//        passwordLabel.textColor = [UIColor lightGrayColor];
    }
}

-(IBAction)backAction:(UIButton*)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)twitterButtonAction:(UIButton*)sender
{
//    if([PKPassLibrary isPassLibraryAvailable])
//    {
//        pasLib = [[PKPassLibrary alloc] init];
//        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Lollipop" ofType:@"pkpass"];
//        NSData *data = [NSData dataWithContentsOfFile:filePath];
//        NSError *error;
//        
//        //init a pass object with the data
//        PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
//        
//        [pasLib addPasses:[NSArray arrayWithObject:pass] withCompletionHandler:nil];
//        NSArray *tmp1 = [pasLib passes];
//        if(tmp1.count > 0)
//        {
//            PKPass *q = [tmp1 objectAtIndex:0];
//            [[UIApplication sharedApplication] openURL:[q passURL]];
//        }
//        
//        if([pasLib containsPass:pass])
//        {
//            NSLog(@"ase");
//        }
//        else
//        {
//            
//        }
//    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comming Soon"
                                                    message:@"This functionality under construction"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)fbButtonAction:(UIButton*)sender
{

    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
   
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies])
//    {
//        NSString* domainName = [cookie domain];
//        NSRange domainRange = [domainName rangeOfString:@"facebook"];
//        if(domainRange.length > 0)
//        {
//            [storage deleteCookie:cookie];
//        }
//    }

//    [FBRequestConnection startWithGraphPath:@"/me/mutualfriends/1347084572"
//                                 parameters:nil
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              /* handle the result */
//                              NSLog(@"result %@",result);
//                          }];
    
    if([[FBSession activeSession] isOpen])
    {
        NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
        NSLog(@"fbToken %@",token);
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"%@",baseUrl];
        [urlStr appendFormat:@"%@",facebookLoginApi];
        [urlStr appendFormat:@"%@",[token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        self.fbSessionTokenRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        self.fbSessionTokenRequest.delegate = self;
        [self.fbSessionTokenRequest startAsynchronous];
        
        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                                  message:@""
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
        [loadingAlert show];
    }
    else
    {
        AppDelegate *apdl = (AppDelegate*)[UIApplication sharedApplication].delegate;
        apdl.delegate = self;
        
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"read_friendlists",@"read_mailbox",@"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
//             self.isFbTapped = YES;
         }];
    }
}

-(void)cameBackToApp
{
    if([[FBSession activeSession] isOpen])
    {
        NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
        NSLog(@"fbToken %@",token);
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"%@",baseUrl];
        [urlStr appendFormat:@"%@",@"fblogin/"];
        [urlStr appendFormat:@"%@",[token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        self.fbSessionTokenRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        self.fbSessionTokenRequest.delegate = self;
        [self.fbSessionTokenRequest startAsynchronous];
        
        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                                  message:@""
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
        [loadingAlert show];
    }
}

-(IBAction)forgotPasswordButtonAction:(UIButton*)sender
{
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self changeBackbuttonTitle];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)commitAnimations:(int)y
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    CGRect frame = self.view.frame;
    frame.origin.y = y;
    self.view.frame = frame;
    
    [UIView commitAnimations];
}

-(void)changeBackbuttonTitle
{
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

@end
