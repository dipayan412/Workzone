//
//  AddDetailViewController.m
//  RenoMate
//
//  Created by yogesh ahlawat on 08/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import "AddDetailViewController.h"
#import "CategoryDescriptionDB.h"
#import "DataBaseManager.h"
#import "HomeScreenController.h"
#import "DisplayImageController.h"
#import "MapKitDisplayViewController.h"
#import "SubcatDescriptionController.h"
#import "WhosinAppDelegate.h"
#import "ApplicationPreference.h"
#import <Dropbox/Dropbox.h>
#import "UINavigationController+Operations.h"
#import "InAppPurchaseManager.h"

@interface AddDetailViewController()<UIAlertViewDelegate>
{
    UIAlertView *loadingAlert;
    UIAlertView *purchaseAlert;
    UIAlertView *newCatAddAlert;
    
    BOOL isNewAddCat;
    BOOL isLoaction;
    
    BOOL isCategoryPickerChanged;
    int tempGlobalIndex;
}
@end

@implementation AddDetailViewController

@synthesize img;
@synthesize noteField;
@synthesize locationField;
@synthesize catNameTextField;
@synthesize categoryArray;
@synthesize mode;
@synthesize locTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithImage:(UIImage*)_img
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.img = _img;
//        WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
//        appDelegate.globalCategoryIndex = -1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.alpha = 1.0f;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    imgView.image = img;
    
    categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    
    NSLog(@"Image size - %f %f ", imgView.image.size.width, imgView.image.size.height);
    
    NSString *systemVer = [[UIDevice currentDevice] systemVersion];
    if(systemVer.floatValue >= 7.0)
    {
        setLocationButton.layer.cornerRadius = addnewCatButton.layer.cornerRadius = 10.0f;
    }
    else
    {
        addnewCatButton.backgroundColor = setLocationButton.backgroundColor = [UIColor clearColor];
    }
}

