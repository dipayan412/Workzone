//
//  DisplayImageController.m
//  RenoMate
//
//  Created by yogesh ahlawat on 18/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import "DisplayImageController.h"
#import "CategoryDescriptionDB.h"
#import "DataBaseManager.h"
#import "AddDetailViewController.h"
#import "HomeScreenController.h"
#import "EditViewController.h"
#import "WhosinAppDelegate.h"
#import "ApplicationPreference.h"
#import "UINavigationController+Operations.h"
#import "InAppPurchaseManager.h"

@interface DisplayImageController()
{
    BOOL isSharedWithEmailBtnPressed;
    BOOL isTweeterPressed;
    
    BOOL isDropBoxAlertShown;
}
@property (nonatomic,retain) NSMutableArray *infoArray;

@end

@implementation DisplayImageController

@synthesize popOver;
@synthesize infoArray;
@synthesize currentIndex;

#define height_potrait 100
#define height_landscape 200


#pragma mark - View lifecycle

-(BOOL)shouldAutorotate
{
    for (UIView *view in containerScrollView.subviews)
    {
        view.frame = CGRectMake(containerScrollView.frame.size.width * view.tag, 0, containerScrollView.frame.size.width, containerScrollView.frame.size.height);
    }
    
    containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width * infoArray.count, containerScrollView.frame.size.height);
    
    containerScrollView.contentOffset = CGPointMake(containerScrollView.frame.size.width * currentIndex, 0);
    
    CGRect frame = loadingView.frame;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = self.view.bounds.size.height;
    
    busyIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    
    loadingView.frame = frame;
    
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    for (UIView *view in containerScrollView.subviews)
    {
        view.frame = CGRectMake(containerScrollView.frame.size.width * view.tag, 0, containerScrollView.frame.size.width, containerScrollView.frame.size.height);
    }
    
    containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width * infoArray.count, containerScrollView.frame.size.height);
    
    containerScrollView.contentOffset = CGPointMake(containerScrollView.frame.size.width * currentIndex, 0);
    
    CGRect frame = loadingView.frame;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = self.view.bounds.size.height;
    
    busyIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    
    loadingView.frame = frame;
    
    return YES;
}

- (void)viewDidLoad
{  
    [super viewDidLoad];
        
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    activity.backgroundColor = [UIColor clearColor];    
    activity.hidden = YES;
    
    UIBarButtonItem *cameraButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonPressed:)];
    self.navigationItem.rightBarButtonItem = cameraButtonItem;
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.leftBarButtonItem = doneButtonItem;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    
    [containerScrollView addGestureRecognizer:tapRecognizer];
    
//    tipStrip.translucent = YES;
    self.navigationController.navigationBar.translucent = YES;
    bottomToolbar.translucent = YES;
    
    busyIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    busyIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    busyIndicator.backgroundColor = [UIColor clearColor];
    busyIndicator.hidden = NO;
    [busyIndicator startAnimating];
    
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    loadingView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
    [loadingView addSubview:busyIndicator];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Connecting with Appstore..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    containerScrollView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
}

