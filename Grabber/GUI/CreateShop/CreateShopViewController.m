//
//  CreateShopViewController.m
//  iOS Prototype
//
//  Created by World on 3/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "BingMaps.h"
#import "CreateShopViewController.h"
#import "CreateStoreTopCell.h"
#import "SearchLocationViewController.h"
#import "LocationObject.h"

#define kTextViewStorePlaceholder @"Enter Store Description"

@interface CreateShopViewController () <ASIHTTPRequestDelegate, CLLocationManagerDelegate,SearchLocationDelegate>
{
    UIAlertView *loadingAlert;
    
    CLLocationManager *userLocationManeger;
    CLLocation *userLocation;
    
    CreateStoreTopCell *topCell;
    
    UITapGestureRecognizer *gestureRecognizer;
    
    LocationObject *locationObject;
}

@property (nonatomic, retain) ASIHTTPRequest *createShopRequest;

@end

@implementation CreateShopViewController

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
    
    userLocationManeger = [[CLLocationManager alloc] init];
    userLocationManeger.delegate = self;
    
    self.navigationItem.title = @"Create Store";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CreatePromoBG.png"]];
    
    [self cellConfiguration];
    
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    gestureRecognizer.delegate = self;
    
    if(![UserDefaultsManager isUserMerchant])
    {
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(home:)];
        self.navigationItem.leftBarButtonItem = newBackButton;
    }
    
    chooseLocationSuperParentView.frame = CGRectMake(0, 568 * 2, 320, 568);
    chooseLocationSuperParentView.backgroundColor = [UIColor colorWithWhite:0.33f alpha:0.72f];
    chooseLocationParentView.backgroundColor = [UIColor whiteColor];
    chooseLocationOptionView.backgroundColor = [UIColor clearColor];
    chooseLocationManualView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:chooseLocationSuperParentView];
    [userLocationManeger startUpdatingLocation];
    
    formTableView.backgroundColor = [UIColor clearColor];
    locationObject = nil;
}

