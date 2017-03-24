//
//  FAQViewController.m
//  MyOvertime
//
//  Created by Ashif on 6/15/13.
//
//

#import "FAQViewController.h"
#import "FAQDetailsViewController.h"
#import "SupportViewController.h"
#import "SubscriptionViewController.h"
#import "MyOvertimeAppDelegate.h"

#define MOT_APP_ID @"453442811"
#define MOT_iAPP_APP_ID @"523417947"

@interface FAQViewController ()

@property (nonatomic, retain) NSArray * listItems;

@end

@implementation FAQViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.listItems = [NSArray arrayWithObjects:NSLocalizedString(@"TITLE_FAQ", nil),NSLocalizedString(@"TITLE_SUPPORT", nil), NSLocalizedString(@"TITLE_REVIEW", nil), nil];
    
#ifdef INAPP_VERSION
    
    NSString *inAppItem = kInAppNavigationTitle;
    
//    inAppItem = [inAppItem stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.listItems = [NSArray arrayWithObjects:NSLocalizedString(@"TITLE_FAQ", nil),NSLocalizedString(@"TITLE_SUPPORT", nil), NSLocalizedString(@"TITLE_REVIEW", nil), inAppItem, nil];
    
#endif
}

-(void)viewWillAppear:(BOOL)animated
{
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
    faqView.backgroundView = myImageView;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
	[myImageView release];
    
//    faqView.backgroundColor = [UIColor  colorWithWhite:1.0f alpha:0.5f];
//    faqView.backgroundView = nil;
    
    /*
#ifdef INAPP_VERSION
    
    UIBarButtonItem *inappButton = [[[UIBarButtonItem alloc] initWithTitle:kInAppNavigationTitle style:UIBarButtonItemStyleBordered target:self action:@selector(inAppButtonAction:) ] autorelease];
    self.navigationItem.rightBarButtonItem = inappButton;
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
#endif
    */
    
    MyOvertimeAppDelegate *app = (MyOvertimeAppDelegate*) [[UIApplication sharedApplication] delegate];
    if(app.fromAlert)
    {
        app.fromAlert = NO;
        
        SubscriptionViewController *controller=[[[SubscriptionViewController alloc]init]autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(IBAction)inAppButtonAction:(id)sender
{
    SubscriptionViewController *controller=[[[SubscriptionViewController alloc]init]autorelease];
    [self.navigationController pushViewController:controller animated:YES];
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
    return self.listItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        cell.backgroundView = nil;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [self.listItems objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        FAQDetailsViewController *detailVC = [[FAQDetailsViewController alloc] initWithNibName:@"FAQDetailsViewController" bundle:nil];
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
    }
    else if (indexPath.row == 1)
    {
        SupportViewController *detailVC = [[SupportViewController alloc] initWithNibName:@"SupportViewController" bundle:nil];
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
    }
    else if(indexPath.row == 2)
    {
        NSString *templateReviewURL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
        
        NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", MOT_APP_ID]];
        
#ifdef INAPP_VERSION
        
        reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", MOT_iAPP_APP_ID]];
        
#endif  
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    }
    else
    {
        SubscriptionViewController *controller=[[[SubscriptionViewController alloc]init]autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
