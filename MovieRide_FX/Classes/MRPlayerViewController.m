//
//  MRPlayerViewController.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MRAppDelegate.h"
#import "YoutubeActivity.h"
#import "MRUtil.h"
#import <QuartzCore/QuartzCore.h>

@interface MRPlayerViewController () <UIWebViewDelegate>
{
    BOOL isPlayerInitialized;
    UIWebView *popUpView;
    UIView *contentView;
    CGRect originalFrame;
    BOOL isPopUpShown;
    BOOL shouldShowPopUp;
}

@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic) NSURL *fileURL;
@property (nonatomic, strong) NSTimer *videoTimer;

@end

@implementation MRPlayerViewController

@synthesize player;
@synthesize filePath;
@synthesize fileURL;
@synthesize fromController;
@synthesize videoTimer;


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
    
	[self.view bringSubviewToFront:customPlayerView];
        
    //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    //[tracker set:kGAIScreenName value:MRCheckPointPlayer];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"filePath %@", self.filePath);
    
    customPlayerView.contentMode = UIViewContentModeRedraw;
    [self.view bringSubviewToFront:customPlayerView];
    
    if(!isPlayerInitialized)
    {
        isPlayerInitialized = YES;
        
        movieProgressSlider.value = 0;
        
        self.fileURL = [[NSURL alloc] initFileURLWithPath:self.filePath];
        
        shouldShowPopUp = [self isVideoCreatedWithKhumba:self.fileURL];
        
        self.player = [[MPMoviePlayerController alloc] initWithContentURL: self.fileURL];
        [self.player prepareToPlay];
        [self.player.view setFrame: self.view.bounds];
        [self.view addSubview:self.player.view];
        [self.view sendSubviewToBack:self.player.view];
        [self.player setScalingMode:MPMovieScalingModeAspectFit];
        [self.player setFullscreen:NO];
        [self.player setControlStyle:MPMovieControlStyleNone];
        
        [self hideCustomControlView:YES];

        id observer;
        observer = [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackDidFinishNotification object:self.player queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSLog(@"playbackFinished");
            isPlaying = NO;
            [self.videoTimer invalidate];
            [self hideCustomControlView:NO];
            if(shouldShowPopUp)
            {
                [self showCustomPopUp];
            }
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(MPMoviePlayerLoadStateDidChange:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
        
        movieProgressSlider.minimumValue = 0;
        
        isPlaying = YES;
        [self.player play];
        
        self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateVideoPlayerSliderAndTime) userInfo:nil repeats:YES];
        
        // initializing custom popup
        
        contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        originalFrame = contentView.frame;
        contentView.backgroundColor = [UIColor clearColor];
        contentView.alpha = 0.0f;
        
//        popUpView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 15, contentView.frame.size.width - 30, contentView.frame.size.height - 30)];
        popUpView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        popUpView.delegate = self;
        popUpView.backgroundColor = [UIColor clearColor];
        popUpView.scalesPageToFit = YES;
//        popUpView.layer.cornerRadius = 7.0f;
//        popUpView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        popUpView.layer.borderWidth = 1;
        popUpView.scrollView.scrollEnabled = NO;
//        [contentView addSubview:popUpView];
        
//        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton.frame = CGRectMake(contentView.frame.size.width - 35, 3, 30, 30);
//        [cancelButton setImage:[UIImage imageNamed:@"delete_norm.png"] forState:UIControlStateNormal];
//        [cancelButton setImage:[UIImage imageNamed:@"delete_press.png"] forState:UIControlStateHighlighted];
//        [cancelButton addTarget:self action:@selector(canCelPopUp) forControlEvents:UIControlEventTouchUpInside];
//        
//        [contentView addSubview:cancelButton];
//        [contentView bringSubviewToFront:cancelButton];
        
//        [self.view addSubview:contentView];
        [self.view addSubview:popUpView];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"khumba" ofType:@"html"] isDirectory:NO];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [popUpView loadRequest:request];
        popUpView.hidden = YES;
    }
    
    [self.view bringSubviewToFront:customPlayerView];
//    [self.view bringSubviewToFront:contentView];
    
//    [self showCustomPopUp];
}

- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if ((self.player.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"content play length is %g seconds", self.player.duration);
        movieProgressSlider.maximumValue = self.player.duration;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateVideoPlayerSliderAndTime
{
    movieProgressSlider.value = self.player.currentPlaybackTime;
    
    if(!isPlaying)
    {
        [self.videoTimer invalidate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

-(IBAction)movieSliderValueChanged:(id)sender
{
    self.player.currentPlaybackTime = movieProgressSlider.value;
}

-(IBAction)playPauseButtonPressed:(id)sender
{
    MRAppDelegate *adel =  (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if(!isPlaying)
    {
        isPlaying = YES;
        [self.player play];
        self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateVideoPlayerSliderAndTime) userInfo:nil repeats:YES];
        [self hideCustomControlView:YES];
        if(isPopUpShown)
        {
            [self hideCustomPopUp];
        }
    }
}

-(IBAction)playFromBeginingPressed:(id)sender
{
    MRAppDelegate *adel =  (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if(!isPlaying)
    {
        [self.player stop];
        isPlaying = YES;
        [self.player play];
        self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateVideoPlayerSliderAndTime) userInfo:nil repeats:YES];
        [self hideCustomControlView:YES];
        
        if(isPopUpShown)
        {
            [self hideCustomPopUp];
        }
    }
}

-(IBAction)deleteButtonPressed:(id)sender
{
    MRAppDelegate *adel =  (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you want to remove this video. This action can not be undone." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

-(IBAction)backButtonPresse:(id)sender
{
    MRAppDelegate *adel = (MRAppDelegate*)  [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if(isPlaying)
    {
        [self.player stop];
        [self.videoTimer invalidate];
    }
    
    if([self.fromController isEqualToString:@"MRProcessingViewController"])
    {
        [self performSegueWithIdentifier:@"UnwindToClips" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"UnwindToGallery" sender:self];
    }
}

-(IBAction)shareButtonPressed:(id)sender
{
    MRAppDelegate *adel =  (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    // creating items array: which items will be published to the social sites
    
    // user must have facebook enabled from device settings (simulator settings will work too)
    
//    NSMutableString *body = [NSMutableString string];
//    // add HTML before the link here with line breaks (\n)
//    [body appendString:@"<a href=\"http://www.movieridefx.com\">Click here!</a>\n"];
    
//    NSArray * activityItems = @[[NSString stringWithFormat:@"Be IN the movies with the MovieRide FX app.\n\n%@", body],self.fileURL];
    
    NSArray * activityItems = @[[NSString stringWithFormat:@"Be IN the movies with the MovieRide FX app.\n\nhttp://www.movieridefx.com"],self.fileURL];
    
    
    // Create the activity view controller passing in the activity provider, image and url we want to share along with the additional source we want to appear (youtube)
    
    YoutubeActivity *youtubeActivity = [[YoutubeActivity alloc] init];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:@[youtubeActivity]];
    [activityViewController setValue:@"My MovieRide FX movie" forKey:@"subject"];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypePostToTencentWeibo,UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
    
    activityViewController.completionHandler = ^(NSString *activityType, BOOL completed)
    {
        if(completed)
        {
            NSLog(@"%@", activityType);
            if([activityType isEqualToString:@"com.apple.UIKit.activity.SaveToCameraRoll"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Video saved to camera roll." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            else if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToFacebook"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Video will be published to Facebook." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            else if([activityType isEqualToString:@"com.apple.UIKit.activity.Mail"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Mail will be sent shortly." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
        
        if([activityType isEqualToString:@"com.mobilica.youtubesharing"])
        {
            // for youtube share, present the youtube login viewcontroller, sharing is handled from there
            
            YoutubeLoginViewController *loginVC = [[YoutubeLoginViewController alloc] initWithNibName:@"YoutubeLoginViewController" bundle:nil];
            loginVC.delegate = self;
            loginVC.filePath = self.filePath;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:navController animated:YES completion:nil];
        }
    };
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)dismissYoutubeShareView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self.player stop];
        [self.videoTimer invalidate];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePathToDelete = self.filePath;
        
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePathToDelete error:&error];
        if (success)
        {
            if([self.fromController isEqualToString:@"MRProcessingViewController"])
            {
                [self performSegueWithIdentifier:@"UnwindToClips" sender:self];
            }
            else
            {
                [self performSegueWithIdentifier:@"UnwindToGallery" sender:self];
            }
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if (touch.view != customPlayerView)
    {
        if(isPlaying)
        {
            isPlaying = NO;
            
            [self.player pause];
            [self.videoTimer invalidate];
            [self hideCustomControlView:NO];
        }
    }
}

-(void)hideCustomControlView:(BOOL)_hide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    CGRect frame = customPlayerView.frame;
    if(_hide)
    {
        frame.origin.y = self.view.bounds.size.height + 5;
    }
    else
    {
        frame.origin.y = self.view.bounds.size.height - customPlayerView.frame.size.height;
    }
    customPlayerView.frame = frame;
    
	[UIView commitAnimations];
}

-(void)showCustomPopUp
{
    isPopUpShown = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    popUpView.hidden = NO;
    
    [UIView commitAnimations];
    
    /*
    contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    contentView.alpha = 0;
    [UIView beginAnimations:@"showAlert" context:nil];
    [UIView setAnimationDelegate:self];

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"khumba" ofType:@"html"] isDirectory:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [popUpView loadRequest:request];
    
    contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    contentView.alpha = 1;
    [UIView commitAnimations];
     */
}

-(void)hideCustomPopUp
{
    isPopUpShown = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    popUpView.hidden = YES;
    
    [UIView commitAnimations];
    /*
    [UIView beginAnimations:@"hideAlert" context:nil];
    [UIView setAnimationDelegate:self];
    contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    contentView.alpha = 0;
    [UIView commitAnimations];
     */
}

-(void)canCelPopUp
{
    [self hideCustomPopUp];
}

#pragma mark Animation delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"showAlert"])
    {
        if (finished)
        {
            [UIView beginAnimations:nil context:nil];
            contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView commitAnimations];
        }
    }
    else if ([animationID isEqualToString:@"hideAlert"])
    {
        if (finished)
        {
            contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            contentView.frame = originalFrame;
        }
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.absoluteString);
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}


-(BOOL)isVideoCreatedWithKhumba:(NSURL*)_fileUrl
{
    AVAsset *asset = [AVAsset assetWithURL:_fileUrl];
    
    NSArray *metadata = [asset commonMetadata];
    for (AVMetadataItem* item in metadata)
    {
        NSString *key = [item commonKey];
        NSString *value = [item stringValue];
        NSLog(@"key = %@, value = %@", key, value);
        if([key isEqualToString:@"title"])
        {
            if([value isEqualToString:mrKhumba])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
