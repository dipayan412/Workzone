//
//  ResetViewController.h
//  MyOvertime
//
//  Created by Prashant Choudhary on 7/15/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
#import "CalendarSelectionDelegate.h"

@interface ResetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, CalendarSelectionDelegate>
{
    IBOutlet UIButton *dateFromButton,*dateToButton;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UILabel *labelSuccess,*labelTitle,*labelFrom,*labelTo;
    IBOutlet UITextView *textView;
    IBOutlet UIButton *goButton;
    NSInteger fromTo;
    NSDate *fromDate,*toDate;

}
@property (nonatomic, retain) IBOutlet UIView *datePickerView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *resetCell;
@property (nonatomic,retain)    UILabel *dateFrom,*dateTo;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
//@property (nonatomic,retain) NSDate *fromDate,*toDate;
-(IBAction) resetDate:(id)sender;
-(IBAction) selectedDate:(id)sender;
-(IBAction) requestDateSelection:(id)sender;

@end
