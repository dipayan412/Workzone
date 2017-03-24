//
//  ActivitySelectionViewController.m
//  MyOvertime
//
//  Created by Ashif on 5/16/13.
//
//

#import "ActivitySelectionViewController.h"

@interface ActivitySelectionViewController ()

@end

@implementation ActivitySelectionViewController

@synthesize selectedActivities;
@synthesize activitiesArray;
@synthesize activitySelectionDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    ActivityModified *mod = [[ActivityModified alloc] init];
    mod.selected = YES;
    mod.activity = nil;
    [array addObject:mod];
    
    for(int i=0; i<self.activitiesArray.count; i++)
    {
        ActivityModified *actMod = [[ActivityModified alloc] init];
        actMod.activity = [self.activitiesArray objectAtIndex:i];
        actMod.selected = NO;
        
        [array addObject:actMod];
    }
    modifiedActivities = [[NSArray alloc] initWithArray:array];
    [array release];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.tableView.editing = NO;
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.userInteractionEnabled = YES;
}

-(void)donePressed:(id)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(ActivityModified *mod in modifiedActivities)
    {
        if(mod.selected)
        {
            [array addObject:mod];
        }
    }
    
    self.selectedActivities = array;
    [array release];
    
    if(self.activitySelectionDelegate)
    {
        [activitySelectionDelegate delegateDidSelectActivities:self.selectedActivities];
    }
}

-(void)cancelPressed:(id)sender
{
    [activitySelectionDelegate delegateDidCancelSelection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modifiedActivities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    ActivityModified *mod = [modifiedActivities objectAtIndex:indexPath.row];
    if(mod.activity == nil)
    {
        cell.textLabel.text = NSLocalizedString(@"TITLE_ALL", nil);
        if (mod.selected)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        cell.textLabel.text = mod.activity.activityTitle;
        if (mod.selected)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModified *mod = [modifiedActivities objectAtIndex:indexPath.row];
    mod.selected = !mod.selected;
    if(indexPath.row == 0)
    {
        for (ActivityModified *mod in modifiedActivities)
        {
            if(mod.activity == nil)
            {
                mod.selected = YES;
            }
            else
            {
                mod.selected = NO;
            }
        }
    }
    else
    {
        for (ActivityModified *mod in modifiedActivities)
        {
            if(mod.activity == nil)
            {
                mod.selected = NO;
            }
        }
    }
    
    [self.tableView reloadData];
}

@end

@implementation ActivityModified

@synthesize activity;
@synthesize selected;

-(void)dealloc
{
    activity = nil;
    [super dealloc];
}

@end
