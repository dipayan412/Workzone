//
//  gameView.m
//  Puzzle
//
//  Created by muhammad sami ather on 6/6/12.
//  Copyright (c) 2012 swengg-co. All rights reserved.
//

#import "gameView.h"
#import <Twitter/Twitter.h>
#import "showAllFriendList.h"
#import "FbGraphFile.h"
#import "AppDelegate.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "Parse/Parse.h"
#import <QuartzCore/QuartzCore.h>
#import "Neocortex.h"
#import "iRate.h"
#import "RateManager.h"

#define easyTopY 104+46
#define mediumTopY 83.33+46
#define hardTopY 69.33+46

@implementation gameView
{
    UIAlertView *congrats;
    
    UIButton *editButton;
    UIButton *backButton;
    
    UIImageView *iv;
    
    
    UIView *navigationBarView;
}
@synthesize imageView;
@synthesize complexityLevel;
@synthesize image;
@synthesize text;
@synthesize textplace;
@synthesize fontselection;
@synthesize Shareimage;
@synthesize Email;
@synthesize shareActionSheet;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

/*
#pragma mark - PlayHaven
-(void)loadPlayHaven
{
    PHPublisherContentRequest * request = [PHPublisherContentRequest requestForApp:PLAYHAVEN_APP_TOKEN secret:PLAYHAVEN_APP_SECRET placement:@"main_menu" delegate:self];
    [request setShowsOverlayImmediately:true];
    [request setAnimated:true];
    [request send];
}
#pragma mark - Playhaven PHPublisherdelegate
-(void)requestDidGetContent:(PHPublisherContentRequest *)request
{
    NSLog(@"requestDidGetContent");
    NSLog(@"requestDidGetContent");
}
-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content
{
    NSLog(@"contentDidDisplay");
    NSLog(@"contentDidDisplay");
}
-(void)request:(PHPublisherContentRequest *)request contentDidDismissWithType:(PHPublisherContentDismissType *)type
{
    NSLog(@"contentDidDismissWithType");
    NSLog(@"contentDidDismissWithType");
}

-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    NSLog(@"didFailWithError");
}
*/

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar.2.png"]] autorelease];
    NSString *client_id = @"399978386739457";
	
	//alloc and initalize our FbGraph instance
	fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view from its nib.
    //    UINavigationBar *navBar = [[self navigationController] navigationBar];
    //    UIImage *backgroundImage = [UIImage imageNamed:@"bar.2.png"];
    //    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    imageView.image=image;
    editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame=CGRectMake(10, 3, 40, 40);
    //    editButton.backgroundColor=[UIColor clearColor];
    editButton.tintColor=nil;
    [editButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(nameOfSomeMethod:) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:editButton] autorelease];
    ////////////Done Button//////////////
    
    backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(270, 3, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"export.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(addimage:) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];;
    Shareimage=[[UIImage alloc]init];
    
    ///////////////////////////////////////////////////////
    
    NSArray *fonts=[fontselection componentsSeparatedByString:@","];
    
    textLabel=[[UILabel alloc]init];
    textLabel.text=text;
    
    int fontNumber=0;
    if([[fonts objectAtIndex:1] isEqualToString:@"Small"])
    {
        fontNumber=15;
    }
    else if([[fonts objectAtIndex:1] isEqualToString:@"Medium"])
    {
        fontNumber=25;
    }
    else if ([[fonts objectAtIndex:1] isEqualToString:@"Large"])
    {
        fontNumber=40;
    }
    textLabel.font=[UIFont fontWithName:[fonts objectAtIndex:0] size:fontNumber];
    [self.view addSubview:textLabel];
    
    textLabel.textAlignment=UITextAlignmentCenter;
    
    if([textplace isEqualToString:@"Top"])
    {
        [textLabel setFrame:CGRectMake((320-300)/2, 50, 300, 50)];
    }
    else if([textplace isEqualToString:@"Bottom"])
    {
        [textLabel setFrame:CGRectMake((320-300)/2, 365, 300, 50)];
    }
    else if([textplace isEqualToString:@"Middle"])
    {
        [textLabel setFrame:CGRectMake((320-300)/2, (440-50)/2, 300, 50)];
    }
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextColor:[UIColor whiteColor]];
    imageView.image=[self changetoimage1];
    imageView.image=[self imageWithImage:imageView.image convertToSize:CGSizeMake(320, 416)];
    //NSLog(@"%@",NSStringFromCGSize(imageView.image.size));
    imagePieces=[[NSMutableArray alloc]init];
    imagerects=[[NSMutableArray alloc]init];
    alreadyDoneRects=[[NSMutableArray alloc]init];
    x=0;
    y=0;
    if([complexityLevel isEqualToString:@"Easy"])
    {
        
        x=2;
        y=4;
        [self easyPuzzle];
    }
    else if([complexityLevel isEqualToString:@"Medium"])
    {
        x=3;
        y=5;
        [self mediumPuzzle];
    }
    else if([complexityLevel isEqualToString:@"Hard"])
    {
        x=5;
        y=6;
        [self hardPuzzle];
    }
    textLabel.hidden=YES;
    imageView.hidden=YES;
    //    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header_shareWithFriends.png"];
    //    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBarHidden = YES;
    iv = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    
    navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
    
    [navigationBarView addSubview:iv];
    [navigationBarView addSubview:editButton];
    [navigationBarView addSubview:backButton];
}
-(IBAction)nameOfSomeMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [fbGraph release];
    [imagePieces release];
    imagePieces=nil;
    [imagerects release];
    imagerects=nil;
    [textLabel release];
    textLabel=nil;
    [image release];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:navigationBarView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)dealloc {
//    self.shareActionSheet.delegate = nil;
    [self.shareActionSheet release];
    [imageView release];
    [super dealloc];
}
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    
    //Note: this is autoreleased
    return img;
}
- (UIImage *)imageWithImage:(UIImage *)image1 convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return destImage;
}
- (UIImage*) maskImage:(UIImage *)image1 withMask:(UIImage *)maskImage {
    
	CGImageRef maskRef = maskImage.CGImage; 
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask([image1 CGImage], mask);
	return [UIImage imageWithCGImage:masked];
    
}
- (UIImage *) changetoimage
{
    CGSize sss=self.view.frame.size;
    
    UIGraphicsBeginImageContext(sss);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *getimage;
    getimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getimage;
}
- (UIImage *) changetoimage:(UIImageView *)EditView
{
    CGSize sss=EditView.frame.size;
    
    UIGraphicsBeginImageContext(sss);
    [EditView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *getimage;
    getimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getimage;
}
- (UIImage *) changetoimage1
{
    CGSize sss=CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    
    UIGraphicsBeginImageContext(sss);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *getimage;
    getimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getimage;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(imageView.hidden==YES)
    {
    UITouch *touch = [[touches objectEnumerator] nextObject];
    location1 = [touch locationInView:self.view];
    for (int i=[imagePieces count]-1; i>=0; i--) {
        UIImageView *tempImage=[imagePieces objectAtIndex:i];
        if(CGRectContainsPoint(tempImage.frame, location1))
        {
            touchedObjectNumber=i;
            [tempImage setFrame:CGRectMake(location1.x-tempImage.frame.size.width/2, location1.y-tempImage.frame.size.height/2, tempImage.frame.size.width, tempImage.frame.size.height)];
            [self.view bringSubviewToFront:tempImage];
            tempImage=nil;
            break;
        }
    }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches objectEnumerator] nextObject];
    CGPoint location2 = [touch locationInView:self.view];
    if(imageView.hidden==YES)
    {
        UIImageView *tempImage=[imagePieces objectAtIndex:touchedObjectNumber];
        [tempImage setFrame:CGRectMake(location2.x-tempImage.frame.size.width/2, location2.y-tempImage.frame.size.height/2, tempImage.frame.size.width, tempImage.frame.size.height)];
        tempImage=nil;
    }
    
    [self.view bringSubviewToFront:navigationBarView];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches objectEnumerator] nextObject];
    CGPoint location2 = [touch locationInView:self.view];
    if(imageView.hidden==YES)
    {
        int i;
        for (i=0; i<(x*y); i++) {
            CGRect holeRect=[[imagerects objectAtIndex:i] CGRectValue];
            if(CGRectContainsPoint(holeRect, location2))
            { 
                int replace=[[alreadyDoneRects objectAtIndex:i] intValue];
                int replace1=[[alreadyDoneRects objectAtIndex:touchedObjectNumber] intValue];
                [alreadyDoneRects replaceObjectAtIndex:touchedObjectNumber withObject:[NSNumber numberWithInt:replace]];
                [alreadyDoneRects replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:replace1]];
                break;
            }
        }
        if([complexityLevel isEqualToString:@"Easy"])
        {
            
            x=2;
            y=4;
            [self easyPuzzlePlay:touchedObjectNumber:i];
        }
        else if([complexityLevel isEqualToString:@"Medium"])
        {
            x=3;
            y=5;
            [self mediumPuzzlePlay:touchedObjectNumber:i];
        }
        else if([complexityLevel isEqualToString:@"Hard"])
        {
            x=5;
            y=6;
            [self hardPuzzlePlay:touchedObjectNumber:i];
        }
        for (i=0; i<[alreadyDoneRects count]; i++) {
            if(i!=[[alreadyDoneRects objectAtIndex:i] intValue])
            { 
                break;
            }
        }
        if(i==[alreadyDoneRects count])
        {
            imageView.hidden=NO;
            congrats=[[UIAlertView alloc]initWithTitle:@"Congratulation's" message:@"You have successfully completed the Puzzle." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,  nil];
            [congrats show];
            [congrats release];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == congrats)
    {
        [[RateManager sharedManager] showReviewApp];
    }
}

