//
//  CommunityHomeController.m
//  Whosin
//
//  Created by Kumar Aditya on 12/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import "CommunityHomeController.h"
#import "Connections.h"
#import "JSON.h"
#import "HomeScreenController.h"
#import "PeopleAtCommunityController.h"
#import "UserCommentsController.h"
 


@implementation CommunityHomeController

@synthesize scroller;
@synthesize imageview;
@synthesize someString,meButton;
@synthesize dictString,peopleButton;
//@synthesize myTable;
 
//NSString *groupid;
NSDictionary *feed;
 
int a=5,b=5	;
float x[]={45.0,5.0,45.0,20.0,50.0,40.0,48.0,40.0,50.0,60.0,50.0,80.0,210.0,70.0,210,100.0};  

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
		//authorityClass=[[SingeltonAuthorityClass alloc]init];
	     if (self) {
        // Custom initialization.
    }
    return self;
} 

 
 

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	Connections  *con=[[Connections alloc]init];
	
	NSString *authtoken=[SingeltonAuthorityClass getauth_token];
	 dictString=[[NSDictionary alloc]initWithDictionary:
				 [con getCommunityHome:someString:authtoken]];
	
	NSLog(@"community home string %@",[dictString valueForKey:@"result"]);
	//  dictString=[con getCommunityHome:someString:authtoken];
	
 
	[self.navigationController setNavigationBarHidden:NO];
	self.navigationItem.hidesBackButton =NO;
	
	/*
    	NSLog(@"value of guid community home%@",[self someString]);
	NSLog(@"view");
	
	scroller=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 500,1000)]; //fit to screen
	[scroller setScrollEnabled:YES];
	//[scroller setContentSize:CGSizeMake(320, 600)];
	UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(20, 20, 200, 200); // position in the parent view and set the size of the button
	Connections  *con=[[Connections alloc]init];
	
	NSString *authtoken=[SingeltonAuthorityClass getauth_token];
	
	NSLog(@"authontication token from singelton class %@",authtoken);
	NSDictionary *feed=[con getCommunityHome:someString:authtoken];
  

	
    NSArray *streams = (NSArray *)[feed valueForKey:@"result"];
	NSArray *array=(NSArray *)[streams valueForKey:@"items"];
	NSLog(@"This is the  items: %@", [streams valueForKey:@"items"]);
	// loop over all the stream objects and print their titles
	int ndx;
	for (ndx = 0;ndx<(array.count); ndx++) {
		NSDictionary *stream = (NSDictionary *)[array objectAtIndex:ndx];
		NSLog(@"This is the  items: %@", [stream valueForKey:@"description"]);
	}
	NSArray *array1=(NSArray *)[array valueForKey:@"user"];
	NSLog(@"value of name%@",[array1 valueForKey:@"name"]);
	// add targets and actions
    //[myButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	//UIImage *img = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [streams objectForKey:@"icon"]]]];
	//[imageButton setImage:img forState:UIControlStateNormal];
	//UILabel *tmp=[[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 200)]; 
	
	//[tmp setFont:[UIFont fontWithName:@"Arial" size:18]]; tmp.text=@"sagar";
	//tmp.backgroundColor=[UIColor clearColor]; [self.view addSubview:tmp]; [tmp release];
	
	
	UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0.0, 320.0, 30.0)];
	topLabel.textAlignment = UITextAlignmentCenter;
	topLabel.text=@"what's up at dps";
	topLabel.font = [UIFont boldSystemFontOfSize:15.0];
	topLabel.textAlignment = UITextAlignmentLeft;
	topLabel.textColor=[UIColor whiteColor];
	topLabel.backgroundColor=[UIColor blueColor];
	NSLog(@"count is =%i",streams.count); 
	NSLog(@"count is =%i",array.count); 
	NSLog(@"count is =%i",array1.count); 
	int i=0,inc=0;
	for(i=0;i<array.count;i++)
	{
		//UIButton *imageButton1;
		NSDictionary *name = (NSDictionary *)[array1 objectAtIndex:i];
	    UIButton *imageButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
		imageButton1.frame = CGRectMake(a,b+inc,40, 40);
		UIImage *img = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:[name valueForKey:@"icon"]]]];
		[imageButton1 setImage:img forState:UIControlStateNormal];

	 
	 
	//UIImage *btnImage = [UIImage imageNamed:@"dps.png"];
	//imageButton1.frame = CGRectMake(a,b+inc,40, 40);
	//[imageButton1 setImage:btnImage forState:UIControlStateNormal];
	
	NSDictionary *comment = (NSDictionary *)[array objectAtIndex:i];
		//dictionary for comments
		 
          //dictionary for name
		NSLog(@"%@",[name valueForKey:@"icon"]);
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x[0],x[1]+inc, 100.0, 20.0)];
	nameLabel.textAlignment = UITextAlignmentCenter;
	nameLabel.text=(@"%@",[name valueForKey:@"name"]);
	nameLabel.font = [UIFont boldSystemFontOfSize:13.0];
	nameLabel.textColor=[UIColor blueColor];
	nameLabel.textAlignment = UITextAlignmentLeft;
	nameLabel.backgroundColor=[UIColor colorWithWhite:(CGFloat)1 alpha:(CGFloat)0];
	
	
	UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(x[2],x[3]+inc, 100, 20.0)];
	commentLabel.textAlignment = UITextAlignmentCenter;
		commentLabel.text=(@"%@",[comment valueForKey:@"description"]);
	commentLabel.font = [UIFont boldSystemFontOfSize:12.0];
	commentLabel.textAlignment = UITextAlignmentLeft;
	commentLabel.textColor=[UIColor blackColor];
	commentLabel.backgroundColor=[UIColor colorWithWhite:(CGFloat)1 alpha:(CGFloat)0]; 
	NSLog(@"value of comments%@",[comment valueForKey:@"num_comments"]);
	NSString *aNumberString =(@"%@",[comment valueForKey:@"num_comments"]);
		
		int i = [aNumberString intValue];
		
		NSLog(@"value of y is %i",i);
		if (!i) {
			UILabel *numberofCommentLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[4],x[5]+inc, 260.0, 20.0)];
			numberofCommentLabel.textAlignment = UITextAlignmentCenter;
			numberofCommentLabel.text=@"No comments yet"; 
			numberofCommentLabel.font = [UIFont boldSystemFontOfSize:15.0];
			numberofCommentLabel.textColor=[UIColor blackColor];
			numberofCommentLabel.textAlignment = UITextAlignmentLeft;
			numberofCommentLabel.backgroundColor=[UIColor darkGrayColor];
			
			
			
			UILabel *backgroundLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[6],x[7]+inc, 260.0, 50.0)];
			backgroundLabel.backgroundColor=[UIColor lightGrayColor];
			
			UILabel *userCommentedLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[8], x[9]+inc, 200.0, 20.0)];
			userCommentedLabel.textAlignment = UITextAlignmentCenter;
			userCommentedLabel.text=@"Add my comment";
			userCommentedLabel.font = [UIFont boldSystemFontOfSize:12.0];
			userCommentedLabel.textColor=[UIColor blueColor];
			userCommentedLabel.textAlignment = UITextAlignmentLeft;
			userCommentedLabel.backgroundColor=[UIColor lightGrayColor];
		 			
			
			UILabel *time2Label= [[UILabel alloc] initWithFrame:CGRectMake(x[14],115.0+inc, 100.0, 20.0)];
			time2Label.textAlignment = UITextAlignmentCenter;
			time2Label.text=@"just now";
			time2Label.font = [UIFont boldSystemFontOfSize:12.0];
			time2Label.textColor=[UIColor blackColor];
			time2Label.textAlignment = UITextAlignmentRight;
			time2Label.backgroundColor=[UIColor colorWithWhite:(CGFloat)1 alpha:(CGFloat)0];    
			
			[scroller addSubview:backgroundLabel];
			[scroller addSubview:numberofCommentLabel];
			[scroller addSubview:time2Label];
			 
			[scroller addSubview:userCommentedLabel];
			
			inc=inc+100;
		}
		else {
			 
		

	UILabel *numberofCommentLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[4],x[5]+inc, 260.0, 20.0)];
	numberofCommentLabel.textAlignment = UITextAlignmentCenter;
	numberofCommentLabel.text=@"1 comment"; 
	numberofCommentLabel.font = [UIFont boldSystemFontOfSize:12.0];
	numberofCommentLabel.textColor=[UIColor blackColor];
	numberofCommentLabel.textAlignment = UITextAlignmentLeft;
	numberofCommentLabel.backgroundColor=[UIColor darkGrayColor];
	
	
	
	UILabel *backgroundLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[6],x[7]+inc, 260.0, 70.0)];
  	backgroundLabel.backgroundColor=[UIColor lightGrayColor];
	
	UILabel *userCommentedLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[8], x[9]+inc, 200.0, 20.0)];
	userCommentedLabel.textAlignment = UITextAlignmentCenter;
	userCommentedLabel.text=@"yogesh k.";
	userCommentedLabel.font = [UIFont boldSystemFontOfSize:12.0];
	userCommentedLabel.textColor=[UIColor blueColor];
	userCommentedLabel.textAlignment = UITextAlignmentLeft;
	userCommentedLabel.backgroundColor=[UIColor lightGrayColor];
	
	UILabel *userCommentLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[10], x[11]+inc, 100.0, 20.0)];
	userCommentLabel.textAlignment = UITextAlignmentCenter;
	userCommentLabel.text=@"nice";
	userCommentLabel.font = [UIFont boldSystemFontOfSize:12.0];
	userCommentLabel.textColor=[UIColor blackColor];
	userCommentLabel.textAlignment = UITextAlignmentLeft;
	userCommentLabel.backgroundColor=[UIColor lightGrayColor];;
	
	UILabel *time1Label= [[UILabel alloc] initWithFrame:CGRectMake(x[12], x[13]+inc, 100.0, 20.0)];
    time1Label.textAlignment = UITextAlignmentCenter;
    time1Label.text=@"just now";
    time1Label.font = [UIFont boldSystemFontOfSize:12.0];
    time1Label.textColor=[UIColor blackColor];
	time1Label.textAlignment = UITextAlignmentRight;
	time1Label.backgroundColor=[UIColor lightGrayColor];
			
			UILabel *time2Label= [[UILabel alloc] initWithFrame:CGRectMake(x[14], x[15]+inc, 100.0, 20.0)];
			time2Label.textAlignment = UITextAlignmentCenter;
			time2Label.text=@"just now";
			time2Label.font = [UIFont boldSystemFontOfSize:12.0];
			time2Label.textColor=[UIColor blackColor];
			time2Label.textAlignment = UITextAlignmentRight;
			time2Label.backgroundColor=[UIColor colorWithWhite:(CGFloat)1 alpha:(CGFloat)0];
			
				inc=inc+120;
			
			[scroller addSubview:backgroundLabel];
			[scroller addSubview:numberofCommentLabel];
			[scroller addSubview:time1Label];
			[scroller addSubview:userCommentLabel];
			[scroller addSubview:userCommentedLabel];
			[scroller addSubview:time2Label];
			
		}
		
		 
	 
	 
	 
		inc=inc+5;
		
 	 
	[scroller addSubview:imageButton1];
	[scroller addSubview:nameLabel];
	[scroller addSubview:commentLabel];
    
		 
	}
	
	//[scroller addSubview:tmp];
	//[scroller addSubview:imageButton];
	[scroller addSubview:topLabel];
	[[self view] addSubview:scroller];
    [super viewDidLoad];
	 */
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
	
    NSArray *streams = (NSArray *)[dictString valueForKey:@"result"];
	NSArray *array=(NSArray *)[streams valueForKey:@"items"];
  	
	 
	 
	return array.count;
	//return 1;
	 
 
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    sizeofblock=0;
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier"; 
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil)
	{ 
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: SimpleTableIdentifier] autorelease];
		
	}	  	
	 
		
		NSString *authtoken=[SingeltonAuthorityClass getauth_token];
		
		NSLog(@"authontication token from singelton class %@",authtoken);
 
		 
		
 	
		
		NSArray *streams = (NSArray *)[dictString valueForKey:@"result"];
		NSArray *array=(NSArray *)[streams valueForKey:@"items"];
	 
		// loop over all the stream objects and print their titles
 
		NSArray *array1=(NSArray *)[array valueForKey:@"user"];
		NSLog(@"value of name%@",[array1 valueForKey:@"name"]);
	 		
		
		  
		 	//UIButton *imageButton1;
			NSDictionary *name = (NSDictionary *)[array1 objectAtIndex:indexPath.row];
			UIButton *imageButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
			imageButton1.frame = CGRectMake(a,b,40, 40);
			UIImage *img = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:[name valueForKey:@"icon"]]]];
			[imageButton1 setImage:img forState:UIControlStateNormal];
			
			
		 	
			NSDictionary *comment = (NSDictionary *)[array objectAtIndex:indexPath.row];
			//dictionary for comments
			
			//dictionary for name
			NSLog(@"%@",[name valueForKey:@"icon"]);
			UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x[0],x[1], 100.0, 20.0)];
			nameLabel.textAlignment = UITextAlignmentCenter;
			nameLabel.text=(@"%@",[name valueForKey:@"name"]);
			nameLabel.font = [UIFont boldSystemFontOfSize:13.0];
			nameLabel.textColor=[UIColor blueColor];
			nameLabel.textAlignment = UITextAlignmentLeft;
			nameLabel.backgroundColor=[UIColor colorWithWhite:(CGFloat)1 alpha:(CGFloat)0];
			
			
			UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(x[2],x[3], 100, 20.0)];
			commentLabel.textAlignment = UITextAlignmentCenter;
			commentLabel.text=(@"%@",[comment valueForKey:@"description"]);
			commentLabel.font = [UIFont boldSystemFontOfSize:12.0];
			commentLabel.textAlignment = UITextAlignmentLeft;
			commentLabel.textColor=[UIColor blackColor];
			commentLabel.backgroundColor=[UIColor colorWithWhite:(CGFloat)1 alpha:(CGFloat)0]; 
			NSLog(@"value of comments%@",[comment valueForKey:@"num_comments"]);
			NSString *aNumberString =(@"%@",[comment valueForKey:@"num_comments"]);
			
			int i = [aNumberString intValue];
			
			NSLog(@"value of y is %i",i);
			if (!i) {
				UILabel *numberofCommentLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[4],x[5], 260.0, 20.0)];
				numberofCommentLabel.textAlignment = UITextAlignmentCenter;
				numberofCommentLabel.text=@"No comments yet"; 
				numberofCommentLabel.font = [UIFont boldSystemFontOfSize:15.0];
				numberofCommentLabel.textColor=[UIColor blackColor];
				numberofCommentLabel.textAlignment = UITextAlignmentLeft;
				numberofCommentLabel.backgroundColor=[UIColor darkGrayColor];
				
				
				
				UILabel *backgroundLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[6],x[7], 260.0, 50.0)];
				backgroundLabel.backgroundColor=[UIColor lightGrayColor];
				
				UILabel *userCommentedLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[8], x[9], 200.0, 20.0)];
				userCommentedLabel.textAlignment = UITextAlignmentCenter;
				userCommentedLabel.text=@"Add my comment";
				userCommentedLabel.font = [UIFont boldSystemFontOfSize:12.0];
				userCommentedLabel.textColor=[UIColor blueColor];
				userCommentedLabel.textAlignment = UITextAlignmentLeft;
				userCommentedLabel.backgroundColor=[UIColor lightGrayColor];
				
				
				UILabel *time2Label= [[UILabel alloc] initWithFrame:CGRectMake(x[14],85.0, 100.0, 20.0)];
			 
				NSLog(@"time ===%@",[comment valueForKey:@"since_created"]);
				NSString *intString =(@"%@",[comment valueForKey:@"since_created"]);
				
				int millsec = [intString intValue];
				time2Label.text=[self timeConverter:millsec];
				time2Label.font = [UIFont boldSystemFontOfSize:12.0];
				time2Label.textColor=[UIColor blackColor];
				time2Label.textAlignment = UITextAlignmentRight;
				time2Label.backgroundColor=[UIColor colorWithWhite:(CGFloat)1 alpha:(CGFloat)0];    
				
				[cell.contentView addSubview:backgroundLabel];
				[cell.contentView addSubview:numberofCommentLabel];
				[cell.contentView addSubview:time2Label];
				[cell.contentView addSubview:userCommentedLabel];
				sizeofblock=70;
				 			}
			else {
				
				NSArray *otherComments=(NSArray *)[array valueForKey:@"comments"];
				NSDictionary *otherCommentDict=(NSDictionary *)[otherComments objectAtIndex:indexPath.row];

				NSArray *otherUser=(NSArray *)[otherComments valueForKey:@"user"];
				NSDictionary *otherDict=(NSDictionary *)[otherUser objectAtIndex:indexPath.row];
		      			 
				NSLog(@"name of commented user===%@",[otherDict valueForKey:(@"name")]);
			 
				UILabel *numberofCommentLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[4],x[5], 260.0, 20.0)];
				numberofCommentLabel.textAlignment = UITextAlignmentCenter;
				NSString *no=[[NSString alloc]initWithFormat:@ "%@",[comment valueForKey:@"num_comments"]];
				[numberofCommentLabel setText:[no stringByAppendingFormat:@"comments"]]; 
				numberofCommentLabel.font = [UIFont boldSystemFontOfSize:12.0];
				numberofCommentLabel.textColor=[UIColor blackColor];
				numberofCommentLabel.textAlignment = UITextAlignmentLeft;
				numberofCommentLabel.backgroundColor=[UIColor darkGrayColor];
				
				
				
				UILabel *backgroundLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[6],x[7], 260.0, 65.0)];
				backgroundLabel.backgroundColor=[UIColor lightGrayColor];
				
				
				
				UILabel *userCommentedLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[8], x[9], 150.0, 20.0)];
				userCommentedLabel.textAlignment = UITextAlignmentCenter;
				NSString *demo=[[NSString alloc]initWithFormat:@ "%@",[otherDict valueForKey:(@"firstname")]]; 
				NSLog(@"demo=======%@",[demo stringByAppendingFormat:@"comments"]);
			 	NSString *newStr = [demo substringFromIndex:1];
				newStr = [newStr substringToIndex:[newStr length]-1];
				newStr=[newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				NSString *demo1=[[NSString alloc]initWithFormat:@ "%@",[otherDict valueForKey:(@"lastname")]]; 

				
				
				NSString *lastName= [demo1 substringFromIndex:1];
				lastName=[lastName substringFromIndex:1];
				lastName = [lastName substringToIndex:[lastName length]-1];
				lastName=[lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				lastName = [lastName substringToIndex:[lastName length]-[lastName length]+1];
				lastName = [lastName stringByAppendingString:@"."];
				newStr = [newStr stringByAppendingString:@" "];
				newStr = [newStr stringByAppendingString:lastName];
				NSLog(@"last name is =%@",lastName);
         
				
				
				[userCommentedLabel setText:newStr];
			    userCommentedLabel.font = [UIFont boldSystemFontOfSize:12.0];
				userCommentedLabel.textColor=[UIColor blueColor];
				userCommentedLabel.textAlignment = UITextAlignmentLeft;
				userCommentedLabel.backgroundColor=[UIColor lightGrayColor];
		
				
				
				UILabel *userCommentLabel= [[UILabel alloc] initWithFrame:CGRectMake(x[10], x[11], 100.0, 20.0)];
				userCommentLabel.textAlignment = UITextAlignmentCenter;
				NSString *commentString=[[NSString alloc]initWithFormat:@ "%@",[otherCommentDict valueForKey:@"value"]];
				NSLog(@"%@",commentString);
				
				commentString=[commentString substringFromIndex:2];
				commentString = [commentString substringToIndex:[commentString length]-2];
				commentString=[commentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				[userCommentLabel setText:commentString];
				userCommentLabel.font = [UIFont boldSystemFontOfSize:12.0];
				userCommentLabel.textColor=[UIColor blackColor];
				userCommentLabel.textAlignment = UITextAlignmentLeft;
				userCommentLabel.backgroundColor=[UIColor lightGrayColor];
			    NSLog(@"comment sucessful");
		
				
				
				UILabel *time1Label= [[UILabel alloc] initWithFrame:CGRectMake(x[12], x[13], 100.0, 20.0)];
				time1Label.textAlignment = UITextAlignmentCenter;
				NSLog(@"since created=%@",[otherCommentDict valueForKey:@"since_created"]);
	
				
				
				NSString *time=[[NSString alloc]initWithFormat:@ "%@",[otherCommentDict valueForKey:@"since_created"]]; 
				NSString *timeString = [time substringFromIndex:1];
				timeString = [timeString substringToIndex:[timeString length]-1];
				timeString=[timeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
				
				
				 
				int millsec1 = [timeString intValue];
				//NSLog(@"value of millisec  \t %@ \t %i",millsec1,timeString);
				time1Label.text=[self timeConverter:millsec1];
				time1Label.font = [UIFont boldSystemFontOfSize:12.0];
				time1Label.textColor=[UIColor blackColor];
				time1Label.textAlignment = UITextAlignmentRight;
				time1Label.backgroundColor=[UIColor lightGrayColor];
				
				
				NSString *intString =(@"%@",[comment valueForKey:@"since_created"]);
				int millsec = [intString intValue];
				UILabel *time2Label= [[UILabel alloc] initWithFrame:CGRectMake(x[14], x[15], 100.0, 20.0)];
				time2Label.textAlignment = UITextAlignmentCenter;
				time2Label.text=[self timeConverter:millsec];
				time2Label.font = [UIFont boldSystemFontOfSize:12.0];
				time2Label.textColor=[UIColor blackColor];
				time2Label.textAlignment = UITextAlignmentRight;
				time2Label.backgroundColor=[UIColor colorWithWhite:(CGFloat)1 alpha:(CGFloat)0];
				
			 				
				[cell.contentView addSubview:backgroundLabel];
				[cell.contentView addSubview:numberofCommentLabel];
				[cell.contentView addSubview:time1Label];
				[cell.contentView addSubview:userCommentLabel];
				[cell.contentView addSubview:userCommentedLabel];
				[cell.contentView addSubview:time2Label];
				sizeofblock=120;
				
			}
			
			
			
			
		 			
			
			[cell.contentView addSubview:imageButton1];
			[cell.contentView addSubview:nameLabel];
			[cell.contentView addSubview:commentLabel];
			
			
		
		
		
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 120;
}

-(IBAction)peopleButtonClicked:(UIButton *)sender
{ 	 
	PeopleAtCommunityController *peopleObj = [[PeopleAtCommunityController alloc]initWithNibName:@"PeopleAtCommunityController" bundle:nil];
	[peopleObj setGuid:[self someString]];
	[self.navigationController pushViewController:peopleObj animated:YES];
	

}
-(IBAction)meButtonClicked:(UIButton *)sender
{

}
-(IBAction)homeButtonClicked
{
 
	 
	HomeScreenController *homeObj = [[HomeScreenController alloc]initWithNibName:@"HomeScreenController" bundle:nil];
	[self.navigationController pushViewController:homeObj animated:YES];
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *streams = (NSArray *)[dictString valueForKey:@"result"];
	NSArray *array=(NSArray *)[streams valueForKey:@"items"];
 
	     
	NSArray *array1=(NSArray *)[array valueForKey:@"user"];
	NSDictionary *name = (NSDictionary *)[array1 objectAtIndex:indexPath.row];

	
	UserCommentsController *userObj = [[UserCommentsController alloc]initWithNibName:@"UserCommentsController" bundle:nil];
	NSLog(@"%@",[name valueForKey:@"guid"]);
	//NSString *inStr = [NSString stringWithFormat:@"%d",[name valueForKey:@"guid"]];
	NSLog(@"%@",[name valueForKey:@"guid"]);
	[userObj setUserguid:[name valueForKey:@"guid"]];
	[self.navigationController pushViewController:userObj animated:YES];
	
}

-(NSString *)timeConverter:(int)seconds
{
	 	
    	
	int minutes = seconds / 60;
	
	seconds %= 60;
	
	int hours = minutes / 60;
	
	minutes %= 60;
	
	int days = hours / 24;
	
	hours %= 24;
	NSLog(@"days=%i \t hours=%i \t minutes=%i",days,hours,minutes);

	if(days>=1)
	{   NSString *intString = [NSString stringWithFormat:@"%d", days];
		NSString *str=[[NSString alloc] initWithString:@" days ago"];
		return [intString stringByAppendingString:str];
	}
	else if(hours>=1){
		NSString *intString = [NSString stringWithFormat:@"%d", hours];
		NSString *str=[[NSString alloc] initWithString:@" hours ago"];
		return [intString stringByAppendingString:str];
	}
	
	else if(minutes>=1){
		NSString *intString = [NSString stringWithFormat:@"%d", minutes];
		NSString *str=[[NSString alloc] initWithString:@" minutes ago"];
		return [intString stringByAppendingString:str];
	}
    else {
		   return @"just now";
	     }

    return @"error";

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


/*
 
 int milliseconds = someNumber;
 
 int seconds = milliseconds / 1000;
 
 int minutes = seconds / 60;
 
 seconds %= 60;
 
 int hours = minutes / 60;
 
 minutes %= 60;
 
 int days = hours / 24;
 
 hours %= 24;
 
 if()
 */

