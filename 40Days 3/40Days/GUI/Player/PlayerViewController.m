//
//  PlayerViewController.m
//  40 Days Retry
//
//  Created by Algonyx on 5/30/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "PlayerViewController.h"
#import "math.h"
#import "AppData.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

@synthesize audioTimer;
@synthesize currnetDay;
@synthesize audioData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBar.png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lesson_background.png"]];
    self.title = @"40 Days With Christ";
    
    [playStopButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [repeatButton setBackgroundImage:[UIImage imageNamed:@"repeat.png"] forState:UIControlStateNormal];
    [volumeMuteButton setImage:[UIImage imageNamed:@"volume_transparent.png"] forState:UIControlStateNormal];
    
    isPlaying = NO;
    isSoundMute = NO;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithData:self.audioData error:nil];
    audioPlayer.delegate = self;
    
    audioPlayerSlider.minimumValue = 0;
    audioPlayerSlider.maximumValue = audioPlayer.duration;
    [audioPlayerSlider addTarget:self action:@selector(audioPlayerSliderChangedAction:) forControlEvents:UIControlEventValueChanged];
    
    volumeSlider.minimumValue = 0;
    volumeSlider.maximumValue = 1.0;
    [volumeSlider addTarget:self action:@selector(volumeSliderChangedAction:) forControlEvents:UIControlEventValueChanged];
    volumeSlider.value = 1.0;
    
    startTimeLabel.text = @"0:00";
    NSInteger mins = floor(audioPlayer.duration / 60);
    NSInteger secs = trunc(audioPlayer.duration - mins * 60);
    endTimeLabel.text = [NSString stringWithFormat:@"%d:%d",mins,secs];
    
    dayNumberLabel.text = [NSString stringWithFormat:@"%d", self.currnetDay];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.audioTimer invalidate];
    [audioPlayer stop];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)homeButtonAction:(id)sender
{
    
}

- (IBAction)previuosSessionButtonAction:(id)sender
{
    
}

- (IBAction)playStopButtonAction:(id)sender
{
    if(isPlaying)
    {
        [audioPlayer pause];
        [playStopButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        isPlaying = NO;
        [self.audioTimer invalidate];
    }
    else
    {
        [audioPlayer play];
        [playStopButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        isPlaying = YES;
        
        self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAudioPlayerSliderAndTime) userInfo:nil repeats:YES];
    }
}

- (IBAction)repeatButtonAction:(id)sender
{
    if(audioPlayer.numberOfLoops < 0)
    {
        audioPlayer.numberOfLoops = 0;
        [repeatButton setBackgroundImage:[UIImage imageNamed:@"repeat.png"] forState:UIControlStateNormal];
    }
    else
    {
        audioPlayer.numberOfLoops = - 1;
        [repeatButton setBackgroundImage:[UIImage imageNamed:@"repeat_highlighted.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)volumeMuteButtonAction:(id)sender
{
    if(isSoundMute)
    {
        audioPlayer.volume = volumeSlider.value;
        volumeSlider.enabled = YES;
        [volumeMuteButton setImage:[UIImage imageNamed:@"volume_transparent.png"] forState:UIControlStateNormal];
        isSoundMute = NO;
    }
    else
    {
        audioPlayer.volume = 0.0;
        volumeSlider.enabled = NO;
        [volumeMuteButton setImage:[UIImage imageNamed:@"mute_transparent.png"] forState:UIControlStateNormal];
        isSoundMute = YES;
    }
}

- (IBAction)audioPlayerSliderChangedAction:(id)sender
{
    audioPlayer.currentTime = audioPlayerSlider.value;
}

- (IBAction)volumeSliderChangedAction:(id)sender
{
    audioPlayer.volume = volumeSlider.value;
}

-(void)updateAudioPlayerSliderAndTime
{
    audioPlayerSlider.value = audioPlayer.currentTime;
    
    NSInteger mins = floor(audioPlayer.currentTime / 60);
    NSInteger secs = trunc(audioPlayer.currentTime - mins * 60);
    
    if(secs < 10)
    {
        startTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",mins,secs];
    }
    else
    {
        startTimeLabel.text = [NSString stringWithFormat:@"%d:%d",mins,secs];
    }
    
    NSInteger inverseTime = audioPlayer.duration - audioPlayer.currentTime;
    NSInteger iMins = floor(inverseTime / 60);
    NSInteger iSecs = trunc(inverseTime - iMins * 60);
    
    if(iSecs < 10)
    {
        endTimeLabel.text = [NSString stringWithFormat:@"-%d:0%d",iMins,iSecs];
    }
    else
    {
        endTimeLabel.text = [NSString stringWithFormat:@"-%d:%d",iMins,iSecs];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [playStopButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    isPlaying = NO;
}

- (void)dealloc
{
    [audioPlayerArea release];
    [homeButton release];
    [previousSessionButton release];
    [playStopButton release];
    [repeatButton release];
    [volumeMuteButton release];
    [audioPlayerSlider release];
    [volumeSlider release];
    [startTimeLabel release];
    [endTimeLabel release];
    [dayNumberLabel release];
    
    [super dealloc];
}
@end