- (UIImage *)changetoimage2
{
    CGSize sss=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    UIGraphicsBeginImageContext(sss);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *getimage;
    getimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(getimage);
    Shareimage=[[UIImage alloc]initWithData:imageData]; 
    return Shareimage;
}

#pragma mark - images delegate
-(IBAction)addimage:(id)sender
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    
    if(!self.shareActionSheet)
    {
        ShareActionSheetVC * temp = [[ShareActionSheetVC alloc] initWithNibName:@"ShareActionSheetVC" bundle:[NSBundle mainBundle]];
        self.shareActionSheet = temp;
        [temp release];

        self.shareActionSheet.delegate = self;
        CGRect viewFrame = self.shareActionSheet.view.frame;
        viewFrame.origin.x = 0.0;
        viewFrame.origin.y = self.view.bounds.size.height - self.shareActionSheet.view.frame.size.height;
        [self.shareActionSheet.view setFrame:viewFrame];
        [self.shareActionSheet.view setBackgroundColor:[UIColor clearColor]];
        [self.shareActionSheet.view setHidden:YES];
        
        
        
        [self.shareActionSheet.view setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        //            [self.customUpgradePopUp.view setTag:100];
        [self.view addSubview:self.shareActionSheet.view];
        [self.shareActionSheet show];

    }
       
    
    /* // An attemp to remove action Sheet
    
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc]
                   initWithTitle:@""
                   delegate:self
                   cancelButtonTitle:@"Cancel" 
                   destructiveButtonTitle:nil 
                   otherButtonTitles:@"Share to Contacts",@"Share to Facebook",@"Share to Twitter",@"Share to Email",nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    //[imageactionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet showInView:self.view];
    [actionSheet release];
     
     
     */
    //    NSLog(@"ADD New image");    
}


