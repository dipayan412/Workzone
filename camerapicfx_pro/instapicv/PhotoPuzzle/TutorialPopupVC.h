//
//  TutorialPopupVC.h
//  PhotoPuzzle
//
//  Created by Granjur on 01/04/2013.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTAnimation+UIView.h"
#import "FTAnimation.h"

@protocol TutorialPopupDelegate <NSObject>

- (void)closeClicked;

@end

@interface TutorialPopupVC : UIViewController



@property (nonatomic, assign) id <TutorialPopupDelegate> delegate;
- (IBAction)closeBtnClicked:(id)sender;
- (void)show;
- (void)hide;

@end
