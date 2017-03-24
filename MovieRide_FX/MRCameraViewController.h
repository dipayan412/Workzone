//
//  MRCameraViewController.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/07.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MRProduct.h"

@interface MRCameraViewController : UIViewController <AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *fromController;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (nonatomic) MRProduct *product;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

- (IBAction)startStopPressed:(id)sender;

- (IBAction)toggleOverlay:(id)sender;
- (IBAction)toggleLight:(id)sender;
- (IBAction)toggleCamera:(id)sender;
-(IBAction)backButtonAction:(id)sender;


@end
