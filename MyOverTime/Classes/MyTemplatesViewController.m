//
//  MyTemplatesViewController.m
//  MyOvertime
//
//  Created by Ashif on 2/19/13.
//
//

#import "MyTemplatesViewController.h"
#import "MyOvertimeAppDelegate.h"
#import "TemplateDetailViewController.h"

@interface MyTemplatesViewController ()

-(void)fetchMyTemplates;

@end

@implementation MyTemplatesViewController

@synthesize myTemplates;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)reloadFetchedResults:(NSNotification*)note
{
    NSLog(@"Underlying data changed ... refreshing!");
    
    [self fetchMyTemplates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"TEMPLATE_LIST_HEADER", nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadFetchedResults:)
                                                 name:@"iCloudDataChanged"
                                               object:[[UIApplication sharedApplication] delegate]];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchMyTemplates];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
    
    
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = myImageView;
	[myImageView release];
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
    return myTemplates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
//        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundColor  = [UIColor colorWithWhite:1.0 alpha:0.6];
        cell.selectionStyle  = UITableViewCellSelectionStyleGray;
    }
    
    MyTemplate *template = [self.myTemplates objectAtIndex:indexPath.row];
    
    cell.textLabel.text = template.templateName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTemplate *template = [self.myTemplates objectAtIndex:indexPath.row];
    TemplateDetailViewController *templateVC = [[TemplateDetailViewController alloc] initWithNibName:@"TemplateDetailViewController" bundle:nil];
    templateVC.myTemplate = template;
    [self.navigationController pushViewController:templateVC animated:YES];
    [templateVC release];
}

-(void)fetchMyTemplates
{
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = app.managedObjectContext;
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"MyTemplate" inManagedObjectContext:managedObjectContext];
    [req setEntity:ent];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [req setSortDescriptors:sortDescriptors];
    
    NSError *err = nil;
    NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
    if (mutableFetchResults1 == nil || mutableFetchResults1.count < 1)
    {
        
    }
    else
    {
        self.myTemplates = [[NSArray alloc] initWithArray:[mutableFetchResults1 mutableCopy]];
        [self.tableView reloadData];
    }
}

@end
