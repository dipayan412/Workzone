//
//  VerifyCodeVViewController.m
//  WakeUp
//
//  Created by World on 7/1/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "VerifyCodeVViewController.h"
#import "LoginV2ViewController.h"
#import "ASIFormDataRequest.h"
#import <AddressBook/AddressBook.h>
#import "CountryCodes.h"
#import "PhoneBookObject.h"
#import "AddContactByPhoneBookManager.h"
#import "AppDelegate.h"

@interface VerifyCodeVViewController () <ASIHTTPRequestDelegate, AddContactByPhoneBookDelegate>
{
    ASIHTTPRequest *checkVerificationCodeRequest;
    ASIHTTPRequest *loginRequest;
    ASIHTTPRequest *registerDeviceRequest;
    ASIHTTPRequest *resendCodeRequest;
    ASIHTTPRequest *syncContactRequest;
    
    NSMutableArray *phoneBookArray;
    
    MBProgressHUD *hud;
}

@end

@implementation VerifyCodeVViewController

@synthesize encodedPhoneNumber;

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
    
    phoneBookArray = [[NSMutableArray alloc] init];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)];
    [doneButton setTintColor:[UIColor whiteColor]];
    [toolBar setItems:[NSArray arrayWithObjects:space1 ,doneButton, space2, nil]];
    verifyCodeField.inputAccessoryView = toolBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)formValidation
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    
    NSLog(@"characters %@",[NSCharacterSet letterCharacterSet]);
    
    if([verifyCodeField.text isEqualToString:@""])
    {
        alert.message = @"No verification code enetered";
        [alert show];
        return NO;
    }
    else if([verifyCodeField.text rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound)
    {
        alert.message = @"Verification code can not conatin any letter";
        [alert show];
        return NO;
    }
    return YES;
}

-(void)doneButtonAction
{
    [self.view endEditing:YES];
}

-(IBAction)resendButtonAction:(UIButton*)sender
{
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Loading..."];
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kResendCodeApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    
    NSLog(@"resendUrl %@",urlStr);
    
    resendCodeRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    resendCodeRequest.delegate = self;
    [resendCodeRequest startAsynchronous];
}

-(IBAction)verifyButtonAction:(UIButton*)sender
{
    [self.view endEditing:YES];
//    [self showLoginController];
    if([self formValidation])
    {
        [self checkVerificationCodeProcedure];
    }
}

-(void)checkVerificationCodeProcedure
{
    [self checkVerificationCodeServerCall];
}

-(void)checkVerificationCodeServerCall
{
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Loading..."];
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kVerifyPhoneNumberApi];
    [urlStr appendFormat:@"&obtoken=%@",[UserDefaultsManager getObserverToken]];
    [urlStr appendFormat:@"&phone=%@",self.encodedPhoneNumber];
    [urlStr appendFormat:@"&code=%@",verifyCodeField.text];
    if([UserDefaultsManager deviceToken].length > 0)
    {
        [urlStr appendFormat:@"&dtoken=%@",[UserDefaultsManager deviceToken]];
        [urlStr appendFormat:@"&dtype=%@",@"1"];
        [UserDefaultsManager setDeviceShouldRegistereLater:NO];
    }
    else
    {
        [UserDefaultsManager setDeviceShouldRegistereLater:YES];
    }
    
    NSLog(@"verifyUrl %@",urlStr);
    
    checkVerificationCodeRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    checkVerificationCodeRequest.delegate = self;
    [checkVerificationCodeRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == checkVerificationCodeRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@ error %@ \nStr %@",responseObject,error,request.responseString);
        
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            [UserDefaultsManager setToken:[[responseObject objectForKey:@"body"] objectForKey:@"token"]];
            
            if([[responseObject objectForKey:@"body"] objectForKey:@"pid"])
            {
                [UserDefaultsManager setUserProfilePicId:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"body"] objectForKey:@"pid"]]];
            }
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if (appDelegate.phonebookCheckDone)
            {
                appDelegate.addPhonebookContactsDone = NO;
                appDelegate.syncOnProgress = YES;
                [[AddContactByPhoneBookManager getInstance] startContactSync];
            }
            
            [self performSelectorOnMainThread:@selector(showLoginController) withObject:nil waitUntilDone:NO];
        }
        else if([[responseObject objectForKey:@"status"] intValue] == -2 && responseObject)
        {
            [UserDefaultsManager hideBusyScreenToView:self.view];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid verification code" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        else if([[responseObject objectForKey:@"status"] intValue] == 3 && responseObject)
        {
            [UserDefaultsManager hideBusyScreenToView:self.view];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong verification code" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [UserDefaultsManager hideBusyScreenToView:self.view];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(request == resendCodeRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@ error %@ \nStr %@",responseObject,error,request.responseString);
        
        
        [UserDefaultsManager hideBusyScreenToView:self.view];
        if([[responseObject objectForKey:@"status"] intValue] == 0)
        {
            
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error localizedDescription]);
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(void)phoneBookSyncProgress:(int)value totalContacts:(int)total syncedContacts:(int)synced
{
    hud.labelText = [NSString stringWithFormat:@"%d / %d numbers synced",synced, total];
}

-(void)PhoneBookSyncFinished
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    [self performSelectorOnMainThread:@selector(showLoginController) withObject:nil waitUntilDone:NO];
}

-(void)showLoginController
{
    LoginV2ViewController *vc = [[LoginV2ViewController alloc] initWithNibName:@"LoginV2ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TextField delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(kIsThreePointFiveInch)
    {
        [UserDefaultsManager goUpView:self.view ForTextField:textField];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(kIsThreePointFiveInch)
    {
        [UserDefaultsManager goDownView:self.view];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == verifyCodeField)
    {
        [verifyCodeField resignFirstResponder];
        return YES;
    }
    return YES;
}

@end
