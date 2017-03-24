//
//  SubscriptionDetailController.m
//  MyOvertime
//
//  Created by Prashant Choudhary on 4/28/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import "SubscriptionDetailController.h"
#import "StaticConstants.h"
#import "InAppPurchaseManager.h"

@interface SubscriptionDetailController ()

@end

@implementation SubscriptionDetailController
@synthesize product;
@synthesize productHeader,productDescription;
@synthesize productIdentifier;
//@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{
//    delegate=nil;
    [product release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loadingView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"LOADING_TITLE", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];		
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage)) {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}	
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
	[myImageView release];    
    
    //[self applyBackgroundToBackView];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=productHeader;
    
  	button.frame = CGRectMake(20, 290, 280, 34);
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:@"buy.png"]  forState:UIControlStateNormal];
	button.titleLabel.font= [UIFont boldSystemFontOfSize:13];
    [button addTarget:self action:@selector(requestProduct:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *productsArray = [[NSArray alloc] initWithArray:[[InAppPurchaseManager getInstance] productArray]];
    
    product = [productsArray objectAtIndex:productIdentifier];
    [button setTitle:[NSString stringWithFormat:@"%@ %@",kBuyButtonTitle,product.priceLocale] forState:UIControlStateNormal];
    
    
    textView.text=[NSString stringWithFormat:@"%@",kSubscriptionNarrativeDetails1Text];

    UIImage *image=[UIImage imageNamed:@"Icon1.png"];;
    if (productIdentifier==1)
    {
        image=[UIImage imageNamed:@"Icon2.png"];
        textView.text=[NSString stringWithFormat:@"%@",kSubscriptionNarrativeDetails2Text];
    }
    else if (productIdentifier==2)
    {
        image=[UIImage imageNamed:@"dropbox.png"];
        textView.text=[NSString stringWithFormat:@"%@",kSubscriptionNarrativeDetails3Text];
    }
    imageView.image=image;
    
    
    textView.backgroundColor=[UIColor clearColor];
    textView.editable=NO;
    label.frame=CGRectMake(106,82,180,22);
    
    CGRect frame=label.frame;
    CGSize maximumLabelSize = CGSizeMake(frame.size.width,9999);
    CGSize expectedLabelSize = [label.text sizeWithFont:[UIFont systemFontOfSize:17.]   constrainedToSize:maximumLabelSize   lineBreakMode:UILineBreakModeWordWrap]; 
    frame.size.height=expectedLabelSize.height;
    label.frame=frame;
    label.numberOfLines=0;
    labelTitle.frame=CGRectMake(106,60,180,22);
    labelTitle.text=productHeader;
    
}
-(IBAction)requestProduct:(id)sender
{
    [loadingView show];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPurchaseNow) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if(productIdentifier == 0)
    {
        [[InAppPurchaseManager getInstance] loadStoreForPruduct:ProductTypeDaysLimit];
    }
    else if (productIdentifier == 1)
    {
        [[InAppPurchaseManager getInstance] loadStoreForPruduct:ProductTypeExportData];
    }
    else if (productIdentifier == 2)
    {
        [[InAppPurchaseManager getInstance] loadStoreForPruduct:ProductTypeDropbox];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark - AlertView Delegate Method

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(alertView == paymentSuccessAlert)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if(buttonIndex == 0)
    {
        [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    }
    if (buttonIndex == 1)
    {
        
    }
    if(buttonIndex == 2)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreCompleted) name:kInAppPurchaseManagerRestoreCompleteNotification object:nil];
        
        [[InAppPurchaseManager getInstance] checkPurchasedItems];
        
        [loadingView show];
    }
}

#pragma mark -
#pragma mark - InAppPurchase Methods

-(void)canPurchaseNow
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    
    if ([[InAppPurchaseManager getInstance] canMakePurchases])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
        
        if(productIdentifier == 0)
        {
            [[InAppPurchaseManager getInstance] purchaseDaysLimit];
        }
        else if (productIdentifier == 1)
        {
            [[InAppPurchaseManager getInstance] purchaseExportData];
        }
        else if (productIdentifier == 2)
        {
            [[InAppPurchaseManager getInstance] purchaseDropbox];
        }
        
        [loadingView show];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPGRADE_FAIL_TITLE", nil) message:NSLocalizedString(@"UPGRADE_FAIL_MESSAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)transactionCancelled
{
    NSLog(@"Transaction cancelled...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    
}

-(void)paymentFailed
{
    NSLog(@"Payment failed...");
    
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPGRADE_FAIL_TITLE", nil) message:NSLocalizedString(@"UPGRADE_FAIL_MESSAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)restoreCompleted
{
    NSLog(@"Restore completed...");
    
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    
    paymentSuccessAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"IAP_TITLE", nil) message:NSLocalizedString(@"IAP_SUCCESS_MSG", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)otherButtonTitles:nil];
    [paymentSuccessAlert show];
    [paymentSuccessAlert release];
}


@end
