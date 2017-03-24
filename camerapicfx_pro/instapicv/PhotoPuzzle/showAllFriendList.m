//
//  showAllFriendList.m
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 6/21/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//
#import "Parse/Parse.h"
#import "showAllFriendList.h"
#import <AddressBook/AddressBook.h>
#import "NSData+Base64.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "Neocortex.h"
#import "iRate.h"
@implementation showAllFriendList
{
    UIButton *editButton;
}
@synthesize list;
@synthesize allFreindList;
@synthesize image;
@synthesize Email;
@synthesize imageNumber;
@synthesize showAll;
@synthesize realImage;
@synthesize totalParts;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [[singletonClass sharedsingletonClass].pool drain];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    list=[[NSArray alloc]initWithArray:allFriends];
    finalList=[[NSMutableArray alloc]init];
    ABAddressBookRef _addressBookRef = ABAddressBookCreate ();
    NSArray* allPeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBookRef);// capacity is only a rough guess, but better than nothing
    for (id record in allPeople) {
            NSString *firstName=(NSString*)ABRecordCopyValue((ABRecordRef)record, kABPersonFirstNameProperty);
            NSString *lastName=(NSString*)ABRecordCopyValue((ABRecordRef)record, kABPersonLastNameProperty);
            
            //            NSStream *email=(NSString*)ABRecordCopyValue((ABRecordRef)record, kABPersonEmailProperty);
            NSString *emailss=@"NULL";
            
            ABMultiValueRef emails = ABRecordCopyValue((ABRecordRef)record, kABPersonEmailProperty);
            for(CFIndex i=0;i<ABMultiValueGetCount(emails);++i) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(emails, i);
                emailss = (NSString *) phoneNumberRef;
            }
            
            NSLog( @"%@",emailss);
        NSString* field;
        if(firstName==nil&&lastName==nil)
            field = [NSString stringWithFormat:@"%@:(null)",emailss];
            else
            field = [NSString stringWithFormat:@"%@:%@",firstName,lastName];
            
            NSMutableArray *recordd=[[[NSMutableArray alloc]init] autorelease];
            
            
            [recordd addObject:field];
            [recordd addObject:emailss];
        if(showAll==NO)
        {
            int i;
            for (i=0; i<[list count]; i++) {
                NSString *email_Id=[[list objectAtIndex:i] objectForKey:@"email"];
                if([email_Id isEqualToString:emailss])
                {
                    break;
                }
            }
            if(i==[list count])
            {
                [finalList addObject:recordd];
            }
        }
        else
            [finalList addObject:recordd];
            
            [firstName release];
            [lastName release];
    }
    CFRelease(_addressBookRef);
    [allPeople release];
    allPeople = nil;
    NSLog(@"%d",[finalList count]);
    
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
//    UIImage *backgroundImage = [UIImage imageNamed:@"header_contact.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame=CGRectMake(0, 2, 40   , 40);
    //    editButton.backgroundColor=[UIColor clearColor];
    editButton.tintColor=nil;
    [editButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIButtonTypeCustom];
    [editButton addTarget:self action:@selector(nameOfSomeMethod:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:editButton] autorelease];
    [self.allFreindList setBackgroundColor:[UIColor clearColor]];
