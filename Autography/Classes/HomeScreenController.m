//
//  HomeScreenController.m
//  RenoMate
//
//  Created by yogesh ahlawat on 08/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import "HomeScreenController.h"
#import "AddDetailViewController.h"
#import "DataBaseManager.h"
#import "SubcatDescriptionController.h"
#import "SettingController.h"
#import "WhosinAppDelegate.h"
#import "ApplicationPreference.h"
#import "UINavigationController+Operations.h"
#import "InAppPurchaseManager.h"

@implementation HomeScreenController
{
    BOOL isKeyboardOpen;
}

@synthesize categoryArray;
@synthesize image;
@synthesize catNameTextField;
@synthesize popOver;

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Categories";
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonPressed:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:cameraButton, self.editButtonItem, nil];
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:(66.0f/255.0f) green:(66.0f/255.0f) blue:(66.0f/255.0f) alpha:1.0f]];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:(61.0f/255.0f) green:(121.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f]];
    
    UIButton *buttonS = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [buttonS setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [buttonS addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(settingButtonClicked:)];
    if([[UIDevice currentDevice] systemVersion].floatValue >= 7.0)
    {
        settingsButton.tintColor = [UIColor colorWithRed:(61.0f/255.0f) green:(121.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f];
    }
    else
    {
        settingsButton.tintColor = [UIColor lightGrayColor];
    }
    
    UIButton *buttonU = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [buttonU setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
    [buttonU addTarget:self action:@selector(uploadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    uploadButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadButtonClicked:)];
    uploadButton.tintColor = [UIColor colorWithRed:(61.0f/255.0f) green:(121.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f];
    
    seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 2, 170, 42)];
    seachBar.delegate = self;
    seachBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [seachBar setBackgroundColor:[UIColor clearColor]];
    
    searchItem = [[UIBarButtonItem alloc] initWithCustomView:seachBar];
    
    fSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    fSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    bottomToolBar.items = [NSArray arrayWithObjects:settingsButton, fSpace1, searchItem, fSpace2, uploadButton, nil];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Connecting to Appstore" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOpen) name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardOpen
{
    isKeyboardOpen = YES;
}

-(void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(85.0f/255.0f) green:(85.0f/255.0f) blue:(85.0f/255.0f) alpha:1.0f]];
    
    categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    
    [categoryTable reloadData];
    
    CALayer* mask = [[CALayer alloc] init];
    [mask setBackgroundColor: [UIColor blackColor].CGColor];
    [mask setFrame: CGRectMake(0.0f, 0.0f, seachBar.frame.size.width, seachBar.frame.size.height)];
    [mask setCornerRadius: 14.0f];
    [seachBar.layer setMask: mask];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [seachBar resignFirstResponder];
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

#pragma mark tableview Delegate methods


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (editingStyle == UITableViewCellEditingStyleDelete)
      {
          NSString *categoryName = [categoryArray objectAtIndex:indexPath.row];
          
          if ([ApplicationPreference dropboxEnabled])
          {
              DBPath *folderPath = [[DBPath root] childPath:categoryName];
              [[DBFilesystem sharedFilesystem] deletePath:folderPath error:nil];
          }
          
          [[DataBaseManager getInstance] removeCat:categoryName];
          
          categoryArray = [[[DataBaseManager getInstance] getCatagoryNames] mutableCopy];
          [categoryTable reloadData];
      }
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
        UIButton *cellAccesaryButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 0, 31, 24)];
        [cellAccesaryButton setImage:[UIImage imageNamed:@"arrow-1.png"] forState:UIControlStateNormal];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    
    int i = [[DataBaseManager getInstance] returnCountByCat:[categoryArray objectAtIndex:indexPath.row]];
    cell.textLabel.text = [[NSString alloc]initWithFormat:@"%@ (%d)",[categoryArray objectAtIndex:indexPath.row],i];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isKeyboardOpen)
    {
        [seachBar resignFirstResponder];
        isKeyboardOpen = NO;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    NSString *categoryName = [categoryArray objectAtIndex:indexPath.row];
    NSArray *allCat = [[[DataBaseManager getInstance] getCatagoryNames] mutableCopy];
    int index = -1;
    for (int i = 0; i < allCat.count; i++)
    {
        NSString *cat = [allCat objectAtIndex:i];
        if ([cat isEqualToString:categoryName])
        {
            index = i;
            break;
        }
    }
    
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.globalCategoryIndex = index;
    
    SubcatDescriptionController *ob = [[SubcatDescriptionController alloc] initWithNibName:@"SubcatDescriptionController" bundle:nil];
    [self.navigationController pushViewController:ob animated:YES];
}


