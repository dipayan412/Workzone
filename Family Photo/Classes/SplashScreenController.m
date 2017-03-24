//
//  SplashScreenController.m
//  Whosin
//
//  Created by Kumar Aditya on 09/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import "SplashScreenController.h"
#import "HomeScreenController.h"
#import "AddDetailViewController.h"
#import "WhosinAppDelegate.h"
#import "ApplicationPreference.h"
#import "DataBaseManager.h"
#import "UINavigationController+Operations.h"
#import "InAppPurchaseManager.h"

@interface SplashScreenController()
{
    BOOL isDropBoxAlertAlreadyShown;
}
@end

@implementation SplashScreenController

@synthesize popOver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization.
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home";
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Connecting with Appstore..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    if ([ApplicationPreference launchCount] == 2 && ![ApplicationPreference dropboxEnabled])
    {
        isDropBoxAlertAlreadyShown = !isDropBoxAlertAlreadyShown;
        dropboxAlert = [[UIAlertView alloc] initWithTitle:@"Dropbox"
                                                  message:@"You can share your files among your devices"
                                                 delegate:self
                                        cancelButtonTitle:@"Not Now"
                                        otherButtonTitles:@"Dropbox Login", nil];
        [dropboxAlert show];
        
        NSLog(@"Launch Count %d", [ApplicationPreference launchCount]);
        return;
    }
    
    if ([ApplicationPreference launchCount] % 3 == 0)
    {
        if (![ApplicationPreference isRatingOfferDisabled])
        {
            ratingAlert = [[UIAlertView alloc] initWithTitle:@"Rate/Feedback"
                                                     message:@"Would you like to rate Family Photo?"
                                                    delegate:self
                                           cancelButtonTitle:@"Never Remind"
                                           otherButtonTitles:@"Rate Now", @"Remind Later", nil];
            [ratingAlert show];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    cameraButton.backgroundColor = [UIColor redColor];
//    libraryButton.backgroundColor = [UIColor greenColor];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if(!stylePerformed)
    {
        stylePerformed = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            cameraButton.frame = CGRectMake(161, 756, 452, 78);
            libraryButton.frame = CGRectMake(161, 860, 452, 78);
            
            bgImageView.image = [UIImage imageNamed:@"splash-1004.png"];
        }
        else
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568) // iPhone 5 or iPod 5th Gen
            {
                cameraButton.frame = CGRectMake(48, 415, 226, 39);
                libraryButton.frame = CGRectMake(48, 466, 226, 38);
                
                bgImageView.image = [UIImage imageNamed:@"splash-568h@2x.png"];
            }
            else
            {
                bgImageView.image = [UIImage imageNamed:@"splash.png"];
            }
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [UIScreen mainScreen].scale > 1)
        {
            cameraButton.frame = CGRectMake(169, 732, 442, 77);
            libraryButton.frame = CGRectMake(169, 831, 442, 77);
            
            bgImageView.image = [UIImage imageNamed:@"splash-1004@2x.png"];
        }
    }
    //cameraButton.backgroundColor = libraryButton.backgroundColor = [UIColor redColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == dropboxAlert)
    {
        if (buttonIndex == 1)
        {
            if ([ApplicationPreference isProUpgradePurchaseDone])
            {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxDidLogin) name:kDropboxDidLoginNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxFailedLogin) name:kDropboxFailedLoginNotification object:nil];
                [[DBAccountManager sharedManager] linkFromController:self];
            }
            else
            {
                [loadingAlert show];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPurchaseNow) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [[InAppPurchaseManager getInstance] loadStore];
            }
        }
        else
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }
    else if (alertView == ratingAlert)
    {
        if (buttonIndex == 0)
        {
            [ApplicationPreference setRatingOfferDisabled:YES];
        }
        else if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.itunes.apple.com/us/app/family-photo/id654973391?ls=1&mt=8"]];
            [ApplicationPreference setRatingOfferDisabled:YES];
        }
    }
    else if (alertView == loadingAlert)
    {
        
    }
    else
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
    }
}

