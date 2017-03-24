//
//  VerificationViewController.m
//  WakeUp
//
//  Created by World on 6/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "VerificationViewController.h"
#import "CountryCodes.h"
#import "VerifyCodeVViewController.h"

@interface VerificationViewController () <ASIHTTPRequestDelegate>
{
    int selectedRow;
    
    ASIHTTPRequest *createAccountRequest;
}

@property (nonatomic, strong) NSArray *countries;

@end

@implementation VerificationViewController

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
    
    selectedRow = 0;
    
    selectCountryField.inputView = countryPicker;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneSelectCountry)];
    [doneButton setTintColor:[UIColor whiteColor]];
    [toolBar setItems:[NSArray arrayWithObjects:space1 ,doneButton, space2, nil]];
    selectCountryField.inputAccessoryView = phoneNumberField.inputAccessoryView = toolBar;
    
    _countries = [[[CountryCodes getInstance] countryCodesDictionary].allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentCountryDetermined) name:kCurrentCountryFound object:nil];
    [countryPicker selectRow:0 inComponent:0 animated:YES];
    
    selectCountryField.minimumFontSize = 4.0f;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UserDefaultsManager setAppLaunchedFirstTime:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)currentCountryDetermined
{
//    if([selectCountryField.text isEqualToString:@""])
//    {
        if([_countries containsObject:[UserDefaultsManager currentCountry]])
        {
            [countryPicker selectRow:[_countries indexOfObject:[UserDefaultsManager currentCountry]] inComponent:0 animated:YES];
            selectedRow = (int)[_countries indexOfObject:[UserDefaultsManager currentCountry]];
            
            selectCountryField.text = [NSString stringWithFormat:@"%@", [_countries objectAtIndex:selectedRow]];
            countryCodeLabel.text = [[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[_countries objectAtIndex:selectedRow]];
        }
//    }
}

-(IBAction)veriFyButtonAction:(UIButton*)sender
{
    [self.view endEditing:YES];
//    VerifyCodeVViewController *vc = [[VerifyCodeVViewController alloc] initWithNibName:@"VerifyCodeVViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    if([self validateTextfields])
    {
//        if()
        [self verificationProcedure];
    }
}

-(void)verificationProcedure
{
    [self.view endEditing:YES];
    NSLog(@"%@%@",[[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[_countries objectAtIndex:selectedRow]],phoneNumberField.text);
    
    [self createAccountServerCall];
}

-(void)createAccountServerCall
{
    NSString* output = phoneNumberField.text;
    
    if([output hasPrefix:@"0"])
    {
        output = [phoneNumberField.text substringFromIndex:1];
    }
    
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Sending phone number..."];
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@&",kCreateAccountApi];
    [urlStr appendFormat:@"phone=%@%@",[[[[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[_countries objectAtIndex:selectedRow]] stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@"%20"],output];
    
    NSLog(@"createAcntUrl %@",urlStr);
    
    createAccountRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    createAccountRequest.delegate = self;
    [createAccountRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"%@ error %@ \nStr %@",responseObject,error,request.responseString);
    
    if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
    {
        NSString* output = phoneNumberField.text;
        
        if([phoneNumberField.text hasPrefix:@"0"])
        {
            output = [phoneNumberField.text substringFromIndex:1];
        }
        
        [UserDefaultsManager hideBusyScreenToView:self.view];
        [UserDefaultsManager setUserPhoneNumber:[NSString stringWithFormat:@"%@%@",[[[[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[_countries objectAtIndex:selectedRow]] stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@"%20"],output]];
        [UserDefaultsManager setUserId:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"body"] objectForKey:@"uid"]]];
        
        VerifyCodeVViewController *vc = [[VerifyCodeVViewController alloc] initWithNibName:@"VerifyCodeVViewController" bundle:nil];
        
        vc.encodedPhoneNumber = [NSString stringWithFormat:@"%@%@",[[[[[CountryCodes getInstance]
                                                                       countryCodesDictionary]
                                                                       objectForKey:[_countries objectAtIndex:selectedRow]]stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@"%20"],output];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([[responseObject objectForKey:@"status"] intValue] == 1 && responseObject)
    {
        [UserDefaultsManager hideBusyScreenToView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Phone number already registered" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [UserDefaultsManager hideBusyScreenToView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Service unavailable. Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error localizedDescription]);
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[request.error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}



-(BOOL)validateTextfields
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    
    if([selectCountryField.text isEqualToString:@""])
    {
        alert.message = @"Select country code";
        [alert show];
        return NO;
    }
    else if([phoneNumberField.text isEqualToString:@""])
    {
        alert.message = @"Give your phone number";
        [alert show];
        return NO;
    }
    return YES;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _countries.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@  %@",[_countries objectAtIndex:row],[[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[_countries objectAtIndex:row]]];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = (int)row;
    
    NSString *countryName = [_countries objectAtIndex:selectedRow];
    NSDictionary *dict = [[CountryCodes getInstance] countryCodesDictionary];
    NSString *countryCode = [dict objectForKey:countryName];
    selectCountryField.text = [NSString stringWithFormat:@"%@", countryName];
    countryCodeLabel.text = countryCode;
    if(countryName.length > 28)
    {
        selectCountryField.font = [UIFont systemFontOfSize:9.0f];
    }
    else
    {
        selectCountryField.font = [UIFont boldSystemFontOfSize:15.0f];
    }
}

-(void)doneSelectCountry
{
    if([selectCountryField isFirstResponder])
    {
        [selectCountryField resignFirstResponder];
        [phoneNumberField becomeFirstResponder];
        return;
    }
    [self.view endEditing:YES];
}

#pragma mark TextField delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(kIsThreePointFiveInch)
    {
        [UserDefaultsManager goUpView:self.view ForTextField:textField];
    }
    
    if(textField == selectCountryField)
    {
        selectCountryField.text = [NSString stringWithFormat:@"%@", [_countries objectAtIndex:selectedRow]];
        countryCodeLabel.text = [[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[_countries objectAtIndex:selectedRow]];
    }
    else if(textField == phoneNumberField)
    {
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(kIsThreePointFiveInch)
    {
        [UserDefaultsManager goDownView:self.view];
    }
    
    if(textField == selectCountryField)
    {
        
    }
    else if(textField == phoneNumberField)
    {
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == phoneNumberField)
    {
        
    }
    return YES;
}

@end
