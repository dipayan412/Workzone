//
//  ActivitiesViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "ActivityDetailViewController.h"
#import "Activity.h"

@implementation ActivitiesViewController

@synthesize activitiesList;

@synthesize managedObjectContext;

#pragma mark -
#pragma mark View lifecycle
#pragma mark -
#pragma mark View lifecycle

- (void)reloadFetchedResults:(NSNotification*)note
{
    NSLog(@"Underlying data changed ... refreshing!");
    
    [self fetchActivities];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadFetchedResults:)
                                                 name:@"iCloudDataChanged"
                                               object:[[UIApplication sharedApplication] delegate]];
	
    self.editing=YES;
    self.tableView.editing=YES;
    self.tableView.allowsSelectionDuringEditing=YES;

    UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addActivity:)];
    self.navigationItem.rightBarButtonItem = add;

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	self.navigationItem.title = NSLocalizedString(@"ACTIVITIES_LIST_TITLE", @"");
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];		
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage)) {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}	
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = myImageView;
	[myImageView release];
    
    [self fetchActivities];
}

-(void)fetchActivities
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isEnabled == %@", [NSNumber numberWithBool:YES]];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil)
    {
		// Handle the error.
	}
    if(self.activitiesList) [activitiesList removeAllObjects];
    
	self.activitiesList = mutableFetchResults;
	
	[mutableFetchResults release];
	[request release];
	
	[self.tableView reloadData];
}

-(IBAction)addActivity:(id)sender
{
    ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] initWithNibName:@"ActivityDetailViewController" bundle:[NSBundle mainBundle]];
    Activity *activity = (Activity*)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
    activity.activityTitle = @"";
    activity.estimateMode = [NSNumber numberWithBool:YES];
    activity.isEnabled = [NSNumber numberWithBool:YES];
    activity.subSequence = [NSNumber numberWithInt:[activitiesList count]];
    activity.useDefault = [NSNumber numberWithBool:NO];
    activity.offsetValue = [NSNumber numberWithInt:480];
    activity.showAmount = [NSNumber numberWithBool:NO];
    activity.amount = [NSNumber numberWithFloat:0.0f];
    
    activityDetail.managedObjectContext = managedObjectContext;
    activityDetail.currentActivity = activity;
    activityDetail.isNew = YES;
    [self.navigationController pushViewController:activityDetail animated:YES];
    [activityDetail release];
}
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ([activitiesList count]);

   /*
    else {
		return [activitiesList count]+1;
	}*/
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.backgroundColor = [UIColor clearColor];
	}

	if (indexPath.row < [activitiesList count]) {
		Activity *activity = (Activity*)[activitiesList objectAtIndex:indexPath.row];
		cell.textLabel.text = activity.activityTitle;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    /*else {
		cell.textLabel.text = NSLocalizedString(@"ACTIVITIES_LIST_NEW_ITEM", @"");
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;

	}*/
	
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row == [self.activitiesList count])
    {
        return YES;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (editingStyle == UITableViewCellEditingStyleDelete)
    {
		Activity *activity = (Activity*)[activitiesList objectAtIndex:indexPath.row];
		activity.isEnabled = [NSNumber numberWithBool:NO];
		activity.subSequence = [NSNumber numberWithInt:-1];

		NSError *error;
		if (![managedObjectContext save:&error])
        {
			// Handle the error.
		}	
		
		[self.activitiesList removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
		
	}
	
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
	[super setEditing:editing animated:animate];
	[self.tableView setEditing:editing animated:animate];
	if (!editing) {
        self.navigationItem.leftBarButtonItem = nil;
		/*NSIndexPath *indexPathForAdd = [NSIndexPath indexPathForRow:[self.activitiesList count] inSection:0];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForAdd] withRowAnimation:UITableViewRowAnimationTop];
		[self.tableView scrollToRowAtIndexPath:indexPathForAdd atScrollPosition:UITableViewScrollPositionMiddle animated:YES];*/
        for ( int i=0;i<[activitiesList count];i++) {
            Activity *activity = (Activity*)[activitiesList objectAtIndex:i];
            activity.subSequence=[NSNumber numberWithInt:i];
        }
        NSError *error;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
        [self.navigationController popViewControllerAnimated:YES];


	} else {
        
		//NSIndexPath *indexPathForAdd = [NSIndexPath indexPathForRow:[self.activitiesList count] inSection:0];
		//[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForAdd] withRowAnimation:UITableViewRowAnimationTop];
       
	}	
}	

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == [self.activitiesList count ]) {
		return UITableViewCellEditingStyleInsert;
	}
    
    else {
		return UITableViewCellEditingStyleDelete;
	}
}	

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] initWithNibName:@"ActivityDetailViewController" bundle:[NSBundle mainBundle]];
	activityDetail.currentActivity = [activitiesList objectAtIndex:indexPath.row];
	activityDetail.managedObjectContext = managedObjectContext;
	[self.navigationController pushViewController:activityDetail animated:YES];
	[activityDetail release];
}
- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==[activitiesList count]) {
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    NSUInteger fromRow = [fromIndexPath row];
    NSUInteger toRow = [toIndexPath row];
    
    id object = [activitiesList objectAtIndex:fromRow] ;
    [activitiesList removeObjectAtIndex:fromRow];
    [activitiesList insertObject:object atIndex:toRow];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[activitiesList release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


@end

