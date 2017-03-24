//
//  VisitDetailViewController.h
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitDetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    IBOutlet UIImageView *attachmentImageView;
    IBOutlet UIImageView *photoImageView;
    
    IBOutlet UILabel *cityLabel;
    IBOutlet UILabel *countryLabel;
    IBOutlet UILabel *fileNameLabel;
    
    IBOutlet UIView *detailsView;
    
    IBOutlet UIButton *attachFileButton;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *deleteButton;
    
    IBOutlet UIView *dateView;
    IBOutlet UILabel *dateLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil GLLVisit:(GLLVisit*)_visit;

@property (nonatomic, retain) UIPopoverController *popOver;

-(IBAction)attachFileButtonAction:(id)sender;
-(IBAction)editButtonAction:(id)sender;
-(IBAction)deleteButtonAction:(id)sender;

@end