-(void)showBusyScreen:(BOOL)_show
{
    if(_show)
    {
        [self.view addSubview:loadingView];
    }
    else
    {
        [loadingView removeFromSuperview];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1.0f;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.translucent = YES;
    
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSArray *categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    self.infoArray = [[DataBaseManager getInstance] getSubCat:[categoryArray objectAtIndex:appDelegate.globalCategoryIndex]];
    
    self.title = [[NSString alloc] initWithFormat:@"%d of %d", currentIndex + 1, infoArray.count];
    
    containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width * infoArray.count, containerScrollView.frame.size.height);
    
    [containerScrollView scrollRectToVisible:CGRectMake(containerScrollView.frame.size.width * currentIndex, 0, containerScrollView.frame.size.width, containerScrollView.frame.size.height) animated:NO];
    
    currentZoomScale = 1.0f;
    startIndex = currentIndex + 1;
    endIndex = currentIndex - 1;
    
    [self completeAnIndex:currentIndex - 1];
	[self completeAnIndex:currentIndex];
    [self completeAnIndex:currentIndex + 1];
    
    CategoryDescriptionDB *ob = [infoArray objectAtIndex:currentIndex];
    
    if (ob.notes == nil || [ob.notes isEqualToString:@""] || [ob.notes isEqualToString:@"(null)"])
    {
        [notes setText:@""];
    }
    else
    {
        [notes setText:ob.notes];
    }
    
    if (ob.location == nil || [ob.location isEqualToString:@""] || [ob.location isEqualToString:@"(null)"])
    {
        [locationButton setTitle:@"No Location"];
        locationButton.enabled = NO;
    }
    else
    {
        [locationButton setTitle:ob.location];
        locationButton.enabled = YES;
    }
    
    self.navigationItem.hidesBackButton = YES;
    
//    [tipStrip pushNavigationItem:self.navigationItem animated:NO];
    
    if(![ApplicationPreference dropboxEnabled])
    {
        if(![ApplicationPreference isDropboxAlertAlreadyShown])
        {
            dropboxAlert = [[UIAlertView alloc] initWithTitle:@"Dropbox"
                                                      message:@"You can share your files among your devices"
                                                     delegate:self
                                            cancelButtonTitle:@"Not Now"
                                            otherButtonTitles:@"Dropbox Login", nil];
            [dropboxAlert show];
            [ApplicationPreference setDropboxAlertAlreadyShown:YES];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    visible = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(85.0f/255.0f) green:(85.0f/255.0f) blue:(85.0f/255.0f) alpha:1.0f]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1.0f;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)sender
//{
//    
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentIndex = containerScrollView.contentOffset.x / containerScrollView.frame.size.width;
	
    self.title = [NSString stringWithFormat:@"%d of %d", currentIndex + 1, infoArray.count];
	
    [self completeAnIndex:currentIndex - 1];
    [self completeAnIndex:currentIndex];
    [self completeAnIndex:currentIndex + 1];
	
    CategoryDescriptionDB *ob = [infoArray objectAtIndex:currentIndex];
    
    if (ob.notes == nil || [ob.notes isEqualToString:@""] || [ob.notes isEqualToString:@"(null)"])
    {
        [notes setText:@""];
    }
    else
    {
        [notes setText:ob.notes];
    }
    
    if (ob.location == nil || [ob.location isEqualToString:@""] || [ob.location isEqualToString:@"(null)"])
    {
        [locationButton setTitle:@"No Location"];
        locationButton.enabled = NO;
    }
    else
    {
        [locationButton setTitle:ob.location];
        locationButton.enabled = YES;
    }
}

-(void)completeAnIndex:(int)index
{
    if (index < 0 || index >= infoArray.count)
    {
		return;
	}
    
    if (index >= startIndex && index <= endIndex)
    {
        return;
    }
    
    if (index < startIndex)
    {
        startIndex = index;
    }
    
    if (index > endIndex)
    {
        endIndex = index;
    }
    
    CategoryDescriptionDB *ob = [infoArray objectAtIndex:index];
    UIImage *img = [UIImage imageWithContentsOfFile:ob.PhotoRef];
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(containerScrollView.frame.size.width * index, 0, containerScrollView.frame.size.width, containerScrollView.frame.size.height)];
    sv.backgroundColor = [UIColor blackColor];
    sv.minimumZoomScale = 1.0f;
    sv.maximumZoomScale = 5.0f;
    sv.delegate = self;
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [sv addGestureRecognizer:doubleTapRecognizer];
    
	UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerScrollView.frame.size.width, containerScrollView.frame.size.height)];
    iv.backgroundColor = [UIColor blackColor];
    
    sv.tag = iv.tag = index;
    sv.autoresizingMask = iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = img;
    
    [sv addSubview:iv];
	[containerScrollView addSubview:sv];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews objectAtIndex:0];
}

#pragma mark - added later in updation

-(void)doneButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleSingleTap:(UITapGestureRecognizer*)recognizer
{
    if (visible)
    {
        return;
    }
    
    visible = YES;
    
//    tipStrip.translucent = YES;
    bottomToolbar.translucent = YES;
    
    [UIView animateWithDuration:0.1f animations:^
     {
//         tipStrip.alpha = 1.0f;
         self.navigationController.navigationBar.alpha = 1.0f;
         bottomStrip.alpha = 1.0f;
     }];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
}

