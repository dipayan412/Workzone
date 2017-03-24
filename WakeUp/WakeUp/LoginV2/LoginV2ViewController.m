//
//  LoginV2ViewController.m
//  WakeUp
//
//  Created by World on 7/2/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "LoginV2ViewController.h"
#import "DrawerViewController.h"
#import "AddContactByPhoneBookManager.h"
#import "AppDelegate.h"

@interface LoginV2ViewController () <ASIHTTPRequestDelegate, FBLoginViewDelegate, AddContactByPhoneBookDelegate, UIActionSheetDelegate>
{
    ASIHTTPRequest *updateProfileRequest;
    BOOL isCheckBoxTapped;
    
    NSString *proPicId;
    
    MBProgressHUD *hud;
}

@end

@implementation LoginV2ViewController

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
    
    proPicId = @"";
    
    if([UserDefaultsManager userProfilePicId].length > 0)
    {
        [proPicImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@", kRootUrl,[UserDefaultsManager userProfilePicId]]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
    }
    proPicImageView.layer.cornerRadius = 35;
    proPicImageView.layer.masksToBounds = YES;
    proPicImageView.layer.borderWidth = 3.0f;
    proPicImageView.layer.borderColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startContactSyncInLogin) name:kStartPhonebookContactSync object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneBookSyncFinished) name:kPhonebookContactSyncDone object:nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *update = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)];
    [doneButton setTintColor:[UIColor whiteColor]];
    [toolBar setItems:[NSArray arrayWithObjects:update,space, doneButton, nil]];
    nameField.inputAccessoryView = toolBar;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(kIsThreePointFiveInch)
    {
        CGRect textFieldFrame = nameField.frame;
        textFieldFrame.origin.y += 30;
        nameField.frame = textFieldFrame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    //    statusLabel.text = @"You're logged in as";
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error)
        {
            NSLog(@"error %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
        else
        {
            
        }
    }];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    
}

-(IBAction)proPicImageViewButtonAction:(UIButton*)sender
{
    [nameField resignFirstResponder];
    
    UIActionSheet *imageOptionActionSheet = [[UIActionSheet alloc] initWithTitle:@"Camera Option"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Cancel"
                                                          destructiveButtonTitle:proPicId.length> 0 ? @"Remove this photo" : nil
                                                               otherButtonTitles:@"Camera", @"Library", nil];
    [imageOptionActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(proPicId.length>0)
    {
        switch (buttonIndex) {
            case 0:
                [self removeOption];
                
                break;
                
            case 1:
                
                [self cameraOption];
                
                break;
                
            case 2:
                
                [self libraryOption];
                
                break;
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex) {
            case 0:
                
                [self cameraOption];
                
                break;
                
            case 1:
                
                [self libraryOption];
                
                break;
            default:
                break;
        }
    }
}

-(void)cameraOption
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [imagePicker setDelegate:self];
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution!"
                                                        message:@"Camera is not availbale for this device. Choose Library Option"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)libraryOption
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)removeOption
{
    if([proPicId isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Nothing to remove" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        proPicId = @"";
        proPicImageView.image = [UIImage imageNamed:@"ProPicUploadIcon.png"];
    }
}

-(IBAction)loginWithFbButtonAction:(UIButton*)sender
{
    fbLoginView = [[FBLoginView alloc] init];
    
    fbLoginView.readPermissions = [NSArray arrayWithObjects:@"public_profile",@"user_friends",@"email", nil];
    fbLoginView.delegate = self;
    fbLoginView.center = self.view.center;
    fbLoginView.hidden = YES;
    [self.view addSubview:fbLoginView];
    
    if([[FBSession activeSession] isOpen])
    {
        [self updateProfileWithFb];
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_friends",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
             [self updateProfileWithFb];
         }];
    }
}

-(void)updateProfileWithFb
{
    [FBRequestConnection startWithGraphPath:@"/me"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if(!error)
                              {
                                  NSLog(@"result %@",result);
                                  [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Loading..."];
                                  
                                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                  
                                      NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", [result objectForKey:@"id"]];
                                      NSLog(@"url -> %@",userImageURL);
                                      NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]];
                                      
                                      NSString *urlString = [NSString stringWithFormat:kUploadphotoApi];
                                      
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
                                      if([[responseObject objectForKey:@"status"] intValue] == 0)
                                      {
                                          NSLog(@"image uploaded successfully");
                                          proPicId = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"imgid"]];;
                                      }
                                      else
                                      {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                          message:@"Could not upload photo to Server. Try again later"
                                                                                         delegate:nil
                                                                                cancelButtonTitle:@"Dismiss"
                                                                                otherButtonTitles:nil];
                                          [alert show];
                                      }
                                      NSLog(@"%@ %@", responseObject, error.description);
                                      
                                      NSMutableString *urlStr = [[NSMutableString alloc] init];
                                      [urlStr appendFormat:@"%@",kBaseUrl];
                                      [urlStr appendFormat:@"cmd=%@",kUpdateProfileApi];
                                      [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
                                      [urlStr appendFormat:@"&name=%@",[[result objectForKey:@"first_name"]stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                                      if(![proPicId isEqualToString:@""])
                                      {
                                          [urlStr appendFormat:@"&pid=%@",proPicId];
                                      }
                                      
                                      nameField.text = [result objectForKey:@"first_name"];
                                      
                                      NSLog(@"loginUrl %@",urlStr);
                                      
                                      updateProfileRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                                      updateProfileRequest.delegate = self;
                                      [updateProfileRequest startAsynchronous];
                                  });
                              }
                          }];
}

