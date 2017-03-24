//
//  MRProcessingViewController.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRProcessingViewController.h"
#import "MRAppDelegate.h"
#import "RXMLElement.h"
#import "UIImage+Resize.h"
#import "MRPlayerViewController.h"
#import "MRUtil.h"
#import <QuartzCore/QuartzCore.h>

@interface MRProcessingViewController () <UIAlertViewDelegate>

@property (nonatomic) CGRect progressImageMaxFrame;
@property (nonatomic) MRCompositor2 *compositor;
@property (nonatomic) NSString *destinationVideoPath;
@property (nonatomic) NSOperationQueue *compositorQueue;

@property BOOL busyWithAdvertAction;
@property BOOL processingFinished;

@end

@implementation MRProcessingViewController

@synthesize product;
@synthesize rotateImage;


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

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
	// Do any additional setup after loading the view.
    
    //Assumption: Image in storeyboard is set to max size by default
    self.progressImageMaxFrame = self.progressImageView.frame;
    [self showProgress:0.0];
    
    
    //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    //[tracker set:kGAIScreenName value:MRCheckPointProcessing];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    processedImageView.layer.cornerRadius = 10.0f;
    processedImageView.layer.borderWidth = 1;
    processedImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    processedImageView.backgroundColor = [UIColor clearColor];
    processedImageView.contentMode = UIViewContentModeScaleToFill;
    processedImageView.clipsToBounds = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseProcessing)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeProcessing)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [self startCompositor];
}


-(void)pauseProcessing
{
//    [self.compositor pauseProcessing];
    
    [self.compositorQueue cancelAllOperations];
    [self.compositor cancelProcessing];
}

-(void)resumeProcessing
{
//    [self.compositor resumeProcessing];
    [self startCompositor];
}


-(void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

-(void)startCompositor {
    
    //run on a background thread
    self.compositorQueue = [[NSOperationQueue alloc] init];
    self.compositorQueue.name = @"Compositor Queue";
    //compositorQueue.maxConcurrentOperationCount = 1;
    
    [self.compositorQueue addOperationWithBlock:^{
        
        self.compositor = [[MRCompositor2 alloc] initWithTemplate:self.template];
        self.compositor.delegate = self;
        self.compositor.rotateImage = self.rotateImage;
        [self.compositor compose];
    }];
    
}

//MRCompositor delegate method
-(void)compositorProgressNotification:(double)progress withRenderedImage:(UIImage *)_image
{
    [self showProgress:progress];
    if(_image)
    {
        [self updateProcessedImageViewWithImage:_image];
    }
}

-(void)compositorFinished {
    
    self.processingFinished = YES;
    
    if (self.busyWithAdvertAction) {
        NSLog(@"Processing finished, but user is busy with advert action.");
        return;
    }
    
    [self showProgress:1.0];
    NSLog(@"Compositing done");
    
    // adding directory
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"/MovieRide"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        NSError* error;
        if( [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
    
    // saving the processed video to documents directory
    
    NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"final.mov"];
//    NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"final.mp4"];
    NSString *clipType = [videoPath pathExtension];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
    NSString *dateStr = [dateformatter stringFromDate:[NSDate date]];
    
    int counter = [MRUtil getCounterForTemplateFolder:self.product.templateFolder];
    counter++;
    
    self.destinationVideoPath = [NSString stringWithFormat:@"%@/%@_%@_take:%02d.%@", dataPath, self.product.templateFolder, dateStr, counter, clipType];
    
    if ([fileManager fileExistsAtPath:self.destinationVideoPath] == NO)
    {
//        [fileManager copyItemAtPath:videoPath toPath:self.destinationVideoPath error:&error];
        
        // adding metadata to video
        
        NSMutableArray *metadata = [NSMutableArray array];
        AVMutableMetadataItem *name = [AVMutableMetadataItem metadataItem];
        name.key = AVMetadataCommonKeyTitle;
        name.keySpace = AVMetadataKeySpaceCommon;
        name.value = [NSString stringWithFormat:@"%@", self.product.templateFolder];
        [metadata addObject:name];
        
        AVMutableMetadataItem *date = [AVMutableMetadataItem metadataItem];
        date.key = AVMetadataCommonKeyCreationDate;
        date.keySpace = AVMetadataKeySpaceCommon;
        date.value = [NSString stringWithFormat:@"%@", dateStr];
        [metadata addObject:date];
        
        AVMutableMetadataItem *take = [AVMutableMetadataItem metadataItem];
        take.key = AVMetadataCommonKeyIdentifier;
        take.keySpace = AVMetadataKeySpaceCommon;
        take.value = [NSString stringWithFormat:@"take:%d", counter];
        [metadata addObject:take];
        
        AVMutableMetadataItem *software = [AVMutableMetadataItem metadataItem];
        software.key = AVMetadataCommonKeySoftware;
        software.keySpace = AVMetadataKeySpaceCommon;
        software.value = @"MovieRide Fx";
        [metadata addObject:software];
        
        AVMutableMetadataItem *publisher = [AVMutableMetadataItem metadataItem];
        publisher.key = AVMetadataCommonKeyPublisher;
        publisher.keySpace = AVMetadataKeySpaceCommon;
        publisher.value = @"Waterson";
        [metadata addObject:publisher];
        
        AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
        NSLog(@"asseturl %@", videoAsset.URL);
        
//        AVAssetExportSession *_videoExportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetMediumQuality];
        AVAssetExportSession *_videoExportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetPassthrough];
        
        NSURL *url = [NSURL fileURLWithPath:self.destinationVideoPath isDirectory:NO];
        _videoExportSession.outputURL = url;
        NSLog(@"_videoExportSession.outputURL %@", _videoExportSession.outputURL);
        _videoExportSession.outputFileType = AVFileTypeQuickTimeMovie;
//        _videoExportSession.outputFileType = AVFileTypeMPEG4;
        _videoExportSession.shouldOptimizeForNetworkUse = YES;
        _videoExportSession.metadata = metadata;
        
        [_videoExportSession exportAsynchronouslyWithCompletionHandler:^(void){
            NSLog(@"export");
            switch ([_videoExportSession status])
            {
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Export sucess");
                    break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[_videoExportSession error] description]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                default:
                    break;
            }
            
            // update take number for template
            [MRUtil setCounterForTemplateFolder:self.product.templateFolder counter:counter];
            
            // skip icloud backup
//            [self addSkipBackupAttributeToItemAtURL:_videoExportSession.outputURL];
            // perform segue
            
            [self performSelectorOnMainThread:@selector(gotToPlayer) withObject:nil waitUntilDone:NO];
        }];
    }
}

