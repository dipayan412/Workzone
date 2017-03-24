//
//  TestViewController.h
//  WakeUp
//
//  Created by World on 6/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DrawerViewDelegate.h"

@interface TestViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
{
    IBOutlet UITextField *statusField;
    
    CLLocationManager *locationManeger;
    CLLocation *userLoaction;
}
@property (nonatomic, assign) id <DrawerViewDelegate> delegate;

-(IBAction)shareButtonAction:(UIButton*)sender;
-(IBAction)backButtonAction:(UIButton*)sender;

@end
