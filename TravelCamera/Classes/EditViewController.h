//
//  EditViewController.h
//  RenoMate
//
//  Created by yogesh ahlawat on 01/06/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "MapKitDisplayViewController.h"

@interface EditViewController : UIViewController <
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
    
    UIActivityIndicatorView *activityView;
    
    BOOL isCatBtn;
    BOOL isLocBtn;
    
    UIAlertView *loadingAlert;
    UIAlertView *purchaseAlert;
    UIAlertView *newCatAddAlert;
}

@property (nonatomic,retain) UIImage *img;
@property (nonatomic,retain) NSString *mode;
@property (nonatomic,retain) NSString *notesString;
@property (nonatomic,retain) NSString *selectedCatString;
@property (nonatomic,retain) NSString *photoID;
@property (nonatomic,retain) UIButton *btn;
@property (nonatomic,retain) NSString *locTitle;
@property (nonatomic)  double locLng;
@property (nonatomic)  double locLat;

-(IBAction)addNewCatButtonPressed:(id)sender;
-(IBAction)locationButtonClicked:(id)sender;
-(IBAction)backgroundTap:(id)sender;

@end
