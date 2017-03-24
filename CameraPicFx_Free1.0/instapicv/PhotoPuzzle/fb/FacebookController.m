//
//  FacebookController.m
//  CrazyFliesTest
//
//  Created by Ashif Iqbal on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookController.h"
#import "AppDelegate.h"

@implementation FacebookController

@synthesize faceBookShareDelegate;

@synthesize imageForShare;
@synthesize apiCall;
@synthesize imageText;

-(id)init
{
    if( (self=[super init])) 
    {
        
	}
    
	return self;
}

-(void)initiateShareImage:(UIImage*)_image andMessage:(NSString*)_message
{
    self.imageForShare = _image;
    self.imageText = _message;
    self.apiCall = kAPIGraphUserPhotosPost;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate fbLogin:self];
}


-(void)initiateLogin
{
    self.apiCall = kAPIGraphUserLogin;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate fbLogin:self];
}

-(void)logOutFromFB
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate fbLogOut:self];
}

-(void)facebookDidLogin
{
    switch (apiCall)
    {
        case kAPIGraphUserLogin:
            
            [self faceBookFetchUserInfo];
            
            break;
            
        case kAPIGraphUserPhotosPost:
            
            [self faceBookImageShare];
            
            break;
            
        default:
            break;
    }
}

-(void)faceBookDidNotLogin
{
    if(self.faceBookShareDelegate)
    {
        [faceBookShareDelegate faceBookDidNotLoginFromController];
    }
}

-(void)faceBookDidLogOut
{
    if(self.faceBookShareDelegate)
    {
        [faceBookShareDelegate faceBookDidLogOutFromController];
    }
}

-(void)faceBookImageShare
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:self.imageText forKey:@"message"];
    [params setObject:self.imageForShare forKey:@"picture"];
    
    [delegate.faceBook requestWithGraphPath:@"me/photos"
                                  andParams:params
                              andHttpMethod:@"POST"
                                andDelegate:self];
}


-(void)faceBookFetchUserInfo
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, email, name, first_name, last_name, pic FROM user WHERE uid=me()", @"query",nil];
    
    [delegate.faceBook requestWithMethodName:@"fql.query"
                    andParams:params
                andHttpMethod:@"POST"
                  andDelegate:self];
}

#pragma mark - Facebook

- (void)request:(FBRequest *)request didLoad:(id)result
{
    if(apiCall == kAPIGraphUserPhotosPost)
    {
        facebookAlert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Shared via Facebook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [facebookAlert show];
        [facebookAlert release];
    }
    else
    {   
        if(self.faceBookShareDelegate)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Logged in to Facebook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            [alert release];
        }
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{
    if(apiCall == kAPIGraphUserPhotosPost)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Facebook could not post your message." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"Err details: %@", [error description]);
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Facebook could not log you in." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"Err details: %@", [error description]);
    }
    
//    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) removeLoadingView];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if(alertView == facebookAlert)
        {
            [self.faceBookShareDelegate facebookShareDidFinishWithSuccess:YES];
        }
        else
        {
            [self.faceBookShareDelegate facebookShareDidFinishWithSuccess:YES];
        }
    }
}

@end
