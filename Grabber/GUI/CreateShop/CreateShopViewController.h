//
//  CreateShopViewController.h
//  iOS Prototype
//
//  Created by World on 3/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "inputTextCell.h"

@interface CreateShopViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *shopNameField;
    IBOutlet UITextField *shopIdField;
    IBOutlet UIButton *registerButton;
    IBOutlet UITableView *formTableView;
    IBOutlet UIPickerView *typePickerView;
    IBOutlet UIImageView *shopImageView;
    
    inputTextCell *storeNameCell;
    inputTextCell *typeCell;
    inputTextCell *descriptionCell;
    UITableViewCell *locationCell;
    
    IBOutlet UIView *chooseLocationSuperParentView;
    IBOutlet UIView *chooseLocationParentView;
    IBOutlet UIView *chooseLocationOptionView;
    IBOutlet UIView *chooseLocationManualView;
    
    IBOutlet UITextField *latField;
    IBOutlet UITextField *longField;
}

-(IBAction)shopImageButtonAction:(UIButton*)btn;
-(IBAction)registerButtonAction:(UIButton*)btn;
-(IBAction)backgroundTap:(id)sender;

-(IBAction)currentLocationButtonAction:(UIButton*)btn;
-(IBAction)manualLocationButtonAction:(UIButton*)btn;
-(IBAction)searchInGrabberLocationButtonAction:(UIButton*)btn;
-(IBAction)reverseGeocodingLocationButtonAction:(UIButton*)btn;
-(IBAction)doneLocationButtonAction:(UIButton*)btn;

@end
