//
//  ShareViewController.h
//  SocialShare
//
//  Created by Ashif on 2/17/14.
//  Copyright (c) 2014 algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoutubeLoginViewController.h"

@interface ShareViewController : UIViewController <YoutubeShareDelegate>

-(IBAction)shareToSocialNetworks:(id)sender;

@end
