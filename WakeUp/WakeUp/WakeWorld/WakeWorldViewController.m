//
//  WakeWorldViewController.m
//  WakeUp
//
//  Created by World on 7/21/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "WakeWorldViewController.h"

#define kTexviewPlaceholder @"Share your thoughts..."

@interface WakeWorldViewController ()
{
    NSString *attachImageId;
    ASIHTTPRequest *addWakeupRequest;
}

@end

@implementation WakeWorldViewController

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
    
    statusTextView.text = kTexviewPlaceholder;
    statusTextView.textColor = [UIColor lightGrayColor];
    statusTextView.layer.cornerRadius = 4.0f;
    statusTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    statusTextView.layer.borderWidth = 1.0f;
    statusTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWakeUpAlert) name:kWakeUpAlertShow object:nil];
    
    attachImageId = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)showWakeUpAlert
{
    
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.delegate)
    {
        [self.delegate showDrawerView];
    }
}

-(IBAction)attachPhotoButtonAction:(UIButton*)sender
{
    UIActionSheet *imageOptionActionSheet = [[UIActionSheet alloc] initWithTitle:@"Camera Option"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Cancel"
                                                          destructiveButtonTitle:attachImageId.length> 0 ? @"Remove this photo" : nil
                                                               otherButtonTitles:@"Camera", @"Library", nil];
    [imageOptionActionSheet showInView:self.view];
}

-(IBAction)shareButtonAction:(UIButton*)sender
{
    [self addWakeupServerCall];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(attachImageId.length>0)
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
    if([attachImageId isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Nothing to remove" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        attachImageId = @"";
        attachPhotoImageView.image = [UIImage imageNamed:@"PlaceHolderImage.png"];
    }
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
    
    img = [self imageWithImage:img scaledToWidth:200];
    attachPhotoImageView.image = img;
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Uploading photo"];
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
            if([[responseObject objectForKey:@"status"] isEqualToString:@"0"])
            {
                NSLog(@"image uploaded successfully");
                attachImageId = [responseObject objectForKey:@"imgid"];
            }
            else
            {
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
        [UserDefaultsManager hideBusyScreenToView:self.view];
    });
}

-(void)addWakeupServerCall
{
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Status updating"];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kAddWakeUpApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    if(![statusTextView.text isEqualToString:kTexviewPlaceholder])
    {
        [urlStr appendFormat:@"&msg=%@",[statusTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if(![attachImageId isEqualToString:@""])
    {
        [urlStr appendFormat:@"&patt=%@",attachImageId];
    }

    NSLog(@"wakeUpUrl %@",urlStr);
    
    addWakeupRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    addWakeupRequest.delegate = self;
    [addWakeupRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"%@ %@ \n %@",responseObject, error.description, request.responseString);
    
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    if([[responseObject objectForKey:@"status"] intValue] == 0)
    {
        attachImageId = @"";
        
        statusTextView.text = kTexviewPlaceholder;
        statusTextView.textColor = [UIColor lightGrayColor];
        attachPhotoImageView.image = [UIImage imageNamed:@"PlaceHolderImage.png"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Status published successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:kTexviewPlaceholder])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        textView.text = kTexviewPlaceholder;
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [statusTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
