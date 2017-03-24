//
//  ReportListViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CPPickerViewCell.h"
#import "CalendarSelectionDelegate.h"
#import "ActivitySelectionDelegate.h"

@interface ReportListViewController : UITableViewController<CPPickerViewCellDataSource,CPPickerViewCellDelegate, CalendarSelectionDelegate, ActivitySelectionDelegate>
{
	NSManagedObjectContext *managedObjectContext;
    UIView *datePickerView;
    UIDatePicker *datePicker;
    
    UITableViewCell *activityReportCell;
    UILabel *lblActivityReport;
    UIButton *btnActivityReportFrom;
    UIButton *btnActivityReportTo;
    
    UITableViewCell *myOvertimeCell;
    UILabel *lblFrom1;
    UILabel *lblTo1;
    UILabel *lblMyOvertime;
    UIButton *btnMyOvertimeReportFrom;
    UIButton *btnMyOvertimeReportTo;
    UITableViewCell *balanceReportCell;
    NSInteger pickerActivityIndex;
    
    IBOutlet UILabel *selectActivityLabel;
    BOOL fromReportDetails;
    
    int btnTag;
    
    UITableViewCell *activityGraphReportCell;
}

@property (nonatomic, retain) NSArray *selectedActivities;
@property (nonatomic, retain) NSMutableString *userName,*companyName;
@property (nonatomic, retain) IBOutlet UITableViewCell *dateSelectionCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *graphicalReportCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *normalReportCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *dateFromToCell;

@property (nonatomic, retain) IBOutlet UITableViewCell *activityReportCell;
@property (nonatomic, retain) IBOutlet UILabel *lblActivityReport;
@property (nonatomic, retain) IBOutlet UIButton *btnActivityReportFrom;
@property (nonatomic, retain) IBOutlet UIButton *btnActivityReportTo;

@property (nonatomic, retain) IBOutlet UITableViewCell *myOvertimeCell;
@property (nonatomic, retain) IBOutlet UILabel *lblFrom1;
@property (nonatomic, retain) IBOutlet UILabel *lblTo1;
@property (nonatomic, retain) IBOutlet UILabel *lblMyOvertime;
@property (nonatomic, retain) IBOutlet UIButton *btnMyOvertimeReportFrom;
@property (nonatomic, retain) IBOutlet UIButton *btnMyOvertimeReportTo;

@property (nonatomic, retain) IBOutlet UITableViewCell *balanceReportCell;
@property (nonatomic, retain) IBOutlet UIButton *buttonFrom,*buttonTo;
@property (nonatomic, retain) IBOutlet UILabel *labelDummy;
@property (nonatomic, retain) IBOutlet UITableViewCell *activityGraphReportCell;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIView *datePickerView;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,retain)     NSMutableArray *pickerActivity;

-(IBAction) showDateView:(UIButton *)sender;
-(IBAction)selectActivitiesForReport:(id)sender;

@end
