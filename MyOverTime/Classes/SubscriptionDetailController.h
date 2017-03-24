//
//  SubscriptionDetailController.h
//  MyOvertime
//
//  Created by Prashant Choudhary on 4/28/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscriptionProduct.h"

@interface SubscriptionDetailController : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UIView *backView;
    IBOutlet UILabel *label,*labelTitle;
    IBOutlet UITextView *textView;

    IBOutlet UIButton *button;
    IBOutlet UIImageView *imageView;
    
    UIAlertView *loadingView;
    UIAlertView *paymentSuccessAlert;

}
@property (nonatomic,retain) SubscriptionProduct *product;
@property (nonatomic,retain) NSString *productHeader,*productDescription;
@property (nonatomic) NSInteger productIdentifier;
//@property (nonatomic,assign) 	id <SubscriptionDetailControllerDelegate> delegate;

@end

//@protocol SubscriptionDetailControllerDelegate
//- (void)requestBuyAction:(int )targetView;

//@end