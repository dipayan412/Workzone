//
//  RA_TakeAwayViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_TakeAwayViewController.h"
#import "RA_OrderDetailCell.h"
#import "RA_OrderLaterCheckBoxCell.h"
#import "RA_InputTextEditCell.h"
#import "RA_ReservationSendCell.h"
#import "RA_MenuObject.h"
#import "RA_AppDelegate.h"

@interface RA_TakeAwayViewController () <RA_OrderLaterCheckBoxCellDelegate, reservationSendCellDelegate,UIGestureRecognizerDelegate>
{
    RA_InputTextEditCell *customerNameCell;
    RA_InputTextEditCell *dateCell;
    RA_InputTextEditCell *timeCell;
    RA_InputTextEditCell *phoneNumberCell;
    RA_InputTextEditCell *commentCell;
    RA_OrderDetailCell *orderDetailCell;
    RA_OrderLaterCheckBoxCell *orderLaterCheckBoxCell;
    RA_ReservationSendCell *reservationSendCell;
    
    NSMutableArray *menuItemsArray;
    NSString *checkBoxString;
}
@property (nonatomic, assign) BOOL isTakeAwaySent;

@end

@implementation RA_TakeAwayViewController

@synthesize isTakeAwaySent;

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
    
    checkBoxString = @"";
    
    //title of the page,picker background,tableview background color and separator color set
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    containerTableView.separatorColor = [UIColor clearColor];
    containerTableView.backgroundColor = kPageBGColor;
    
    datePicker.backgroundColor = [UIColor whiteColor];
    
    menuItemsArray = [[NSMutableArray alloc] init];
    
    for(RA_MenuObject *object in [RA_UserDefaultsManager getOrderItemsArray])
    {
        [menuItemsArray addObject:object];
    }
    [self cellConfiguration];
    
    //gesture added for the tableview. If background of the tableview tapped, selector called
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.delegate = self;
    [containerTableView addGestureRecognizer:gestureRecognizer];
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateStrings];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Tableview Delagate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return customerNameCell;
            
        case 1:
            return dateCell;
            
        case 2:
            return timeCell;
            
        case 3:
            return phoneNumberCell;
            
        case 4:
            return orderDetailCell;
            
        case 5:
            return orderLaterCheckBoxCell;
        
        case 6:
            return commentCell;
            
        case 7:
            return reservationSendCell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 4)
    {
        return 120;
    }
    if([UIScreen mainScreen].bounds.size.width > 568)//ipad
    {
        return 70;
    }
    return 40;//iphone
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
}

#pragma mark TextField Delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        datePicker.datePickerMode = UIDatePickerModeDate;
    }
    if(textField.tag == 2)
    {
        datePicker.datePickerMode = UIDatePickerModeTime;
    }
    
    if(textField.tag == 4)
    {
        if([UIScreen mainScreen].bounds.size.height < 568)
        {
            [self commitAnimations:-130];
        }
        else if([UIScreen mainScreen].bounds.size.height == 568)
        {
            [self commitAnimations:-90];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self commitAnimations:64];
    
    if(textField.tag == 1)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd";
        textField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[datePicker date]]];
    }
    
    if(textField.tag == 2)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"HH:mm:ss";
        textField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[datePicker date]]];
    }
}

/**
 * Method name: commitAnimations
 * Description: when keyboard shown the view moves up so that no view elements get hidden under the keyboard and comes to the actual position when keyboard gets hidden
 * Parameters: the amount view will move
 */

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

#pragma mark checkBox Delegate Method

/**
 * Method name: checkBoxButtonSelected
 * Description: disappers the keyboard
 * Parameters: whether checkbow selected or not
 */

-(void)checkBoxButtonSelected:(BOOL)selected
{
    if(selected)
    {
        checkBoxString = @"#Order later";
    }
    else
    {
        checkBoxString = @"";
    }
}

/**
 * Method name: cellConfiguration
 * Description: initializes ech row of the form
 * Parameters: none
 */

