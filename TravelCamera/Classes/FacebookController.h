//
//  FacebookController.h
//  CrazyFliesTest
//
//  Created by Ashif Iqbal on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBRequest.h"
#import "FBUser.h"
#import "FacebookShareDelegate.h"

typedef enum apiCall
{
    kAPIGraphUserLogin,
    kAPIGraphUserPhotosPost,
} ApiCall;

@interface FacebookController : NSObject <UIAlertViewDelegate, FBRequestDelegate, FBUser>
{
    UIImage *imageForShare;
    id<FacebookShareDelegate>faceBookShareDelegate;
    UIAlertView *facebookAlert;
    
    ApiCall apiCall;
}

@property (nonatomic, retain) UIImage *imageForShare;
@property (nonatomic, retain) NSString *imageText;
@property (nonatomic, assign) ApiCall apiCall;
@property (nonatomic, assign) id<FacebookShareDelegate>faceBookShareDelegate;

-(void)initiateLogin;
-(void)faceBookFetchUserInfo;
-(void)initiateShareImage:(UIImage*)_image andMessage:(NSString*)_message;
-(void)faceBookImageShare;
-(void)logOutFromFB;

@end
