//
//  RegistrationViewController.m
//  WakeUp
//
//  Created by World on 6/18/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "RegistrationViewController.h"
#import "LoginCell.h"

@interface RegistrationViewController () <ASIHTTPRequestDelegate>
{
    NSArray *genderArray;
    
    LoginCell *firstNameCell;
    LoginCell *lastNameCell;
    LoginCell *emailCell;
    LoginCell *sexCell;
    LoginCell *phoneCell;
    LoginCell *dobCell;
    LoginCell *passwordCell;
    LoginCell *confirmPasswordCell;
    
    ASIHTTPRequest *regRequest;
    
    UIAlertView *loadingAlert;
}

@end

@implementation RegistrationViewController

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
    
    genderArray = [[NSArray alloc] initWithObjects:@"Female", @"Male", @"Other", nil];
    [sexPicker selectRow:0 inComponent:0 animated:YES];
    
    sexField.inputView = sexPicker;
    dobField.inputView = dobPicker;
    
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..." message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark button actions

-(IBAction)backButtonAction:(UIButton*)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)registerButtonAction:(UIButton*)sender
{
    [self registerProcedure];
}

-(void)registerProcedure
{
    [self.view endEditing:YES];
    
    if([self formValidation])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [imagePicker setDelegate:self];
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)registrationRequestWithPhotoId:(NSString*)pid
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@&",kRegisterApi];
    [urlStr appendFormat:@"email=%@&",emailCell.cellField.text];
    [urlStr appendFormat:@"name=%@&",[firstNameCell.cellField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlStr appendFormat:@"dob=%@&",dobCell.cellField.text];
    [urlStr appendFormat:@"sex=%ld&",(long)[sexPicker selectedRowInComponent:0]];
    [urlStr appendFormat:@"pass=%@",[passwordCell.cellField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if(![pid isEqualToString:@""])
    {
        [urlStr appendFormat:@"&pid=%@",pid];
    }
    
    regRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    regRequest.delegate = self;
    [regRequest startAsynchronous];
}

#pragma mark asihttprequest delegate methods

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    if(request == regRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@ %@",responseObject, error.description);
        
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Welcome to WakeUp network"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else if([[responseObject objectForKey:@"status"] intValue] == 1 && responseObject)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Email already exist"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
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

#pragma mark imagePicker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if ([info objectForKey:@"UIImagePickerControllerMediaMetadata"])
    {
        int state = [[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"Orientation"] intValue];
        NSLog(@"State = %d", state);
        switch (state)
        {
            case 3:
                //Rotate image to the left twice.
                img = [UIImage imageWithCGImage:[img CGImage]];
                img = [self rotateImage:[self rotateImage:img withRotationType:1] withRotationType:1];
                break;
                
            case 6:
                img = [UIImage imageWithCGImage:[img CGImage]];
                img = [self rotateImage:img withRotationType:-1];
                break;
                
            case 8:
                img = [UIImage imageWithCGImage:[img CGImage]];
                img = [self rotateImage:img withRotationType:1];
                break;
                
            default:
                break;
        }
    }
    
    img = [self imageWithImage:img scaledToWidth:200];
    [self uploadImageWithImageData:UIImagePNGRepresentation(img)];
}

#pragma mark scale image

- (UIImage *) imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark rotate image

-(UIImage*)rotateImage:(UIImage*)img withRotationType:(int)rotation
{
    CGImageRef imageRef = [img CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (alphaInfo == kCGImageAlphaNone)
    {
        alphaInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    bitmap = CGBitmapContextCreate(NULL, img.size.height, img.size.width, CGImageGetBitsPerComponent(imageRef), 4 * img.size.height, colorSpaceInfo, (CGBitmapInfo)alphaInfo);
    CGColorSpaceRelease(colorSpaceInfo);
    
    CGContextTranslateCTM (bitmap, (rotation > 0 ? img.size.height : 0), (rotation > 0 ? 0 : img.size.width));
    CGContextRotateCTM (bitmap, rotation * M_PI / 2.0f);
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, img.size.width, img.size.height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    CGContextRelease(bitmap);
    return result;
}

#pragma mark upload image to server

-(void)uploadImageWithImageData:(NSData*)imageData
{
    [loadingAlert show];
    
    NSString *urlString = [NSString stringWithFormat:kUploadphotoApi];
    
    NSData *data = imageData;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"test.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSError *error = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
    if([[responseObject objectForKey:@"status"] isEqualToString:@"0"])
    {
        NSLog(@"image uploaded successfully");
        [self registrationRequestWithPhotoId:[responseObject objectForKey:@"imgid"]];
    }
    else
    {
        [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Could not upload photo to Server. Try again later"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSLog(@"%@ %@", responseObject, error.description);
}

#pragma mark alertView delegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark pickerView delegate methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [genderArray objectAtIndex:row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    sexCell.cellField.text = [genderArray objectAtIndex:row];
}

#pragma mark textfield delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == sexCell.cellField)
    {
        sexCell.cellField.text = [genderArray objectAtIndex:[sexPicker selectedRowInComponent:0]];
    }
    if(textField == passwordCell.cellField)
    {
        [self commitAnimations:-44];
    }
    else if(textField == confirmPasswordCell.cellField)
    {
        [self commitAnimations:-85];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == dobCell.cellField)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        dobCell.cellField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:dobPicker.date]];
    }
    [self commitAnimations:0];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text isEqualToString:@""] && textField != confirmPasswordCell.cellField)
    {
        [textField resignFirstResponder];
        return YES;
    }
    if(textField == firstNameCell.cellField)
    {
        [firstNameCell.cellField resignFirstResponder];
        [lastNameCell.cellField becomeFirstResponder];
        return NO;
    }
    else if(textField == lastNameCell.cellField)
    {
        [lastNameCell.cellField resignFirstResponder];
        [emailCell.cellField becomeFirstResponder];
        return NO;
    }
    else if(textField == emailCell.cellField)
    {
        [emailCell.cellField resignFirstResponder];
        [sexCell.cellField becomeFirstResponder];
        return NO;
    }
    else if(textField == passwordCell.cellField)
    {
        [passwordCell.cellField resignFirstResponder];
        [confirmPasswordCell.cellField becomeFirstResponder];
        return NO;
    }
    else if(textField == confirmPasswordCell.cellField)
    {
        [confirmPasswordCell.cellField resignFirstResponder];
        [self registerProcedure];
        return YES;
    }
    return YES;
}