//progress is normalized (value between 0 and 1)
-(void)showProgress:(double)progress {
    
    //must update GUI on main thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        double newWidth = self.progressImageMaxFrame.size.width * progress;
        CGRect newFrame = self.progressImageMaxFrame;
        newFrame.size.width = newWidth;
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.progressImageView setFrame:newFrame];
        }];
                
    }];
}

-(void)updateProcessedImageViewWithImage:(UIImage*)_image
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{

        [UIView animateWithDuration:0.4 animations:^{
            processedImageView.image = _image;
        }];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotToPlayer
{
    [self performSegueWithIdentifier:@"Player" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MRAppDelegate *adel = (MRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if ([segue.identifier isEqualToString:@"Player"]) {
        MRPlayerViewController *playerController = (MRPlayerViewController *)segue.destinationViewController;
        playerController.template = self.template;
        playerController.fromController = @"MRProcessingViewController";
        playerController.filePath = self.destinationVideoPath;
    }
    else if ([segue.identifier isEqualToString:@"UnwindToCamera"])
    {
        [self.compositorQueue cancelAllOperations];
        [self.compositor cancelProcessing];
    }
}

-(IBAction)cancelProcess:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure, you want to cancel the process and re-shoot?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self performSegueWithIdentifier:@"UnwindToCamera" sender:self];
    }
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success)
    {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    else
    {
        NSLog(@"excluded");
    }
    return success;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"bannerViewDidLoadAd");
    [UIView animateWithDuration:0.4 animations:^{
        self.advertView.alpha = 1.0;
    }];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    BOOL shouldBegin = !self.processingFinished;
    if (shouldBegin) {
        self.busyWithAdvertAction = YES;
    }
    
    NSLog(@"bannerViewActionShouldBegin");
    return (shouldBegin);
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner {
    NSLog(@"bannerViewActionDidFinish");
    
    self.busyWithAdvertAction = NO;
    
    if (self.processingFinished) {
        NSLog(@"Calling compositorFinished because advert interaction finished.");
        [self compositorFinished];
    }
}


@end
