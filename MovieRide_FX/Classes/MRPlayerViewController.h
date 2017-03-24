//
//  MRPlayerViewController.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRTemplate.h"
#import "YoutubeLoginViewController.h"

@interface MRPlayerViewController : UIViewController <UIAlertViewDelegate, YoutubeShareDelegate>
{
    IBOutlet UIView *customPlayerView;
    IBOutlet UISlider *movieProgressSlider;
    
    BOOL isPlaying;
}

@property (nonatomic) MRTemplate *template;
@property (nonatomic) NSString *filePath;
@property (nonatomic) NSString *fromController;

-(IBAction)playPauseButtonPressed:(id)sender;
-(IBAction)shareButtonPressed:(id)sender;
-(IBAction)deleteButtonPressed:(id)sender;
-(IBAction)playFromBeginingPressed:(id)sender;
-(IBAction)backButtonPresse:(id)sender;
-(IBAction)movieSliderValueChanged:(id)sender;


@end
