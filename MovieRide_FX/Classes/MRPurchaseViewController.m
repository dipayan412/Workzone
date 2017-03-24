//
//  MRPurchaseViewController.m
//  MovieRide FX
//
//  Created by Ashif on 3/5/14.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRPurchaseViewController.h"
#import "MRAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "InAppPurchaseManager.h"
#import "MRUtil.h"
#import "MRCameraViewController.h"


@interface MRPurchaseViewController () <UIAlertViewDelegate, InAppProductDetailsDelegate>
{
    //UIAlertView *loadingView;
}

@property (nonatomic, strong) MPMoviePlayerController *player;
//@property (nonatomic) ProductType productType;
@property (nonatomic) UIImageView *firstFrmaeView;

@end

@implementation MRPurchaseViewController

@synthesize videoPlaceholderView;
@synthesize product;
//@synthesize productType;
@synthesize player;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    //[tracker set:kGAIScreenName value:MRCheckPointPurchase];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
	//loadingView = [[UIAlertView alloc] initWithTitle:@"" message:@"please wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    self.priceLabel.text = @"";
    self.priceLabel.alpha = 0.0f;
    
    NSString *clipResource = [self.product.previewClip stringByDeletingPathExtension];
    NSString *clipType = [self.product.previewClip pathExtension];
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:clipResource ofType:clipType];
    NSURL *videoUrl = [NSURL fileURLWithPath:videoPath];
    
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: videoUrl];
    //[self.player prepareToPlay];
    [self.player.view setFrame: self.videoPlaceholderView.frame];
    [self.view addSubview:self.player.view];
    [self.player setScalingMode:MPMovieScalingModeAspectFill];
    [self.player setRepeatMode:MPMovieRepeatModeOne];
    [self.player setAllowsAirPlay:NO];
    [self.player setControlStyle:MPMovieControlStyleNone];
    
    

}

-(void)viewWillAppear:(BOOL)animated {

    [self.player prepareToPlay];
    
    UIImage *firstFrameImage = [self.player thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    self.firstFrmaeView = [[UIImageView alloc] initWithFrame:self.videoPlaceholderView.frame];
    [self.view addSubview:self.firstFrmaeView];
    [self.firstFrmaeView setImage:firstFrameImage];
    [self.firstFrmaeView setContentMode:UIViewContentModeScaleAspectFill];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStarted) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];

    [self.player play];

}

-(void)videoStarted {
    NSLog(@"Movie started playing. Removing first frame image");
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
        [self.firstFrmaeView setHidden:YES];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    
    //self.productType = [MRUtil getTypeForFolderName:self.product.templateFolder];
    
    [InAppPurchaseManager getInstance].productDetailsDelegate = self;
    [[InAppPurchaseManager getInstance] getProductDetailsForProduct:self.product];
    
    //[loadingView show];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopPlayer)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumePlayer)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)stopPlayer
{
    [self.player pause];
}

-(void)resumePlayer
{
    [self.player play];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.player stop];
    
    [super viewWillDisappear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MRAppDelegate *adel = (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if ([segue.identifier isEqualToString:@"purchaseToCamera"])
    {
        MRCameraViewController *cameraController = (MRCameraViewController *)segue.destinationViewController;
        cameraController.product = self.product;
        cameraController.fromController = @"MRPurchaseViewController";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)initiatePurchase:(id)sender
{
    NSLog(@"purchase tapped");
    MRAppDelegate *adel = (MRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
//    [self.player stop];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Purchase %@", self.product.name] message:@"Want to enjoy new content by purchasing?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", @"Restore", nil];
    [alert show];
}

#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //[loadingView show];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPurchaseNow) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[InAppPurchaseManager getInstance] loadStoreForPruduct:self.product];
    }
    
    if (buttonIndex == 2)
    {
        //[loadingView show];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canRestoreNow) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[InAppPurchaseManager getInstance] loadStoreForPruduct:self.product];
    }
}

#pragma mark -
#pragma mark - InAppPurchaseDelegate Methods

-(void)localizedProductPrice:(NSString *)_price
{
    //[self hideLoadingAlert];
    
    [InAppPurchaseManager getInstance].productDetailsDelegate = nil;
    
    if(_price && _price.length>0)
    {
        _priceLabel.text = [NSString stringWithFormat:@"Price: %@", _price];
        [UIView animateWithDuration:0.4 animations:^{
            _priceLabel.alpha = 1.0;
        }];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"Product details are not available at the moment. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark - InAppPurchase Methods

-(void)canPurchaseNow
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self performSelectorOnMainThread:@selector(hideLoadingAlert) withObject:nil waitUntilDone:NO];
    
    
    if ([[InAppPurchaseManager getInstance] canMakePurchases])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
        
        /*
        if(self.productType == ProductTypeMRacer)
        {
            [[InAppPurchaseManager getInstance] purchaseMRacer];
        }
        else if (self.productType == ProductTypeSpaceWalk2)
        {
            [[InAppPurchaseManager getInstance] purchaseSpaceWalk2];
        }
        else if (self.productType == ProductTypeSpaceWars)
        {
            [[InAppPurchaseManager getInstance] purchaseSpaceWars1];
        }
        else if (self.productType == ProductTypeTransPodGiant)
        {
            [[InAppPurchaseManager getInstance] purchaseTranspodGiant];
        }
        */
        	[[InAppPurchaseManager getInstance] purchaseTemplate];
        
        //[loadingView show];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Failed" message:@"Cannot connection to appstore. Try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)canRestoreNow
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self performSelectorOnMainThread:@selector(hideLoadingAlert) withObject:nil waitUntilDone:NO];
    
    if ([[InAppPurchaseManager getInstance] canMakePurchases])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[InAppPurchaseManager getInstance] loadStoreForPruduct:self.product];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionCancelled) name:kInAppPurchaseManagerTransactionCancelledNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreFailed) name:kInAppPurchaseManagerInvalidRestoreNotification object:nil];
        
        [[InAppPurchaseManager getInstance] checkPurchasedItems];
        
        //[loadingView show];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Failed" message:@"Cannot connect to appstore. Try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)transactionCancelled
{
    NSLog(@"Transaction cancelled...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self performSelectorOnMainThread:@selector(hideLoadingAlert) withObject:nil waitUntilDone:NO];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)paymentFailed
{
    NSLog(@"Payment failed...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self performSelectorOnMainThread:@selector(hideLoadingAlert) withObject:nil waitUntilDone:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Failed" message:@"Payment failed. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)restoreFailed
{
    NSLog(@"Restore failed...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self performSelectorOnMainThread:@selector(hideLoadingAlert) withObject:nil waitUntilDone:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Failed" message:@"Failed to restore. Please try later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)paymentSucceeded
{
    NSLog(@"Payment succeeded...");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self performSelectorOnMainThread:@selector(hideLoadingAlert) withObject:nil waitUntilDone:NO];
    
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[MRUtil downloadableContentPath] error:&error];
    NSLog(@"files%@", files);
    if(files.count > 0)
    {
        NSString *path = [[MRUtil downloadableContentPath] stringByAppendingPathComponent:[files objectAtIndex:0]];
        
        MRAppDelegate *appDel = (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
        if([appDel saveDownloadedContentAndUnzipfile:path toFolder:self.product.templateFolder])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = nil;
            
            [fileManager removeItemAtPath:path error:&error];
        }
    }
    
    [self performSegueWithIdentifier:@"purchaseToCamera" sender:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/*
-(void)hideLoadingAlert
{
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
}
*/

@end
