//
//  EmailRegistrationViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/22/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "EmailRegistrationViewController.h"
#import "HomeViewController.h"
#import "PolicyView.h"

@interface EmailRegistrationViewController () <PolicyViewDelegate>
{
    PolicyView *policyView;
}

@end

@implementation EmailRegistrationViewController

//@synthesize emailAddress;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    emailField.text = emailAddress;
    
    credentialsView.layer.borderColor = [UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255].CGColor;
    credentialsView.layer.borderWidth = 1.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    policyView = [[PolicyView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    policyView.delegate = self;
//    policyView.backgroundColor = [UIColor redColor];
    [self.view addSubview:policyView];
//    [self.view insertSubview:policyView belowSubview:self.view];
}

-(IBAction)backButtonAction:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)singInButtonAction:(UIButton*)button
{
//    if(![passwordField.text isEqualToString:confirmPasswordField.text] || [passwordField.text isEqualToString:@""] || ![self validateEmail:emailField.text])
//    {
//        [emailField resignFirstResponder];
//        [passwordField resignFirstResponder];
//        [confirmPasswordField resignFirstResponder];
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your credentials again" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:dismiss];
//        
//        [self presentViewController:alertController animated:YES completion:^{
//            
//            return;
//        }];
//    }
//    else
//    {
    NSLog(@"Sign up");
        [self showPolicyView];
//    }
    
}

-(void)showPolicyView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = policyView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.origin.y;
    policyView.frame = frame;
    
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
}

-(void)backgroundControlAction
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = policyView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    policyView.frame = frame;
    
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
}

-(void)aggreButtonAction
{
    [self insertUserWithUserName:emailField.text andPassWord:passwordField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)insertUserWithUserName:(NSString*)userName andPassWord:(NSString*)passWord
{
    __block BOOL success = FALSE;
    NSURL *URL = [NSURL URLWithString:insertUserURL];
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
            NSLog(@"signUp %@", dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                [UserDefaultsManager setUserId:[dataJSON objectForKey:@"USR_ID"]];
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
    HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(void)insertUser
{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kSessionIdentifier];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
}

@end
