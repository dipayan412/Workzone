//
//  HelpViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "HelpViewController.h"
#import "SubscriptionViewController.h"
#import "StaticConstants.h"
#import "MyOvertimeAppDelegate.h"
#import "ExportImportHandler.h"
#import "FAQViewController.h"

@implementation HelpViewController

@synthesize helpContentCell, helpContentView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSString *path = [[NSBundle mainBundle] pathForResource:@"Help" ofType:@"html"];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	
    // rykosoft: added custom encoding for german
    NSStringEncoding encoding = NSUTF8StringEncoding;
    
    NSArray * langs = [ NSLocale preferredLanguages ]; 
    NSString * lang = [ langs count ] ? [ langs objectAtIndex: 0 ] : nil;
    if( [ lang isEqualToString: @"de" ] )
        encoding = NSWindowsCP1252StringEncoding;
    
    NSString *htmlString = [[NSString alloc] initWithData: [readHandle readDataToEndOfFile] 
                                                 encoding: encoding
                            ];
   // htmlString = [htmlString stringByReplacingOccurrencesOfString:@"†" withString:@"Ü"];
	helpContentView.delegate = self;
    helpContentView.opaque = NO;
    helpContentView.backgroundColor = [UIColor clearColor];
    [self.helpContentView loadHTMLString:[htmlString stringByReplacingOccurrencesOfString:@"†" withString:@"Ü"] baseURL:nil];
    [htmlString release];
    
    UIBarButtonItem *import = [[[UIBarButtonItem alloc] initWithTitle:@"Import" style:UIBarButtonItemStyleBordered target:self action:@selector(importDemoFile) ] autorelease];
    self.navigationItem.leftBarButtonItem = import;
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
}

-(void)importDemoFile
{
    FAQViewController *faq = [[FAQViewController alloc] initWithNibName:@"FAQViewController" bundle:nil];
    [self.navigationController pushViewController:faq animated:YES];
    [faq release];
//    [[ExportImportHandler getInstance] importFromBackupFileDemo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app checkIfDataExist];
    
#ifdef INAPP_VERSION	  

    UIBarButtonItem *inappButton = [[[UIBarButtonItem alloc] initWithTitle:kInAppNavigationTitle style:UIBarButtonItemStyleBordered target:self action:@selector(inAppButtonAction:) ] autorelease];
    self.navigationItem.rightBarButtonItem = inappButton;
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
#endif	

	
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return helpContentCell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 340.0;
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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


- (void)dealloc
{
	[helpContentView release];
	[helpContentCell release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
    else
    {
		return YES;
	}	
}	

@end