-(void)home:(UIBarButtonItem *)sender
{
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    userLocation = [locations lastObject];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(IBAction)registerButtonAction:(UIButton*)btn
{
    [self registerOperation];
}

-(void)registerOperation
{
    [storeNameCell.inputField resignFirstResponder];
    [typeCell.inputField resignFirstResponder];
    [descriptionCell resignFirstResponder];
    
    if([storeNameCell.inputField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter the name of the store"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if(locationObject == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please select a location"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSMutableString *urlStr = [[NSMutableString alloc] init];
//    [urlStr appendFormat:@"%@%@%@/%@/%@/%@/%@", baseUrl,registerShopApi,[UserDefaultsManager sessionToken],storeNameCell.inputField.text,typeCell.inputField.text,[NSString stringWithFormat:@"%f",locationObject.locationLatitude],[NSString stringWithFormat:@"%f",locationObject.locationLongitude]];
    [urlStr appendFormat:@"%@", baseUrl];
    [urlStr appendFormat:@"%@", registerShopApi];
    [urlStr appendFormat:@"%@/", [UserDefaultsManager sessionToken]];
    [urlStr appendFormat:@"%@/", storeNameCell.inputField.text];//[storeNameCell.inputField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlStr appendFormat:@"%@/", [NSString stringWithFormat:@"%f",locationObject.locationLatitude]];
    [urlStr appendFormat:@"%@", [NSString stringWithFormat:@"%f",locationObject.locationLongitude]];
    
    if(![typeCell.inputField.text isEqualToString:@""])
    {
        [urlStr appendFormat:@"/%@/", typeCell.inputField.text];//[typeCell.inputField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if(![descriptionCell.inputTextView.text isEqualToString:@""])
    {
        [urlStr appendFormat:@"%@", descriptionCell.inputTextView.text];//[descriptionCell.inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSLog(@"%@",urlStr);
    
    //@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"
    urlStr = (NSMutableString*)[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //lat --> 23.770974 lng --> 90.354004
    
    // 37.332596 -122.030318
    NSURL *url = [NSURL URLWithString:urlStr];
    self.createShopRequest = [ASIHTTPRequest requestWithURL:url];
    self.createShopRequest.delegate = self;
    [self.createShopRequest startAsynchronous];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"%@",request.responseString);
    if([responseObject objectForKey:@"status"] != nil)
    {
        if([[responseObject objectForKey:@"status"] intValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Shop registered successfully"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            if(![UserDefaultsManager isUserMerchant])
            {
                [UserDefaultsManager setUserMerchant:YES];
                [UserDefaultsManager setMerchantModeOn:YES];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[responseObject objectForKey:@"message"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Something went wrong. Try again later"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:[request.error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return topCell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            return storeNameCell;
        }
        else if (indexPath.row == 1)
        {
            return typeCell;
        }
        else if (indexPath.row == 2)
        {
            return locationCell;
        }
        else
        {
            return descriptionCell;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 120.0f;
    }
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1)
    {
        if(indexPath.row == 2)
        {
            SearchLocationViewController *vc = [[SearchLocationViewController alloc] initWithNibName:@"SearchLocationViewController" bundle:nil];
            vc.delegate = self;
            [self changeBackbuttonTitle];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

-(void)cellConfiguration
{
    topCell = [[CreateStoreTopCell alloc] init];
    topCell.storeNameField.delegate = self;
    topCell.storeNameField.tag = 2;
    
    storeNameCell = [[inputTextCell alloc] initWithIsDescription:NO];
    storeNameCell.fieldTitleLabel.text = @"Store Name";
    storeNameCell.inputField.placeholder = @"Enter name of the store";
    storeNameCell.inputField.delegate = self;
    storeNameCell.inputField.tag = 0;
    storeNameCell.inputField.returnKeyType = UIReturnKeyNext;
    
    typeCell = [[inputTextCell alloc] initWithIsDescription:NO];
    typeCell.fieldTitleLabel.text = @"iBeacon Id";
    typeCell.inputField.placeholder = @"Type your iBeaconId";
    typeCell.inputField.text = @"A77A1B68-49A7-4DBF-914C-760D07FBB87B";
    typeCell.inputField.delegate = self;
    typeCell.inputField.tag = 1;
    typeCell.inputField.returnKeyType = UIReturnKeyNext;
    typeCell.inputField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    typeCell.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    descriptionCell = [[inputTextCell alloc] initWithIsDescription:YES];
    descriptionCell.fieldTitleLabel.text = @"Description";
    descriptionCell.inputTextView.text = @"Enter Store Description";
    descriptionCell.inputTextView.delegate = self;
    descriptionCell.inputTextView.returnKeyType = UIReturnKeyDone;
    
    locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LocationCell"];
    locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    locationCell.textLabel.text = @"Select Loaction";
    locationCell.textLabel.font = [UIFont systemFontOfSize:13.0f];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [formTableView addGestureRecognizer:gestureRecognizer];
    [self.view addGestureRecognizer:gestureRecognizer];
    if(textField.tag == 0)
    {
        if([UIScreen mainScreen].bounds.size.height < 568)
        {
            [self commitAnimations:-10];
        }
    }
    
    if(textField.tag == 1)
    {
        if([UIScreen mainScreen].bounds.size.height < 568)
        {
            [self commitAnimations:-30];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view removeGestureRecognizer:gestureRecognizer];
    [formTableView removeGestureRecognizer:gestureRecognizer];
    
    [self commitAnimations:64];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 0)
    {
        [typeCell.inputField becomeFirstResponder];
    }
    else if(textField.tag == 1)
    {
        [descriptionCell.inputTextView becomeFirstResponder];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [formTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [formTableView addGestureRecognizer:gestureRecognizer];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    if([textView.text isEqualToString:kTextViewStorePlaceholder])
    {
        textView.text = @"";
    }
    
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        [self commitAnimations:-120];
    }
    else
    {
        [self commitAnimations:-60];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.view removeGestureRecognizer:gestureRecognizer];
    [formTableView removeGestureRecognizer:gestureRecognizer];
    
    if([textView.text isEqualToString:@""])
    {
        textView.text = kTextViewStorePlaceholder;
    }
    [self commitAnimations:64];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [self registerOperation];
        return NO;
    }
    return YES;
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

-(IBAction)shopImageButtonAction:(UIButton*)btn
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    shopImageView.image = img;
}

-(IBAction)currentLocationButtonAction:(UIButton*)btn
{
    
}

-(IBAction)manualLocationButtonAction:(UIButton*)btn
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    chooseLocationManualView.frame = CGRectMake(0, 112, 320, 106);
    [UIView commitAnimations];
}

-(IBAction)searchInGrabberLocationButtonAction:(UIButton*)btn
{
    
}

-(IBAction)reverseGeocodingLocationButtonAction:(UIButton*)btn
{
    
}

-(IBAction)doneLocationButtonAction:(UIButton*)btn
{
    [self animateChooseLocationView:-320];
}

-(void)locateButtonTapped
{
    [self animateChooseLocationView:0];
}

-(void)animateChooseLocationView:(int)x
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    chooseLocationSuperParentView.frame = CGRectMake(x, 0, 320, 568);
    [UIView commitAnimations];
}

-(void)locationSelected:(LocationObject *)_locationObject
{
    locationCell.textLabel.text = _locationObject.locationName;
    locationCell.detailTextLabel.text = _locationObject.locationAddress;
    locationObject = _locationObject;
    [formTableView reloadData];
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
