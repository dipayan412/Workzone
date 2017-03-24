//
//  SetWorkDaysViewController.h
//  MyOvertime
//
//  Created by Ashif on 1/5/13.
//
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "GlobalFunctions.h"

@interface SetWorkDaysViewController : UITableViewController
{
    UITableViewCell *workDaysCell;
    
    NSMutableDictionary *settingsDictionary;
    
    UIButton *mondayCheckbox;
	UIButton *tuesdayCheckbox;
	UIButton *wednesdayCheckbox;
	UIButton *thursdayCheckbox;
	UIButton *fridayCheckbox;
	UIButton *saturdayCheckbox;
	UIButton *sundayCheckbox;
    
//    UIButton *mondayTemplateCheckbox;
//	UIButton *tuesdayTemplateCheckbox;
//	UIButton *wednesdayTemplateCheckbox;
//	UIButton *thursdayTemplateCheckbox;
//	UIButton *fridayTemplateCheckbox;
//	UIButton *saturdayTemplateCheckbox;
//	UIButton *sundayTemplateCheckbox;
    
    UIButton *mondayTemplateButton;
	UIButton *tuesdayTemplateButton;
	UIButton *wednesdayTemplateButton;
	UIButton *thursdayTemplateButton;
	UIButton *fridayTemplateButton;
	UIButton *saturdayTemplateButton;
	UIButton *sundayTemplateButton;
    
    UILabel *monOffsetLabel;
    UILabel *tueOffsetLabel;
    UILabel *wedOffsetLabel;
    UILabel *thuOffsetLabel;
    UILabel *friOffsetLabel;
    UILabel *satOffsetLabel;
    UILabel *sunOffsetLabel;
    
    NSNumber *monOffsetValue;
    NSNumber *tueOffsetValue;
    NSNumber *wedOffsetValue;
    NSNumber *thuOffsetValue;
    NSNumber *friOffsetValue;
    NSNumber *satOffsetValue;
    NSNumber *sunOffsetValue;
    
    UILabel *monBreakLabel;
    UILabel *tueBreakLabel;
    UILabel *wedBreakLabel;
    UILabel *thuBreakLabel;
    UILabel *friBreakLabel;
    UILabel *satBreakLabel;
    UILabel *sunBreakLabel;
    
    NSNumber *monbreakValue;
    NSNumber *tuebreakValue;
    NSNumber *wedbreakValue;
    NSNumber *thubreakValue;
    NSNumber *fribreakValue;
    NSNumber *satbreakValue;
    NSNumber *sunbreakValue;
    
    UIView *offsetSelectView;
	UIPickerView *offsetSelectPicker;
	UIView *breakSelectView;
	UIPickerView *breakSelectPicker;
    
    NSArray *hoursPickerData;
	NSArray *minutesPickerData;
    
    OffSetForDay offsetForDay;
    BreakForDay breakForDay;
    
    WeekDay weekDay;
    
    Settings *settings;
}

@property (nonatomic, retain) NSArray *hoursPickerData;
@property (nonatomic, retain) NSArray *minutesPickerData;

@property (nonatomic, retain) Settings *settings;

@property (nonatomic, retain) IBOutlet UITableViewCell *workDaysCell;

@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;

@property (nonatomic, retain) IBOutlet UIButton *mondayCheckbox;
@property (nonatomic, retain) IBOutlet UIButton *tuesdayCheckbox;
@property (nonatomic, retain) IBOutlet UIButton *wednesdayCheckbox;
@property (nonatomic, retain) IBOutlet UIButton *thursdayCheckbox;
@property (nonatomic, retain) IBOutlet UIButton *fridayCheckbox;
@property (nonatomic, retain) IBOutlet UIButton *saturdayCheckbox;
@property (nonatomic, retain) IBOutlet UIButton *sundayCheckbox;

//@property (nonatomic, retain) IBOutlet UIButton *mondayTemplateCheckbox;
//@property (nonatomic, retain) IBOutlet UIButton *tuesdayTemplateCheckbox;
//@property (nonatomic, retain) IBOutlet UIButton *wednesdayTemplateCheckbox;
//@property (nonatomic, retain) IBOutlet UIButton *thursdayTemplateCheckbox;
//@property (nonatomic, retain) IBOutlet UIButton *fridayTemplateCheckbox;
//@property (nonatomic, retain) IBOutlet UIButton *saturdayTemplateCheckbox;
//@property (nonatomic, retain) IBOutlet UIButton *sundayTemplateCheckbox;

@property (nonatomic, retain) IBOutlet UIButton *mondayTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *tuesdayTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *wednesdayTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *thursdayTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *fridayTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *saturdayTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *sundayTemplateButton;


@property (nonatomic, retain) IBOutlet UIView *offsetSelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *offsetSelectPicker;
@property (nonatomic, retain) IBOutlet UIView *breakSelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *breakSelectPicker;

@property (nonatomic, retain) IBOutlet UILabel *monOffsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *tueOffsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *wedOffsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *thuOffsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *friOffsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *satOffsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *sunOffsetLabel;

@property (nonatomic, retain) NSNumber *monOffsetValue;
@property (nonatomic, retain) NSNumber *tueOffsetValue;
@property (nonatomic, retain) NSNumber *wedOffsetValue;
@property (nonatomic, retain) NSNumber *thuOffsetValue;
@property (nonatomic, retain) NSNumber *friOffsetValue;
@property (nonatomic, retain) NSNumber *satOffsetValue;
@property (nonatomic, retain) NSNumber *sunOffsetValue;

@property (nonatomic, retain) IBOutlet UILabel *monBreakLabel;
@property (nonatomic, retain) IBOutlet UILabel *tueBreakLabel;
@property (nonatomic, retain) IBOutlet UILabel *wedBreakLabel;
@property (nonatomic, retain) IBOutlet UILabel *thuBreakLabel;
@property (nonatomic, retain) IBOutlet UILabel *friBreakLabel;
@property (nonatomic, retain) IBOutlet UILabel *satBreakLabel;
@property (nonatomic, retain) IBOutlet UILabel *sunBreakLabel;

@property (nonatomic, retain) NSNumber *monbreakValue;
@property (nonatomic, retain) NSNumber *tuebreakValue;
@property (nonatomic, retain) NSNumber *wedbreakValue;
@property (nonatomic, retain) NSNumber *thubreakValue;
@property (nonatomic, retain) NSNumber *fribreakValue;
@property (nonatomic, retain) NSNumber *satbreakValue;
@property (nonatomic, retain) NSNumber *sunbreakValue;

- (IBAction) mondayCheckboxSelected:(id)sender;
-(IBAction)enableTemplateSelected:(id)sender;

- (IBAction) showSelectOffsetView:(id)sender;
- (IBAction) hideSelectOffsetView:(id)sender;

- (IBAction) showSelectBreakView:(id)sender;
- (IBAction) hideSelectBreakView:(id)sender;

-(IBAction)showWorkDayTemplate:(id)sender;

- ( void ) updateMinutesForActiveInterval;
- ( NSInteger ) safeTimeInterval;
- ( void ) updatePickersSelection;

@end
