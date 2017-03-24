//
//  playPuzzle.m
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 6/26/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import "playPuzzle.h"
#import "Parse/Parse.h"
#import <QuartzCore/QuartzCore.h>
#import "playPuzzleGame.h"
#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"
#import "AppDelegate.h"
#import <Twitter/Twitter.h>
#import "showAllFriendList.h"
#import "SBJSON.h"
#import "FbGraphFile.h"
#import "MBProgressHUD.h"
#import "photoView.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"

@implementation playPuzzle
@synthesize tabBar;
@synthesize allPhotoTable;
@synthesize moreButton;
@synthesize Email;
@synthesize subject;
@synthesize customizedTabBar;
@synthesize bgImage,inviteBtn;

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
#pragma mark - PlayHaven
-(void)loadPlayHaven
{
    PHPublisherContentRequest *request2 = [PHPublisherContentRequest requestForApp:PLAYHAVEN_APP_TOKEN secret:PLAYHAVEN_APP_SECRET placement:@"main_menu" delegate:self];
    [request2 send];
}
#pragma mark - Playhaven PHPublisherdelegate
-(void)requestDidGetContent:(PHPublisherContentRequest *)request
{
    NSLog(@"requestDidGetContent");
}
-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content
{
    NSLog(@"contentDidDisplay");
}
-(void)request:(PHPublisherContentRequest *)request contentDidDismissWithType:(PHPublisherContentDismissType *)type
{
    NSLog(@"contentDidDismissWithType");
}

