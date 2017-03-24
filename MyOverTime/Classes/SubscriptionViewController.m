//
//  FlipsideViewController.m
//  DigiClock
//
//  Created by amuck on 10/29/08.
//  Copyright Amuck LLC 2008. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "StaticConstants.h"
//#import "SubscriptionProduct.h"
#import "MyOvertimeAppDelegate.h"
#import "SubscriptionDetailController.h"
#define  kHalfWidth 195
#define  kImage 100


@implementation SubscriptionViewController
@synthesize tableView;
@synthesize lastIndexPath;
@synthesize list,description;
@synthesize firstSelected,secondSelected;;
@synthesize purchaseManager;

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    loadingView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"LOADING_TITLE", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    self.tableView.backgroundView=nil;
    self.purchaseManager=[InAppPurchaseManager getInstance];
    self.navigationItem.title=kInAppNavigationTitle;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresheView) name:@"ProductPricesAvailable" object:nil];
   
    
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
   
    adjustFirstTwoSubscription=kAdjustFirstTwoSubscription;
}

-(void) refresheViewSubscription
{
    [self.tableView reloadData];
}

-(void) refresheView
{
    [self.tableView reloadData];
}

-(void) updateState
{
    [self.tableView reloadData];
}

-(void) closeView
{
	[self  dismissModalViewControllerAnimated:YES];
}


- (void)viewWilDisAppear:(BOOL) animated
{
}

- (void)viewWillAppear:(BOOL) animated
{
    [self setContentSizeForViewInPopover:CGSizeMake(320, 460)];
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app checkProductStatus];
  
    self.navigationItem.title= kInAppNavigationTitle;

    NSArray *array = [[NSArray alloc] initWithObjects:kSubscription1Text,kSubscription2Text,kSubscription3Text,kInAppRestoreTitle,@"",nil];
    self.list = array;
    [array release];
    
    NSArray *array2 = [[NSArray alloc] initWithObjects:kSubscriptionDetails1Text,kSubscriptionDetails2Text,kSubscriptionDetails3Text,kInAppRestoreDescription,@"",nil];
    self.description = array2;
    [array2 release];
    
	self.tableView.scrollEnabled=YES;
	
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    v.backgroundColor = [UIColor clearColor];
    UILabel *mainLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 3, 260, 16)] autorelease];
    mainLabel.textAlignment = UITextAlignmentCenter;
    mainLabel.font = [UIFont boldSystemFontOfSize:13]; //PK
    mainLabel.textColor=[UIColor blackColor]; //Pk
    mainLabel.text=@" ";
    mainLabel.backgroundColor=[UIColor clearColor];
    [v addSubview:mainLabel];
    
    
    [self.tableView setTableFooterView:v];
    [v release];

    //[app checkForSubscription];
    [self.tableView reloadData];
//    for (int i=0;i< [purchaseManager.productArray count]; i++)
//    {
//        SubscriptionProduct *text=[purchaseManager.productArray objectAtIndex:i];
//        text.isPurchased=[purchaseManager getProductStatus:text.productId];
//    }
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ProductPricesAvailable" object:nil];

	[tableView release];
	[lastIndexPath release];
	[list release];
	[description release];
	
	
	[super dealloc];
}



#pragma mark -
#pragma mark Table view data source

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;   	
}

