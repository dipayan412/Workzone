//
//  ReviewView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 8/29/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReviewViewDelegate <NSObject>

-(void)postReviewButtonAction;

@end

@interface ReviewView : UIView

@property(nonatomic) id <ReviewViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId;
- (void)getReviewsFromServer;

@end