-(void)handleDoubleTap:(UITapGestureRecognizer*)recognizer
{
    UIScrollView *currentView = nil;
    for (UIScrollView *view in containerScrollView.subviews)
    {
        if (view.tag == currentIndex)
        {
            currentView = view;
            break;
        }
    }
    
    if (currentView)
    {
        [currentView setZoomScale:(currentView.zoomScale * 1.5f) animated:YES];
    }
}

-(void)timeout:(id)sender
{
    if (visible)
    {
        visible = NO;
    
        [UIView animateWithDuration:0.6f animations:^
         {
//             tipStrip.alpha = 0.0f;
             self.navigationController.navigationBar.alpha = 0.0f;
             bottomStrip.alpha = 0.0f;
         }];
    }
}

-(IBAction)deleteButtonPressed:(id)sender
{
    popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
    popupQuery.tag = 0;  // to identify the type of action sheet displayed
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [popupQuery showInView:self.view];
    
    //[popupQuery release];
}

-(IBAction)optionButtonPressed:(id)sender
{
    popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Notes or Location",@"Share with Email",@"Share with Facebook",@"Share with Twitter",@"Save to iPhone", nil];
    popupQuery.tag=1;  // to identify the type of action sheet displayed
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [popupQuery showInView:self.view];
}

