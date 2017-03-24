//
//  RatingsViewController.h
//  Robick
//
//  Created by Atif Qayyum Toor on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RatingsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UINavigationItem * m_navigator;
- (IBAction)rateApp:(id)sender;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)buyPro:(id)sender;

@end
