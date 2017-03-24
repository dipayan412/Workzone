//
//  RA_ReservationViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_ReservationViewController.h"
#import "RA_InputTextEditCell.h"
#import "RA_ReservationSendCell.h"
#import "RA_AppDelegate.h"

@interface RA_ReservationViewController () <reservationSendCellDelegate, UIGestureRecognizerDelegate>
{
    RA_InputTextEditCell *customerNameCell;
    RA_InputTextEditCell *numberOfCustomerCell;
    RA_InputTextEditCell *dateCell;
    RA_InputTextEditCell *timeCell;
    RA_InputTextEditCell *phoneNUmberCell;
    RA_InputTextEditCell *commentCell;
}

@end

@implementation RA_ReservationViewController

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
    
    [self cellConfiguration];
    
    //page,picker and tableview background set
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    containerTableView.separatorColor = [UIColor clearColor];
    containerTableView.backgroundColor = kPageBGColor;
    
    datePicker.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = kPageBGColor;
    
    //gesture added for the tableview. If background of the tableview tapped, selector called
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.delegate = self;
    [containerTableView addGestureRecognizer:gestureRecognizer];
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateStrings];//static strings localized to user selected language
    [containerTableView reloadData];
}

/**
 * Method name: hideKeyboard
 * Description: disappers the keyboard
 * Parameters: none
 */

-(void)hideKeyboard
{
    [self.view endEditing:YES];
}

/**
 * Method name: backButtonAction
 * Description: goes to previous page
 * Parameters: none
 */

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Tableview Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //show static cells
    if(indexPath.row < 6)
    {
        switch (indexPath.row)
        {
            case 0:
                return customerNameCell;
                
            case 1:
                return numberOfCustomerCell;
                
            case 2:
                return dateCell;
                
            case 3:
                return timeCell;
                
            case 4:
                return phoneNUmberCell;
                
            case 5:
                return commentCell;
        }
    }
    //send button shown
    static NSString *identifier = @"ReservationSendCellId";
    RA_ReservationSendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[RA_ReservationSendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        [cell changeButtonTitleWithkey:@"kSendRervation"];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([UIScreen mainScreen].bounds.size.width > 568)//ipad
    {
        return 70;
    }
    return 40;//iphone
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //this method also hides the keyboard
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
}

#pragma mark TextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 2)//if setDate textfield selected then the picker in date mode
    {
        datePicker.datePickerMode = UIDatePickerModeDate;
    }
    if(textField.tag == 3)// if setTime textfield selected then the picker in time mode
    {
        datePicker.datePickerMode = UIDatePickerModeTime;
    }
    
    if(textField.tag == 4 || textField.tag == 5)//when these two textfields selected, the keyboard hides the textfield. So the view need to be animated upward and downward
    {
        if([UIScreen mainScreen].bounds.size.height < 568)
        {
            [self commitAnimations:-120];
        }
        else
        {
            [self commitAnimations:0];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self commitAnimations:0];
    
    //takes the time or date from the picker and append on the corresponding textfields
    
    if(textField.tag == 2)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd";
        textField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[datePicker date]]];
    }
    
    if(textField.tag == 3)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"HH:mm:ss";
        textField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[datePicker date]]];
    }
}

/**
 * Method name: commitAnimations
 * Description: when keyboard shown the view moves up so that no view elements get hidden under the keyboard and comes to the actual position when keyboard gets hidden
 * Parameters: amount of the view to be moved
 */

-(void)commitAnimations:(int)y//animate the view upward/downward
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    containerTableView.frame = CGRectMake(0, y, containerTableView.frame.size.width, containerTableView.frame.size.height);
    [UIView commitAnimations];
}

/**
 * Method name: cellConfiguration
 * Description: initialize all the fields in the form
 * Parameters: none
 */