- (NSInteger)tableView:(UITableView *)thetableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
//        return [purchaseManager.productArray count];
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)thetableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionsTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier ];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier: SectionsTableIdentifier ] autorelease];
		//Sub cell grid
        //int xpos=15;
        int xposWidth=290;

       
		UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, xposWidth, 19)];
		mainLabel.textAlignment = UITextAlignmentCenter;
		mainLabel.font = [UIFont boldSystemFontOfSize:16];
		mainLabel.tag=kTitle;
        mainLabel.textAlignment=UITextAlignmentLeft;
        mainLabel.backgroundColor=[UIColor clearColor];
		mainLabel.textColor=[UIColor blackColor]; //PK
		[cell.contentView addSubview: mainLabel];
		[mainLabel release];
		
        UILabel *mainLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 33, kHalfWidth, 19)];
		mainLabel2.textAlignment = UITextAlignmentCenter;
		mainLabel2.font = [UIFont systemFontOfSize:14.];
		mainLabel2.tag=kSubTitle;
        mainLabel2.textAlignment=UITextAlignmentLeft;
        mainLabel2.backgroundColor=[UIColor clearColor];
		mainLabel2.textColor=[UIColor blackColor]; //PK
		[cell.contentView addSubview: mainLabel2];
		[mainLabel2 release];
		
        
        UIImageView *mainImage = [[UIImageView alloc] initWithFrame: CGRectMake(10, 15, 40, 40)];
        mainImage.tag=kImage;
       // mainImage.image=[UIImage imageNamed:@"address.png"];
        [cell.contentView addSubview: mainImage];
        mainImage.contentMode=UIViewContentModeScaleAspectFit;
        [mainImage release];
        

		
        UIImageView *mainImagePurchase = [[UIImageView alloc] initWithFrame: CGRectMake(260, 30, 24, 24)];
        mainImagePurchase.tag=kImage+1;
        [cell.contentView addSubview: mainImagePurchase];
        mainImagePurchase.contentMode=UIViewContentModeScaleAspectFit;
        [mainImagePurchase release];		
	}
	
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:kTitle];
    UILabel *titleSub = (UILabel *)[cell.contentView viewWithTag:kSubTitle];   
    if (indexPath.section==0)
    {
        title.text = [self.list objectAtIndex: indexPath.row+2*indexPath.section+adjustFirstTwoSubscription];
        titleSub.text = [self.description objectAtIndex: indexPath.row+2*indexPath.section+adjustFirstTwoSubscription];
    }
    else if (indexPath.section==1)
    {
        title.text = [self.list objectAtIndex: 3];
        titleSub.text = [self.description objectAtIndex: 3];
    }
    
    CGRect frame=titleSub.frame;
    CGSize maximumLabelSize = CGSizeMake(kHalfWidth,9999);
    CGSize expectedLabelSize = [titleSub.text sizeWithFont:[UIFont systemFontOfSize:14.]   constrainedToSize:maximumLabelSize   lineBreakMode:UILineBreakModeWordWrap]; 
    frame.size.height=expectedLabelSize.height;
    titleSub.frame=frame;
    titleSub.numberOfLines=0;

    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kImage];   
    if (indexPath.row==0 && indexPath.section==0)
    {
        imageView.image=[UIImage imageNamed:@"Icon1.png"];
    }
    if (indexPath.row==1)
    {
        imageView.image=[UIImage imageNamed:@"Icon2.png"];
    }
    if(indexPath.row == 2)
    {
        imageView.image=[UIImage imageNamed:@"dropbox.png"];
    }
    if (indexPath.section==0)
    {
        CGRect frame=title.frame;
        frame.origin.x=60;
        title.frame=frame;
        
        frame=titleSub.frame;
        frame.origin.x=60;
        titleSub.frame=frame;
    }
    else
    {
        CGRect frame=title.frame;
        frame.origin.x=10;
        title.frame=frame;
        
        frame=titleSub.frame;
        frame.origin.x=10;
        titleSub.frame=frame;
    }
    
    UIImageView *imageView2 = (UIImageView *)[cell.contentView viewWithTag:kImage+1];   
    imageView2.image=[UIImage imageNamed:@"checked.png"];
    imageView2.hidden=YES;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(200, 140, 80, 28);
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:@"green_btn.png"]  forState:UIControlStateNormal];
	button.tag=indexPath.row;
    if (indexPath.section==1)
    {
        button.tag=100;
    }
	button.titleLabel.font= [UIFont boldSystemFontOfSize:13];
    [button addTarget:self action:@selector(requestProduct:) forControlEvents:UIControlEventTouchUpInside];    
    if (indexPath.section==0)
    {
        MyOvertimeAppDelegate *app = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
        if (indexPath.row == 0)
        {
            if(app.isProduct1Purchased)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                imageView2.hidden=NO;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                imageView2.hidden=YES;
            }
        }
        else if (indexPath.row == 1)
        {
            if(app.isProduct2Purchased)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                imageView2.hidden=NO;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                imageView2.hidden=YES;
            }
        }
        else if (indexPath.row == 2)
        {
            if(app.isProduct3Purchased)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                imageView2.hidden=NO;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                imageView2.hidden=YES;
            }
        }

    }
    if (indexPath.section==1 && indexPath.row==0)
    {
        [button setTitle:kInAppTitleButton forState:UIControlStateNormal];    
    }
    //cell.accessoryView=button;

    if (indexPath.section==1)
    {
        cell.accessoryView=button;
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOvertimeAppDelegate *app = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.section==1)
    {
        return;
    }
	
    if(indexPath.row == 0)
    {
        if (app.isProduct1Purchased)
        {
            return;
        }
    }
    else if (indexPath.row == 1)
    {
        if (app.isProduct2Purchased)
        {
            return;
        }
    }
    else
    {
        if (app.isProduct3Purchased)
        {
            return;
        }
    }
    
    SubscriptionDetailController *controller=[[[SubscriptionDetailController alloc]init]autorelease];
    controller.productIdentifier=indexPath.row;
    controller.productDescription= [self.description objectAtIndex: indexPath.row+2*indexPath.section+adjustFirstTwoSubscription];
    controller.productHeader= [self.list objectAtIndex: indexPath.row+2*indexPath.section+adjustFirstTwoSubscription];

    [self.navigationController pushViewController:controller animated:YES];

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return kInAppTitle1; //PK
    }
	return kInAppTitle3;

}
	