-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[[ALSharedData getSharedInstance] playHavenInfoObj] showOnPlaying] == YES)
    {
        [self loadPlayHaven];
    }
    if([[[ALSharedData getSharedInstance] appLovinInfoObj] showOnPlaying] == YES)
    {
        [ALInterstitialAd showOver:[(AppDelegate*)[[UIApplication sharedApplication] delegate] window]];
    }
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    
    
    
    self.customizedTabBar = [nibObjects objectAtIndex:0];
    self.customizedTabBar.frame = CGRectMake(0, self.view.bounds.size.height - customizedTabBar.frame.size.height , customizedTabBar.frame.size.width, 50);
    [self.view addSubview:customizedTabBar];
    //    self.customizedTabBar
    [self.customizedTabBar selectTab:11];
    self.customizedTabBar.delegate = self;
    if (![UserDefaultsManager isProUpgradePurchaseDone])
    {
        //[[Neocortex getInstance] onPlaying];
//        [[SNAdsManager sharedManager]  giveMeGameOverAd];
    }
    
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Puzzle"];
    query.cachePolicy=kPFCachePolicyNetworkElseCache;
  //  NSLog(@"%@",Email);
    [query whereKey:@"playerEmail" equalTo:Email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d Scores.", objects.count);
            dataArray1 = [[NSArray alloc]initWithArray:objects];
            [allPhotoTable reloadData];
            if ([objects count]==0) {
                
                [self.bgImage setHidden:NO];
                [self.inviteBtn setHidden:NO];
                [self.inviteBtn addTarget:self action:@selector(inviteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
               
                UIButton *shareButton=[[[UIButton alloc]initWithFrame:CGRectMake(40, 295, 230, 15)] autorelease];
                [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:shareButton];
                [self.view bringSubviewToFront:moreButton];
            }
        } else {
            // Log details of the failure
            [self.inviteBtn setHidden:YES];
            [self.bgImage setHidden:YES];
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
     

    
    */
    /*
     
     UIImageView *networkImage=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 320, 260)] autorelease];;
     [networkImage setImage:[UIImage imageNamed:@"logo.png"]];
     [self.view addSubview:networkImage];
     UIButton *inviteButton=[[[UIButton alloc]initWithFrame:CGRectMake(22, 275, 230, 15)] autorelease];
     [inviteButton addTarget:self action:@selector(inviteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:inviteButton];
     */
    // Do any additional setup after loading the view from its nib.
       [self.view bringSubviewToFront:moreButton];
    [self.allPhotoTable reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
//    UIImage *backgroundImage = [UIImage imageNamed:@"bar.2.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    tabBar.selectedItem=[[self.tabBar items]objectAtIndex:0];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.TopAd==NO)
    {
        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView actualAdSize];
        CGRect newFrame ;
        newFrame.size = adSize;
        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
        newFrame.origin.y=46.0f;
        newFrame.size.height=50.0f;
        [singletonClass sharedsingletonClass].adWhrilView.frame = newFrame;
        
        if (![UserDefaultsManager isProUpgradePurchaseDone])
        {
//            [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
        }
        
    }
    if(appDelegate.bottomAd==NO)
    {
        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView1 actualAdSize];
        CGRect newFrame ;
        newFrame.size = adSize;
        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
//        newFrame.origin.y=322.0f;
        newFrame.origin.y= self.view.bounds.size.height - 100;
        newFrame.size.height=50.0f;
        [singletonClass sharedsingletonClass].adWhrilView1.frame = newFrame;
        
        if (![UserDefaultsManager isProUpgradePurchaseDone])
        {
//            [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
        }
        
    }
    if(appDelegate.TopAd==YES)
    {
        [allPhotoTable setFrame:CGRectMake(0, 0, 320, 340)];
    }
    if(appDelegate.bottomAd==YES)
    {
        [allPhotoTable setFrame:CGRectMake(0, 50, 320, 340)];
        [moreButton setFrame:CGRectMake(moreButton.frame.origin.x, 335, moreButton.frame.size.width, moreButton.frame.size.height)];
    }
    if(appDelegate.bottomAd==YES&&appDelegate.TopAd==YES)
    {
        [allPhotoTable setFrame:CGRectMake(0, 0, 320, 390)];
    }
    [[singletonClass sharedsingletonClass].theAudios1 stop];
    playsound=NO;
    self.navigationController.navigationBarHidden = NO;
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header_puzzle.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBarHidden = YES;
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    [self.view addSubview:iv];
    
    UIButton *editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame=CGRectMake(0, 6, 40, 40);
    editButton.tintColor=nil;
    [editButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(nameOfSomeMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:editButton];
    //self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:editButton] autorelease];

}
-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES&&playsound==NO)
    {
        [[singletonClass sharedsingletonClass].theAudios1 play];
    }
    if(appDelegate.TopAd==NO)
    {
        [[singletonClass sharedsingletonClass].adWhrilView removeFromSuperview];
    }
    if(appDelegate.bottomAd==NO)
    {
        [[singletonClass sharedsingletonClass].adWhrilView1 removeFromSuperview];
    }
}
-(IBAction)inviteButtonPressed:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self performSelector:@selector(invite) withObject:nil afterDelay:0.1];
}
-(void)invite
{
    PFQuery *query = [PFQuery queryWithClassName:@"AllEmails"];
    [query whereKey:@"Email" equalTo:@"Email"];
    NSArray *usersPosts = [query findObjects];
    showAllFriendList *showall=[[[showAllFriendList alloc]init] autorelease];
    showall.list=[[[NSArray alloc]initWithArray:usersPosts] autorelease];;
    showall.image=[[[UIImage alloc]init] autorelease];
    showall.image=[UIImage imageNamed:@"screen1.png"];
    showall.Email=Email;
    
    showall.realImage=[UIImage imageNamed:@"screen1.png"];
    showall.imageNumber=[[[NSArray alloc]init] autorelease];;
    showall.showAll=NO;
    [self.navigationController pushViewController:showall animated:YES];
}
-(IBAction)shareButtonPressed:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] 
                   initWithTitle:@""
                   delegate:self
                   cancelButtonTitle:@"Cancel" 
                   destructiveButtonTitle:nil 
                   otherButtonTitles:@"Share to Facebook",@"Share to Twitter",nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    //[imageactionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet showInView:self.view];
    [actionSheet release];
}
-(IBAction)nameOfSomeMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Adwhril

