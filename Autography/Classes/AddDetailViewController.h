//
//  AddDetailViewController.h
//  RenoMate
//
//  Created by yogesh ahlawat on 08/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "MapKitDisplayViewController.h"

@interface AddDetailViewController : UIViewController <
    UIPickerViewDelegate,
    UIPickerViewDataSource,
    UITextFieldDelegate,
    locationUpdated,
    UIAlertViewDelegate>
{
    UIImage *img;                       // display image in the background
    
    IBOutlet UIImageView *imgView;
    IBOutlet UIControl *baseView;                   // view acting base to add other toolbar like uitextfield
    
    IBOutlet UITextField *categoryField;
    UIPickerView *categoryPickerView;
    IBOutlet UIButton *addnewCatButton;
    IBOutlet UIButton *setLocationButton;
    
    UITextField *locationField;         // location details
    IBOutlet UITextField *noteField;             // notes details
    UITextField *catNameTextField;      // textfield to enter category name
    NSMutableArray *categoryArray;      // array to set the data in option table
    
    NSString *mode;                     // edit mode or insert mode
    
    NSString *locTitle;
    double locLng;
    double locLat;
    IBOutlet UIButton *btn;
    
    UIAlertView *loadingView;
    UIAlertView *newCatAddAlert;
    UIAlertView *purchaseAlert;
    UIActivityIndicatorView *activityView;
    UIAlertView *loadingAlert;
}

@property (nonatomic,copy) UIImage *img;
@property (nonatomic,retain) UITextField *locationField;
@property (nonatomic,retain) UITextField *noteField;
@property (nonatomic,retain) UITextField *catNameTextField;
@property (nonatomic,retain) NSMutableArray *categoryArray;
@property (nonatomic,retain) NSString *mode; 
@property (nonatomic,retain) NSString *locTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage*)_img;

-(IBAction)addNewCatButtonPressed:(id)sender;
-(IBAction)locationButtonClicked:(id)sender;
-(IBAction)backgroundTap:(id)sender;

@end
