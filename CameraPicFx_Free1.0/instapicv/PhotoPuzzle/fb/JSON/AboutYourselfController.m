//
//  AboutYourselfController.m
//  Whosin
//
//  Created by Kumar Aditya on 18/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import "AboutYourselfController.h"
//#import "CommunityHomeController.h"


@implementation AboutYourselfController

@synthesize  label1;
@synthesize label2;
@synthesize  picButton;
@synthesize  saveButton;
@synthesize  skipButton;
@synthesize textView;
@synthesize guid;

 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
 

 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 

 
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)skipButtonClicked
{
//	CommunityHomeController *communityHomeObj = [[CommunityHomeController alloc]initWithNibName:@"CommunityHomeController"  bundle:nil];
//	communityHomeObj.someString=[self groupid];
//	NSLog(@"groupuid in about yourself= %@",[self groupid]);
//	[self.navigationController pushViewController:communityHomeObj animated:YES];
    
}
-(void)saveButtonClicked
{
	//call to web service
	
//   	CommunityHomeController *communityHomeObj = [[CommunityHomeController alloc]initWithNibName:@"CommunityHomeController"  bundle:nil];
//	communityHomeObj.someString=[self groupid];
//	NSLog(@"groupuid in about yourself= %@",[self groupid]);
//	[self.navigationController pushViewController:communityHomeObj animated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
