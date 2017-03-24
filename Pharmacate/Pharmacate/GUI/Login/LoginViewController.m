//
//  LoginViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/21/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "ProductDetailViewController.h"
#import "EmailRegistrationViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Reachability.h"

#define insertUser  @"https://m6zbw2uc09.execute-api.us-west-2.amazonaws.com/dev/insert/single-user"

@interface LoginViewController () <UITextFieldDelegate, NSURLConnectionDelegate, FBSDKLoginButtonDelegate>

@end

@implementation LoginViewController
{
    UITextField *emailField;
    UITextField *passwordField;
    
    UIButton *skipSignInButton;
    UIButton *fbButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *URL = [NSURL URLWithString:getUserIdURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJUSU1FX1NUQU1QIjoxNDY3MTM4Njg5MTk1LCJVU0VSX05BTUUiOiJkaXBheWFuNDEyQGdtYWlsLmNvbSIsImV4cCI6MTQ2NzE0MjI4OX0.djggKer3hwpSNZgkP7m_pNbwG6NJLJ3URA89dPd22e4";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[UserDefaultsManager getUserName], @"USER_NAME", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error)
        {
            NSLog(@"%@",dataJSON);
        }
        else
        {
            NSLog(@"%@",error);
        }
        
    }];
    [dataTask resume];
    
    // Allocate a reachability object
