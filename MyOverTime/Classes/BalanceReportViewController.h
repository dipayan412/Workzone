//
//  BalanceReportViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface BalanceReportViewController : UITableViewController<MFMailComposeViewControllerDelegate>
{
	UITableViewCell *headerCell;
	UITableViewCell *reportCell;
    UITableViewCell *footerCell;
	
	UILabel *totalBalanceLabel;
    
    UILabel *labelFrom;
    UILabel *labelTo;
    UILabel *rangeLabelFrom;
    UILabel *rangeLabelTo;

    UILabel *rangeLabel;
    UILabel *inRangeLabel;
    
    UILabel *footerHoursLabel;
    UILabel *footerOffsetLabel;
    UILabel *footerBalanceLabel;
	
	UIScrollView *scrollView;
	
	NSManagedObjectContext *managedObjectContext;
	NSArray *reportData;
	
	NSMutableArray *reportRowViews;
    
    NSString *beginDate;
    NSString *endDate;
}
@property (nonatomic, retain) NSMutableString *userName,*companyName;

@property (nonatomic, retain) IBOutlet UITableViewCell *headerCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *reportCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *footerCell;

@property (nonatomic, retain) IBOutlet UILabel *totalBalanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *labelFrom;
@property (nonatomic, retain) IBOutlet UILabel *labelTo;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabelFrom;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabelTo;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabel;
@property (nonatomic, retain) IBOutlet UILabel *inRangeLabel;

@property (nonatomic, retain) IBOutlet UILabel *footerHoursLabel;
@property (nonatomic, retain) IBOutlet UILabel *footerOffsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *footerBalanceLabel;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *reportData;

@property (nonatomic, retain) NSMutableArray *reportRowViews;

@property (nonatomic, retain) NSString *beginDate;
@property (nonatomic, retain) NSString *endDate;
- (NSArray*)formPDFContent;
- (NSString*)formPDFContentHeader;
- (IBAction) emailAction:(id)sender;
- (NSString*)formPDFContentHeader;

@end
