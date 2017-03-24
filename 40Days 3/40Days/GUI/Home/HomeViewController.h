//
//  HomeViewController.h
//  40Days
//
//  Created by User on 4/25/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"

@interface HomeViewController : UIViewController
{
    IBOutlet UILabel *dayInfoLabel;
    
    IBOutlet UIButton *devotionalButton;
    IBOutlet UIButton *previousSessionButton;
    IBOutlet UIButton *remindersButton;
    
    int currentDay;
}

- (IBAction)devotionButtonPressed:(id)sender;
- (IBAction)previousSessionButtonPressed:(id)sender;
- (IBAction)remindersButtonPressed:(id)sender;
@end
