//
//  photoView.m
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 6/9/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//


#import "photoView.h"
#import "mainview.h"
#import "imagePreView.h"
#import <QuartzCore/QuartzCore.h>
//#import "AdWhirlView.h"
//#import "AdWhirlDelegateProtocol.h"
#import "AppDelegate.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "DataBase.h"
#import <sqlite3.h>
#import "Neocortex.h"

#import "SetDifficultyVC.h"
/* Sher
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdvertiser.h>
 */

@implementation photoView
{
    UIButton *suspend1;
}
@synthesize allPhotoTable;
@synthesize tabBar;
@synthesize moreButtonPressed;
@synthesize Email;
@synthesize customizedTabBar;
@synthesize tutorialPopup;
@synthesize bgImage,arrowImage;
@synthesize cameraSheet;
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
    if(imagePicker.isFirstResponder==YES)
        [imagePicker dismissModalViewControllerAnimated:YES];
    [[singletonClass sharedsingletonClass].pool drain];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    
    
    
    self.customizedTabBar = [nibObjects objectAtIndex:0];
    self.customizedTabBar.frame = CGRectMake(0, self.view.bounds.size.height - customizedTabBar.frame.size.height , customizedTabBar.frame.size.width, 50);
    [self.view addSubview:customizedTabBar];
    //    self.customizedTabBar
    [self.customizedTabBar selectTab:12];
    self.customizedTabBar.delegate = self;
    
    
//    [[Neocortex getInstance] onGameover];
    [[Chartboost sharedChartboost] cacheMoreApps];
    imagePicker = [[UIImagePickerController alloc] init];
    // Delegate is self
	imagePicker.delegate = self;
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view from its nib.
    tabBar.delegate=self;
    
    // Do any additional setup after loading the view from its nib.
    //Edit and Back button initializtion
    
//    UIBarButtonItem *addimage=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addimage:)];
//    self.navigationItem.rightBarButtonItem=addimage;
//    self.navigationItem.hidesBackButton=YES;
    
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
//    UIImage *backgroundImage = [UIImage imageNamed:@"header_album.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.tintColor=[UIColor blueColor];
//    
//    [addimage release];
    
    tabBar.selectedItem=[[self.tabBar items]objectAtIndex:1];
    
    ////////////////////////////Custom Camera Button////////////
    
    UIView *rightview = [[UIView alloc] initWithFrame:CGRectMake(0,0,53,44)];
    suspend1=[[UIButton alloc]initWithFrame:CGRectMake(260, 3, 40, 40)];
    
    suspend1.clipsToBounds=YES;
    
    suspend1.contentMode=UIViewContentModeScaleAspectFit;
    [suspend1 setImage:[UIImage imageNamed:@"photo_btn.png"] forState:UIControlStateNormal];
    [suspend1 addTarget:self action:@selector(addimage:) forControlEvents:UIControlEventTouchUpInside];
    [rightview addSubview:suspend1];
//    [suspend1 release];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem = customItem;
    [customItem release];
    [rightview release];
    totalImages=0;
    [self.view bringSubviewToFront:moreButtonPressed];
    [DataBase checkAndCreateDatabase];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header_album.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBarHidden = YES;
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    [self.view addSubview:iv];
    [self.view addSubview:suspend1];
    
    dataArray1=[DataBase viewAllPuzzle:Email];
    if ([dataArray1 count]==0) {
        
        [self.arrowImage setHidden:NO];
        [self.bgImage setHidden:NO];
        
        
        if(!self.tutorialPopup)
        {
            
            
            TutorialPopupVC * temp = [[TutorialPopupVC alloc] initWithNibName:@"TutorialPopupVC" bundle:[NSBundle mainBundle]];
            self.tutorialPopup = temp;
            [temp release];
            self.self.tutorialPopup.delegate = self;
            
            CGRect viewFrame = self.tutorialPopup.view.frame;
            viewFrame.origin.x = 0.0;
            
            [self.tutorialPopup.view setFrame:viewFrame];
            [self.tutorialPopup.view setBackgroundColor:[UIColor clearColor]];
            [self.tutorialPopup.view setHidden:YES];
            
            
            
            [self.tutorialPopup.view setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
            //            [self.customUpgradePopUp.view setTag:100];
            [self.view addSubview:self.tutorialPopup.view];
            [self.tutorialPopup show];
        }
        
        
        
//        networkImage=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 320, 260)] autorelease];;
//        [networkImage setImage:[UIImage imageNamed:@"photoviewimage.png"]];
//        [self.view addSubview:networkImage];
//        [self.view bringSubviewToFront:moreButtonPressed];
    }
    [self.allPhotoTable reloadData];
      [[singletonClass sharedsingletonClass].theAudios1 stop];
}
#pragma mark - Tutorial Popup Delegate
- (void)closeClicked
{
    [self.tutorialPopup hide];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

//    if(appDelegate.TopAd==NO)
//    {
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
//        newFrame.origin.y=0.0f;
//        newFrame.size.height=50.0f;
//        [singletonClass sharedsingletonClass].adWhrilView.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
//    }
//    if(appDelegate.bottomAd==NO)
//    {
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView1 actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
//        //        newFrame.origin.y=322.0f;
//        newFrame.origin.y= self.view.bounds.size.height - 100;
//        newFrame.size.height=50.0f;
//        [singletonClass sharedsingletonClass].adWhrilView1.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
//    }
//    if(appDelegate.TopAd==YES)
//    {
//        [allPhotoTable setFrame:CGRectMake(0, 0, 320, 340)];
//    }
//    if(appDelegate.bottomAd==YES)
//    {
//        [allPhotoTable setFrame:CGRectMake(0, 50, 320, 340)];
//        [moreButtonPressed setFrame:CGRectMake(moreButtonPressed.frame.origin.x, 335, moreButtonPressed.frame.size.width, moreButtonPressed.frame.size.height)];
//    }
//    if(appDelegate.bottomAd==YES&&appDelegate.TopAd==YES)
//    {
//        [allPhotoTable setFrame:CGRectMake(0, 0, 320, 390)];
//    }

//    self.tutorialPopup = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    if ([dataArray1 count]==0)
    {
        [networkImage removeFromSuperview];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios1 play];
    }