-(IBAction)requestProduct:(id)sender
{
    MyOvertimeAppDelegate *app = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app.isProduct1Purchased && app.isProduct2Purchased && app.isProduct3Purchased)
    {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreCompleted) name:kInAppPurchaseManagerRestoreCompleteNotification object:nil];
    
    [loadingView show];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:purchaseManager];
    
    [purchaseManager checkPurchasedItems];
}


//Implements rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark - AlertView Delegate Method

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(buttonIndex == 0)
    {
        [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    }
    if (buttonIndex == 1)
    {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
        
        NSLog(@"Should not call this, button index 1");
    }
    if(buttonIndex == 2)
    {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreCompleted) name:kInAppPurchaseManagerRestoreCompleteNotification object:nil];
//        
//        [[InAppPurchaseManager getInstance] checkPurchasedItems];
//        
//        [((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController addBussyScreen];
        
        NSLog(@"Should not call this, button index 2");
    }
}

#pragma mark -
#pragma mark - InAppPurchase Methods

-(void)transactionCancelled
{
    NSLog(@"Transaction cancelled...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
}

-(void)paymentFailed
{
    NSLog(@"Payment failed...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPGRADE_FAIL_TITLE", nil) message:NSLocalizedString(@"UPGRADE_FAIL_MESSAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
}

-(void)restoreCompleted
{
    NSLog(@"Restore completed...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self updateViewChange];
    [NSTimer timerWithTimeInterval:2 target:self selector:@selector(updateAfterPurchase) userInfo:nil repeats:NO];
    
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RESTORE_COMPLETE_TITLE", nil) message:NSLocalizedString(@"RESTORE_COMPLETE_MESSAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)paymentSucceeded
{
    NSLog(@"Payment succeeded...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    
//    [self updateViewChange];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateAfterPurchase) userInfo:nil repeats:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE_DONE", nil) message:NSLocalizedString(@"RESTORE_COMPLETE_TITLE", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alert show];
    [alert release];
}

-(void)updateAfterPurchase
{
    [self updateViewChange];
}

-(void)updateViewChange
{
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app checkProductStatus];
    
    [tableView reloadData];
}

//<body bgcolor=transparent lang=EN-US link=blue vlink=purple style='tab-interval:.5in'>

//<meta name='viewport' content='width=device-width; initial-scale=0.5; maximum-scale=0.5;'>




@end
