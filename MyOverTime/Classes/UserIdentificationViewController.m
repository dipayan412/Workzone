//
//  UserIdentificationViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "UserIdentificationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalFunctions.h"
#import "NSString+Validation.h"

@implementation UserIdentificationViewController

@synthesize userIdentificationCell;

@synthesize settingsDictionary;

@synthesize userName, companyName;

@synthesize email;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"MY_HEADING", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];		
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	self.settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	if (([[self.settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}	
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = myImageView;
	[myImageView release];
			
	userName.text = [settingsDictionary objectForKey:@"userName"];
	companyName.text = [settingsDictionary objectForKey:@"companyName"];
    
    self.email = [GlobalFunctions getDefaultEmail];
    emailField.text = [GlobalFunctions getDefaultEmail];
    
    descriptionView.text = NSLocalizedString(@"USER_IDENTIFICATION_DESCRIPTION", nil);
    
    descriptionView.layer.borderColor = [UIColor grayColor].CGColor;
    descriptionView.layer.borderWidth = 1.0f;
    descriptionView.layer.cornerRadius = 7.0f;
    descriptionView.editable = NO;
}

-(void)setDescription:(NSString*)string forKey:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:string forKey:key];
	[prefs synchronize];
}

-(NSString*)getDescriptionFromCache:(NSString*)key
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *str = [prefs stringForKey:key];
    return str;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
	[settingsDictionary setObject:userName.text forKey:@"userName"];
	[settingsDictionary setObject:companyName.text forKey:@"companyName"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	[self.settingsDictionary writeToFile:path atomically:YES];
}

///*
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
//*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return userIdentificationCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 355.0f;
}

#pragma mark -
#pragma mark TextField delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTextInput)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void) hideTextInput
{
    [emailField resignFirstResponder];
    [userName resignFirstResponder];
    [companyName resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == emailField)
    {
        if([emailField.text validateEmail])
        {
            [GlobalFunctions setdefaultEmail:emailField.text];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BACKUP_ERROR_MESSAGE", nil) message:NSLocalizedString(@"BACKUP_EMAIL_VALIDATION_ERROR_MESSAGE", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        
        [textField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
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
	[userIdentificationCell release];
	
	[settingsDictionary release];
	
	[userName release];
	[companyName release];
    
    [self.email release];
	
    [super dealloc];
}


@end