#pragma mark- Share Action Sheet Delegate
- (void)clickedButtonAtIndex:(int)index
{
    /*
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     if(appDelegate.sound==YES)
     {
     [[singletonClass sharedsingletonClass].theAudios1 play];
     }
     if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share to Facebook"]) {
     [self facebookButtonTap];
     
     }
     else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share to Contacts"]) {
     // Find all posts by the current user
     PFQuery *query = [PFQuery queryWithClassName:@"AllEmails"];
     [query whereKey:@"Email" equalTo:@"Email"];
     NSArray *usersPosts = [query findObjects];
     if([usersPosts count]>0)
     {
     showAllFriendList *showall=[[[showAllFriendList alloc]init] autorelease];
     showall.list=[[[NSArray alloc]initWithArray:usersPosts] autorelease];;
     showall.image=[self changetoimage1];
     showall.realImage=imageView.image;
     showall.Email=Email;
     showall.imageNumber=[[[NSArray alloc]initWithArray:alreadyDoneRects] autorelease];;
     showall.showAll=YES;
     showall.totalParts=(x*y);
     [self.navigationController pushViewController:showall animated:YES];
     }
     else
     {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"No users"
     delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [alert show];
     [alert release];
     
     }
     //        [[iRate sharedInstance] promptForRating];
     }
     else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share to Twitter"]) {
     
     [self twitterButtonTap];
     
     }
     else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share to Email"]){
     [self displayComposer];
     }
     if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
     
     
     
     }

     */
    [self.shareActionSheet hide];

//    [self performSelectorInBackground:@selector(btnAtIndex:) withObject:[NSNumber numberWithInt:index]];/
    [self performSelector:@selector(btnAtIndex:) withObject:[NSNumber numberWithInt:index] afterDelay:1];
 /*   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios1 play];
    }
//     [self.shareActionSheet hide]; // did that
    
    if(index == 1990)
    {
        // Share to contacts
        PFQuery *query = [PFQuery queryWithClassName:@"AllEmails"];
        [query whereKey:@"Email" equalTo:@"Email"];
        NSArray *usersPosts = [query findObjects];
        if([usersPosts count]>0)
        {
            showAllFriendList *showall=[[[showAllFriendList alloc]init] autorelease];
            showall.list=[[[NSArray alloc]initWithArray:usersPosts] autorelease];;
            showall.image=[self changetoimage1];
            showall.realImage=imageView.image;
            showall.Email=Email;
            showall.imageNumber=[[[NSArray alloc]initWithArray:alreadyDoneRects] autorelease];;
            showall.showAll=YES;
            showall.totalParts=(x*y);
            [self.navigationController pushViewController:showall animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"No users"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            
        }
        

        
    }
    else if(index == 1991)
    {
        // Share to fb
         [self facebookButtonTap];
    }
    else if (index == 1992)
    {
        // Share to twitter
         [self twitterButtonTap];
    }
    else if (index == 1993)
    {
        // Share to email
        [self displayComposer];
    }
    else if (index == 1994)
    {
        // cancel
    }
   
    self.shareActionSheet = nil;*/
}
-(void)btnAtIndex:(NSNumber*)inde
{
    [self performSelectorOnMainThread:@selector(selectedActionSheetBtn:) withObject:inde waitUntilDone:NO];
}
- (void)selectedActionSheetBtn:(NSNumber*)num
{
    int index  = [num integerValue];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios1 play];
    }
    //     [self.shareActionSheet hide]; // did that
    
    if(index == 1990)
    {
        // Share to contacts
        PFQuery *query = [PFQuery queryWithClassName:@"AllEmails"];
        [query whereKey:@"Email" equalTo:@"Email"];
        NSArray *usersPosts = [query findObjects];
        if([usersPosts count]>0)
        {
            showAllFriendList *showall=[[[showAllFriendList alloc]init] autorelease];
            showall.list=[[[NSArray alloc]initWithArray:usersPosts] autorelease];;
            showall.image=[self changetoimage1];
            showall.realImage=imageView.image;
            showall.Email=Email;
            showall.imageNumber=[[[NSArray alloc]initWithArray:alreadyDoneRects] autorelease];;
            showall.showAll=YES;
            showall.totalParts=(x*y);
            [self.navigationController pushViewController:showall animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"No users"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            
        }
        
        
        
    }
    else if(index == 1991)
    {
        // Share to fb
        [self facebookButtonTap];
    }
    else if (index == 1992)
    {
        // Share to twitter
        [self twitterButtonTap];
    }
    else if (index == 1993)
    {
        // Share to email
        [self displayComposer];
    }
    else if (index == 1994)
    {
        // cancel
    }
    
    self.shareActionSheet = nil;
}
- (void)hideShareSheet
{
    [self.shareActionSheet hide];
}
//Share Action Methods
#pragma mark- share Function
- (void)facebookButtonTap 
{
    NSString *client_id = @"399978386739457";
	
	//alloc and initalize our FbGraph instance
	fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
	
	//begin the authentication process.....
	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
						 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
    
}
- (void)fbGraphCallback:(id)sender {
    if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
		
	//	NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
        
       	
    } else {
        UIImage *picture=[self changetoimage];
        NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:2];
        
        //create a UIImage (you could use the picture album or camera too)
        
        //create a FbGraphFile object insance and set the picture we wish to publish on it
        FbGraphFile *graph_file = [[[FbGraphFile alloc] initWithImage:picture] autorelease];
        
        //finally, set the FbGraphFileobject onto our variables dictionary....
        [variables setObject:graph_file forKey:@"file"];
        
        [variables setObject:@"I am using Camera Pic Fx - FREE Messenger App." forKey:@"message"];
        
        //the fbGraph object is smart enough to recognize the binary image data inside the FbGraphFile
        //object and treat that is such.....
        FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"me/photos" withPostVars:variables];//117795728310
     //   NSLog(@"postPictureButtonPressed:  %@", fb_graph_response.htmlResponse);
        
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Camera Pic Fx - FREE Messenger App is posted to your wall." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        //////////////////////code to logout from facebook/////////////////   
        //FaceBook Logout Function
        fbGraph.accessToken = nil;
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            NSString* domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"facebook"];
            if(domainRange.length > 0)
            {
                [storage deleteCookie:cookie];
            }
        }
    }
    [[iRate sharedInstance] promptForRating];
}
-(void)twitterButtonTap
{
    Shareimage=[self changetoimage1];
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[[TWTweetComposeViewController alloc]init]autorelease];

        [tweetSheet setInitialText:@"Lets play photo puzzle  with Camera Pic Fx - FREE Messenger App'"];
        if (Shareimage)
        {
            [tweetSheet addImage:Shareimage];
            [tweetSheet addURL:[NSURL URLWithString:@"http://georiot.co/3OeA"]];
        }
	    
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result)  {
            
            [self dismissModalViewControllerAnimated:YES];
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    break;
                    
                case TWTweetComposeViewControllerResultDone:
                {
                    [[iRate sharedInstance] promptForRating];
                    break;
                }
            }
        };
        [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Sorry" 
                                                             message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" 
                                                            delegate:self 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil]autorelease];
        [alertView show];
    }
    
    
}
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize: (UIImage *)img1
{
	UIImage *sourceImage = img1;
	UIImage *newImage = nil;        
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == YES) 
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor) 
			scaleFactor = widthFactor; // scale to fit height
        else
			scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
		}
        else 
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}       
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil) 
    //    NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}

