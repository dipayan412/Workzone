//
//  EditViewController.m
//  RenoMate
//
//  Created by yogesh ahlawat on 01/06/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//




#import "EditViewController.h"
#import "CategoryDescriptionDB.h"
#import "DataBaseManager.h"
#import "HomeScreenController.h"
#import "DisplayImageController.h"
#import "WhosinAppDelegate.h"
#import "ApplicationPreference.h"
#import "UINavigationController+Operations.h"
#import "InAppPurchaseManager.h"

@implementation EditViewController
{
    BOOL isCategoryPickerChanged;
    int tempGlobalIndex;
    
    float systemVer;
}

static sqlite3 *database;

@synthesize img;
@synthesize mode;
@synthesize selectedCatString;
@synthesize notesString;
@synthesize photoID;
@synthesize btn;
@synthesize locTitle;
@synthesize locLng;
@synthesize locLat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    imgView.image = [UIImage imageWithContentsOfFile:photoID];
    categoryField.text = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
    
    [categoryPickerView selectRow:appDelegate.globalCategoryIndex inComponent:0 animated:NO];
    
    noteField.text = notesString;
    
    if(locTitle == nil || [locTitle isEqualToString:@""] || [locTitle isEqualToString:@"(null)"])
    {
        [setLocationButton setTitle:@"Set Location" forState:UIControlStateNormal];
    }
    else
    {
        [setLocationButton setTitle:locTitle forState:UIControlStateNormal];
    }
    
    [self resizeElements];
    
    if([[UIDevice currentDevice] systemVersion].floatValue >= 7.0)
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit";

