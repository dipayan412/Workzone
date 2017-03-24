//
//  CamerActionSheetVC.h
//  PhotoPuzzle
//
//  Created by Granjur on 03/04/2013.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTAnimation.h"
#import "FTAnimation+UIView.h"
@protocol CameraActionSheetDelegate <NSObject>
- (void)clickedBtnAtIndex:(int)index;
@end

@interface CamerActionSheetVC : UIViewController

@property (nonatomic, assign) id <CameraActionSheetDelegate> delegate;

-(IBAction)clicked:(id)sender;
-(void)show;
-(void)hide;

@end
