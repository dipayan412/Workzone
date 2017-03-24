//
//  OverViewView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OverViewViewDelegate <NSObject>

-(void)alarmButtonAction;
-(void)postReviewButtonAction;
-(void)bookmarkButtonAction;
-(void)bookmarkDeleteActionConfirmation;
-(void)shareButtonAction;

@end

@interface OverViewView : UIView

@property(nonatomic) id<OverViewViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId;
-(void)getReviewsFromServer;
-(void)bookmarkDeleteCall;

@end
