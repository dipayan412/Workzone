//
//  playPuzzle.h
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 6/26/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AdWhirlView.h"
//#import "AdWhirlDelegateProtocol.h"
//#import "Chartboost.h"
#import "FbGraph.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "ALTabBarView.h"

@interface playPuzzle : UIViewController </*AdWhirlDelegate,*/UITabBarDelegate,UIActionSheetDelegate,/*ChartboostDelegate,*/UIWebViewDelegate,AVAudioPlayerDelegate,ALTabBarDelegate>
{
    NSArray *dataArray1;
    NSString *Email;
    NSString *subject;
////////////////////////////
    FbGraph *fbGraph;
    
	//we'll use this to store a feed post (when you press 'post me/feed').
	//when you press delete me/feed this is the post that's deleted
	NSString *feedPostId;
    ////sound
    BOOL playsound;
    BOOL photoView;
    ALTabBarView * customizedTabBar;
}

@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
- (IBAction)moreButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *moreButton;
@property (retain, nonatomic)NSString *Email;
@property (retain, nonatomic)NSString *subject;
@property (retain, nonatomic) IBOutlet UITableView *allPhotoTable;

/////////////// New Sher
@property (nonatomic, retain) ALTabBarView * customizedTabBar;

@property (nonatomic, retain) IBOutlet UIImageView * bgImage;
@property (nonatomic, retain) IBOutlet UIButton * inviteBtn;

-(void)updateData;
-(void)loadData;
-(void)nextView:(NSString*)number;
@end
