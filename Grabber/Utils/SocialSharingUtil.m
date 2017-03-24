//
//  SocialSharingUtil.m
//  Grabber
//
//  Created by shabib hossain on 4/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Social/Social.h>
#import <Pinterest/Pinterest.h>
#import "SocialSharingUtil.h"



@interface SocialSharingUtil ()
{
    Pinterest*  _pinterest;
    UIAlertView *loadingAlert;
    
    int numberOfshares;
}

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) NSString *imgUrlStr;

@end

@implementation SocialSharingUtil

@synthesize delegate;
@synthesize viewController;
@synthesize shareImage;
@synthesize shareText;
@synthesize userLocation;
@synthesize imgUrlStr;

-(id)initWithViewController:(UIViewController *)vc shareImage:(UIImage *)img imageURL:(NSString *)url shareText:(NSString *)str userLocation:(CLLocation *)loc
{
    if (self = [super init])
    {
        self.viewController = vc;
        self.shareImage = img;
        self.shareText = str;
        self.userLocation = loc;
        self.imgUrlStr = url;
        
        numberOfshares = 0;
        
        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                                  message:@"Sharing on Social Networks. Please wait for a while..."
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
    }
    return self;
}

-(void)startSharing
{
    [self shareOnFacebook];
}

#pragma mark - facebook stack

-(void)shareOnFacebook
{
    if([UserDefaultsManager isFacebookEnabled])
    {
        [loadingAlert show];
        
        [FBRequestConnection startWithGraphPath:@"/me/permissions"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error){
                                      NSDictionary *permissions= [(NSArray *)[result data] objectAtIndex:0];
                                      if (![permissions objectForKey:@"publish_actions"]){
                                          // Permission hasn't been granted, so ask for publish_actions
                                          [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                                                defaultAudience:FBSessionDefaultAudienceFriends
                                                                              completionHandler:^(FBSession *session, NSError *error) {
                                                                                  if (!error)
                                                                                  {
                                                                                      if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
                                                                                      {
                                                                                          // Permission not granted, tell the user we will not share to Facebook
                                                                                          NSLog(@"Permission not granted, we will not share to Facebook.");
                                                                                          [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                                                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                                                          message:@"Permission not granted"
                                                                                                                                         delegate:nil
                                                                                                                                cancelButtonTitle:@"OK"
                                                                                                                                otherButtonTitles:nil];
                                                                                          [alert show];
                                                                                          [self shareOnTwitter];
                                                                                      }
                                                                                      else
                                                                                      {
                                                                                          // Permission granted, publish the OG story
                                                                                          [self publishPostOnFB];
                                                                                      }
                                                                                  }
                                                                                  else
                                                                                  {
                                                                                      // An error occurred, we need to handle the error
                                                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                                                      NSLog(@"Encountered an error requesting permissions: %@", error.description);
                                                                                      [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                                                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                                                      message:@"Error while requesting permission"
                                                                                                                                     delegate:nil
                                                                                                                            cancelButtonTitle:@"OK"
                                                                                                                            otherButtonTitles:nil];
                                                                                      [alert show];
                                                                                      
                                                                                      [self shareOnTwitter];
                                                                                  }
                                                                              }];
                                      }
                                      else
                                      {
                                          // Permissions present, publish the OG story
                                          [self publishPostOnFB];
                                      }
                                  }
                                  else
                                  {
                                      // An error occurred, we need to handle the error
                                      // See: https://developers.facebook.com/docs/ios/errors
                                      NSLog(@"Encountered an error checking permissions: %@", error.description);
                                      [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                      message:@"Error while requesting permission"
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                                      [alert show];
                                      
                                      [self shareOnTwitter];
                                  }
                              }];
    }
    else
    {
        [self shareOnTwitter];
    }
}