-(void)cellConfiguration
{
    containerTableView.backgroundColor = kPageBGColor;
    customerNameCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TakeAwayCellId" placeHolderString:@"Your name"];
    customerNameCell.inputTextField.delegate = self;
    customerNameCell.inputTextField.tag = 0;
    
    dateCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TakeAwayCellId" placeHolderString:@"Set date"];
    dateCell.inputTextField.delegate = self;
    dateCell.inputTextField.tag = 1;
    dateCell.inputTextField.inputView = datePicker;
    
    timeCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TakeAwayCellId" placeHolderString:@"Set time"];
    timeCell.inputTextField.delegate = self;
    timeCell.inputTextField.tag = 2;
    timeCell.inputTextField.inputView = datePicker;
    
    phoneNumberCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TakeAwayCellId" placeHolderString:@"Phone number"];
    phoneNumberCell.inputTextField.delegate = self;
    phoneNumberCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberCell.inputTextField.tag = 3;
    
    commentCell = [[RA_InputTextEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TakeAwayCellId" placeHolderString:@"Comment(optional)"];
    commentCell.inputTextField.delegate = self;
    commentCell.inputTextField.tag = 4;
    
    RA_AppDelegate *apdl = (RA_AppDelegate*)[[UIApplication sharedApplication] delegate];
    float total = 0;
    NSMutableString *str = [[NSMutableString alloc] init];
    for(RA_MenuObject *object in menuItemsArray)
    {
        total += (object.menuPrice.floatValue * object.numberOfOrder);
        [str appendFormat:@"%d %@ %0.2f %@,\n",object.numberOfOrder,object.menuName,(object.menuPrice.floatValue * object.numberOfOrder),apdl.currency];
    }
    
    if([str isEqualToString:@""])
    {
        [str appendFormat:@"%@\n",AMLocalizedString(@"kNoOrder", nil)];
    }
    
    [str appendFormat:@"\n%@: %0.2f %@\n",AMLocalizedString(@"kOrder", nil),total,apdl.currency];
    [str appendFormat:@"%@: %0.2f",AMLocalizedString(@"kTax", nil),apdl.taxAmount];
    [str appendString:@"%"];
    [str appendFormat:@": %0.2f %@\n",total/apdl.taxAmount,apdl.currency];
    [str appendFormat:@"%@: %0.2f %@",AMLocalizedString(@"kTotal", nil), (total + (total/apdl.taxAmount)), apdl.currency];
    
    orderDetailCell = [[RA_OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TakeAwayCellId"];
    orderDetailCell.orderDetailTextView.text = str;
    
    orderLaterCheckBoxCell = [[RA_OrderLaterCheckBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TakeAwayCellId" isCheckboxSelected:NO];
    orderLaterCheckBoxCell.delegate = self;
    [orderLaterCheckBoxCell changeLabel];
    
    reservationSendCell = [[RA_ReservationSendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TakeAwayCellId"];
    reservationSendCell.delegate = self;
    [reservationSendCell changeButtonTitleWithkey:@"kSendRervation"];
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    customerNameCell.inputTextField.placeholder = AMLocalizedString(@"kYourName", nil);
    dateCell.inputTextField.placeholder = AMLocalizedString(@"kSetDate", nil);
    timeCell.inputTextField.placeholder = AMLocalizedString(@"kSetTime", nil);
    phoneNumberCell.inputTextField.placeholder = AMLocalizedString(@"kPhoneNumber", nil);
    commentCell.inputTextField.placeholder = AMLocalizedString(@"kComment", nil);
}

/**
 * Method name: updateStrings
 * Description: update static strings to the language chosen
 * Parameters: none
 */

-(void)updateStrings
{
    [orderLaterCheckBoxCell changeLabel];
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    customerNameCell.inputTextField.placeholder = AMLocalizedString(@"kYourName", nil);
    dateCell.inputTextField.placeholder = AMLocalizedString(@"kSetDate", nil);
    timeCell.inputTextField.placeholder = AMLocalizedString(@"kSetTime", nil);
    phoneNumberCell.inputTextField.placeholder = AMLocalizedString(@"kPhoneNumber", nil);
    commentCell.inputTextField.placeholder = AMLocalizedString(@"kComment", nil);
    
    [reservationSendCell changeButtonTitleWithkey:@"kSendRervation"];
    
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

-(BOOL)formValidationDone
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    if(customerNameCell.inputTextField.text == nil || [customerNameCell.inputTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kGiveName", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
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
    
    if(menuItemsArray.count < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kPlaceOrder", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    if(phoneNumberCell.inputTextField.text == nil || [phoneNumberCell.inputTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kGiveNumber", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

/**
 * Method name: sendButtonClicked
 * Description: if all fields filled up correctly send data to the server
 * Parameters: none
 */

-(void)sendButtonClicked
{
    if([self formValidationDone])
    {
        [self postTakeAway];
    }
}

/**
 * Method name: postTakeAway
 * Description: sends data to the server
 * Parameters: none
 */

-(void)postTakeAway
{
    RA_AppDelegate *apdl = (RA_AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableString *orderList = [[NSMutableString alloc] init];
    float Order_price = 0;
    float Total_price = 0;
    float tax = 0;
    
    [orderList appendFormat:@"%@",checkBoxString];
    
    for(RA_MenuObject *object in menuItemsArray)
    {
        NSString *menuName = object.menuName;
        NSString *quantity = [NSString stringWithFormat:@"%d",object.numberOfOrder];
        float Sub_total_price = (object.menuPrice.intValue * object.numberOfOrder);
        Order_price += Sub_total_price;
        
        [orderList appendFormat:@"%@ %@ %0.1f %@\n",quantity,menuName,Sub_total_price, apdl.currency];
    }
    if(orderList.length <1)
    {
        [orderList appendString:@"No Order"];
    }
    
    tax = Order_price/apdl.taxAmount;
    Total_price = Order_price + tax;
    [orderList appendFormat:@"\nOrder: %0.1f %@\nTax %0.1f",Order_price, apdl.currency, apdl.taxAmount];
    [orderList appendString:@"%"];
    [orderList appendFormat:@": %0.1f %@",tax, apdl.currency];
    [orderList appendFormat:@"\nTotal: %0.1f %@", Total_price, apdl.currency];
    
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    NSString *dateTimeStr = [NSString stringWithFormat:@"%@ %@",dateCell.inputTextField.text,timeCell.inputTextField.text];
    
    [jsonObject setValue:customerNameCell.inputTextField.text forKey:@"name"];
    [jsonObject setValue:dateTimeStr forKey:@"date_n_time"];
    [jsonObject setValue:phoneNumberCell.inputTextField.text forKey:@"phone"];
    [jsonObject setValue:orderList forKey:@"order_list"];
    [jsonObject setValue:commentCell.inputTextField.text forKey:@"comment"];
    
    NSURL *url = [NSURL URLWithString:SendTakeAwayAPI];
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
        
//        [RA_UserDefaultsManager removeAllItems];
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
