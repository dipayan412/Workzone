//
//  gameView.h
//  Puzzle
//
//  Created by muhammad sami ather on 6/6/12.
//  Copyright (c) 2012 swengg-co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gameView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FbGraph.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "ShareActionSheetVC.h"
#import "PlayHavenSDK.h"
#import "ALInterstitialAd.h"
#import "ALSharedData.h"
@interface gameView : UIViewController <UIActionSheetDelegate,UIAlertViewDelegate, MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,ShareActionSheetDelegate,PHPublisherContentRequestDelegate>

{
    NSString *complexityLevel;
    NSString *fontselection;
    NSString *textplace;
    NSString *text;
    
    UIImage *image;
    int x;
    int y;
    UILabel *textLabel;
    //NSString *text;
    NSMutableArray *imagePieces;
    NSMutableArray *imagerects;
    CGPoint location1;
    CGRect startingRect;
    int touchedObjectNumber;
    NSMutableArray *alreadyDoneRects;
    
    UIImage *Shareimage;
    NSString *Email;
    ////////////////////////////
    FbGraph *fbGraph;
    
	//we'll use this to store a feed post (when you press 'post me/feed').
	//when you press delete me/feed this is the post that's deleted
	NSString *feedPostId;

    ////sound
    BOOL playsound;
    
    ShareActionSheetVC * shareActionSheet;
    
}
@property (retain, nonatomic) UIImage *Shareimage;
@property (retain, nonatomic)NSString *Email;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSString *textplace;
@property (nonatomic, retain) NSString *complexityLevel;
@property (nonatomic, retain) NSString *fontselection;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic,retain) NSString *text;
@property (nonatomic, retain) ShareActionSheetVC * shareActionSheet;
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
- (UIImage *)imageWithImage:(UIImage *)image1 convertToSize:(CGSize)size;
- (UIImage*) maskImage:(UIImage *)image1 withMask:(UIImage *)maskImage;
- (UIImage *) changetoimage:(UIImageView *)EditView;
- (UIImage *) changetoimage1;
- (UIImage *)changetoimage2;
-(void)easyPuzzle;
-(void)easyPuzzlePlay:(int)firstNumber :(int)secondNumber;
-(void)mediumPuzzle;
-(void)mediumPuzzlePlay:(int)firstNumber :(int)secondNumber;
-(void)hardPuzzle;
-(void)hardPuzzlePlay:(int)firstNumber :(int)secondNumber;
- (void) loadPlayHaven;
@end
