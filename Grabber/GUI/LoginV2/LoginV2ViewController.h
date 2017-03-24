//
//  LoginV2ViewController.h
//  Grabber
//
//  Created by World on 4/2/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface LoginV2ViewController : GAITrackedViewController
{
    IBOutlet UISwitch *keepMeSignedInSwitch;
    
    FBLoginView *fbLoginView;
}
@property (nonatomic, assign) BOOL isFirstTimeLoginDone;


-(IBAction)signInWithFbButtonAction:(UIButton*)sender;
-(IBAction)twitterButtonAction:(UIButton*)sender;


- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;

@end
