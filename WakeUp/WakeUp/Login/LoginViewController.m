//
//  LoginViewController.m
//  WakeUp
//
//  Created by World on 6/18/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "LoginViewController.h"
#import "DrawerViewController.h"
#import "RegistrationViewController.h"
#import "LoginCell.h"

@interface LoginViewController () <ASIHTTPRequestDelegate>
{
    BOOL isKeyboardHidden;
    
    LoginCell *userNameCell;
    LoginCell *passwordCell;
    
    ASIHTTPRequest *loginRequest;
    
    UIAlertView *loadingAlert;
}

@end

@implementation LoginViewController

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
    if([UserDefaultsManager keepMeLoggedIn])
    {
        DrawerViewController *vc = [[DrawerViewController alloc] initWithNibName:@"DrawerViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAlreadyHidden) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown) name:UIKeyboardDidShowNotification object:nil];
    
    containerTableView.layer.cornerRadius = 14.0f;
    containerTableView.layer.borderWidth = 0.5f;
    containerTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    loginButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    loginButton.layer.cornerRadius = 7.0f;
    
    registerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    registerButton.layer.cornerRadius = 7.0f;
    
    [self cellConfiguration];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..." message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)loginButtonAction:(UIButton*)sender
{
    [self loginProcedure];
}

-(void)keyboardAlreadyHidden
{
    isKeyboardHidden = YES;
}

-(void)keyboardShown
{
    isKeyboardHidden = NO;
}

-(void)loginProcedure
{
    if([self formValidation])
    {
        [self.view endEditing:YES];
        
        [self loginRequest];
    }
}

-(void)loginRequest
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@&",kLoginApi];
    [urlStr appendFormat:@"email=%@&",userNameCell.cellField.text];
    [urlStr appendFormat:@"pass=%@",passwordCell.cellField.text];
    
    loginRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    loginRequest.delegate = self;
    [loginRequest startAsynchronous];
    
    [loadingAlert show];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    if(request == loginRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",responseObject);
        
        if([[responseObject objectForKey:@"status"]  intValue] == 0)
        {
            
//            [UserDefaultsManager setSessionToken:[[responseObject objectForKey:@"body"] objectForKey:@"session"]];
            [self gotoHome];
        }
        else if([[responseObject objectForKey:@"status"] intValue]  == 2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"User does not exist"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else if([[responseObject objectForKey:@"status"] intValue]  == 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Email/password did not match"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)gotoHome
{
    [UserDefaultsManager setKeepMeLoggedIn:keepMeLoggedInSwitch.isOn];
    
    DrawerViewController *vc = [[DrawerViewController alloc] initWithNibName:@"DrawerViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[request.error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)keepMeLoggedInSwitchValueChanged:(UISwitch*)sender
{
    
}

-(IBAction)registerButtonAction:(UIButton*)sender
{
    RegistrationViewController *vc = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)forgotPasswordButtonAction:(UIButton*)sender
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == userNameCell.cellField)
    {
        [userNameCell.cellField resignFirstResponder];
        [passwordCell.cellField becomeFirstResponder];
        return NO;
    }
    if(textField == passwordCell.cellField)
    {
        [passwordCell.cellField resignFirstResponder];
        if([passwordCell.cellField.text isEqualToString:@""])
        {
            return YES;
        }
        [self loginProcedure];
        return YES;
    }
    return YES;
}

-(BOOL)formValidation
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    if([userNameCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Username can not be empty";
        [alert show];
        return NO;
    }
    else if([passwordCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Password can not be empty";
        [alert show];
        return NO;
    }
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            
            return userNameCell;
            
        case 1:
            
            return passwordCell;
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)cellConfiguration
{
    userNameCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loginCell"];
    userNameCell.cellField.delegate = self;
    userNameCell.cellField.placeholder = @"Example: abc@xyz.com";
    userNameCell.cellField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameCell.cellField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameCell.cellField.keyboardType = UIKeyboardTypeEmailAddress;
    userNameCell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    passwordCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loginCell"];
    passwordCell.cellField.delegate = self;
    passwordCell.cellField.placeholder = @"Password";
    passwordCell.cellField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordCell.cellField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordCell.cellField.secureTextEntry = YES;
}

@end