#pragma mark -
#pragma mark Compose Mail
// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet {
 //   NSLog(@"Form fully Completed!");
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
        NSString *subject=@"Psst…open up!";
        
        [picker setSubject:subject];
        NSArray *toRecipients = [NSArray arrayWithObject:@""]; 
        [picker setToRecipients:toRecipients];
        Shareimage=[self changetoimage1];
        NSData *img=UIImagePNGRepresentation(Shareimage);
        [picker addAttachmentData:img mimeType:@"image/png" fileName:@"photopuzzle"];
        img=nil;
        //https://itunes.apple.com/us/app/jigsaw-puzzle-photos-free/id578879125
        //NSString *base64String = [img base64EncodedString];
        NSString *emailString=[NSString stringWithFormat:@"<html><body><a href=\"http://georiot.co/3OeA\">Click the image to decode my secret Photo Puzzle Message.</a></body></html>"];
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
//	NSLog(@"pop-up email here");
	[self displayComposerSheet];
}



#pragma mark -
#pragma mark AddThisSDK Delegate

- (void)didInitiateShareForService:(NSString *)serviceCode {
	//NSLog(@"Share started for service - %@",serviceCode);
}
#pragma mark - Action Sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios1 play];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share to Facebook"]) {
        [self facebookButtonTap];
        
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share to Contacts"]) {
        // Find all posts by the current user
        PFQuery *query = [PFQuery queryWithClassName:@"AllEmails"];
        [query whereKey:@"Email" equalTo:@"Email"];
        NSArray *usersPosts = [query findObjects];
        if([usersPosts count]>0)
        {
            showAllFriendList *showall=[[[showAllFriendList alloc]init] autorelease];
            showall.list=[[[NSArray alloc]initWithArray:usersPosts] autorelease];;
            showall.image=[self changetoimage1];
            showall.realImage=imageView.image;
            showall.Email=Email;
            showall.imageNumber=[[[NSArray alloc]initWithArray:alreadyDoneRects] autorelease];;
            showall.showAll=YES;
            showall.totalParts=(x*y);
            [self.navigationController pushViewController:showall animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"No users"
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
            
        }
//        [[iRate sharedInstance] promptForRating];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share to Twitter"]) {
        
        [self twitterButtonTap];
        
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share to Email"]){
        [self displayComposer];
    }
    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
        
        

    }
    
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
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
//            [self dismissModalViewControllerAnimated:YES];
             [[iRate sharedInstance] promptForRating];
  //          return;
            
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

