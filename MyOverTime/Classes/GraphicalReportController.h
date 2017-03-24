//
//  GraphicalReportController.h
//  MyOvertime
//
//  Created by Prashant Choudhary on 6/16/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreData/CoreData.h>
#import "ReportItem.h"

@interface GraphicalReportController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *tableView;
    NSInteger numberOfPages;
    NSInteger countItem;
    NSInteger maxWeek,maxMonth,maxYear;
    NSInteger minWeek,minMonth,minYear;
    UIView *customTitleView;
    BOOL startUp;
}

@property (nonatomic, retain) NSMutableString *userName,*companyName;
@property (nonatomic,retain)     NSDate *startingDate;
@property (nonatomic,retain)     NSDate *endingDate;

@property (nonatomic,retain) 	UISegmentedControl *segmentControl;
@property (nonatomic,retain) NSMutableArray *listArray;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *reportData;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (ReportItem *) displayFetchedDataForType:(NSInteger) type andIdentifierStart:(NSInteger) identifierStart  ;
-(NSInteger) getWeekNumberForDate:(NSDate *)date;
-(NSInteger) getMonthNumberForDate:(NSDate *)date;
-(NSInteger) getYearNumberForDate:(NSDate *)date;

@end