//    [baseView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
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
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Connecting to Appstore" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
//    categoryField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow.png"]];
//    categoryField.rightViewMode = UITextFieldViewModeAlways;
    
    systemVer = [[UIDevice currentDevice] systemVersion].floatValue;
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
-(IBAction)locationButtonClicked:(id)sender
{
    isLocBtn = YES;
    isCatBtn = NO;
    
    if([ApplicationPreference isProUpgradePurchaseDone])
    {
        
        [noteField resignFirstResponder];
        [categoryField resignFirstResponder];
        
        MapKitDisplayViewController *ob = [[MapKitDisplayViewController alloc] init];
        ob.locObj = self;
        
        ob.locTitle=locTitle;
        //    ob.loc = locLat;
        //    ob.longitude1=locLng;
        ob.mode=@"edit";
        
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

-(void)sendLocationDetails:(NSString *)title:(double)lng:(double)lat
{
    self.locTitle = title;
    locLng = lng;
    locLat = lat;
    [setLocationButton setTitle:title forState:UIControlStateNormal];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)savePhotoToDocumentFolder
{
    // store photo to document folder
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory1 = [NSString stringWithFormat:@"%@",[paths1 objectAtIndex:0]];
    
    NSLog(@"documentsDirectory1111 = %@",documentsDirectory1);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM-dd-yyyy HH:mm:ss";
    NSString *datestr = [df stringFromDate:[NSDate date]];
    
    
    NSString *PhotoDesc = [NSString stringWithFormat:@"%@%@%@.png", documentsDirectory1,@"/" ,datestr];
    NSLog(@"Location of photo reference======%@", PhotoDesc);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str=[defaults valueForKey:@"iPhonePhotoSwitch"];
    if ([str isEqualToString:@"set"]) {
        
        
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    
//    NSData *imageData = UIImagePNGRepresentation(img);
    
//    NSLog(@"%@",img);
//    BOOL response =[imageData writeToFile:PhotoDesc atomically:NO]; 
    //  BOOL response =[UIImagePNGRepresentation(img) writeToFile:PhotoDesc atomically:YES];
    
    // NSLog(@"file save result %@",response);
    return PhotoDesc;
    
    
}

#pragma mark database methods

-(void)insertInCategoryTable:(NSString *)name
{
    // insert data into Category table
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
    NSLog(@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]);
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        
//        NSString *myQuery;
        
        //        
        //        myQuery=[[NSString alloc]initWithFormat:@"insert into userSetting values ('%@','%@','%@','%@','%@');",userNameTextField.text,passwordTextField.text,IPAddressTextField.text,portTextField.text,userIDTextField.text];
        //        NSLog(@"url ==%@",myQuery);
        //        sqlite3_exec(database, [myQuery UTF8String], nil, nil, nil);
        //        
        //        
        //        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Sucess" message:@"database updated" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil,nil];
        //        [myAlertView show];
        //        [myAlertView release];
    }
    
 //   [self displayViewAnimated];
    
}

-(void)insertInDescriptionTable:(NSString *)name:(NSString *)note
{
    // insert data into Description table 
}

-(void)craetePhotoFile
{   
//    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory1 = [NSString stringWithFormat:@"%@",[paths1 objectAtIndex:0]];
//    NSString *datestr=[NSDate date];
//    NSString *PhotoDesc = [NSString stringWithFormat:@"%@%@%@.png", documentsDirectory1,@"/" ,datestr];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str=[defaults valueForKey:@"iPhonePhotoSwitch"];
    if ([str isEqualToString:@"set"])
    {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    
//    NSData *imageData = UIImagePNGRepresentation(img);
//    BOOL response =[imageData writeToFile:PhotoDesc atomically:NO]; 
    
//    NSLog(@"%@",img);
    //   BOOL response =[imageData writeToFile:PhotoDesc atomically:NO]; 
    //  BOOL response =[UIImagePNGRepresentation(img) writeToFile:PhotoDesc atomically:YES];
    
    // NSLog(@"file save result %@",response);
    //  return PhotoDesc;
    
}

-(void)submitButtonPressed:(id)sender
{
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.globalCategoryIndex < 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Slect the category" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if(isCategoryPickerChanged)
        {
            appDelegate.globalCategoryIndex = tempGlobalIndex;
        }
        CategoryDescriptionDB *ob = [[CategoryDescriptionDB alloc] init];
        ob.notes = noteField.text; 
        ob.location = locTitle;
        ob.PhotoRef = photoID;
        ob.latitute = locLat;
        ob.longitute = locLng;
        ob.name = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];

        DataBaseManager *manager = [[DataBaseManager alloc] init];
        [manager updateInfo:ob];
        
        if ([ApplicationPreference dropboxEnabled])
        {
            NSString *fileName = [ob.PhotoRef lastPathComponent];
            
            DBPath *folderPath = [[DBPath root] childPath:[categoryArray objectAtIndex:appDelegate.globalCategoryIndex]];
            
//            DBPath *textFilePath = [[folderPath childPath:@"Info"] childPath:[NSString stringWithFormat:@"%@.txt", fileName]];
            
//            [[DBFilesystem sharedFilesystem] deletePath:textFilePath error:nil];
            
//            DBFile *textFile = [[DBFilesystem sharedFilesystem] createFile:textFilePath error:nil];
//            if (textFile)
//            {
//                [textFile writeString:[NSString stringWithFormat:@"%f\n%f\n%@\n%@\n", ob.latitute, ob.latitute, ob.location, ob.notes] error:nil];
//            }
            
            DBPath *imageFilePath = [folderPath childPath:fileName];
            
            [[DBFilesystem sharedFilesystem] deletePath:imageFilePath error:nil];
            
            DBFile *imageFile = [[DBFilesystem sharedFilesystem] createFile:imageFilePath error:nil];
            if (imageFile)
            {
                [imageFile writeData:UIImagePNGRepresentation(img) error:nil];
            }
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)addNewCatButtonPressed:(id)sender
{
    isCatBtn = YES;
    isLocBtn = NO;
    
    if([ApplicationPreference isProUpgradePurchaseDone])
    {
        catNameTextField = [[UITextField alloc] init];
        catNameTextField.frame = CGRectMake(12.0, 45.0, 260.0, 25.0);
        catNameTextField.backgroundColor = [UIColor whiteColor];
        catNameTextField.returnKeyType = UIReturnKeyDone;
        
        newCatAddAlert = [[UIAlertView alloc]initWithTitle:@"Name the new category" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        
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
        
        purchaseAlert = [[UIAlertView alloc] initWithTitle:@"Upgrade to RenoMate Plus?" message:nil delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Upgrade Now", @"Restore Purchases", nil];
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
    if(isCatBtn)
    {
        catNameTextField = [[UITextField alloc] init];
        catNameTextField.frame = CGRectMake(12.0, 45.0, 260.0, 25.0);
        catNameTextField.backgroundColor = [UIColor whiteColor];
        catNameTextField.returnKeyType = UIReturnKeyDone;
        
        newCatAddAlert = [[UIAlertView alloc]initWithTitle:@"Name the new category" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        
        if(systemVer >= 7.0)
        {
            newCatAddAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        }
        else
        {
            [newCatAddAlert addSubview:catNameTextField];
        }
        [newCatAddAlert show];
        isCatBtn = !isCatBtn;
    }
    else if(isLocBtn)
    {
        isLocBtn = !isLocBtn;
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
        WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (buttonIndex == 1)
        {
            if(systemVer >= 7.0)
            {
                catNameTextField = [newCatAddAlert textFieldAtIndex:0];
            }
            
            if(catNameTextField.text == nil || [catNameTextField.text isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter category name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                return;
            }
            
            [[DataBaseManager getInstance] insertCatName:catNameTextField.text];
            
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
        }
        
        NSString *categoryName = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
        
        DBPath *folderPath = [[DBPath root] childPath:categoryName];
        [[DBFilesystem sharedFilesystem] createFolder:folderPath error:nil];
        
        //    DBPath *infoFolderPath = [folderPath childPath:@"Info"];
        //    [[DBFilesystem sharedFilesystem] createFolder:infoFolderPath error:nil];
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
    categoryField.text = [categoryArray objectAtIndex:row];
    
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
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




