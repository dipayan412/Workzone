//
//  SettingsViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>
#import "ScaryBugDoc.h"
#import "ScaryBugData.h"
#import "GlobalFunctions.h"
#import "Settings.h"

@interface SettingsViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
	UITableViewCell *timeStyleCell;
	UITableViewCell *timeDialIntervalCell;
	UITableViewCell *reminderCell;
	UITableViewCell *defineActivitiesCell;
    UITableViewCell *firstCheckinCell;
    UITableViewCell *hoursToDaysCell;
	
	NSMutableDictionary *settingsDictionary;
		
	UIButton *amDayMode;
	UIButton *roundDayMode;
    IBOutlet UIButton *decimalButton;
	
    UIButton * interval1Min;
    UIButton * interval5Min;
    UIButton * interval15Min;
    UIButton * interval3Min;
    
	UISwitch *reminderSwitch;
	
	NSManagedObjectContext *managedObjectContext;
    
    UITextField *filename;
    
    IBOutlet UIButton * showMyTemplateButton;
    IBOutlet UIButton * showDayTemplateButton;
    IBOutlet UIButton * showCopyLastSheetButton;
    IBOutlet UIButton * showFirstCheckinButton;
    
    IBOutlet UITableViewCell *showButtonOptionsCell;
    
    IBOutlet UILabel *checkinActivityLabel;
    IBOutlet UILabel *hoursToDaysTimeLabel;
}


@property (nonatomic, retain) IBOutlet UITextField *filename;

@property (nonatomic, retain) IBOutlet UITableViewCell *timeStyleCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *timeDialIntervalCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *reminderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *defineActivitiesCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *firstCheckinCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *hoursToDaysCell;

@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;

@property (nonatomic, retain) IBOutlet UIButton *amDayMode;
@property (nonatomic, retain) IBOutlet UIButton *roundDayMode;

@property (nonatomic, retain) IBOutlet UIButton * interval1Min;
@property (nonatomic, retain) IBOutlet UIButton * interval5Min;
@property (nonatomic, retain) IBOutlet UIButton * interval15Min;
@property (nonatomic, retain) IBOutlet UIButton * interval3Min;

@property (nonatomic, retain) IBOutlet UISwitch *reminderSwitch;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UIView *activitySelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *activitySelectPicker;

@property (nonatomic, retain) IBOutlet UIView *hoursToDaysSelectTimeView;
@property (nonatomic, retain) IBOutlet UIPickerView *hoursToDaysSelectTimePicker;

@property (nonatomic, retain) NSArray *activitiesPickerData;

- (IBAction) timeDialIntervalCheckboxSelected:(id)sender;
- (IBAction) hoursToDaysButtonPressed:(id)sender;
- (IBAction) fistCheckingButtonPressed:(id)sender;
- (IBAction) dayModeCheckboxSelected:(id)sender;
- (IBAction) openDefineActivitiesWindow:(id)sender;
- (IBAction) chooseBackground:(id)sender;
- (IBAction) userIdentication:(id)sender;
-(IBAction)setWorkDaysButtonPressed:(id)sender;
-(IBAction)myTemplatesButtonPressed:(id)sender;
- (IBAction) showHelpWindow:(id)sender;
-(IBAction)dropBoxButtonPressed:(id)sender;

-(IBAction)showButtonsOptionSelection:(id)sender;

- (IBAction) hideSelectActivityView:(id)sender;

- (IBAction) hideHoursToDaysSelectTimeView:(id)sender;

- (IBAction)backup:(id)sender;
- (IBAction)resetTimesheets:(id)sender;

- ( NSInteger ) safeTimeInterval;

- ( void ) saveAllSettings;

@end
