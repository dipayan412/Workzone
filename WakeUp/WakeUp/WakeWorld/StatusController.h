//
//  StatusController.h
//  WakeUp
//
//  Created by World on 8/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatusControllerDelegate;

@interface StatusController : UIViewController <UITextViewDelegate, ASIHTTPRequestDelegate>
{
    IBOutlet UILabel *goodMorningLabel;
    
    IBOutlet UITextView *statusTextView;
    IBOutlet UILabel *textCounterLabel;
    IBOutlet UIImageView *statusImageView;
    IBOutlet UIView *statusContainerView;
}
@property (nonatomic, assign) id <StatusControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *attachedImage;
@property (nonatomic, strong) NSString *attachedImageId;

-(IBAction)statusBGAction:(UIControl*)sender;

@end

@protocol StatusControllerDelegate <NSObject>

-(void)dismissStatusViewController:(UIViewController*)vc;

@end