-(void)cellConfiguration
{
    //textField cells configured in this method
    customerNameCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCellId" placeHolderString:@"Your name"];
    customerNameCell.inputTextField.delegate = self;
    customerNameCell.inputTextField.tag = 0;
    
    numberOfCustomerCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCellId" placeHolderString:@"Number of people"];
    numberOfCustomerCell.inputTextField.delegate = self;
    numberOfCustomerCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    numberOfCustomerCell.inputTextField.tag = 1;
    
    dateCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCellId" placeHolderString:@"Set date"];
    dateCell.inputTextField.delegate = self;
    dateCell.inputTextField.tag = 2;
    dateCell.inputTextField.inputView = datePicker;
    
    timeCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCellId" placeHolderString:@"Set time"];
    timeCell.inputTextField.delegate = self;
    timeCell.inputTextField.tag = 3;
    timeCell.inputTextField.inputView = datePicker;
    
    phoneNUmberCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCellId" placeHolderString:@"Phone number"];
    phoneNUmberCell.inputTextField.delegate = self;
    phoneNUmberCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNUmberCell.inputTextField.tag = 4;
    
    commentCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCellId" placeHolderString:@"Comment(optional)"];
    commentCell.inputTextField.delegate = self;
    commentCell.inputTextField.tag = 5;
    
    //localizing the texts to the user selected language
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    customerNameCell.inputTextField.placeholder = AMLocalizedString(@"kYourName", nil);
    numberOfCustomerCell.inputTextField.placeholder = AMLocalizedString(@"kYourName", nil);
    dateCell.inputTextField.placeholder = AMLocalizedString(@"kSetDate", nil);
    timeCell.inputTextField.placeholder = AMLocalizedString(@"kSetTime", nil);
    phoneNUmberCell.inputTextField.placeholder = AMLocalizedString(@"kPhoneNumber", nil);
    commentCell.inputTextField.placeholder = AMLocalizedString(@"kComment", nil);
}

/**
 * Method name: updateStrings
 * Description: change static strings according to the language chosen
 * Parameters: none
 */

-(void)updateStrings
{
    //localizing the texts to the user selected language
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    customerNameCell.inputTextField.placeholder = AMLocalizedString(@"kYourName", nil);
    numberOfCustomerCell.inputTextField.placeholder = AMLocalizedString(@"kYourName", nil);
    dateCell.inputTextField.placeholder = AMLocalizedString(@"kSetDate", nil);
    timeCell.inputTextField.placeholder = AMLocalizedString(@"kSetTime", nil);
    phoneNUmberCell.inputTextField.placeholder = AMLocalizedString(@"kPhoneNumber", nil);
    commentCell.inputTextField.placeholder = AMLocalizedString(@"kComment", nil);
    
    //picker also localized
    if([RA_UserDefaultsManager isLanguageItalian])
    {
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"it"];
    }
    else
    {
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    }
}

/**
 * Method name: formValidationDone
 * Description: checks whether all the fields filled up or not
 * Parameters: none
 */

-(BOOL)formValidationDone//this method checks whether all the fields has been fill up by the user or not
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    if(customerNameCell.inputTextField.text == nil || [customerNameCell.inputTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kGiveName", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    if(numberOfCustomerCell.inputTextField.text == nil || [numberOfCustomerCell.inputTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kNumberOfPeople", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    if(dateCell.inputTextField.text == nil || [dateCell.inputTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kEnterDate", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    if(timeCell.inputTextField.text == nil || [timeCell.inputTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kEnterTime", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    if(phoneNUmberCell.inputTextField.text == nil || [phoneNUmberCell.inputTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kGiveNumber", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

/**
 * Method name: sendButtonClicked
 * Description: if all fields filled up correctly send data to the server action performed
 * Parameters: none
 */

-(void)sendButtonClicked//send button action
{
    if([self formValidationDone])
    {
        [self postReserveASeat];
    }
}

/**
 * Method name: postReserveASeat
 * Description: sends data to the server
 * Parameters: none
 */

-(void)postReserveASeat
{

//  this method sends the data of the form to the server
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    NSString *dateTimeStr = [NSString stringWithFormat:@"%@ %@",dateCell.inputTextField.text,timeCell.inputTextField.text];
    
    [jsonObject setValue:customerNameCell.inputTextField.text forKey:@"name"];
    [jsonObject setValue:numberOfCustomerCell.inputTextField.text forKey:@"number_of_people"];
    [jsonObject setValue:dateTimeStr forKey:@"date_n_time"];
    [jsonObject setValue:phoneNUmberCell.inputTextField.text forKey:@"phone"];
    [jsonObject setValue:commentCell.inputTextField.text forKey:@"comment"];
    
    NSURL *url = [NSURL URLWithString:SendReservationAPI];
    NSDictionary *postDict = [[NSDictionary alloc] initWithDictionary:jsonObject];
    NSData *postData = [self encodeDictionary:postDict];
    
    // Create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"]; // define the method type
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"Response: %@\n",data);
    
    if(data == nil)
    {
        NSLog(@"hamba");
    }
    else
    {
        LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kSuccess", nil) message:AMLocalizedString(@"kReservationSuccessful", nil)  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"returnedObject: %@",object);
}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary)
    {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