#pragma mark added methods

-(void)uploadButtonClicked:(id)sender
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        
        [self presentModalViewController:imagePicker animated:YES];
    }
    else
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.popOver setDelegate:self];
        
        [self.popOver setPopoverContentSize:CGSizeMake(320, 600) animated:NO];
        
        CGRect r = CGRectMake(220,160,320,600);
        [self.popOver presentPopoverFromRect:r inView:self.view permittedArrowDirections:0 animated:YES];
    }
}

-(void)settingButtonClicked:(id)sender
{
    SettingController *ob = [[SettingController alloc] initWithNibName:@"SettingController" bundle:nil];
    [self.navigationController pushViewController:ob animated:YES];
}

-(void)displayViewAnimated

{
    AddDetailViewController *obj=[[AddDetailViewController alloc] initWithNibName:@"AddDetailViewController" bundle:nil withImage:self.image];

    [self.navigationController pushViewController:obj animated:YES];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: animated];

    [categoryTable setEditing:editing animated:animated];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    if (editing)
    {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCategory:)];  
    }
    else
    {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonPressed:)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:(61.0f/255.0f) green:(121.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f]];
    }
}

-(void)cameraButtonPressed:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
	imagePicker.delegate = self;
	imagePicker.allowsEditing = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        [self presentModalViewController:imagePicker animated:YES];
    }
    else
    {
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.popOver setDelegate:self];
        
        [self.popOver setPopoverContentSize:CGSizeMake(320, 600) animated:NO];
        
        CGRect r = CGRectMake(220,160,320,600);
        [self.popOver presentPopoverFromRect:r inView:self.view permittedArrowDirections:0 animated:YES];
    }
}

