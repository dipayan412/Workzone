//
//  OverViewViewV2.h
//  Pharmacate
//
//  Created by Dipayan Banik on 8/29/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OverViewViewV2Delegate <NSObject>

-(void)imageButtonAction;
-(void)postReviewButtonAction;
-(void)alarmButtonAction;
-(void)bookmarkButtonAction;
-(void)bookmarkDeleteActionConfirmation;
-(void)whyButtonAction;
-(void)fbShareActionWithImage:(NSString*)_imageLink;
-(void)shareButtonActionWithImage:(UIImage*)_image;

@end

@interface OverViewViewV2 : UIView

@property(nonatomic) id <OverViewViewV2Delegate> delegate;
@property(nonatomic, strong) UIImageView *productImageView;
- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId;
-(void)bookmarkDeleteCall;

@end