-(void)publishPostOnFB
{
    [FBRequestConnection startForUploadStagingResourceWithImage:self.shareImage completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error)
        {
            // Log the uri of the staged image
            NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
            
            // Further code to post the OG story goes here
            
            // instantiate a Facebook Open Graph object
            NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
            
            // specify that this Open Graph object will be posted to Facebook
            object.provisionedForPost = YES;
            
            // for og:title
            object[@"title"] = self.shareText;
            
            // for og:type, this corresponds to the Namespace you've set for your app and the object type name
            object[@"type"] = @"codespoon_grabber:promo";
            
            // for og:description
            object[@"description"] = self.shareText;
            
            NSString *lat = [NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
            NSString *lng = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
            
            object[ @"data" ] = @{ @"location": @{ @"latitude": lat, @"longitude": lng }};
            
            // for og:url, we cover how this is used in the "Deep Linking" section below
            object[@"url"] = [NSString stringWithFormat:@"https://www.google.com/maps/@%@,%@,21z", lat, lng];
            
            // for og:image we assign the image that we just staged, using the uri we got as a response
            // the image has to be packed in a dictionary like this:
            NSLog(@"uri %@",@[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }]);
            object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
            
            [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error)
                {
                    // get the object ID for the Open Graph object that is now stored in the Object API
                    NSString *objectId = [result objectForKey:@"id"];
                    NSLog(@"%@",[NSString stringWithFormat:@"object id: %@", objectId]);
                    
                    // Further code to post the OG story goes here
                    
                    // create an Open Graph action
                    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
                    [action setObject:objectId forKey:@"promo"];
                    [action setComments:[NSArray arrayWithObject:@"hello"]];
                    [action setMessage:@"hello"];
                    
                    id<FBGraphPlace> place = (id<FBGraphPlace>)[FBGraphObject graphObject];
                    [place setId:@"141887372509674"]; // Facebook Seattle
                    [action setPlace:place];
                    
                    [action setImage:[UIImage imageNamed:@"LoginHeader.png"]];
                    
//                    [action setTags:[NSArray arrayWithObject:@"1347084572"]];
                    
                    // create action referencing user owned object
                    [FBRequestConnection startForPostWithGraphPath:@"/me/codespoon_grabber:grab" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        if(!error)
                        {
                            NSLog(@"%@",[NSString stringWithFormat:@"OG story posted, story id: %@", [result objectForKey:@"id"]]);
                            [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                            [[[UIAlertView alloc] initWithTitle:@"Story posted"
                                                        message:@"Check your Facebook profile or activity log to see the story."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK!"
                                              otherButtonTitles:nil] show];
                            numberOfshares++;
                        }
                        else
                        {
                            // An error occurred
                            NSLog(@"Encountered an error posting to Open Graph: %@", error);
                            [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                            message:@"Error while posting to Facebook"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                        [self shareOnTwitter];
                    }];
                }
                else
                {
                    // An error occurred
                    NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
                    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Error while posting to Facebook"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }];
            
        }
        else
        {
            // An error occurred
            NSLog(@"Error staging an image: %@", error);
            [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Error while posting to Facebook"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark - twitter stack

-(void)shareOnTwitter
{
    if([UserDefaultsManager isTwitterEnabled])
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController * composeVC = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
            
            
            if(self.shareImage)
            {
                [composeVC addImage:shareImage];
            }
            
            [composeVC setInitialText:self.shareText];
            
            if(composeVC)
            {
                // assume everything validates
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
                {
                    if (result == SLComposeViewControllerResultCancelled)
                    {
                        NSLog(@"Cancelled");
                        
                    }
                    else
                    {
                        NSLog(@"Post");
                        numberOfshares++;
                    }
//                    [self shareOnPinterest];
                    [composeVC dismissViewControllerAnimated:YES completion:Nil];
                    
                    if(delegate)
                    {
                        [delegate totalSharesCompleted:numberOfshares];
                    }
                };
                
                composeVC.completionHandler = myBlock;
                [viewController presentViewController: composeVC animated: YES completion: nil];
            }
        }
        else
        {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            controller.view.hidden = YES;
            [viewController presentViewController:controller animated:NO completion:nil];
            
//            [self shareOnPinterest];
        }
    }
    else
    {
        if(delegate)
        {
            [delegate totalSharesCompleted:numberOfshares];
        }
    }
}

#pragma mark - pinterest stack

- (void)shareOnPinterest
{
    if([UserDefaultsManager isPinterestEnabled])
    {
        //TODO: change the url
        _pinterest = [[Pinterest alloc] initWithClientId:kPinterestAppID];
        
        [_pinterest createPinWithImageURL:[NSURL URLWithString:self.imgUrlStr] sourceURL:[NSURL URLWithString:@"http://getgrabber.com/"] description:self.shareText];
        
        [self shareOnInstagram];
        numberOfshares++;
    }
    else
    {
        [self shareOnInstagram];
    }
}

#pragma mark - instagram stack

-(void)shareOnInstagram
{
    if([UserDefaultsManager isInstagramEnabled])
    {
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://location?id=1"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            
            NSString* imagePath = [NSString stringWithFormat:@"%@/image.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
            
            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
            [UIImagePNGRepresentation(shareImage) writeToFile:imagePath atomically:YES];
            
            NSLog(@"image size: %@", NSStringFromCGSize(shareImage.size));
            
            [self openDocControllerWithImagePath:imagePath];
            numberOfshares++;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Install Instagram from Appstore"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
//    if(delegate)
//    {
//        [delegate totalSharesCompleted:numberOfshares];
//    }
}

-(void)openDocControllerWithImagePath:(NSString *)imagePath
{
    if (delegate)
    {
        [delegate openOptionToShareOnInstagramWithImagePath:imagePath];
    }
}

-(void)doNextShare
{
    
}

@end
