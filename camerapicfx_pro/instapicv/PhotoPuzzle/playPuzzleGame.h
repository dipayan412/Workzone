//
//  playPuzzleGame.h
//  PhotoPuzzle
//
//  Created by Synergy Computers on 6/27/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PlayHavenSDK.h"
//#import "ALInterstitialAd.h"
//#import "ALSharedData.h"
@interface playPuzzleGame : UIViewController //<PHPublisherContentRequestDelegate>
{
    UIImage *RealImage;
    CGPoint location1;
    int totalImages;
    NSMutableArray *imagePieces;
    NSMutableArray *imageRects;
    int touchedObjectNumber;
    NSMutableArray *alreadyDoneRects;
    UIImageView *imageView;
    int x;
    int y;
}
@property int totalImages;
@property(nonatomic,retain)UIImage *RealImage;
@property(nonatomic,retain)NSMutableArray *alreadyDoneRects;
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
- (UIImage *)imageWithImage:(UIImage *)image1 convertToSize:(CGSize)size;
- (UIImage*) maskImage:(UIImage *)image1 withMask:(UIImage *)maskImage;
- (UIImage *) changetoimage:(UIImageView *)EditView;
- (UIImage *) changetoimage1;
-(void)easyPuzzle;
-(void)easyPuzzlePlay:(int)firstNumber :(int)secondNumber;
-(void)mediumPuzzle;
-(void)mediumPuzzlePlay:(int)firstNumber :(int)secondNumber;
-(void)hardPuzzle;
-(void)hardPuzzlePlay:(int)firstNumber :(int)secondNumber;
@end