//    if(appDelegate.TopAd==NO)
//    {
//        [[singletonClass sharedsingletonClass].adWhrilView removeFromSuperview];
//    }
//    if(appDelegate.bottomAd==NO)
//    {
//        [[singletonClass sharedsingletonClass].adWhrilView1 removeFromSuperview];
//    }
}
#pragma mark -
#pragma mark Adwhril

//- (NSString *)adWhirlApplicationKey {
//    NSString *key;
//    key=@"d03363079b004be1bd89e9ff4f4e49d9";
//    return key;
//}

- (UIViewController *)viewControllerForPresentingModalView {
    //Remember that UIViewController we created in the Game.h file? AdMob will use it.
    //If you want to use "return self;" instead, AdMob will cancel the Ad requests.
    return self;
}
- (void)viewDidUnload
{
    [imagePicker release];
    [self setMoreButtonPressed:nil];
    [super viewDidUnload];
    [self setTabBar:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc {
    self.cameraSheet.delegate = nil;
    [self.cameraSheet release];
    [self.bgImage release];
    [self.arrowImage release];
    self.tutorialPopup.delegate = nil;
    [self.tutorialPopup release];
    [self.customizedTabBar release];
    [tabBar release];
    [allPhotoTable release];
    [moreButtonPressed release];
    [super dealloc];
}
#pragma mark tabbar function
-(void)tabWasSelected:(NSInteger)index
{
    if(index==11)
    {

            [self.navigationController popViewControllerAnimated:NO];
    }
}
#pragma mark- tabbar function
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.tabBar.selectedItem.tag==0)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
#pragma mark - images delegate
-(IBAction)addimage:(id)sender{
    
    
    
    if(!self.cameraSheet)
    {
        CamerActionSheetVC * temp = [[CamerActionSheetVC alloc] initWithNibName:@"CamerActionSheetVC" bundle:[NSBundle mainBundle]];
        self.cameraSheet = temp;
        [temp release];
        
        self.cameraSheet.delegate = self;
        CGRect viewFrame = self.cameraSheet.view.frame;
        viewFrame.origin.x = 0.0;
        viewFrame.origin.y = self.view.bounds.size.height - self.cameraSheet.view.frame.size.height;
        [self.cameraSheet.view setFrame:viewFrame];
        [self.cameraSheet.view setBackgroundColor:[UIColor clearColor]];
        [self.cameraSheet.view setHidden:YES];
        
        
        
        [self.cameraSheet.view setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        //            [self.customUpgradePopUp.view setTag:100];
        [self.view addSubview:self.cameraSheet.view];
        [self.cameraSheet show];
        
    }
    
    /*
    NSLog(@"ADD New image");
    
	UIActionSheet *actionSheet;
    
    actionSheet = [[UIActionSheet alloc] 
                   initWithTitle:@""
                   delegate:self 
                   cancelButtonTitle:@"Cancel" 
                   destructiveButtonTitle:nil
                   otherButtonTitles:@"Add Photo from Library", @"Take Photo with Camera", nil];
    
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	[actionSheet release];
     */
    
}
#pragma mark - Camera Sheet Delegate
-(void)clickedBtnAtIndex:(int)index
{
    if(index == 1980)
    {
       [self pickPhotoFromCamera:nil];	
    }
    else if (index == 1981)
    {
         [self pickPhotoFromPhotoLibrary:nil];
    }
    else if (index == 1982)
    {
        
    }
    [self.cameraSheet hide];
    self.cameraSheet = nil;

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add Photo from Library"])
        [self pickPhotoFromPhotoLibrary:nil];
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo with Camera"])
        [self pickPhotoFromCamera:nil];		
}



- (void)pickPhotoFromCamera:(id)sender {
    // Set source to the camera
	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    
    // Allow editing of image ?
	imagePicker.allowsEditing = NO;
    
    // Show image picker
	[self presentModalViewController:imagePicker animated:YES];	
    // Picker is displayed asynchronously.
    ImagePickerControllerSourceType=1;
    imgPickerSelected=YES;
}

- (void)pickPhotoFromPhotoLibrary:(id)sender {
    // Create image picker controller
    
    
    // Set source to the camera
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    
    // Allow editing of image ?
	imagePicker.allowsEditing = NO;
    
    // Show image picker
	[self presentModalViewController:imagePicker animated:YES];	
    // Picker is displayed asynchronously.
    ImagePickerControllerSourceType=0;
    imgPickerSelected=YES;
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    float currentVersion = 5.0;
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVersion >= currentVersion) {
        // iOS 5.0 or later version of iOS specific functionality hanled here 
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        //Previous than iOS 5.0 specific functionality
        [self dismissModalViewControllerAnimated:YES];
        
    }
    
    SetDifficultyVC * temp = [[[SetDifficultyVC alloc] init] autorelease];
    NSData *dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],0.1);
    temp.Email = Email;
    [temp setint:-1];
    temp.selectedImage=[UIImage imageWithData:dataImage];
    [self.navigationController pushViewController:temp animated:YES];
    
