//
//  ActivityBalanceViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>

@interface ActivityBalanceViewController : UITableViewController<MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
{
	UITableViewCell *activityBalanceCell;
	
	UIScrollView *scrollView;
	
	NSManagedObjectContext *managedObjectContext;
	NSArray *reportData;
	
	NSMutableArray *reportRowViews;

}

@property (nonatomic, retain) IBOutlet UITableViewCell *activityBalanceCell;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *reportData;

@property (nonatomic, retain) NSMutableArray *reportRowViews;
@property (nonatomic, retain) NSMutableString *userName,*companyName;

-(IBAction)emailAction:(id)sender;
@end
