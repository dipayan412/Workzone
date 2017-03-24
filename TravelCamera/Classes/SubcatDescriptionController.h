//
//  SubcatDescriptionController.h
//  RenoMate
//
//  Created by yogesh ahlawat on 17/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubcatDescriptionController : UIViewController <
    UITableViewDelegate, 
    UITableViewDataSource,
    UISearchBarDelegate, 
    UIImagePickerControllerDelegate, 
    UINavigationControllerDelegate,
    UIPopoverControllerDelegate>
{
    IBOutlet UITableView *subCatTable;
    IBOutlet UIToolbar *bottomToolbar;
    
    UIBarButtonItem *settingsButton;
    UIBarButtonItem *fSpace1;
    UISearchBar *seachBar;
    UIBarButtonItem *searchItem;
    UIBarButtonItem *fSpace2;
    UIBarButtonItem *uploadButton;
    
    NSString *selectedCategory;       // past from previous controller
    
    NSMutableArray *subCatArray;      // repository to hold data
    
    UIImage *image;                   // image to be displayed on adddetailviewcontroller
}

@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic,retain) NSMutableArray *subCatArray;
@property (nonatomic,retain) UITextField *catNameTextField;
@property (nonatomic,retain) UIImage *image;

@end
