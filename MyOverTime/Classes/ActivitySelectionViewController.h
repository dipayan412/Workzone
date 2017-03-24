//
//  ActivitySelectionViewController.h
//  MyOvertime
//
//  Created by Ashif on 5/16/13.
//
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "ActivitySelectionDelegate.h"

@interface ActivityModified : NSObject
{
    Activity *activity;
    BOOL selected;
}

@property (nonatomic, retain) Activity *activity;
@property (nonatomic, assign) BOOL selected;

@end

@interface ActivitySelectionViewController : UITableViewController
{
    NSArray *modifiedActivities;
    
    id<ActivitySelectionDelegate> activitySelectionDelegate;
}

@property (nonatomic, retain) NSArray *activitiesArray;
@property (nonatomic , retain) NSMutableArray *selectedActivities;

@property (nonatomic , assign) id<ActivitySelectionDelegate> activitySelectionDelegate;

@end