-(void)addCategory:(id)sender
{
    // Adding category through alertview
    
    if([ApplicationPreference isProUpgradePurchaseDone])
    {
        catNameTextField = [[UITextField alloc] init];
        catNameTextField.frame = CGRectMake(12.0, 45.0, 260.0, 25.0);
        catNameTextField.backgroundColor = [UIColor whiteColor];
        catNameTextField.returnKeyType = UIReturnKeyDone;
        
        newCatAddAlert = [[UIAlertView alloc]initWithTitle:@"Name the new category" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        
        NSString *systemVer = [[UIDevice currentDevice] systemVersion];
        if(systemVer.floatValue >= 7.0)
        {
            newCatAddAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        }
        else
        {
            [newCatAddAlert addSubview:catNameTextField];
        }

        [newCatAddAlert show];
        // [newCatAddAlert release];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    if ([[InAppPurchaseManager getInstance] canMakePurchases])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        purchaseAlert = [[UIAlertView alloc] initWithTitle:@"Upgrade to Autography Plus?" message:nil delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Upgrade Now", @"Restore Purchases", nil];
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
            //[dropboxSwitch setOn:NO animated:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    catNameTextField = [[UITextField alloc] init];
    catNameTextField.frame = CGRectMake(12.0, 45.0, 260.0, 25.0);
    catNameTextField.backgroundColor = [UIColor whiteColor];
    catNameTextField.returnKeyType = UIReturnKeyDone;
    
    newCatAddAlert = [[UIAlertView alloc]initWithTitle:@"Name the new category" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    
    NSString *systemVer = [[UIDevice currentDevice] systemVersion];
    if(systemVer.floatValue >= 7.0)
    {
        newCatAddAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    else
    {
        [newCatAddAlert addSubview:catNameTextField];
    }
    [newCatAddAlert show];
    // [newCatAddAlert release];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

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
    
    bitmap = CGBitmapContextCreate(NULL, img.size.height, img.size.width, CGImageGetBitsPerComponent(imageRef), 4 * img.size.height, colorSpaceInfo, alphaInfo);
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

#pragma mark UIImagePicker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self dismissModalViewControllerAnimated:NO];
    }
    else
    {
        [self.popOver dismissPopoverAnimated:YES];
    }
    
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if ([info objectForKey:@"UIImagePickerControllerMediaMetadata"])
    {
        int state = [[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"Orientation"] intValue];
        NSLog(@"State = %d", state);
        switch (state)
        {
            case 3:
                //Rotate image to the left twice.
                img = [UIImage imageWithCGImage:[img CGImage]];  //Strip off that pesky meta data!
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

//	self.image = img;
    self.image = [ApplicationPreference imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
    
    [self displayViewAnimated];    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // cancel button got clicked on UIimagepicker
   
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self dismissModalViewControllerAnimated:NO];
    }
    else
    {
        [self.popOver dismissPopoverAnimated:YES];
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
	// Unable to save the image  
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
	else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    
    
    [alert show];
  //  [alert release];
}


#pragma mark alertview delegate 

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alert == newCatAddAlert)
    {
        if (buttonIndex == 1)
        {
            NSString *systemVer = [[UIDevice currentDevice] systemVersion];
            if(systemVer.floatValue >= 7.0f)
            {
                catNameTextField = [newCatAddAlert textFieldAtIndex:0];
            }
            
            if(catNameTextField.text == nil || [catNameTextField.text isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter category name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                return;
            }
            
            NSString *catName = catNameTextField.text;
            [[DataBaseManager getInstance] insertCatName:catName];
            
            categoryArray = [[DataBaseManager getInstance] getCatagoryNames] ;
            
            [categoryTable reloadData];
        }
    }
}

#pragma mark search bar delegate 

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        seachBar.frame = CGRectMake(0, 2, 270, 42);
        
        CALayer* mask = [[CALayer alloc] init];
        [mask setBackgroundColor: [UIColor blackColor].CGColor];
        [mask setFrame: CGRectMake(0.0f, 0.0f, seachBar.frame.size.width, seachBar.frame.size.height)];
        [mask setCornerRadius: 14.0f];
        [seachBar.layer setMask: mask];
    }
    
    bottomToolBar.items = [NSArray arrayWithObjects:fSpace1, searchItem, fSpace2, nil];
    seachBar.showsCancelButton = YES;
    [self animateTextField:searchBar up:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        seachBar.frame = CGRectMake(0, 2, 170, 42);
        
        CALayer* mask = [[CALayer alloc] init];
        [mask setBackgroundColor: [UIColor blackColor].CGColor];
        [mask setFrame: CGRectMake(0.0f, 0.0f, seachBar.frame.size.width, seachBar.frame.size.height)];
        [mask setCornerRadius: 14.0f];
        [seachBar.layer setMask: mask];
    }
    
    bottomToolBar.items = [NSArray arrayWithObjects:settingsButton, fSpace1, searchItem, fSpace2, uploadButton, nil];
    seachBar.showsCancelButton = NO;
    [self animateTextField:searchBar up:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text isEqualToString:@""])
    {
        categoryArray = [[[DataBaseManager getInstance] getCatagoryNames] mutableCopy];
    }
    else
    {
        categoryArray = [[[DataBaseManager getInstance] getMatchingCat:searchBar.text] mutableCopy];
    }
    [categoryTable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [seachBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [seachBar resignFirstResponder];
}
     
- (void) animateTextField: (UISearchBar*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = self.view.frame.size.height - 49;
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
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        
        categoryTable.frame = CGRectMake(0, up ? movementDistance : 0, categoryTable.frame.size.width, categoryTable.frame.size.height + movement);
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);       
        
        [UIView commitAnimations];
    }
}

@end
