//
//  ProfileViewController.m
//  WakeUp
//
//  Created by World on 6/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ProfileViewController.h"
#import "RA_ImageCache.h"

@interface ProfileViewController () <UIActionSheetDelegate>
{
    ASIHTTPRequest *updateProfileRequest;
    RA_ImageCache *imgCh;
    NSString *proPicId;
    
    UIImage *userImage;
}

@end

@implementation ProfileViewController
@synthesize delegate;

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
    
    proPicId = [UserDefaultsManager userProfilePicId];
    imgCh = [[RA_ImageCache alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadControllerUserProfile) name:kProfileViewControllerComeToFront object:nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *update = [[UIBarButtonItem alloc] initWithCustomView:updateButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)];
    [doneButton setTintColor:[UIColor whiteColor]];
    [toolBar setItems:[NSArray arrayWithObjects:update,space, doneButton, nil]];
    userNameField.inputAccessoryView = toolBar;
    
    self.view.backgroundColor = kAppBGColor;
    
    userImageView.layer.borderColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]].CGColor;
    userNameField.textColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)reloadControllerUserProfile
{
    if(![[UserDefaultsManager userProfilePicId] isEqualToString:@""])
    {
        NSMutableString *downloadImageUrlStr = [[NSMutableString alloc] init];
        [downloadImageUrlStr appendFormat:@"%@/",kRootUrl];
        [downloadImageUrlStr appendFormat:@"%@?",kDownloadImageApi];
        
        userImageView.image = [imgCh getImage:[NSString stringWithFormat:@"%@imgid=%@",downloadImageUrlStr,[UserDefaultsManager userProfilePicId]]];
    }
    else
    {
        userImageView.image = [UIImage imageNamed:@"ProPicUploadIcon.png"];
    }
    
    userImage = userImageView.image;
    
    userImageView.layer.cornerRadius = 75;
    userImageView.layer.borderWidth = 3.0f;
    userImageView.layer.borderColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]].CGColor;
    userImageView.layer.masksToBounds = YES;
    
    proPicId = [UserDefaultsManager userProfilePicId];
    userNameField.text = [UserDefaultsManager userName];
    userNameField.textColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]];
    
    updateButton.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:188.0f/255.0f blue:45.0f/255.0f alpha:1.0f];
    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    updateButton.layer.cornerRadius = 4.0f;
    
    updateButtonInView.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:188.0f/255.0f blue:45.0f/255.0f alpha:1.0f];
    [updateButtonInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    updateButtonInView.layer.cornerRadius = 4.0f;
}

-(IBAction)userColorThemeAction:(UIButton*)sender
{
    [UserDefaultsManager setUserColorTheme:sender.tag];
    
    userImageView.layer.borderColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]].CGColor;
    userNameField.textColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProfileUpdated object:nil];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.delegate)
    {
        [self.delegate showDrawerView];
    }
}

-(IBAction)imageButtonAction:(UIButton*)sender
{
    [userNameField resignFirstResponder];
    
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
//    if([proPicId isEqualToString:@""])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Nothing to remove" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
//        [alert show];
//    }
//    else
//    {
//        proPicId = @"";
//        userImageView.image = userImage;
//    }
    
    proPicId = @"";
    userImageView.image = [UIImage imageNamed:@"ProPicUploadIcon.png"];
}

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
    userImageView.image = img;
//    [self uploadImageWithImageData:UIImagePNGRepresentation(img)];
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
        
        if (error || returnData == nil)
        {
            NSLog(@"%@", error.description);
        }
        else
        {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
            NSLog(@"%@ %@", responseObject, error.description);
            if([[responseObject objectForKey:@"status"] intValue] == 0)
            {
                NSLog(@"image uploaded successfully");
                proPicId = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"imgid"]];
                [self updateProfileRequestCall];
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
                return;
            }
        }
    });
}

-(IBAction)updateButtonAction:(UIButton*)sender
{
    [userNameField resignFirstResponder];
    
    if(userNameField.text.length  < 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User name can not be empty." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if(![proPicId isEqualToString:@""])
    {
        [self uploadImageWithImageData:UIImagePNGRepresentation(userImageView.image)];
    }
    else
    {
        [self updateProfileRequestCall];
    }
}

-(void)updateProfileRequestCall
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kUpdateProfileApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&name=%@",[userNameField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    if(![proPicId isEqualToString:@""])
    {
        [urlStr appendFormat:@"&pid=%@",proPicId];
    }
    
    NSLog(@"updateUrl %@",urlStr);
    
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
        [UserDefaultsManager setUserName:userNameField.text];
        [UserDefaultsManager setUserProfilePicId:(proPicId ? proPicId : @"")];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kProfileUpdated object:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Profile updated successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error localizedDescription]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(void)doneButtonAction
{
    [userNameField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [userNameField resignFirstResponder];
    return YES;
}

@end