/*
    imagePreView *imageprocessing=[[[imagePreView alloc]init]autorelease];
    NSData *dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],0.1);
    imageprocessing.selectedImage=[UIImage imageWithData:dataImage];
    [imageprocessing setint:-1];
    imageprocessing.Email=Email;
    [self.navigationController pushViewController:imageprocessing animated:YES];
 */
    
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image  
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    else // All is well
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
        
    }
    [alert show];
    [alert release];
}
#pragma Own Function
-(IBAction)buttonPressed:(id)sender
{
//    imagePreView *imagepreView=[[[imagePreView alloc]init] autorelease];
//    imagepreView.selectedImage=[UIImage imageWithData:[[dataArray1 objectAtIndex:((UIButton*)sender).tag]objectForKey:@"image"]];
//    [imagepreView setint:((UIButton*)sender).tag];
//    imagepreView.Email=Email;
//    [self.navigationController pushViewController:imagepreView animated:YES];
    
    SetDifficultyVC * temp = [[[SetDifficultyVC alloc] init] autorelease];
    temp.Email = Email;
    temp.selectedImage=[UIImage imageWithData:[[dataArray1 objectAtIndex:((UIButton*)sender).tag]objectForKey:@"image"]];
    [temp setint:((UIButton*)sender).tag];
    [self.navigationController pushViewController:temp animated:YES];
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
    if (cell == nil||[dataArray1 count]!=totalImages) {
       cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"cell"] autorelease]; 
        int ii=0,ii1=0;
        int offset=0;
        int start=[dataArray1 count]-1;
        totalImages=[dataArray1 count];
        if(ii==0)
            offset=4;
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
                CGRect rect = CGRectMake(offset+(4+75)*j, yy, 75, 70);
                button[ii]=[[[UIButton alloc] initWithFrame:rect] autorelease];
                NSDictionary *fulldata=[dataArray1 objectAtIndex:start];
                NSData *imagedata1=[fulldata objectForKey:@"image"];
                button[ii].tag=ii2;
                UIImage *buttonImageNormal=[[[UIImage alloc]initWithData:imagedata1] autorelease];
                [button[ii] setImage:buttonImageNormal forState:UIControlStateNormal];
                [button[ii] addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button[ii]]; 
                [[button[ii] layer] setBorderColor:[[UIColor grayColor] CGColor]];
                
                [[ button[ii] layer] setBorderWidth:3];
                button[ii].clipsToBounds=YES;
                fulldata=nil;
                imagedata1=nil;
                buttonImageNormal=nil;
                ii++;
                ii2--;
                start--;
            }
            ii1 = ii1+1;
        }
    }
    return cell;
    
}
- (IBAction)moreButtonPressed:(id)sender {
//    [RevMobAds showPopup]; // Sher
//    /* Sher
    Chartboost *cb = [Chartboost sharedChartboost];
//    cb.delegate = self;
//    cb.appId = @"4fe1fe28f87659966f00000d";
//    //    cb.appId=@"4fec316df87659b22f000006";
//    cb.appSignature = @"3fcf8281d7845374540a0ec5a2f2e7c9ac53c861";
    
    [cb showMoreApps];
     
//    [[Neocortex getInstance] showMoreScreen];
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
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}
@end