-(void)loginServerCall
{
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Updating profile..."];
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kUpdateProfileApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&name=%@",[nameField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    if(![proPicId isEqualToString:@""])
    {
        [urlStr appendFormat:@"&pid=%@",proPicId];
    }
    
    NSLog(@"loginUrl %@",urlStr);
    
    updateProfileRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    updateProfileRequest.delegate = self;
    [updateProfileRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"%@ error %@ \nStr %@",responseObject,error,request.responseString);
    
    if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UserDefaultsManager setUserName:nameField.text];
        [UserDefaultsManager setUserProfilePicId:(proPicId ? proPicId : @"")];
        [UserDefaultsManager setAccountVerified:YES];
        
        AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        NSLog(@"addPhonebookContactsDone %d",appDel.addPhonebookContactsDone);
        
        isUpdateProfileFinished = YES;
        
        if(!appDel.addPhonebookContactsDone)
        {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Syncing Contacts";
            hud.labelColor = [UIColor lightGrayColor];
            
            if(!appDel.syncOnProgress)
            {
                AddContactByPhoneBookManager *phoneBookManager = [AddContactByPhoneBookManager getInstance];
                phoneBookManager.delegate = self;
            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(syncPhonebookDone) withObject:nil waitUntilDone:NO];
        }
    }
    else
    {
        [UserDefaultsManager hideBusyScreenToView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error localizedDescription]);
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(void)startContactSyncInLogin
{
    AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if(!appDel.addPhonebookContactsDone && !appDel.syncOnProgress)
    {
        appDel.syncOnProgress = YES;
        [[AddContactByPhoneBookManager getInstance] startContactSync];
    }
}

-(void)phoneBookSyncProgress:(int)value totalContacts:(int)total syncedContacts:(int)synced
{
    hud.labelText = [NSString stringWithFormat:@"%d / %d numbers synced",synced, total];
}

-(void)phoneBookSyncFinished
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    if(isUpdateProfileFinished)
    {
        [self performSelectorOnMainThread:@selector(syncPhonebookDone) withObject:nil waitUntilDone:NO];
    }
}


-(void)syncPhonebookDone
{
    isUpdateProfileFinished = NO;
    
    DrawerViewController *vc = [[DrawerViewController alloc] initWithNibName:@"DrawerViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)userSelectedColorAction:(UIButton*)sender
{
    [UserDefaultsManager setUserColorTheme:sender.tag];
    proPicImageView.layer.borderColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]].CGColor;
    nameField.textColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]];
}

-(IBAction)finishButtonAction:(UIButton*)sender
{
    
    NSLog(@"button tag %d",sender.tag);
//    DrawerViewController *vc = [[DrawerViewController alloc] initWithNibName:@"DrawerViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    [self.view endEditing:YES];
    
    if([self formValidation])
    {
        if(proPicId.length > 0)
        {
            [self uploadImageWithImageData:UIImagePNGRepresentation(proPicImageView.image)];
        }
        else
        {
            [self loginServerCall];
        }
    }
}

-(BOOL)formValidation
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    if([nameField.text isEqualToString:@""])
    {
        alert.message = @"Give name";
        [alert show];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == nameField)
    {
        [nameField resignFirstResponder];
    }
    return YES;
}

-(void)doneButtonAction
{
    [nameField resignFirstResponder];
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
    
    proPicId = @"123";
    
    img = [self imageWithImage:img scaledToWidth:200];
    proPicImageView.image = img;
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

#pragma mark upload image to server

-(void)uploadImageWithImageData:(NSData*)imageData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
        if([[responseObject objectForKey:@"status"] intValue] == 0)
        {
            NSLog(@"image uploaded successfully");
            proPicId = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"imgid"]];
            [self loginServerCall];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Could not upload photo to Server. Try again later"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            proPicId = @"";
        }
        NSLog(@"%@ %@", responseObject, error.description);
    });
}


@end
