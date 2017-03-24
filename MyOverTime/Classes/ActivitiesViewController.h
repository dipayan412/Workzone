//
//  ActivitiesViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ActivitiesViewController : UITableViewController {
	NSMutableArray *activitiesList;
	
	NSManagedObjectContext *managedObjectContext;
    BOOL showInsert;

}

@property (nonatomic, retain) NSMutableArray *activitiesList;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
