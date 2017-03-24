//
//  RA_FindUsViewController.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
//#import "GoogleMaps/GoogleMaps.h"

@interface RA_FindUsViewController : UIViewController <MFMailComposeViewControllerDelegate>//, GMSMapViewDelegate>
{
    IBOutlet UILabel *restaurantNameLabel;
    IBOutlet UILabel *restaurantAddressLabel;
    IBOutlet UILabel *restaurantEmailLabel;
    
    IBOutlet UIButton *openNavigatorButton;
    IBOutlet UIButton *emailUsButton;
    
//    CLLocation *location;
}

-(IBAction)openNavigatorAction:(UIButton*)sender;
-(IBAction)emailUsButtonAction:(UIButton*)sender;

@end
