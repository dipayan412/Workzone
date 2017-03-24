//
//  MainPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController
{
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *checkedInOutLabel;
    
    IBOutlet UIButton *checkedInOutButton;
    IBOutlet UIButton *jobsButton;
    IBOutlet UIButton *fuelPurchaseButton;
    IBOutlet UIButton *locateGroupButton;
    IBOutlet UIButton *settingsButton;
    IBOutlet UIButton *vehicleInspectionButton;
    IBOutlet UIButton *driverStatusButton;
}
@property (nonatomic, retain) NSString* username;
@property (nonatomic, assign) BOOL isCheckedIn;


- (IBAction)checkedInOutButtonAction:(UIButton *)sender;
- (IBAction)jobsButtonAction:(UIButton *)sender;
- (IBAction)fuelPurchaseButtonAction:(UIButton *)sender;
- (IBAction)vehicleInspectionButtonAction:(UIButton *)sender;
- (IBAction)settingsButtonAction:(UIButton *)sender;
- (IBAction)locateGroupButtonAction:(UIButton *)sender;
- (IBAction)driverStatusButtonAction:(UIButton *)sender;

@end