//    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
//    
//    // Set the blocks
//    reach.reachableBlock = ^(Reachability*reach)
//    {
//        // keep in mind this is called on a background thread
//        // and if you are updating the UI it needs to happen
//        // on the main thread, like this:
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"REACHABLE!");
//        });
//    };
//    
//    reach.unreachableBlock = ^(Reachability*reach)
//    {
//        NSLog(@"UNREACHABLE!");
//    };
//    
//    // Start the notifier, which will cause the reachability object to retain itself!
//    [reach startNotifier];
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 90, [UIScreen mainScreen].bounds.size.height);
//    pageControl.frame = CGRectMake(0, 0, 100, 100);
//    pageControl.backgroundColor = [UIColor redColor];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pharmacateIcon@2x.png"]];
    imgView.frame = CGRectMake(pageControl.frame.size.width/2 - 55, 100, 200, 254);
    [pageControl addSubview:imgView];
    pageControl.backgroundColor = [UIColor colorWithRed:243.0/255 green:242.0/255 blue:247.0/255 alpha:1.0];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, pageControl.frame.size.height/2 + 10, [UIScreen mainScreen].bounds.size.width, pageControl.frame.size.height/2)];
    layerView.backgroundColor = [UIColor clearColor];
    
    fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fbButton setBackgroundImage:[UIImage imageNamed:@"facebookButton.png"] forState:UIControlStateNormal];
    fbButton.frame = CGRectMake(13, 5, 120, 120*0.42);
    [layerView addSubview:fbButton];
    [fbButton addTarget:self action:@selector(fbButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *googleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [googleButton setBackgroundImage:[UIImage imageNamed:@"googleButton.png"] forState:UIControlStateNormal];
    googleButton.frame = CGRectMake(fbButton.frame.size.width + fbButton.frame.origin.x + 15, fbButton.frame.origin.y, 120, 120*0.42);
    [layerView addSubview:googleButton];
//    [googleButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"twitterButton.png"] forState:UIControlStateNormal];
    twitterButton.frame = CGRectMake(googleButton.frame.size.width + googleButton.frame.origin.x + 15, fbButton.frame.origin.y, 120, 120*0.42);
    [layerView addSubview:twitterButton];
//    [twitterButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *orEmailLabelImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emailOptionLabelImage@2x.png"]];
    orEmailLabelImgView.frame = CGRectMake(13, fbButton.frame.origin.y + fbButton.frame.size.height + 40, 393, 20);
    orEmailLabelImgView.contentMode = UIViewContentModeScaleAspectFit;
//    [layerView addSubview:orEmailLabelImgView];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(13, orEmailLabelImgView.frame.origin.y + orEmailLabelImgView.frame.size.height, [UIScreen mainScreen].bounds.size.width - 26, 40)];
    emailField.backgroundColor = [UIColor clearColor];
    emailField.placeholder = [NSString stringWithFormat:@"Email Address"];
    emailField.delegate = self;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.textAlignment = NSTextAlignmentCenter;
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(13, emailField.frame.origin.y + emailField.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 26, 40)];
    passwordField.backgroundColor = [UIColor clearColor];
    passwordField.placeholder = [NSString stringWithFormat:@"Password"];
    passwordField.delegate = self;
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.textAlignment = NSTextAlignmentCenter;
    passwordField.secureTextEntry = YES;
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, emailField.frame.size.height - borderWidth, emailField.frame.size.width, emailField.frame.size.height);
    border.borderWidth = borderWidth;
    [emailField.layer addSublayer:border];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, emailField.frame.size.height - 5, 1.0f, 5.0f);
    leftBorder.borderColor = [UIColor lightGrayColor].CGColor;
    leftBorder.borderWidth = 1;
    [emailField.layer addSublayer:leftBorder];
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(emailField.frame.size.width - 1, emailField.frame.size.height - 5, 1.0f, 5.0f);
    rightBorder.borderColor = [UIColor lightGrayColor].CGColor;
    rightBorder.borderWidth = 1;
    [emailField.layer addSublayer:rightBorder];
    
    CALayer *borderPass = [CALayer layer];
    borderPass.borderColor = [UIColor lightGrayColor].CGColor;
    borderPass.frame = CGRectMake(0, passwordField.frame.size.height - borderWidth, passwordField.frame.size.width, passwordField.frame.size.height);
    borderPass.borderWidth = 0.5f;
    [passwordField.layer addSublayer:borderPass];
    
    CALayer *leftBorderPass = [CALayer layer];
    leftBorderPass.frame = CGRectMake(0.0f, passwordField.frame.size.height - 5, 1.0f, 5.0f);
    leftBorderPass.borderColor = [UIColor lightGrayColor].CGColor;
    leftBorderPass.borderWidth = borderWidth;
    [passwordField.layer addSublayer:leftBorderPass];
    
    CALayer *rightBorderPass = [CALayer layer];
    rightBorderPass.frame = CGRectMake(passwordField.frame.size.width - 1, passwordField.frame.size.height - 5, 1.0f, 5.0f);
    rightBorderPass.borderColor = [UIColor lightGrayColor].CGColor;
    rightBorderPass.borderWidth = borderWidth;
    [passwordField.layer addSublayer:rightBorderPass];
    
    emailField.layer.masksToBounds = YES;
    [layerView addSubview:emailField];
    passwordField.layer.masksToBounds = YES;
    [layerView addSubview:passwordField];
    
    signInButton.frame = CGRectMake(emailField.frame.origin.x + 50, passwordField.frame.origin.y + passwordField.frame.size.height + 15, 120, 120*0.42);
    [layerView addSubview:signInButton];
    
    signUpButton.frame = CGRectMake(twitterButton.frame.origin.x - 50, passwordField.frame.origin.y + passwordField.frame.size.height + 15, 120, 120*0.42);
    [layerView addSubview:signUpButton];
    
    skipSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipSignInButton.frame = CGRectMake(280, layerView.frame.size.height - 40, 120, 20);
    [skipSignInButton setBackgroundImage:[UIImage imageNamed:@"skipSignInButton@2x.png"] forState:UIControlStateNormal];
    [skipSignInButton setBackgroundImage:[UIImage imageNamed:@"skipSignInButton@2x.png"] forState:UIControlStateHighlighted];
    skipSignInButton.backgroundColor = [UIColor redColor];
    [layerView addSubview:skipSignInButton];
    [skipSignInButton addTarget:self action:@selector(skipSignInButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:layerView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    skipSignInButton.enabled = YES;
    fbButton.enabled = YES;
    
    if(![[UserDefaultsManager getUserToken] isEqualToString:@""])
    {
        [self checkUserToken:[UserDefaultsManager getUserToken]];
    }
}

-(void)checkUserToken:(NSString*)userToken
{
    __block BOOL success = FALSE;
    NSURL *URL = [NSURL URLWithString:isTokenValidURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userToken, @"TOKEN", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error)
        {
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                if([dataJSON objectForKey:@"USER_NAME"] != [NSNull null])
                {
                    [UserDefaultsManager setUserName:[dataJSON objectForKey:@"USER_NAME"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self pushViewController];
                    });
                }
            }
        }
        else
        {
            NSLog(@"%@",error);
            success = false;
        }
        
    }];
    [dataTask resume];
}

-(void)fbButtonAction
{
    fbButton.enabled = NO;
    NSLog(@"token expiration date %f", [FBSDKAccessToken currentAccessToken].expirationDate.timeIntervalSinceNow);
    if([FBSDKAccessToken currentAccessToken].expirationDate.timeIntervalSinceNow > 0.0f)
    {
        [self fetchUserInfoFromFBProfile];
    }
    else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile",@"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                NSLog(@"error %@",error);
            }
            else if (result.isCancelled)
            {
                
            }
            else
            {
                
                [self fetchUserInfoFromFBProfile];
            }
        }];
    }
}

