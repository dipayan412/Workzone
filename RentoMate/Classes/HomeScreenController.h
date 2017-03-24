//
//  HomeScreenController.h
//  RenoMate
//
//  Created by yogesh ahlawat on 08/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

#import <QuartzCore/QuartzCore.h>

@interface HomeScreenController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate, UIPopoverControllerDelegate>
{
    IBOutlet UITableView *categoryTable;
    IBOutlet UIToolbar *bottomToolBar;
    
    NSMutableArray *categoryArray;    // array containig data from database
    UITextField *catNameTextField;    // textfield on alert view to add category name
    
    UIBarButtonItem *settingsButton;
    UIBarButtonItem *fSpace1;
    UISearchBar *seachBar;
    UIBarButtonItem *searchItem;
    UIBarButtonItem *fSpace2;
    UIBarButtonItem *uploadButton;
    
    UIAlertView *loadingAlert;
    UIAlertView *purchaseAlert;
    UIAlertView *newCatAddAlert;
}

@property (nonatomic,retain) NSMutableArray *categoryArray;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) UITextField *catNameTextField;
@property (nonatomic, retain) UIPopoverController *popOver;

-(void)displayViewAnimated;                     // Display the view to add info about pics
-(void)addCategory:(id)sender;                  // Adding category in edit mode

@end
