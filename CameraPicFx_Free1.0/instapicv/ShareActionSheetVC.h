//
//  ShareActionSheetVC.h
//  PhotoPuzzle
//
//  Created by Granjur on 03/04/2013.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTAnimation+UIView.h"
#import "FTAnimation.h"

@protocol ShareActionSheetDelegate <NSObject>

- (void)clickedButtonAtIndex:(int)index;

@end

@interface ShareActionSheetVC : UIViewController


@property (nonatomic, assign) id <ShareActionSheetDelegate> delegate;

-(IBAction)clickedButton:(id)sender;
-(void)show;
-(void)hide;

@end
