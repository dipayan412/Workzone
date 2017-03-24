//
//  MRPreviewViewController.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRPreviewViewController.h"
#import "MRAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MRCameraViewController.h"
#import "MRGalleryViewController.h"
#import "MRUtil.h"

@interface MRPreviewViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic) UIImageView *firstFrmaeView;

@end

@implementation MRPreviewViewController

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
    
    //[tracker set:kGAIScreenName value:MRCheckPointPreview];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopPlayer)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumePlayer)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
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
//    NSString *clipResource = [self.product.previewClip stringByDeletingPathExtension];
//    NSString *clipType = [self.product.previewClip pathExtension];
//    
//    NSString *videoPath = [[NSBundle mainBundle] pathForResource:clipResource ofType:clipType];
//    NSURL *videoUrl = [NSURL fileURLWithPath:videoPath];
//    
//    self.player = [[MPMoviePlayerController alloc] initWithContentURL: videoUrl];
//    [self.player prepareToPlay];
//    [self.player.view setFrame: self.videoPlaceholderView.frame];
//    [self.view addSubview:self.player.view];
//    [self.player setScalingMode:MPMovieScalingModeAspectFill];
//    [self.player setRepeatMode:MPMovieRepeatModeOne];
//    [self.player setAllowsAirPlay:NO];
//    [self.player setControlStyle:MPMovieControlStyleNone];
//    
//    [self.player play];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(stopPlayer)
//                                                 name:UIApplicationWillResignActiveNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(resumePlayer)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MRAppDelegate *adel =  (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if ([segue.identifier isEqualToString:@"Camera"]) {
        // add check point to testflight
        [MRUtil passCheckpointForTemplateFolder:self.product.templateFolder];
        
        MRCameraViewController *cameraController = (MRCameraViewController *)segue.destinationViewController;
        cameraController.product = self.product;
        cameraController.fromController = @"MRPreviewViewController";
    }
    else if ([segue.identifier isEqualToString:@"PreviewToGallery"]) {
        
        MRGalleryViewController *galleryController = (MRGalleryViewController *)segue.destinationViewController;
        galleryController.fromController = @"MRPreviewViewController";
    }
}

-(IBAction)unwindToPreview:(UIStoryboardSegue *)segue
{
    NSLog(@"Unwinded to preview");
}

-(IBAction)unwindToPreviewFromGallery:(UIStoryboardSegue *)segue
{
    NSLog(@"Unwinded to Preview");
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    NSLog(@"alertIndex %d", buttonIndex);
}

@end