-(IBAction)openLocation:(id)sender
{
    CategoryDescriptionDB *obj=[infoArray objectAtIndex:currentIndex];
    
    NSString *llStr = [NSString stringWithFormat:@"%f,%f", obj.latitute, obj.longitute];
    
    //TODO: Need to check in a iOS 6 device
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"http://maps.google.com/maps"];
    [urlStr appendFormat:@"?q=%@", [obj.location stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlStr appendFormat:@"&&mrt=yp"];
    [urlStr appendFormat:@"&ll=%@", [llStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

-(void)doneButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark - delegate for uiaction sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==0)
    {
        // delete action sheet displayed
        
        if (buttonIndex == 0)
        {
            
//            NSLog(@"deleted");
            
            // delete from database
            CategoryDescriptionDB *obj=[infoArray objectAtIndex:currentIndex];
            
            if ([ApplicationPreference dropboxEnabled])
            {
                WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
                NSArray *categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
                NSString *categoryName = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
                
                DBPath *folderPath = [[DBPath root] childPath:categoryName];
                NSString *fileName = [obj.PhotoRef lastPathComponent];
                
                DBPath *imageFilePath = [folderPath childPath:fileName];
                [[DBFilesystem sharedFilesystem] deletePath:imageFilePath error:nil];
                
//                DBPath *textFilePath = [[folderPath childPath:@"Info"] childPath:[NSString stringWithFormat:@"%@.txt", fileName]];
//                [[DBFilesystem sharedFilesystem] deletePath:textFilePath error:nil];
            }
            
            [[DataBaseManager getInstance] removePhoto:obj.PhotoRef];
            
            // remove controller
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(actionSheet.tag==1)
    {
        // option of sharing sheet displayed
        
        if (buttonIndex == 0)
        {
            CategoryDescriptionDB *obj=[infoArray objectAtIndex:currentIndex];
            EditViewController *ob = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
            ob.locLat = obj.latitute;
            ob.locLng = obj.longitute;
            ob.locTitle = obj.location;
            ob.photoID = obj.PhotoRef;
            ob.notesString = obj.notes;

            [self.navigationController pushViewController:ob animated:YES];
        }
        else if (buttonIndex == 1)
        {
            isSharedWithEmailBtnPressed = YES;
            isTweeterPressed = NO;
            if([ApplicationPreference isProUpgradePurchaseDone])
            {
                MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                mailViewController.mailComposeDelegate = self;
                [mailViewController setSubject:@"Message from TheAppVault.com"];
                [mailViewController setMessageBody:@"via TheAppVault.com" isHTML:NO];
                
                
                CategoryDescriptionDB *ob = [infoArray objectAtIndex:currentIndex];
                UIImage *img = [UIImage imageWithContentsOfFile:ob.PhotoRef];
                NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
                [mailViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"MyImage"];
                if ([MFMailComposeViewController canSendMail])
                {
                    [self presentModalViewController:mailViewController animated:YES];
                }
                else
                {
                    UIAlertView *view=[[UIAlertView alloc] initWithTitle:@"Error" message:@"mail not configured" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    [view show];
                }
            }
            else
            {
                [loadingAlert show];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPurchaseNow) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [[InAppPurchaseManager getInstance] loadStore];
            }
            
            
//            NSLog(@"deleted");
        }
        else if (buttonIndex == 2)
        {   
            [self showBusyScreen:YES];
            
            CategoryDescriptionDB *ob=[infoArray objectAtIndex:0];
            
            UIImage *rawImage = [UIImage imageWithContentsOfFile:ob.PhotoRef];
            UIImage *imageToShare = [ApplicationPreference imageWithImage:rawImage scaledToSize:CGSizeMake(rawImage.size.width/2, rawImage.size.height/2)];
            
            facebookController = [[FacebookController alloc] init];
            facebookController.faceBookShareDelegate = self;
            [facebookController initiateShareImage:imageToShare andMessage:notes.text];   
        }
        else if (buttonIndex == 3)
        {
            isTweeterPressed = YES;
            isSharedWithEmailBtnPressed = NO;
            if([ApplicationPreference isProUpgradePurchaseDone])
            {
                NSLog(@"deleted");
                
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSString *str=[defaults valueForKey:@"twitterSwitch"];
                
                if ([str isEqualToString:@"set"]) {
                    
                    
                    // Create the view controller
                    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
                    
                    // Optional: set an image, url and initial text
                    
                    CategoryDescriptionDB *ob=[infoArray objectAtIndex:0];
                    NSString *photoloc=ob.PhotoRef;
                    [twitter addImage:[UIImage imageWithContentsOfFile:photoloc]];
                    //[twitter addURL:[NSURL URLWithString:[NSString stringWithString:@"http://lptpl.com"]]];
                    [twitter setInitialText:@"via TheAppVault.com"];
                    
                    
                    // Show the controller
                    [self presentModalViewController:twitter animated:YES];
                    
                    // Called when the tweet dialog has been closed
                    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result)
                    {
                        NSString *msg;
                        
                        if (result == TWTweetComposeViewControllerResultCancelled)
                            msg = @"Tweet cancelled.";
                        else if (result == TWTweetComposeViewControllerResultDone)
                            msg = @"Tweet composition completed.";
                        
                        // Show alert to see how things went...
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tweet Status" message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alertView show];
                        
                        // Dismiss the controller
                        [self dismissModalViewControllerAnimated:YES];
                    };
                    
                }
            }
            else
            {
                [loadingAlert show];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPurchaseNow) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [[InAppPurchaseManager getInstance] loadStore];
            }
        }
        else if(buttonIndex==4)
        {
            CategoryDescriptionDB *ob = [infoArray objectAtIndex:currentIndex];
            UIImage *img = [UIImage imageWithContentsOfFile:ob.PhotoRef];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *str=[defaults valueForKey:@"iPhonePhotoSwitch"];
            if ([str isEqualToString:@"set"])
            {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
            }
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Saved to iPhone" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)animateAvtivity
{
    activity.hidden=FALSE;
    
    [self.view addSubview:activity];
    
    [popupQuery addSubview:activity];
    [activity startAnimating];
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade to RenoMate Plus?" message:nil delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Upgrade Now", @"Restore Purchases", nil];
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
    
    if(isSharedWithEmailBtnPressed)
    {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Message from TheAppVault.com"];
        [mailViewController setMessageBody:@"via TheAppVault.com" isHTML:NO];
        
        
        CategoryDescriptionDB *ob = [infoArray objectAtIndex:currentIndex];
        UIImage *img = [UIImage imageWithContentsOfFile:ob.PhotoRef];
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
        [mailViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"MyImage"];
        if ([MFMailComposeViewController canSendMail])
        {
            [self presentModalViewController:mailViewController animated:YES];
        }
        else
        {
            UIAlertView *view=[[UIAlertView alloc] initWithTitle:@"Error" message:@"mail not configured" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [view show];
        }
        isSharedWithEmailBtnPressed = !isSharedWithEmailBtnPressed;
    }
    else if(isTweeterPressed)
    {
        NSLog(@"deleted");
        isTweeterPressed = !isTweeterPressed;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *str=[defaults valueForKey:@"twitterSwitch"];
        
        if ([str isEqualToString:@"set"]) {
            
            
            // Create the view controller
            TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
            
            // Optional: set an image, url and initial text
            
            CategoryDescriptionDB *ob=[infoArray objectAtIndex:0];
            NSString *photoloc=ob.PhotoRef;
            [twitter addImage:[UIImage imageWithContentsOfFile:photoloc]];
            //[twitter addURL:[NSURL URLWithString:[NSString stringWithString:@"http://lptpl.com"]]];
            [twitter setInitialText:@"via TheAppVault.com"];
            
            
            // Show the controller
            [self presentModalViewController:twitter animated:YES];
            
            // Called when the tweet dialog has been closed
            twitter.completionHandler = ^(TWTweetComposeViewControllerResult result)
            {
                NSString *msg;
                
                if (result == TWTweetComposeViewControllerResultCancelled)
                    msg = @"Tweet cancelled.";
                else if (result == TWTweetComposeViewControllerResultDone)
                    msg = @"Tweet composition completed.";
                
                // Show alert to see how things went...
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tweet Status" message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alertView show];
                
                // Dismiss the controller
                [self dismissModalViewControllerAnimated:YES];
            };
            
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - messageui delegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    switch (result)    
    {
            
        case MFMailComposeResultCancelled:
            
           // message.text = @"Result: canceled";
            
            break;
            
        case MFMailComposeResultSaved:
            
           // message.text = @"Result: saved";
            
            break;
            
        case MFMailComposeResultSent:
            
         //   message.text = @"Result: sent";
            
            break;
            
        case MFMailComposeResultFailed:
            
           // message.text = @"Result: failed";
            
            break;
            
        default:
            
          //  message.text = @"Result: not sent";
            
            break;
            
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark alertview delegate 

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        /*
        oAuth2TestViewController *ob = [[oAuth2TestViewController alloc] init];
        
        if (str == nil)
        {
            ob.parentController = self;
            [self.navigationController pushViewController:ob animated:YES];
        }
        else
        {
            [self.view addSubview:activity];
            activity.hidden = false;
        
            [activity startAnimating];
            
            CategoryDescriptionDB *obj = [infoArray objectAtIndex:0];
            NSString *photoloc = obj.PhotoRef;
           
            // [ob postImage:photoloc:@"via RenoMate"];
            
            [ob postImage:photoloc :notes.text];
            [activity stopAnimating];
        }
        */
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    visible = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
    
    if(isFbAuthenticationDoneFirstTime)
    {
        [self performSelectorInBackground:@selector(animateAvtivity) withObject:nil];
        
//        oAuth2TestViewController *ob = [[oAuth2TestViewController alloc] init];
//        CategoryDescriptionDB *obj = [infoArray objectAtIndex:0];
//        NSString *photoloc = obj.PhotoRef;
//        // [ob postImage:photoloc:@"via RenoMate"];
//        [ob postImage:photoloc :notes.text];
        isFbAuthenticationDoneFirstTime = NO;
    }
}

-(void)FBauthenticationDone
{
    isFbAuthenticationDoneFirstTime = YES;
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
    
    img = [ApplicationPreference imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
    
    AddDetailViewController *obj = [[AddDetailViewController alloc] initWithNibName:@"AddDetailViewController" bundle:nil WithImage:img];
    
    UINavigationController *navController = self.navigationController;
    [navController popToRootViewControllerAnimated:NO];
    [navController pushViewController:obj animated:YES];
    
    NSLog(@"Image size  %f %f ", obj.img.size.width, obj.img.size.height);
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;

    if (error)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    }
	else
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    
    }
    [alert show];
}

-(void)facebookShareDidFinishWithSuccess:(BOOL)_success
{
    [self showBusyScreen:NO];
}

-(void)faceBookDidNotLoginFromController
{
    [self showBusyScreen:NO];
}

-(void)faceBookDidLogOutFromController
{
    [self showBusyScreen:NO];
}

@end