-(void)canPurchaseNow
{
    NSLog(@"4");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    if ([[InAppPurchaseManager getInstance] canMakePurchases])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade to FamilyPhoto Plus?" message:nil delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Upgrade Now", @"Restore Purchases", nil];
        [alert show];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Failed" message:@"Cannot connection to appstore. Try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)transactionCancelled
{
    NSLog(@"Transaction cancelled...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)paymentFailed
{
    NSLog(@"Payment failed...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxDidLogin) name:kDropboxDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxFailedLogin) name:kDropboxFailedLoginNotification object:nil];
    [[DBAccountManager sharedManager] linkFromController:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)dropboxDidLogin
{
//    DBPath *dbFilePath = [[DBPath root] childPath:@"Renomate.txt"];
//    [[DBFilesystem sharedFilesystem] deletePath:dbFilePath error:nil];
//    
//    DBFile *dbFile = [[DBFilesystem sharedFilesystem] createFile:dbFilePath error:nil];
    
    NSArray *categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    
    for (int i = 0; i < categoryArray.count; i++)
    {
        NSString *categoryName = [categoryArray objectAtIndex:i];
        
        DBPath *folderPath = [[DBPath root] childPath:categoryName];
        BOOL success = [[DBFilesystem sharedFilesystem] createFolder:folderPath error:nil];
        
//        DBPath *infoFolderPath = [folderPath childPath:@"Info"];
//        [[DBFilesystem sharedFilesystem] createFolder:infoFolderPath error:nil];
        
        if (success)
        {
            NSArray *subCatArray = [[DataBaseManager getInstance] getSubCat:categoryName];
            for (int j = 0; j < subCatArray.count; j++)
            {
                CategoryDescriptionDB *subCat = [subCatArray objectAtIndex:j];
                
                NSString *fileName = [subCat.PhotoRef lastPathComponent];
                
//                DBPath *textFilePath = [infoFolderPath childPath:[NSString stringWithFormat:@"%@.txt", fileName]];
//                DBFile *textFile = [[DBFilesystem sharedFilesystem] createFile:textFilePath error:nil];
                
//                if (textFile)
//                {
//                    [textFile writeString:[NSString stringWithFormat:@"%f\n%f\n%@\n%@\n", subCat.latitute, subCat.latitute, subCat.location, subCat.notes] error:nil];
//                }
                
                DBPath *imageFilePath = [folderPath childPath:fileName];
                DBFile *imageFile = [[DBFilesystem sharedFilesystem] createFile:imageFilePath error:nil];
                
                UIImage *img = [UIImage imageWithContentsOfFile:subCat.PhotoRef];
                                      
                [imageFile writeData:UIImagePNGRepresentation(img) error:nil];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dropboxFailedLogin
{
}

-(IBAction)photoGalleryClicked:(id)sender
{
    HomeScreenController *ob=[[HomeScreenController alloc] initWithNibName:@"HomeScreenController" bundle:nil];
    [self.navigationController pushViewController:ob animated:YES];
}

-(IBAction)cameraButtonClicked:(id)sender
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

-(UIImage*)rotateImage:(UIImage*)image withRotationType:(int)rotation
{
    CGImageRef imageRef = [image CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (alphaInfo == kCGImageAlphaNone)
    {
        alphaInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    bitmap = CGBitmapContextCreate(NULL, image.size.height, image.size.width, CGImageGetBitsPerComponent(imageRef), 4 * image.size.height, colorSpaceInfo, alphaInfo);
    CGColorSpaceRelease(colorSpaceInfo);
    
    CGContextTranslateCTM (bitmap, (rotation > 0 ? image.size.height : 0), (rotation > 0 ? 0 : image.size.width));
    CGContextRotateCTM (bitmap, rotation * M_PI / 2.0f);
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
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
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self.popOver dismissPopoverAnimated:YES];
    }
    
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
//    if ([info objectForKey:@"UIImagePickerControllerMediaMetadata"])
//    {
//        int state = [[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"Orientation"] intValue];
//        NSLog(@"State = %d", state);
//        switch (state)
//        {
//            case 3:
//                //Rotate image to the left twice.
//                img = [UIImage imageWithCGImage:[img CGImage]];  //Strip off that pesky meta data!
//                img = [self rotateImage:[self rotateImage:img withRotationType:1] withRotationType:1];
//                break;
//                
//            case 6:
//                img = [UIImage imageWithCGImage:[img CGImage]];
//                img = [self rotateImage:img withRotationType:-1];
//                break;
//                
//            case 8:
//                img = [UIImage imageWithCGImage:[img CGImage]];
//                img = [self rotateImage:img withRotationType:1];
//                break;
//                
//            default:
//                break;
//        }
//    }

//    obj.img = img;
    img = [ApplicationPreference imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
    AddDetailViewController *obj = [[AddDetailViewController alloc] initWithNibName:@"AddDetailViewController" bundle:nil WithImage:img];
    
    [self.navigationController pushViewController:obj animated:YES];
    
    NSLog(@"Image size - %f %f ", obj.img.size.width, obj.img.size.height);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self.popOver dismissPopoverAnimated:YES];
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}

@end