- (NSString *)adWhirlApplicationKey {
    NSString *key;
    key=@"d03363079b004be1bd89e9ff4f4e49d9";
    return key;
}

- (UIViewController *)viewControllerForPresentingModalView {
    //Remember that UIViewController we created in the Game.h file? AdMob will use it.
    //If you want to use "return self;" instead, AdMob will cancel the Ad requests.
    return self;
}

- (void)viewDidUnload
{
    [fbGraph release];
    [self setAllPhotoTable:nil];
    [self setMoreButton:nil];
    [self setTabBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported Orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [self.bgImage release];
    [self.inviteBtn release];
    [self.customizedTabBar release];
    [allPhotoTable release];
    [moreButton release];
    [tabBar release];
    [super dealloc];
}
-(void)loadData{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filepath =[documentsDirectory stringByAppendingPathComponent:@"photos.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    
    if (fileExists) 
    {
    //    NSLog(@"%@",filepath);
        dataArray1 = [NSMutableArray arrayWithContentsOfFile:filepath];
    }   
  //  NSLog(@"%d",dataArray1.count);
    
}
-(void)updateData{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath =[documentsDirectory stringByAppendingPathComponent:@"Puzzles.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    
    if (fileExists) {
      //  NSLog(@"%@",filepath);
        [dataArray1 writeToFile:filepath atomically:YES];
    }
    else{
        //NSLog(@"%@",filepath);
        [dataArray1 writeToFile:filepath atomically:YES];
    }
   // NSLog(@"%@",filepath);
}
#pragma mark- table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if([dataArray1 count]>0)
        return 1;
    else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {  
    
    int numRows = [dataArray1 count]/4+1;
    return numRows *80;
    //    cell.backgroundColor = [UIColor greenColor]
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}  

#pragma mark- table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    int n = [dataArray1 count];
    UIButton *button[n];
    PFImageView *imageView[n];
    if (cell == nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"cell"] autorelease]; 
        int ii=0,ii1=0;
        int start=[dataArray1 count]-1;
        int ii2=[dataArray1 count]-1;
        for (int i=[dataArray1 count]-1; i>=0; i--) 
        {
            int yy = 5 +ii1*75;
            for(int j=0; j<4;j++){
                
                if (ii>=n) 
                    break;
                if(ii==1)
                {
                    j=1;
                }
                CGRect rect = CGRectMake(5+(75)*j, yy, 75, 70);
                button[ii]=[[[UIButton alloc] initWithFrame:rect] autorelease];
                PFObject *fulldata=[dataArray1 objectAtIndex:start];
                PFFile *imagedata1=[fulldata objectForKey:@"imageFile"];
                button[ii].tag=ii2;
//                UIImage *buttonImageNormal=[[[UIImage alloc]initWithData:imagedata1.getData] autorelease];
//                [button[ii] setImage:buttonImageNormal forState:UIControlStateNormal];
                imageView[ii]= [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 70)];
                imageView[ii].image = [UIImage imageNamed:@"logomini.png"]; // placeholder image
                imageView[ii].file = imagedata1; // remote image
                [imageView[ii] loadInBackground];
                [button[ii] addSubview:imageView[ii]];
                
                [cell.contentView addSubview:button[ii]]; 
                [[button[ii] layer] setBorderColor:[[UIColor grayColor] CGColor]];
                
                [[ button[ii] layer] setBorderWidth:3];
                button[ii].clipsToBounds=YES;
                fulldata=nil;
                imagedata1=nil;
//                buttonImageNormal=nil;
                [tableView bringSubviewToFront:button[ii]];
                [button[ii] addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                ii++;
                ii2--;
                start--;
            }
            ii1 = ii1+1;
        }
    }
    return cell;
    
}
-(IBAction)buttonPressed:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self performSelector:@selector(nextView:) withObject:[NSString stringWithFormat:@"%d",((UIButton *)sender).tag] afterDelay:0.1];
 //   NSLog(@"%@",[NSNumber numberWithInt:((UIButton *)sender).tag]);
}
-(void)nextView:(NSString*)number
{
    int no=[number intValue];
    PFObject *fulldata=[dataArray1 objectAtIndex:no];
    int totimages=[[fulldata objectForKey:@"totalParts"] intValue];
    playPuzzleGame *nextview=[[[playPuzzleGame alloc]init] autorelease];
    PFFile *imagedata1=[fulldata objectForKey:@"realImage"];
    nextview.RealImage=[UIImage imageWithData:imagedata1.getData];
    nextview.totalImages=totimages;
    nextview.alreadyDoneRects=[fulldata objectForKey:@"imageNumbers"];
    [self.navigationController pushViewController:nextview animated:YES];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}
