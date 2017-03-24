//
//  HomeViewController.h
//  iOS Prototype
//
//  Created by World on 2/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    IBOutlet UIButton *notificationButton;
}

-(IBAction)settingsButtonAction:(UIButton*)btn;
-(IBAction)associateButtonAction:(UIButton*)btn;

@end
