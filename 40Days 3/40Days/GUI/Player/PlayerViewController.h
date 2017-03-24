//
//  PlayerViewController.h
//  40 Days Retry
//
//  Created by Algonyx on 5/30/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController : UIViewController <AVAudioPlayerDelegate>
{
    IBOutlet UIImageView *audioPlayerArea;
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *previousSessionButton;
    
    IBOutlet UILabel *dayNumberLabel;
    
    IBOutlet UIButton *playStopButton;
    IBOutlet UIButton *repeatButton;
    IBOutlet UIButton *volumeMuteButton;
    
    IBOutlet UISlider *audioPlayerSlider;
    IBOutlet UISlider *volumeSlider;
    
    IBOutlet UILabel *startTimeLabel;
    IBOutlet UILabel *endTimeLabel;
    
    BOOL isPlaying;
    BOOL isSoundMute;
    
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic,retain) NSTimer *audioTimer;
@property (nonatomic, assign) int currnetDay;
@property (nonatomic,retain) NSData *audioData;

- (IBAction)homeButtonAction:(id)sender;
- (IBAction)previuosSessionButtonAction:(id)sender;

- (IBAction)playStopButtonAction:(id)sender;
- (IBAction)repeatButtonAction:(id)sender;
- (IBAction)volumeMuteButtonAction:(id)sender;

- (IBAction)audioPlayerSliderChangedAction:(id)sender;
- (IBAction)volumeSliderChangedAction:(id)sender;

@end
