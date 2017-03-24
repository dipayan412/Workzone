//
//  MRCameraViewController.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/07.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRCameraViewController.h"
#import "MRAppDelegate.h"
#import "MRTemplate.h"
#import "MRUtil.h"
#import "MRProcessingViewController.h"
#import "MRPreviewViewController.h"
#import "MotionOrientation.h"

@interface MRCameraViewController ()
{
    BOOL backButtonPressed;
    BOOL isFrontCamera;
    BOOL userStoppedRecording;
    BOOL isOrientationLandscapeLeft;
    BOOL appEnteredBG;
    
    UIDeviceOrientation motionOrientation;
}

@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain) AVCaptureDevice *camera;
@property (nonatomic, retain) AVCaptureMovieFileOutput *movieOutput;

@property (nonatomic) MRTemplate *template;
@property (nonatomic) NSTimer *recordingTimer;
@property (nonatomic) NSDate *recordingStartDate;
@property (nonatomic) NSTimeInterval requiredRecordingInterval;
@property (nonatomic) UIImageView *overlayImageView;

@end

@implementation MRCameraViewController
@synthesize fromController;

BOOL isRecording = NO;

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
    
    //[tracker set:kGAIScreenName value:MRCheckPointCamera];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    //load template object
    
    NSString *templatesPath = [[MRUtil applicationDocumentsDirectory] stringByAppendingPathComponent:@"templates"];
    NSString *templatePath = [templatesPath stringByAppendingPathComponent:self.product.templateFolder];
    self.template = [MRTemplate templateFromPath:templatePath];
    
    [self determineRequiredRecordingInterval];
    
    self.session = [[AVCaptureSession alloc] init];
    
    self.camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.camera error:&error];
    if (videoInput) {
        [self.session addInput:videoInput];
    }
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        self.session.sessionPreset = AVCaptureSessionPreset640x480;
    }
    else {
        NSLog(@"WARNING: Could not set recording resolution to 640x480");
        assert(NO);
    }
    
    self.movieOutput = [[AVCaptureMovieFileOutput alloc] init];

    
    if ([self.session canAddOutput:self.movieOutput]) {
        [self.session addOutput:self.movieOutput];
    }
    else {
        NSLog(@"WARNING: Could not add movie output.");
    }
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect layerFrame = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    self.previewLayer.frame = layerFrame;

    [self.view.layer insertSublayer:self.previewLayer atIndex:0];    
    
    NSString *overlayPath = [self.template.path stringByAppendingPathComponent:self.template.sequence.pathToOverlayEnd];
    UIImage* overlayImage = [UIImage imageWithContentsOfFile:overlayPath];
    self.overlayImageView = [[UIImageView alloc] initWithImage:overlayImage];
    [self.overlayImageView setFrame:layerFrame];
    [self.overlayImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view insertSubview:self.overlayImageView belowSubview:self.backgroundView];
        
    AVCaptureConnection *connection = self.previewLayer.connection;
    AVCaptureConnection *movieOutputConnection = [self.movieOutput.connections objectAtIndex:0];
    
    //UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = [self interfaceOrientation];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        isOrientationLandscapeLeft = YES;
        [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
        [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        isOrientationLandscapeLeft = NO;
        [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
        [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    else
    {
        isOrientationLandscapeLeft = NO;
        [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
        [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    
    isFrontCamera = NO;
    
    [self.session startRunning];
    
    [self updateLightButtonVisibility];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self determineRequiredRecordingInterval];
    [self.timerLabel setTextColor:[UIColor greenColor]];
    [self resetTimerText];
    
    
    NSString *overlayPath = [self.template.path stringByAppendingPathComponent:self.template.sequence.pathToOverlayEnd];
    UIImage* overlayImage = [UIImage imageWithContentsOfFile:overlayPath];
    self.overlayImageView.image = overlayImage;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnteredBackground)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnteredForeground)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // Initialize MotionOrientation
    [MotionOrientation initialize];
}

-(void)appEnteredBackground
{
    appEnteredBG = YES;
}

-(void)appEnteredForeground
{
    if(!isRecording)
    {
        appEnteredBG = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    appEnteredBG = NO;
    [super viewWillDisappear:animated];
}

-(void)determineRequiredRecordingInterval {

    //record a few extra frames, just to make sure we have enough
    self.requiredRecordingInterval = self.template.sequence.recLengthInFrames / self.template.sequence.frameRate + 0.5;
    
    NSLog(@"self.requiredRecordingInterval %0.2f", self.requiredRecordingInterval);
}

#pragma mark - AVCaptureFileOutputRecordingDelegate Method

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@"Recording started.");
    isRecording = YES;
    
    //start the timer
    self.recordingStartDate = [NSDate date];
    [self.timerLabel setTextColor:[UIColor redColor]];
    self.recordingTimer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(updateRecordingTimer) userInfo:nil repeats:YES];
    //TODO should we perhaps schedule it on a different runloop?
    [[NSRunLoop mainRunLoop] addTimer:self.recordingTimer forMode:NSDefaultRunLoopMode];
    
    [self.startStopButton setImage:[UIImage imageNamed:@"stop_big_norm"] forState:UIControlStateNormal];
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"Recording stopped.");
    
    isRecording = NO;
    
    //stop the timer
    [self.recordingTimer invalidate];
    
    [self.startStopButton setImage:[UIImage imageNamed:@"rec_big_norm"] forState:UIControlStateNormal];
    
    if(!backButtonPressed && !userStoppedRecording && !appEnteredBG)
    {
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Continue" message:@"Are you happy with that take? (Tap NO to re-record)." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        //[alert show];
        
        //show progress screen
        [self performSegueWithIdentifier:@"Process" sender:self];
        
    }
    else if (appEnteredBG)
    {
        self.timerLabel.textColor = [UIColor greenColor];
        [self resetTimerText];
        
        NSString *overlayPath = [self.template.path stringByAppendingPathComponent:self.template.sequence.pathToOverlayStart];
        UIImage* overlayImage = [UIImage imageWithContentsOfFile:overlayPath];
        self.overlayImageView.image = overlayImage;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not complete recording." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
    if(userStoppedRecording)
    {
        userStoppedRecording = NO;
        
        [self.timerLabel setTextColor:[UIColor greenColor]];
        [self resetTimerText];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please record for a longer duration. Your device will stop recording automatically when the required time has elapsed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)updateRecordingTimer {
    NSTimeInterval lapsedInterval = [self.recordingStartDate timeIntervalSinceNow] * -1;

    [self updateTimerText];
    
    //stop recording if we have enough frames
    if (lapsedInterval >= self.requiredRecordingInterval)
    {
        [self.movieOutput stopRecording];

        [self.timerLabel setTextColor:[UIColor greenColor]];
        lapsedInterval = self.requiredRecordingInterval;
        [self updateTimerText];
        
        NSString *overlayPath = [self.template.path stringByAppendingPathComponent:self.template.sequence.pathToOverlayEnd];
        UIImage* overlayImage = [UIImage imageWithContentsOfFile:overlayPath];
        self.overlayImageView.image = overlayImage;
    }
}

-(void)updateTimerText {
    NSTimeInterval lapsedInterval = [self.recordingStartDate timeIntervalSinceNow] * -1;
    NSString *timerStr = [NSString stringWithFormat:@"%05.2f / %05.2f", lapsedInterval, self.requiredRecordingInterval];
    self.timerLabel.text = timerStr;
}

-(void)resetTimerText {
    NSTimeInterval lapsedInterval = 0.0;
    NSString *timerStr = [NSString stringWithFormat:@"%05.2f / %05.2f", lapsedInterval, self.requiredRecordingInterval];
    self.timerLabel.text = timerStr;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        //shoot again
        
        [self.timerLabel setTextColor:[UIColor greenColor]];
        [self resetTimerText];
        
        NSString *overlayPath = [self.template.path stringByAppendingPathComponent:self.template.sequence.pathToOverlayEnd];
        UIImage* overlayImage = [UIImage imageWithContentsOfFile:overlayPath];
        self.overlayImageView.image = overlayImage;
    }
    else
    {
        //show progress screen
        [self performSegueWithIdentifier:@"Process" sender:self];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    AVCaptureConnection *connection = self.previewLayer.connection;
    AVCaptureConnection *movieOutputConnection = [self.movieOutput.connections objectAtIndex:0];
    
    /*
    if(isFrontCamera)
    {
        [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
        [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    else
    {
        [connection setVideoOrientation:[[UIDevice currentDevice] orientation]];
        [movieOutputConnection setVideoOrientation:[[UIDevice currentDevice] orientation]];
    }
    */
    
    if(!isRecording)
    {
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            isOrientationLandscapeLeft = YES;
            [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
            [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
        }
        else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            isOrientationLandscapeLeft = NO;
            [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
        }
        else
        {
            isOrientationLandscapeLeft = NO;
            [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
        }
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    /*
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        NSLog(@"landscapeLeft");
    }
    else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"landscapeRight");
    }
    else
    {
        if (self.interfaceOrientation == UIInterfaceOrientationMaskPortraitUpsideDown)
        {
            NSLog(@"portratitUpSideDown");
        }
        else if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
        {
            NSLog(@"portratit");
        }
    }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopPressed:(id)sender {
    MRAppDelegate *adel = (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if (isRecording) {
        //stop
        userStoppedRecording = YES;
        
        [self.movieOutput stopRecording];
        
        NSString *overlayPath = [self.template.path stringByAppendingPathComponent:self.template.sequence.pathToOverlayEnd];
        UIImage* overlayImage = [UIImage imageWithContentsOfFile:overlayPath];
        self.overlayImageView.image = overlayImage;
        
    }
    else
    {
        // check orientation and show alert
        
        if([self isOrientatinSameAsDeviceOrientation])
        {
            //start
            NSString *overlayPath = [self.template.path stringByAppendingPathComponent:self.template.sequence.pathToOverlayStart];
            UIImage* overlayImage = [UIImage imageWithContentsOfFile:overlayPath];
            self.overlayImageView.image = overlayImage;
            
            
            AVCaptureConnection *connection = self.previewLayer.connection;
            AVCaptureConnection *movieOutputConnection = [self.movieOutput.connections objectAtIndex:0];
            
            //UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
            UIInterfaceOrientation interfaceOrientation = [self interfaceOrientation];
            if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
            {
                NSLog(@"Orientation is LANDSCAPE LEFT");
                
                isOrientationLandscapeLeft = YES;
                [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
                [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
            }
            else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
            {
                NSLog(@"Orientation is LANDSCAPE RIGHT");
                
                isOrientationLandscapeLeft = NO;
                [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
                [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            }
            else
            {
                NSLog(@"Orientation is INVALID: %d", interfaceOrientation);
                assert(NO);
                
                isOrientationLandscapeLeft = NO;
                [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
                [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            }
            
            NSString *path = [MRAppDelegate recordingFilePath];
            NSURL *url = [NSURL fileURLWithPath:path];
            
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:path])
            {
                NSLog(@"Deleting existing movie file.");
                NSError *error;
                [fm removeItemAtPath:path error:&error];
                if (error)
                {
                    NSLog(@"ERROR: %@", [error description]);
                }
            }
            
            [self.movieOutput startRecordingToOutputFileURL:url recordingDelegate:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Recording could not start because your device is currently in wrong orientation. Please hold your phone to match application's interface orientation and check that your device orientation is not locked in portrait mode." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (IBAction)toggleOverlay:(id)sender
{
    self.overlayImageView.hidden = !self.overlayImageView.hidden;
}

- (IBAction)toggleLight:(id)sender {
    
    if ([self.camera hasTorch] && [self.camera isTorchAvailable] && [self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        
        [self.camera lockForConfiguration:nil];
        [self.camera setTorchMode: self.camera.torchActive ? AVCaptureTorchModeOff : AVCaptureTorchModeOn];
        [self.camera unlockForConfiguration];
    }
}

- (IBAction)toggleCamera:(id)sender
{
    //Change camera source
    if(self.session)
    {
        //Remove existing input
        AVCaptureInput* currentCameraInput = [self.session.inputs objectAtIndex:0];
        
        [self.camera lockForConfiguration:nil];
        if([self.camera isTorchActive])
        {
            [self.camera setTorchMode: AVCaptureTorchModeOff];
        }
        [self.camera unlockForConfiguration];
        
        [self.session removeInput:currentCameraInput];
        
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            isFrontCamera = YES;
            self.camera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            isFrontCamera = NO;
            self.camera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        //Add input to session
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.camera error:nil];
        [self.session addInput:newVideoInput];
        
        AVCaptureConnection *connection = self.previewLayer.connection;
        AVCaptureConnection *movieOutputConnection = [self.movieOutput.connections objectAtIndex:0];
        
        if(isFrontCamera)
        {
            [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
        }
        else
        {
            UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
            if (deviceOrientation == UIInterfaceOrientationLandscapeLeft)
            {
                [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
                [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
            }
            else if (deviceOrientation == UIInterfaceOrientationLandscapeRight)
            {
                [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
                [movieOutputConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            }
        }
        
        [self updateLightButtonVisibility];
    }
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

-(void)updateLightButtonVisibility
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if ([self.camera hasTorch] && [self.camera isTorchAvailable] && [self.camera isTorchModeSupported:AVCaptureTorchModeOn])
    {
        self.flashButton.hidden = NO;
    }
    else
    {
        self.flashButton.hidden = YES;
    }
    [UIView commitAnimations];
}

-(IBAction)backButtonAction:(id)sender
{
    MRAppDelegate *adel = (MRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    backButtonPressed = YES;
    
    if(isRecording)
    {
        [self.movieOutput stopRecording];
        [self.session stopRunning];
    }
    
    if([self.fromController isEqualToString:@"MRPurchaseViewController"])
    {
        [self performSegueWithIdentifier:@"UnwindToClips" sender:self];
    }
    else if([self.fromController isEqualToString:@"MRPreviewViewController"])
    {
        [self performSegueWithIdentifier:@"UnwindToPreview" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Process"]) {
        
        if ([self.camera hasTorch] && [self.camera isTorchAvailable] && [self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
            
            [self.camera lockForConfiguration:nil];
            if([self.camera isTorchActive])
            {
                [self.camera setTorchMode: AVCaptureTorchModeOff];
            }
            [self.camera unlockForConfiguration];
        }
        
        MRProcessingViewController *processController = segue.destinationViewController;
        processController.template = self.template;
        processController.product = self.product;
        processController.rotateImage = isOrientationLandscapeLeft;
    }
}

-(IBAction)unwindToCamera:(UIStoryboardSegue *)segue
{
    NSLog(@"Unwinded to Camera");
}

-(BOOL)isOrientatinSameAsDeviceOrientation
{
    NSString *motionString = [self stringDescriptionForDeviceOrientation:[MotionOrientation sharedInstance].deviceOrientation];
    NSString *motionInterfaceString = [self stringDescriptionForInterdaceOrientation:[MotionOrientation sharedInstance].interfaceOrientation];
    NSString *deviceOrientationString = [self stringDescriptionForDeviceOrientation:[UIDevice currentDevice].orientation];
    NSString *interfaceOrientationString = [self stringDescriptionForInterdaceOrientation:self.interfaceOrientation];
    NSLog(@"motionStr %@", motionString);
    NSLog(@"motionInterfaceStr %@", motionInterfaceString);
    NSLog(@"deviceOrientationString %@", deviceOrientationString);
    NSLog(@"interfaceOrientationString %@", interfaceOrientationString);
    
    if(![motionInterfaceString isEqualToString:@"Portrait"] && ![motionInterfaceString isEqualToString:@"PortraitUpsideDown"])
    {
        if([motionInterfaceString isEqualToString:@"LandscapeLeft"])
        {
            return YES;
        }
        else
        {
            if([interfaceOrientationString isEqualToString:@"LandscapeRight"] && [deviceOrientationString isEqualToString:@"Portrait"])
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)motionOrientationChanged:(NSNotification *)notification
{
}

- (void)motionInterfaceOrientationChanged:(NSNotification *)notification
{

}

- (NSString *)stringDescriptionForDeviceOrientation:(UIDeviceOrientation)orientation
{
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
            return @"Portrait";
        case UIDeviceOrientationPortraitUpsideDown:
            return @"PortraitUpsideDown";
        case UIDeviceOrientationLandscapeLeft:
            return @"LandscapeLeft";
        case UIDeviceOrientationLandscapeRight:
            return @"LandscapeRight";
        case UIDeviceOrientationFaceUp:
            return @"FaceUp";
        case UIDeviceOrientationFaceDown:
            return @"FaceDown";
        case UIDeviceOrientationUnknown:
        default:
            return @"Unknown";
    }
}

- (NSString *)stringDescriptionForInterdaceOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
            return @"Portrait";
        case UIInterfaceOrientationPortraitUpsideDown:
            return @"PortraitUpsideDown";
        case UIInterfaceOrientationLandscapeLeft:
            return @"LandscapeLeft";
        case UIInterfaceOrientationLandscapeRight:
            return @"LandscapeRight";
        default:
            return @"Unknown";
    }
}

@end
