//
//  mainview.h
//  Puzzle
//
//  Created by muhammad sami ather on 6/6/12.
//  Copyright (c) 2012 swengg-co. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AdWhirlView.h"
//#import "Chartboost.h"
#import "ALTabBarView.h"
//#import "PlayHavenSDK.h"

#import <AVFoundation/AVAudioPlayer.h>
@interface mainview : UIViewController <UITabBarDelegate/*,AdWhirlDelegate *//*,PHPublisherContentRequestDelegate*//*,ChartboostDelegate*/
    ,AVAudioPlayerDelegate,ALTabBarDelegate>
{
    UIView *_contentView;
    NSString *Email;
//    ALTabBarView * customizedTabBar;
}
@property (retain, nonatomic) IBOutlet UILabel *photoTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (retain, nonatomic) NSString *Email;
@property (retain, nonatomic) IBOutlet UITabBar *tabbar;

@property (nonatomic, retain) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UIButton *morebutton;
@property (retain, nonatomic) IBOutlet UIButton *optionbutton;
@property (retain, nonatomic) IBOutlet UIButton *PuzzleButton;

@property (nonatomic, retain) ALTabBarView * customizedTabBar;

@property (nonatomic, retain) IBOutlet UIImageView * notifier;

- (IBAction)MorePressed:(id)sender;
- (IBAction)OptionPressed:(id)sender;
- (IBAction)PuzzlePressed:(id)sender;

//- (void)loadPlayHaven;



@end
