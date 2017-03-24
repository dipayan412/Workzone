//
//  MRAlertView.h
//  MovieRide FX
//
//  Created by Ashif on 4/17/14.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRAlertViewDelegate

- (void)alertDialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface MRAlertView : UIView <MRAlertViewDelegate>

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, retain) UIView *buttonView;    // Buttons on the bottom of the dialog

@property (nonatomic, assign) id<MRAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;

@property (copy) void (^onButtonTouchUpInside)(MRAlertView *alertView, int buttonIndex) ;

- (id)init;

- (void)show;
- (void)closeAlert;

- (void)customDialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(MRAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;



@end
