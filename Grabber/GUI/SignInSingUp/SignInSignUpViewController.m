//
//  SignInSignUpViewController.m
//  iOS Prototype
//
//  Created by World on 3/5/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SignInSignUpViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "AppDelegate.h"
#import "LoginV2ViewController.h"

@interface SignInSignUpViewController ()
{
    
}

@end

@implementation SignInSignUpViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SignInSignUpBG.png"]];
    
    if ([UserDefaultsManager isKeepMeSignedInOn] && ![[UserDefaultsManager sessionToken] isEqualToString:@""])
    {
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
    }
    
    [[PromoScanner getInstance] stopUpdateingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)signInButtonAction:(UIButton*)btn
{
//    if([UIScreen mainScreen].bounds.size.height < 568)
//    {
//        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController_small" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else
//    {
//        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    LoginV2ViewController *vc = [[LoginV2ViewController alloc] initWithNibName:@"LoginV2ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)signUpButtonAction:(UIButton*)btn
{
    RegistrationViewController *vc = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