-(void)fetchUserInfoFromFBProfile
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email, first_name, last_name, gender, name, locale"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 [self insertDataToFbProfileWithResult:result];
             }
         }];
    }
}

-(void)insertDataToFbProfileWithResult:(id)result
{
    __block BOOL success = FALSE;
    NSURL *URL = [NSURL URLWithString:userSignInWithFBURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *queryDictionary;
    
    NSString *firstName = [result objectForKey:@"first_name"];
    NSString *lastName = [result objectForKey:@"last_name"];
    NSString *fbId = [result objectForKey:@"id"];
    if([result objectForKey:@"email"] != nil)
    {
        NSString *userName = [NSString stringWithFormat:@"%@", [result objectForKey:@"email"]];
        queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:firstName, @"FIRST_NAME", lastName, @"LAST_NAME",fbId, @"FB_ID", userName, @"USER_NAME", nil];
        [UserDefaultsManager setUserName:userName];
    }
    else
    {
        queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:firstName, @"FIRST_NAME", lastName, @"LAST_NAME",fbId, @"FB_ID", nil];
    }
    
    NSError *error;
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error)
        {
            NSLog(@"%@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pushViewController];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            success = false;
        }
        
    }];
    [dataTask resume];
}

-(void)skipSignInButtonAction
{
    skipSignInButton.enabled = NO;
    __block BOOL success = FALSE;
    NSURL *URL = [NSURL URLWithString:skipSignInURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    if([[UserDefaultsManager getUDID] isEqualToString:@""])
    {
        NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
        [UserDefaultsManager setUDID:uniqueIdentifier];
    }
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[UserDefaultsManager getUDID], @"UDID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error)
        {
            NSLog(@"%@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pushViewController];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            success = false;
        }
        
    }];
    [dataTask resume];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error
{
//    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
//                                                          initWithRegionType:AWSRegionUSEast1
//                                                          identityPoolId:@"us-east-1:ca9c73fd-458d-4bdc-9d48-f8866fe85893"];
//    
//    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
//    
//    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
//    
//    NSString *token = [FBSDKAccessToken currentAccessToken].tokenString;
//    credentialsProvider.logins = @{ @(AWSCognitoLoginProviderKeyFacebook): token };
    
}

/*!
 @abstract Sent to the delegate when the button was used to logout.
 @param loginButton The button that was clicked.
 */
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

-(void)emailRegistrationButtonAction
{
//    if([emailField.text isEqualToString:@""])
//    {
//        [emailField resignFirstResponder];
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Enter Your Email Address" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:dismiss];
//        
//        [self presentViewController:alertController animated:YES completion:^{
//            return;
//        }];
//    }
    EmailRegistrationViewController *vc = [[EmailRegistrationViewController alloc] initWithNibName:@"EmailRegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signInButtonAction:(UIButton *)sender
{
    if(![emailField.text isEqualToString:@""] && ![passwordField.text isEqualToString:@""])
    {
        [self signInUserWithUserName:emailField.text andPassWord:passwordField.text];
    }
}

- (IBAction)signUpButtonAction:(UIButton *)sender
{
    [self emailRegistrationButtonAction];
}

- (void)signInUserWithUserName:(NSString*)userName andPassWord:(NSString*)passWord
{
    __block BOOL success = FALSE;
    NSURL *URL = [NSURL URLWithString:signInURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userName lowercaseString], @"USER_NAME", passWord, @"PASS", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error)
        {
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pushViewController];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            success = false;
        }
        
    }];
    [dataTask resume];
}

-(void)pushViewController
{
    emailField.text = @"";
    passwordField.text = @"";
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
    HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)pageTurn:(UIPageControl *) page
{
    int c = (int)page.currentPage;
    if(c==0)
    {
        //        pageControl.backgroundColor=[UIColor blueColor];
    }else if(c==1)
    {
        //        pageControl.backgroundColor=[UIColor redColor];
    }else if(c==2)
    {
        //        pageControl.backgroundColor=[UIColor yellowColor];
    }else if(c==3)
    {
        //        pageControl.backgroundColor=[UIColor greenColor];
    }else if(c==4)
    {
        //        pageControl.backgroundColor=[UIColor grayColor];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