-(void)resizeElements
{
    CGRect frame = categoryField.frame;
    float y = addnewCatButton.frame.origin.y;
    frame.origin.y = y;
    addnewCatButton.frame = frame;
    
    y = noteField.frame.origin.y;
    frame.origin.y = y;
    noteField.frame = frame;
    
    y = setLocationButton.frame.origin.y;
    frame.origin.y = y;
    setLocationButton.frame = frame;
    
    CGPoint center = imgView.center;
    center.x = self.view.frame.size.width / 2;
    imgView.center = center;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Add Details";

    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    loadingView = [[UIAlertView alloc] initWithTitle:@"Saving Image" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [loadingView addSubview:activityView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    [button setImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitButtonPressed:)];
    submitButton.tintColor = [UIColor colorWithRed:(61.0f/255.0f) green:(121.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f];
    self.navigationItem.rightBarButtonItem = submitButton;
    
    categoryPickerView = [[UIPickerView alloc] init];
    categoryPickerView.delegate = self;
    categoryPickerView.dataSource = self;
    categoryPickerView.showsSelectionIndicator = YES;
    
    categoryField.inputView = categoryPickerView;
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Connecting to Appstore..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
//    categoryField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow.png"]];
//    categoryField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark user added method

-(void)sendLocationDetails:(NSString *)title:(double)lng:(double)lat
{
    self.locTitle = title;
    locLng = lng;
    locLat = lat;
    [setLocationButton setTitle:locTitle forState:UIControlStateNormal];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)locationButtonClicked:(id)sender
{
    isLoaction = YES;
    isNewAddCat = NO;
    if([ApplicationPreference isProUpgradePurchaseDone])
    {
        [noteField resignFirstResponder];
        [categoryField resignFirstResponder];
        
        MapKitDisplayViewController *ob=[[MapKitDisplayViewController alloc] init];
        ob.locObj = self;
        
        [self.navigationController pushViewController:ob animated:YES];
    }
    else
    {
        [loadingAlert show];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPurchaseNow) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[InAppPurchaseManager getInstance] loadStore];
    }
}

-(NSString *)savePhotoToDocumentFolder
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults valueForKey:@"iPhonePhotoSwitch"];
    if ([str isEqualToString:@"set"])
    {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory1 = [NSString stringWithFormat:@"%@",[paths1 objectAtIndex:0]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM-dd-yyyy HH:mm:ss";
    NSString *datestr = [df stringFromDate:[NSDate date]];
    NSString *PhotoDesc = [NSString stringWithFormat:@"%@%@%@.png", documentsDirectory1, @"/" ,datestr];
    
    NSData *imageData = UIImagePNGRepresentation(img);
    [imageData writeToFile:PhotoDesc atomically:NO];
    
    return PhotoDesc;
}

#pragma mark database methods
-(void)insertInCategoryTable:(NSString *)name
{

}

-(void)insertInDescriptionTable:(NSString *)name:(NSString *)note
{
    // insert data into Description table 
}

-(void)submitButtonPressed:(id)sender
{
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(isCategoryPickerChanged)
    {
        appDelegate.globalCategoryIndex = tempGlobalIndex;
    }
    
    if (appDelegate.globalCategoryIndex < 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Select the category" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
//        [activityView startAnimating];
//        [loadingView show];
    
        CategoryDescriptionDB *ob = [[CategoryDescriptionDB alloc] init];
        if (!noteField.text)
        {
            ob.notes = @"";
        }
        else
        {
           ob.notes = noteField.text;
        }
    
        if (locTitle)
        {
            ob.location = locTitle;
            ob.latitute = locLat;
            ob.longitute = locLng;
        }
        else
        {
            ob.location = @"";
            ob.latitute = 0.0f;
            ob.longitute = 0.0f;
        }
        
        ob.PhotoRef = [self savePhotoToDocumentFolder];
        ob.name = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
        
        [[DataBaseManager getInstance] insertCatDescription:ob];
        
        imgView.image = [UIImage imageWithContentsOfFile:ob.PhotoRef];
        
        WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        
        
        if ([ApplicationPreference dropboxEnabled])
        {
            NSString *fileName = [ob.PhotoRef lastPathComponent];
            
            DBPath *folderPath = [[DBPath root] childPath:[categoryArray objectAtIndex:appDelegate.globalCategoryIndex]];
            
//            DBPath *textFilePath = [[folderPath childPath:@"Info"] childPath:[NSString stringWithFormat:@"%@.txt", fileName]];
//            DBFile *textFile = [[DBFilesystem sharedFilesystem] createFile:textFilePath error:nil];
//            if (textFile)
//            {
//                [textFile writeString:[NSString stringWithFormat:@"%f\n%f\n%@\n%@\n", ob.latitute, ob.latitute, ob.location, ob.notes] error:nil];
//            }
            
            DBPath *imageFilePath = [folderPath childPath:fileName];
            DBFile *imageFile = [[DBFilesystem sharedFilesystem] createFile:imageFilePath error:nil];
        
            if (imageFile)
            {
                [imageFile writeData:UIImagePNGRepresentation(img) error:nil];
            }
        }
        else if([[DataBaseManager getInstance] returnCount] == 3 || ([[DataBaseManager getInstance] returnCount] % 9 == 0))
        {
            [ApplicationPreference setDropboxAlertAlreadyShown:NO];
        }
        
        UINavigationController *navController = self.navigationController;
        
        [navController popToRootViewControllerAnimated:NO];
        
        HomeScreenController *homeVC = [[HomeScreenController alloc] initWithNibName:@"HomeScreenController" bundle:nil];
        [navController pushViewController:homeVC animated:NO];
        
        SubcatDescriptionController *listVC = [[SubcatDescriptionController alloc] initWithNibName:@"SubcatDescriptionController" bundle:nil];
        [navController pushViewController:listVC animated:NO];
        
        DisplayImageController *imageVC = [[DisplayImageController alloc] initWithNibName:@"DisplayImageController" bundle:nil];
        imageVC.currentIndex = 0;
        [navController pushViewController:imageVC animated:YES];
    }
}

-(IBAction)addNewCatButtonPressed:(id)sender
{
    isNewAddCat = YES;
    isLoaction = NO;
    if([ApplicationPreference isProUpgradePurchaseDone])
    {
        catNameTextField = [[UITextField alloc] init];
        catNameTextField.frame = CGRectMake(12.0, 45.0, 260.0, 25.0);
        catNameTextField.backgroundColor = [UIColor whiteColor];
        catNameTextField.returnKeyType = UIReturnKeyDone;
        
        newCatAddAlert = [[UIAlertView alloc]initWithTitle:@"Name the new category" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        
        float systemVer = [[UIDevice currentDevice] systemVersion].floatValue;
        if(systemVer >= 7.0)
        {
            newCatAddAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        }
        else
        {
            [newCatAddAlert addSubview:catNameTextField];
        }
        
        [newCatAddAlert show];
    }
    else
    {
        [loadingAlert show];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPurchaseNow) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[InAppPurchaseManager getInstance] loadStore];
    }
}

#pragma mark -
#pragma mark - InAppPurchase Methods

-(void)canPurchaseNow
{
    NSLog(@"4");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    if ([[InAppPurchaseManager getInstance] canMakePurchases])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        purchaseAlert = [[UIAlertView alloc] initWithTitle:@"Upgrade to FamilyPhoto Plus?" message:nil delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Upgrade Now", @"Restore Purchases", nil];
        [purchaseAlert show];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Failed" message:@"Cannot connection to appstore. Try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == purchaseAlert)
    {
        if (buttonIndex == 1)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
            
            [[InAppPurchaseManager getInstance] purchaseProUpgrade];
            
            [loadingAlert show];
        }
        
        if(buttonIndex == 2)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreFailed) name:kInAppPurchaseManagerInvalidRestoreNotification object:nil];
            
            [[InAppPurchaseManager getInstance] checkPurchasedItems];
            
            [loadingAlert show];
        }
        
        if(buttonIndex == 0)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //[dropboxSwitch setOn:NO animated:YES];
        }
    }
}

