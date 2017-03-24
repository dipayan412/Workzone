//
//  ActivityReportViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CMPopTipView.h"

@interface ActivityReportViewController : UITableViewController <MFMailComposeViewControllerDelegate, UIScrollViewDelegate, CMPopTipViewDelegate>
{
	UITableViewCell *activityReportCell;
    UITableViewCell *footerCell;
	
	UIScrollView *headerScrollView;
	UIScrollView *scrollView;
	
	NSManagedObjectContext *managedObjectContext;
	NSArray *reportData;

	NSMutableArray *reportRowViews;
    //Meghan
    NSString *beginDate;
    NSString *endDate;
   
    UITableViewCell *headerCell;

    UILabel *labelFrom;
    UILabel *labelTo;
    UILabel *rangeLabelFrom;
    UILabel *rangeLabelTo;

    UILabel *rangeLabel;
    UILabel *rangeStartLabel;
    UILabel *rangeEndLabel;
    
    UILabel *footerHoursLabel;
    UILabel *footerOffsetLabel;
    UILabel *footerBalanceLabel;
    
    BOOL isFilterResult;
    NSInteger totalFilteredResult;
    
    UILabel *labelTotalAmount;
    
    CGFloat amountTotal;
    BOOL is24HourMode;
    BOOL setTimeForFlatHours;
    BOOL stylePerformed;
    
    UIButton *filterButton;
}
@property (nonatomic, retain)	NSMutableArray	*visiblePopTipViews;
@property (nonatomic, retain)	id				currentPopTipViewTarget;

@property (nonatomic, retain) NSString *multiFiler;
@property(nonatomic, retain) NSArray *selectedActivities;
@property (nonatomic, retain) NSMutableString *userName,*companyName;
@property (nonatomic, retain) IBOutlet UITableViewCell *headerCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *footerCell;
@property (nonatomic, retain) IBOutlet UILabel *labelFrom;
@property (nonatomic, retain) IBOutlet UILabel *labelTo;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabelFrom;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabelTo;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabel;
@property (nonatomic, retain) IBOutlet UILabel *rangeStartLabel;
@property (nonatomic, retain) IBOutlet UILabel *rangeEndLabel;
@property (nonatomic, retain) IBOutlet UILabel *filterActivity;
@property (nonatomic, retain) IBOutlet UILabel *filterTotalAmount;
@property (nonatomic, retain) IBOutlet UILabel *labelDummy1;
@property (nonatomic, retain) IBOutlet UILabel *labelDummy2;
@property (nonatomic, retain) IBOutlet UILabel *labelDummy3;
@property (nonatomic, retain) IBOutlet UILabel *labelAmount;


@property (nonatomic, retain) IBOutlet UILabel *filterHead;
@property (nonatomic, retain) IBOutlet UILabel *labelTotal;

@property (nonatomic, retain) IBOutlet UILabel *footerHoursLabel;
@property (nonatomic, retain) IBOutlet UILabel *footerOffsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *footerBalanceLabel;

@property (nonatomic,retain) NSString *totalString;
@property (nonatomic,retain) NSString *totalAmountString;
@property (nonatomic, retain) IBOutlet UITableViewCell *activityReportCell;
@property (nonatomic, retain) IBOutlet UIScrollView *headerScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *reportData;
@property (nonatomic, retain) NSArray *filteredReportData;

@property (nonatomic, retain) NSString *filter;

@property (nonatomic, retain) NSMutableArray *reportRowViews;

@property (nonatomic, retain) NSString *beginDate;
@property (nonatomic, retain) NSString *endDate;

- (IBAction) emailAction:(id)sender;
- (NSString*)formCVSContent;
- (NSString*)formHTMLContent;

@end
