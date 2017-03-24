//
//  UserDrawerView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/1/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserDrawerViewDelegate <NSObject>

-(void)hideDrawerView;
-(void)captureImageButtonAction;
-(void)logOutButtonAction;
-(void)historyButtonAction:(NSArray*)historyArray withDates:(NSArray*)dates;
-(void)userProfileButtonAction;
-(void)feedbackButtonAction;
-(void)pillReminderButtonAction;
-(void)myReviewsButtonAction;
-(void)faqButtonAction;
-(void)infoButtonAction;
-(void)conditionButtonAction;
-(void)allergyButtonAction;
-(void)termsButtonAction;
-(void)signOutButtonAction;
@end

@interface UserDrawerView : UIView

@property(nonatomic) id<UserDrawerViewDelegate> delegate;
@property(nonatomic, strong) UIImage *userImage;

-(void)userDrawerViewReloadData;

@end