-(void)transactionCancelled
{
    NSLog(@"Transaction cancelled...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    //[dropboxSwitch setOn:NO animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)paymentFailed
{
    NSLog(@"Payment failed...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    //[dropboxSwitch setOn:NO animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Failed" message:@"Payment failed. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)restoreFailed
{
    NSLog(@"Restore failed...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    //[dropboxSwitch setOn:NO animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Failed" message:@"Failed to restore. Please try later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)paymentSucceeded
{
    NSLog(@"Payment succeeded...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    [ApplicationPreference setProUpgradePurchaseDone:YES];
    
    if(isNewAddCat)
    {
        isNewAddCat = !isNewAddCat;
        catNameTextField = [[UITextField alloc] init];
        catNameTextField.frame = CGRectMake(12.0, 45.0, 260.0, 25.0);
        catNameTextField.backgroundColor = [UIColor whiteColor];
        catNameTextField.returnKeyType = UIReturnKeyDone;
        
        newCatAddAlert = [[UIAlertView alloc]initWithTitle:@"Name the new category" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        
        float systemVer = [[UIDevice currentDevice] systemVersion].floatValue;
        if(systemVer >= 7.0)
        {
            newCatAddAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        }
        else
        {
            [newCatAddAlert addSubview:catNameTextField];
        }
        [newCatAddAlert show];
    }
    else if (isLoaction)
    {
        isLoaction = !isLoaction;
        [noteField resignFirstResponder];
        [categoryField resignFirstResponder];
        
        MapKitDisplayViewController *ob=[[MapKitDisplayViewController alloc] init];
        ob.locObj = self;
        
        [self.navigationController pushViewController:ob animated:YES];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (textField == categoryField)
    {
        if (appDelegate.globalCategoryIndex < 0)
        {
            if (categoryArray.count > 0)
            {
                appDelegate.globalCategoryIndex = 0;
                categoryField.text = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
                [categoryPickerView selectRow:appDelegate.globalCategoryIndex inComponent:0 animated:NO];
            }
        }
        else
        {
            categoryField.text = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
            [categoryPickerView selectRow:appDelegate.globalCategoryIndex inComponent:0 animated:NO];
        }
    }
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = (up ? self.view.frame.origin.y : 0) + baseView.frame.origin.y + textField.frame.origin.y + textField.frame.size.height;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = 264 - self.view.frame.size.height + moveUpValue + 50;
        }
        else
        {
            animatedDistance = 352 - self.view.frame.size.height + moveUpValue + 50;
        }
    }
    else
    {
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = 216 - self.view.frame.size.height + moveUpValue + 50;
        }
        else
        {
            animatedDistance = 162 - self.view.frame.size.height + moveUpValue + 50;
        }
    }
    
    if(animatedDistance > 0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f; 
        int movement = 0;
        float systemVers = [[UIDevice currentDevice] systemVersion].floatValue;
        if(systemVers >= 7.0)
        {
            movement = (up ? -movementDistance : movementDistance + 64);
        }
        else
        {
            movement = (up ? -movementDistance : movementDistance);
        }
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);       
        [UIView commitAnimations];
    }
}

#pragma mark alertview delegate methods

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alert == newCatAddAlert)
    {
        float systemVer = [[UIDevice currentDevice] systemVersion].floatValue;
        if(systemVer >= 7.0)
        {
            catNameTextField = [newCatAddAlert textFieldAtIndex:0];
        }
        
        if (buttonIndex == 1)
        {
            if(catNameTextField.text == nil || [catNameTextField.text isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter category name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                return;
            }
            
            [[DataBaseManager getInstance] insertCatName:catNameTextField.text];
            
            WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
            //        [appDelegate uploadDataToDropbox];
            
            categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
            
//            [categoryArray sortUsingSelector:@selector(compare:)];
            [categoryPickerView reloadAllComponents];
            categoryField.text = catNameTextField.text;
            
            for (int i = 0; i < categoryArray.count; i++)
            {
                if ([[categoryArray objectAtIndex:i] isEqualToString:catNameTextField.text])
                {
                    appDelegate.globalCategoryIndex = i;
                    break;
                }
            }
            
            NSString *categoryName = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
            
            DBPath *folderPath = [[DBPath root] childPath:categoryName];
            [[DBFilesystem sharedFilesystem] createFolder:folderPath error:nil];
            
            //        DBPath *infoFolderPath = [folderPath childPath:@"Info"];
            //        [[DBFilesystem sharedFilesystem] createFolder:infoFolderPath error:nil];
        }

    }
}

#pragma mark - tableview delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return categoryArray.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [categoryArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    categoryField.text = [categoryArray objectAtIndex:row];
//    appDelegate.globalCategoryIndex = row;
    isCategoryPickerChanged = YES;
    tempGlobalIndex = row;
}

-(IBAction)backgroundTap:(id)sender
{
    [categoryField resignFirstResponder];
    [noteField resignFirstResponder];
}

@end