#pragma mark- share Function
- (void)facebookButtonTap 
{
    
    NSString *client_id = @"399978386739457";
	
	//alloc and initalize our FbGraph instance
	fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
	
    [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
						 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,email"];
    
}
- (void)fbGraphCallback:(id)sender {
    if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
        
       	
    } else {
        NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:2];
        
        //create a UIImage (you could use the picture album or camera too)
        UIImage *picture = [UIImage imageNamed:@"screen1.png"];
        
        //create a FbGraphFile object insance and set the picture we wish to publish on it
        FbGraphFile *graph_file = [[FbGraphFile alloc] initWithImage:picture];
        
        //finally, set the FbGraphFileobject onto our variables dictionary....
        [variables setObject:graph_file forKey:@"file"];
        
        [variables setObject:@"Camera Pic Fx - FREE Messenger App." forKey:@"message"];
        
        //the fbGraph object is smart enough to recognize the binary image data inside the FbGraphFile
        //object and treat that is such.....
        FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"me/photos" withPostVars:variables];//117795728310
        NSLog(@"postPictureButtonPressed:  %@", fb_graph_response.htmlResponse);
        
        [graph_file release];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Camera Pic Fx - FREE Messenger App is post at your wall." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
}

-(void)twitterButtonTap
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[[TWTweetComposeViewController alloc]init]autorelease];
        [tweetSheet setInitialText:@"Lets play photo puzzle  with 'Camera Pic Fx - FREE Messenger App'"];
        [tweetSheet addImage:[UIImage imageNamed:@"screen1.png"]];
        [tweetSheet addURL:[NSURL URLWithString:@""]];
        
        
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
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share to Twitter"]) {
        
        [self twitterButtonTap];
        
    }
}
- (IBAction)moreButtonPressed:(id)sender {
//    [RevMobAds showPopup]; // Sher
    /* Sher
    Chartboost *cb = [Chartboost sharedChartboost];
    cb.delegate = self;
    cb.appId = @"4fe1fe28f87659966f00000d";
    //    cb.appId=@"4fec316df87659b22f000006";
    cb.appSignature = @"3fcf8281d7845374540a0ec5a2f2e7c9ac53c861";
    [cb cacheMoreApps];
    [cb showMoreApps];
     */
    
    [[SNAdsManager sharedManager]  giveMeMoreAppsAd];
}
-(void)didCloseMoreApps
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (BOOL)shouldDisplayMoreApps
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    return YES;
}
- (BOOL)shouldDisplayLoadingViewForMoreApps
{
    return YES;
}
-(void)didDismissMoreApps
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
#pragma mark tabbar function
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.tabBar.selectedItem.tag==1)
    {
        photoView *nextview=[[[photoView alloc]init] autorelease];;
        nextview.Email=Email;
        [self.navigationController pushViewController:nextview animated:NO];
        playsound=YES;
    }
}
#pragma mark tabbar function
-(void)tabWasSelected:(NSInteger)index
{
    if(index==12)
    {
        photoView *nextview=[[[photoView alloc]init] autorelease];;
        nextview.Email=Email;
        [self.navigationController pushViewController:nextview animated:NO];
        playsound = YES;
        
    }
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}
@end