//    [self.allFreindList setBackgroundView:self.view];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}
-(IBAction)nameOfSomeMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [self setAllFreindList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
//    UIImage *backgroundImage = [UIImage imageNamed:@"selectcontactbar.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    //    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header_option.png"];
    //    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBarHidden = YES;
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    [self.view addSubview:iv];
    [self.view addSubview:editButton];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [allFreindList release];
    [super dealloc];
}
#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    [self.allFreindList setBackgroundColor:[UIColor clearColor]];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    [self.allFreindList setBackgroundColor:[UIColor clearColor]];
    return [finalList count];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UILabel *oHAttributedLabel;
    UIImageView *checkImage;
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        CGRect rect=CGRectMake(5, 7, 315, 30);
        oHAttributedLabel=[[UILabel alloc]initWithFrame:rect];
        //        CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height)
        oHAttributedLabel.tag=3;
        oHAttributedLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:oHAttributedLabel];
        checkImage=[[UIImageView alloc]initWithFrame:CGRectMake(270, 0, 40, 40)];
        checkImage.tag=4;
        [cell.contentView addSubview:checkImage];
    }
    NSArray *contact;
    NSArray *innerPart=[finalList objectAtIndex:indexPath.row];
    contact=[[innerPart objectAtIndex:0] componentsSeparatedByString:@":"];
    NSString *fName=[contact objectAtIndex:0];
    NSString *lName=nil;
    if ([contact count]>1) {
        lName=[contact objectAtIndex:1];
    }
    NSString *finalString=@"";
    if ([lName isEqualToString:@"(null)"]) {
        finalString=[[[NSString alloc]initWithFormat:@"%@",fName] autorelease];
    }
    else if ([fName isEqualToString:@"(null)"]) {
        finalString=[[[NSString alloc]initWithFormat:@"%@",lName] autorelease];
    }
    else {
        finalString=[[[NSString alloc]initWithFormat:@"%@ %@",fName, lName] autorelease];
    }
    oHAttributedLabel=(UILabel*)[cell.contentView viewWithTag:3];
    [oHAttributedLabel setFont:[UIFont boldSystemFontOfSize:22]];
    oHAttributedLabel.text=finalString;
    for (int i=0; i<[list count]; i++) {
        NSString *email_Id=[[list objectAtIndex:i] objectForKey:@"email"];
        if([email_Id isEqualToString:[innerPart objectAtIndex:1]])
        {
            checkImage=(UIImageView *)[cell.contentView viewWithTag:4];
            [checkImage setImage:[UIImage imageNamed:@"logomini.png"]];
            
            break;
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *innerPart=[finalList objectAtIndex:indexPath.row];
    int i;
    for (i=0; i<[list count]; i++) {
        NSString *email_Id=[[list objectAtIndex:i] objectForKey:@"email"];
        if([email_Id isEqualToString:[innerPart objectAtIndex:1]])
        {
            NSData *imageData=UIImagePNGRepresentation(image);
            PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
            [imageFile saveInBackground];
            imageData=UIImagePNGRepresentation(realImage);
            PFFile *realimage=[PFFile fileWithName:@"realImage.png" data:imageData];;
            [realimage saveInBackground];
            PFObject *gameScore = [PFObject objectWithClassName:@"Puzzle"];
            [gameScore setObject:email_Id forKey:@"playerEmail"];
            [gameScore setObject:realimage  forKey:@"realImage"];
            [gameScore setObject:imageFile  forKey:@"imageFile"];
            [gameScore setObject:imageNumber  forKey:@"imageNumbers"];
            [gameScore setObject:[NSNumber numberWithInt:totalParts]  forKey:@"totalParts"];
            [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Success!");
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"New Puzzle is sent by %@ to %@",Email,email_Id], @"alert",
                                          [NSNumber numberWithInt:1], @"badge",
                                          nil];
                    NSString *channelName=[[[NSString alloc]initWithFormat:@"PhotoPuzzle%@",[[list objectAtIndex:i] objectForKey:@"udid"]] autorelease];
                    PFPush *push = [[[PFPush alloc] init] autorelease];
                    [push setChannels:[NSArray arrayWithObjects:channelName, nil]];
                    [push setPushToAndroid:false];
                    [push expireAfterTimeInterval:86400];
                    [push setData:data];
                    [push sendPushInBackground];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation!"
                                                                    message:@"Successfully Send Puzzle."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                } else {
                    // There was an error saving the gameScore.
                }
            }];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
    if(i==[list count])
    {
        NSArray *record=[finalList objectAtIndex:indexPath.row];
        if([MFMailComposeViewController canSendMail]){
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
            NSString *subject=@"Check this out!!";
            
            [picker setSubject:subject];
            NSArray *toRecipients = [NSArray arrayWithObject:[record objectAtIndex:1]]; 
            [picker setToRecipients:toRecipients];
            NSData *img=UIImagePNGRepresentation(image);
            [picker addAttachmentData:img mimeType:@"image/png" fileName:@"photopuzzle"];
            //NSString *base64String = [img base64EncodedString];
            NSString *emailString=[NSString stringWithFormat:@"<html><body><a href=\"http://georiot.co/3OeA\">Lets play photo puzzle  with 'Camera Pic FX PRO - Messenger App'</a></body></html>"];
            [picker setMessageBody:emailString isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
            
            picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
            
            [self presentModalViewController:picker animated:YES];
            [picker release];
            
        }
        else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Mail Account" message:@"Please set up a Mail account in order to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
    }
    
}
#pragma mark -
#pragma mark Compose Mail
// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet
{
   // NSLog(@"Form fully Completed!");
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
        NSString *subject=@"Psst…open up!";
        
        [picker setSubject:subject];
        NSArray *toRecipients = [NSArray arrayWithObject:@""]; 
        [picker setToRecipients:toRecipients];
        NSData *img=UIImagePNGRepresentation(image);
        [picker addAttachmentData:img mimeType:@"image/png" fileName:@"photopuzzle"];
        //NSString *base64String = [img base64EncodedString];
        NSString *emailString=[NSString stringWithFormat:@"<html><body><a href=\"http://georiot.co/3OeA\">Click the image to decode my secret Camera Pic Fx Puzzle Photos message.</a></body></html>"];
        [picker setMessageBody:emailString isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
        
        picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    }
    else{
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Mail Account" message:@"Please set up a Mail account in order to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
}
-(void)displayComposer {
	//NSLog(@"pop-up email here");
	[self displayComposerSheet];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Message Sent Successfully."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if(appDelegate.sound==YES)
            {
                [[singletonClass sharedsingletonClass].theAudios1 play];
            }
            [[iRate sharedInstance] promptForRating];
    }
			break;
		case MFMailComposeResultFailed:
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}
@end