- (NSString*)base64forData:(NSData*)theData 
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}
#pragma mark-
#pragma mark- Easy Puzzle
-(void)easyPuzzle
{
    x=2;
    y=4;
    for (int i=0; i<y; i++) {
        for (int j=0; j<x; j++) {
            int r = arc4random() % (x*y);
            int k=0;
            if([alreadyDoneRects count]>0)
            {
                for (k=0; k<[alreadyDoneRects count]; k++) {
                    if([[alreadyDoneRects objectAtIndex:k] intValue]==r)
                        break;
                }
            }
            if(k==[alreadyDoneRects count])
            {
                UIImageView *maskFrame=[[[UIImageView alloc]init]autorelease];;
                [maskFrame setBackgroundColor:[UIColor whiteColor]];
                [alreadyDoneRects addObject:[NSNumber numberWithInt:r]];
                UIImage *maskImage=[UIImage imageNamed:[NSString stringWithFormat:@"mask_easy_%d.png",r+1]];
                int jj=r%2;
                int ii=r/2;
                CGRect rect=CGRectMake(j*160-0.5, i*easyTopY, maskImage.size.width+1, maskImage.size.height+1);
                CGRect rect1=CGRectMake(jj*160, ii*easyTopY, maskImage.size.width+1, maskImage.size.height+1);
                if(r==2||r==5)
                {
                    rect=CGRectMake(j*160-0.5, i*easyTopY-36, maskImage.size.width+1, maskImage.size.height+1);
                    rect1=CGRectMake(rect1.origin.x, rect1.origin.y-36, maskImage.size.width+1, maskImage.size.height+1);
                }
                else if(r==3||r==7)
                {
                    rect=CGRectMake(j*160-55-0.5, i*easyTopY, maskImage.size.width+1, maskImage.size.height+1);
                    rect1=CGRectMake(rect1.origin.x-55, rect1.origin.y, maskImage.size.width+1, maskImage.size.height+1);
                }
                [maskFrame setFrame:CGRectMake(0, 0, rect.size.width+3, rect.size.height+3)];
                [maskFrame setImage:maskImage];
                maskImage=[self changetoimage:maskFrame];
                UIImage *cropimage=[self imageByCropping:imageView.image toRect:rect1];
                //NSLog(@"%@",NSStringFromCGRect(rect));
                [maskFrame setFrame:rect];
                [maskFrame setImage:[self maskImage:cropimage withMask:maskImage]];
                [maskFrame setBackgroundColor:[UIColor clearColor]];
                [self.view addSubview:maskFrame];
                [imagePieces addObject:maskFrame];
                [imagerects addObject:[NSValue valueWithCGRect:rect]];
            }
            else
            {
                j--;
            }
        }
    }
}
-(void)easyPuzzlePlay:(int)firstNumber :(int)secondNumber
{
    if(secondNumber==(x*y))
    {
        UIImageView *tempImage=[imagePieces objectAtIndex:firstNumber];
        [tempImage setFrame:[[imagerects objectAtIndex:firstNumber] CGRectValue]];
    }
    else
    {
        UIImageView *maskFrame=[imagePieces objectAtIndex:firstNumber];
        UIImageView *maskFrame1=[imagePieces objectAtIndex:secondNumber];
        int r = [[alreadyDoneRects objectAtIndex:secondNumber] intValue];
        int j=secondNumber%2;
        int i=secondNumber/2;
        CGRect rect=CGRectMake(j*160-0.5, i*easyTopY, maskFrame.frame.size.width, maskFrame.frame.size.height);
        if(r==2||r==5)
        {
            rect=CGRectMake(j*160-0.5, i*easyTopY-36, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==3||r==7)
        {
            rect=CGRectMake(j*160-55-0.5, i*easyTopY, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        [maskFrame setFrame:rect];
        [maskFrame setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(2*i) withObject:maskFrame];
        [imagerects replaceObjectAtIndex:j+(2*i) withObject:[NSValue valueWithCGRect:rect]];
        r = [[alreadyDoneRects objectAtIndex:firstNumber] intValue];
        j=firstNumber%2;
        i=firstNumber/2;
        rect=CGRectMake(j*160-0.5, i*easyTopY, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        
        if(r==2||r==5)
        {
            rect=CGRectMake(j*160-0.5, i*easyTopY-36, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==3||r==7)
        {
            rect=CGRectMake(j*160-55-0.5, i*easyTopY, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        [maskFrame1 setFrame:rect];
        [maskFrame1 setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(2*i) withObject:maskFrame1];
        [imagerects replaceObjectAtIndex:j+(2*i) withObject:[NSValue valueWithCGRect:rect]];
    }
}
#pragma mark-
#pragma mark- Medium Puzzle
-(void)mediumPuzzle
{
    x=3;
    y=5;
    for (int i=0; i<y; i++) {
        for (int j=0; j<x; j++) {
            int r = arc4random() % (x*y);
            int k=0;
            if([alreadyDoneRects count]>0)
            {
                for (k=0; k<[alreadyDoneRects count]; k++) {
                    if([[alreadyDoneRects objectAtIndex:k] intValue]==r)
                        break;
                }
            }
            if(k==[alreadyDoneRects count])
            {
                UIImageView *maskFrame=[[[UIImageView alloc]init]autorelease];;
                [maskFrame setBackgroundColor:[UIColor whiteColor]];
                [alreadyDoneRects addObject:[NSNumber numberWithInt:r]];
                UIImage *maskImage=[UIImage imageNamed:[NSString stringWithFormat:@"mask_medium_%d.png",r+1]];
                int jj=r%3;
                int ii=r/3;
                CGRect rect=CGRectMake(j*106.66, i*mediumTopY, maskImage.size.width+1, maskImage.size.height+1);
                CGRect rect1=CGRectMake(jj*106.66, ii*mediumTopY, maskImage.size.width+1, maskImage.size.height+1);
                if(r==2||r==8||r==10)
                {
                    rect=CGRectMake(j*106.66-37, i*mediumTopY, maskImage.size.width+1, maskImage.size.height+1);
                    rect1=CGRectMake(rect1.origin.x-37, rect1.origin.y, maskImage.size.width+1, maskImage.size.height+1);
                }
                else if(r==4||r==5||r==7||r==9||r==11||r==12)
                {
                    rect=CGRectMake(j*106.66, i*mediumTopY-29.5, maskImage.size.width+1, maskImage.size.height+1);
                    rect1=CGRectMake(rect1.origin.x, rect1.origin.y-29, maskImage.size.width+1, maskImage.size.height+1);
                }
                else if(r==13)
                {
                    rect=CGRectMake(j*106.66-37, i*mediumTopY-29.5, maskImage.size.width+1, maskImage.size.height+1);
                    rect1=CGRectMake(rect1.origin.x-37, rect1.origin.y-29, maskImage.size.width+1, maskImage.size.height+1);
                }
                [maskFrame setFrame:CGRectMake(0, 0, rect.size.width+3, rect.size.height+3)];
                [maskFrame setImage:maskImage];
                maskImage=[self changetoimage:maskFrame];
                UIImage *cropimage=[self imageByCropping:imageView.image toRect:rect1];
                //NSLog(@"%@",NSStringFromCGRect(rect));
                [maskFrame setFrame:rect];
                [maskFrame setImage:[self maskImage:cropimage withMask:maskImage]];
                [maskFrame setBackgroundColor:[UIColor clearColor]];
                [self.view addSubview:maskFrame];
                [imagePieces addObject:maskFrame];
                [imagerects addObject:[NSValue valueWithCGRect:rect]];
            }
            else
            {
                j--;
            }
        }
    }
}
-(void)mediumPuzzlePlay:(int)firstNumber :(int)secondNumber
{
    if(secondNumber==(x*y))
    {
        UIImageView *tempImage=[imagePieces objectAtIndex:firstNumber];
        [tempImage setFrame:[[imagerects objectAtIndex:firstNumber] CGRectValue]];
    }
    else
    {
        UIImageView *maskFrame=[imagePieces objectAtIndex:firstNumber];
        UIImageView *maskFrame1=[imagePieces objectAtIndex:secondNumber];
        int r = [[alreadyDoneRects objectAtIndex:secondNumber] intValue];
        int j=secondNumber%3;
        int i=secondNumber/3;
        CGRect rect=CGRectMake(j*106.66, i*mediumTopY, maskFrame.frame.size.width, maskFrame.frame.size.height);
        if(r==2||r==8||r==10)
        {
            rect=CGRectMake(j*106.66-37, i*mediumTopY, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==4||r==5||r==7||r==9||r==11||r==12)
        {
            rect=CGRectMake(j*106.66, i*mediumTopY-29.5, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==13)
        {
            rect=CGRectMake(j*106.66-37, i*mediumTopY-29.5, maskFrame.frame.size.width+1, maskFrame.frame.size.height);
        }
        [maskFrame setFrame:rect];
        [maskFrame setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(3*i) withObject:maskFrame];
        [imagerects replaceObjectAtIndex:j+(3*i) withObject:[NSValue valueWithCGRect:rect]];
        r = [[alreadyDoneRects objectAtIndex:firstNumber] intValue];
        j=firstNumber%3;
        i=firstNumber/3;
        rect=CGRectMake(j*106.66, i*mediumTopY, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        if(r==2||r==8||r==10)
        {
            rect=CGRectMake(j*106.66-37, i*mediumTopY, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==4||r==5||r==7||r==9||r==11||r==12)
        {
            rect=CGRectMake(j*106.66, i*mediumTopY-29.5, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==13)
        {
            rect=CGRectMake(j*106.66-37, i*mediumTopY-29.5, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        [maskFrame1 setFrame:rect];
        [maskFrame1 setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(3*i) withObject:maskFrame1];
        [imagerects replaceObjectAtIndex:j+(3*i) withObject:[NSValue valueWithCGRect:rect]];
    }
}

#pragma mark-
#pragma mark- Hard Puzzle
-(void)hardPuzzle
{
    x=5;
    y=6;
    for (int i=0; i<y; i++) {
        for (int j=0; j<x; j++) {
            int r = arc4random() % (x*y);
            int k=0;
            if([alreadyDoneRects count]>0)
            {
                for (k=0; k<[alreadyDoneRects count]; k++) {
                    if([[alreadyDoneRects objectAtIndex:k] intValue]==r)
                        break;
                }
            }
            if(k==[alreadyDoneRects count])
            {
                UIImageView *maskFrame=[[[UIImageView alloc]init]autorelease];;
                [maskFrame setBackgroundColor:[UIColor whiteColor]];
                [alreadyDoneRects addObject:[NSNumber numberWithInt:r]];
                UIImage *maskImage=[UIImage imageNamed:[NSString stringWithFormat:@"mask_hard_%d.png",r+1]];
                int jj=r%5;
                int ii=r/5;
                CGRect rect=CGRectMake(j*64, i*hardTopY, maskImage.size.width+1, maskImage.size.height+1);
                CGRect rect1=CGRectMake(jj*64, ii*hardTopY, maskImage.size.width+1, maskImage.size.height+1);
                if(r==1||r==3||r==7||r==9||r==11||r==17||r==19||r==21||r==23||r==29)
                {
                    rect=CGRectMake(j*64-22, i*hardTopY, maskImage.size.width+1, maskImage.size.height+1);
                    rect1=CGRectMake(rect1.origin.x-22, rect1.origin.y, maskImage.size.width+1, maskImage.size.height+1);
                }
                else if(r==6||r==8||r==10||r==12||r==16||r==18||r==20||r==22||r==24||r==26)
                {
                    rect=CGRectMake(j*64, i*hardTopY-23.67, maskImage.size.width+1, maskImage.size.height+1);
                    rect1=CGRectMake(rect1.origin.x, rect1.origin.y-23.67, maskImage.size.width+1, maskImage.size.height+1);
                }
                else if(r==13||r==27)
                {
                    rect=CGRectMake(j*64-22, i*hardTopY-23.67, maskImage.size.width+1, maskImage.size.height+1);
                    rect1=CGRectMake(rect1.origin.x-22, rect1.origin.y-23.67, maskImage.size.width+1, maskImage.size.height+1);
                }
                [maskFrame setFrame:CGRectMake(0, 0, rect.size.width+3, rect.size.height+3)];
                [maskFrame setImage:maskImage];
                maskImage=[self changetoimage:maskFrame];
                UIImage *cropimage=[self imageByCropping:imageView.image toRect:rect1];
                //NSLog(@"%@",NSStringFromCGRect(rect));
                [maskFrame setFrame:rect];
                [maskFrame setImage:[self maskImage:cropimage withMask:maskImage]];
                [maskFrame setBackgroundColor:[UIColor clearColor]];
                [self.view addSubview:maskFrame];
                [imagePieces addObject:maskFrame];
                [imagerects addObject:[NSValue valueWithCGRect:rect]];
            }
            else
            {
                j--;
            }
        }
    }
}
-(void)hardPuzzlePlay:(int)firstNumber :(int)secondNumber
{
    if(secondNumber==(x*y))
    {
        UIImageView *tempImage=[imagePieces objectAtIndex:firstNumber];
        [tempImage setFrame:[[imagerects objectAtIndex:firstNumber] CGRectValue]];
    }
    else
    {
        UIImageView *maskFrame=[imagePieces objectAtIndex:firstNumber];
        UIImageView *maskFrame1=[imagePieces objectAtIndex:secondNumber];
        int r = [[alreadyDoneRects objectAtIndex:secondNumber] intValue];
        int j=secondNumber%5;
        int i=secondNumber/5;
        CGRect rect=CGRectMake(j*64, i*hardTopY, maskFrame.frame.size.width, maskFrame.frame.size.height);
        if(r==1||r==3||r==7||r==9||r==11||r==17||r==19||r==21||r==23||r==29)
        {
            rect=CGRectMake(j*64-22, i*hardTopY, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==6||r==8||r==10||r==12||r==16||r==18||r==20||r==22||r==24||r==26)
        {
        rect=CGRectMake(j*64, i*hardTopY-23.67, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==13||r==27)
        {
        rect=CGRectMake(j*64-22, i*hardTopY-23.67, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        [maskFrame setFrame:rect];
        [maskFrame setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(5*i) withObject:maskFrame];
        [imagerects replaceObjectAtIndex:j+(5*i) withObject:[NSValue valueWithCGRect:rect]];
        r = [[alreadyDoneRects objectAtIndex:firstNumber] intValue];
        j=firstNumber%5;
        i=firstNumber/5;
        rect=CGRectMake(j*64, i*hardTopY, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        if(r==1||r==3||r==7||r==9||r==11||r==17||r==19||r==21||r==23||r==29)
        {
            rect=CGRectMake(j*64-22, i*hardTopY, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==6||r==8||r==10||r==12||r==16||r==18||r==20||r==22||r==24||r==26)
        {
            rect=CGRectMake(j*64, i*hardTopY-23.67, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==13||r==27)
        {
            rect=CGRectMake(j*64-22, i*hardTopY-23.67, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        [maskFrame1 setFrame:rect];
        [maskFrame1 setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(5*i) withObject:maskFrame1];
        [imagerects replaceObjectAtIndex:j+(5*i) withObject:[NSValue valueWithCGRect:rect]];
    }
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}
@end