#pragma mark tableView delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return firstNameCell;
            
        case 1:
            return lastNameCell;
            
        case 2:
            return emailCell;
            
        case 3:
            return sexCell;
            
        case 4:
            return phoneCell;
            
        case 5:
            return dobCell;
            
        case 6:
            return passwordCell;
            
        case 7:
            return confirmPasswordCell;
            
        case 8:{
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegCell"];
            UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            registerButton.frame = CGRectMake(0, 0, 320, 44);
            registerButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
            [registerButton setTitle:@"Register" forState:UIControlStateNormal];
            [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
            registerButton.layer.cornerRadius = 7.0f;
            [registerButton addTarget:self action:@selector(registerProcedure) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:registerButton];
            cell.separatorInset = UIEdgeInsetsMake(0, 320, 0, 0);
            return cell;
        }
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark animate view up or down

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

#pragma mark formValidation

-(BOOL)formValidation
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    if([firstNameCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Give Firstname";
        [alert show];
        return NO;
    }
    else if([lastNameCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Give Lastname";
        [alert show];
        return NO;
    }
    else if([emailCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Give email";
        [alert show];
        return NO;
    }
    else if([sexCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Give gender";
        [alert show];
        return NO;
    }
    else if([phoneCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Give phone number";
        [alert show];
        return NO;
    }
    else if([dobCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Give date of birth";
        [alert show];
        return NO;
    }
    else if([passwordCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Give password";
        [alert show];
        return NO;
    }
    else if([passwordCell.cellField.text length] < 6)
    {
        alert.message = @"Password is too short";
        [alert show];
        return NO;
    }
    else if([confirmPasswordCell.cellField.text isEqualToString:@""])
    {
        alert.message = @"Fill confirm password field";
        [alert show];
        return NO;
    }
    else if(![passwordCell.cellField.text isEqualToString:confirmPasswordCell.cellField.text])
    {
        alert.message = @"Password do not match";
        [alert show];
        return NO;
    }
    else if(![self NSStringIsValidEmail:emailCell.cellField.text])
    {
        alert.message = @"Give valid email address";
        [alert show];
        return NO;
    }
    return YES;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark configuring cells

-(void)cellConfiguration
{
    firstNameCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegCell"];
    firstNameCell.cellField.delegate = self;
    firstNameCell.cellField.placeholder = @"Firstname";
    
    lastNameCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegCell"];
    lastNameCell.cellField.delegate = self;
    lastNameCell.cellField.placeholder = @"Lastname";
    
    emailCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegCell"];
    emailCell.cellField.delegate = self;
    emailCell.cellField.placeholder = @"Email";
    emailCell.cellField.keyboardType = UIKeyboardTypeEmailAddress;
    emailCell.cellField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailCell.cellField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    phoneCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegCell"];
    phoneCell.cellField.delegate = self;
    phoneCell.cellField.placeholder = @"Phone";
    phoneCell.cellField.keyboardType = UIKeyboardTypePhonePad;
    phoneCell.cellField.keyboardAppearance = UIKeyboardAppearanceDefault;
    
    dobCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegCell"];
    dobCell.cellField.delegate = self;
    dobCell.cellField.placeholder = @"Date of birth";
    dobCell.cellField.inputView = dobPicker;
    
    sexCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegCell"];
    sexCell.cellField.delegate = self;
    sexCell.cellField.placeholder = @"Gender";
    sexCell.cellField.inputView = sexPicker;
    
    passwordCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegCell"];
    passwordCell.cellField.delegate = self;
    passwordCell.cellField.placeholder = @"Password";
    passwordCell.cellField.secureTextEntry = YES;
    passwordCell.cellField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordCell.cellField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    confirmPasswordCell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegCell"];
    confirmPasswordCell.cellField.delegate = self;
    confirmPasswordCell.cellField.placeholder = @"Confirm password";
    confirmPasswordCell.cellField.secureTextEntry = YES;
    confirmPasswordCell.cellField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    confirmPasswordCell.cellField.autocorrectionType = UITextAutocorrectionTypeNo;
    confirmPasswordCell.separatorInset = UIEdgeInsetsMake(0, 320, 0, 0);
    confirmPasswordCell.cellField.returnKeyType = UIReturnKeyGo;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(registerProcedure)];
    [doneButton setTintColor:[UIColor whiteColor]];
    [toolBar setItems:[NSArray arrayWithObjects:space1 ,doneButton, space2, nil]];
    
    firstNameCell.cellField.inputAccessoryView = toolBar;
    lastNameCell.cellField.inputAccessoryView = toolBar;
    emailCell.cellField.inputAccessoryView = toolBar;
    passwordCell.cellField.inputAccessoryView = toolBar;
//    confirmPasswordCell.cellField.inputAccessoryView = toolBar;
    
    [self setUpKeyboardToolbars];
}

#pragma mark setting inputAccessoryView

-(void)setUpKeyboardToolbars
{
    [self settingToolbarOnDobFieldKeyBoard];
    [self settingToolbarOnPhoneFieldKeyBoard];
    [self settingToolbarOnSexFieldKeyBoard];
}

-(void)settingToolbarOnSexFieldKeyBoard
{
    UIToolbar *sexFieldToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    sexFieldToolBar.barStyle = UIBarStyleBlackTranslucent;
    sexFieldToolBar.translucent = YES;
    sexFieldToolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(registerProcedure)];
    [doneButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space2.width = 70;
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(sexFieldDoneAction)];
    nextButton.tintColor = [UIColor whiteColor];
    [sexFieldToolBar setItems:[NSArray arrayWithObjects:space1, doneButton, space2, nextButton, nil]];
    
    sexCell.cellField.inputAccessoryView = sexFieldToolBar;
}

-(void)sexFieldDoneAction
{
    [sexCell.cellField resignFirstResponder];
    [phoneCell.cellField becomeFirstResponder];
}

-(void)settingToolbarOnPhoneFieldKeyBoard
{
    UIToolbar *phoneFieldToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    phoneFieldToolBar.barStyle = UIBarStyleBlackTranslucent;
    phoneFieldToolBar.translucent = YES;
    phoneFieldToolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(registerProcedure)];
    [doneButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space2.width = 70;
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(phoneFieldDoneAction)];
    nextButton.tintColor = [UIColor whiteColor];
    [phoneFieldToolBar setItems:[NSArray arrayWithObjects:space1, doneButton, space2, nextButton, nil]];
    
    phoneCell.cellField.inputAccessoryView = phoneFieldToolBar;
}

-(void)phoneFieldDoneAction
{
    if([phoneCell.cellField.text isEqualToString:@""])
    {
        [phoneCell.cellField resignFirstResponder];
        return;
    }
    [phoneCell.cellField resignFirstResponder];
    [dobCell.cellField becomeFirstResponder];
}

-(void)settingToolbarOnDobFieldKeyBoard
{
    UIToolbar *dobFieldToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    dobFieldToolBar.barStyle = UIBarStyleBlackTranslucent;
    dobFieldToolBar.translucent = YES;
    dobFieldToolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(registerProcedure)];
    [doneButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space2.width = 70;
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(dobFieldDoneAction)];
    nextButton.tintColor = [UIColor whiteColor];
    [dobFieldToolBar setItems:[NSArray arrayWithObjects:space1, doneButton, space2, nextButton, nil]];
    
    dobCell.cellField.inputAccessoryView = dobFieldToolBar;
}

-(void)dobFieldDoneAction
{
    [dobCell.cellField resignFirstResponder];
    [passwordCell.cellField becomeFirstResponder];
}

@end
