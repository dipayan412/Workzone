//
//  RA_ShareViewController.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_ShareViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UITextView *commentTextView;
    
    IBOutlet UIImageView *twitterCheckBoxImage;
    IBOutlet UIImageView *FacebookCheckBoxImage;
    
    IBOutlet UIButton *postButton;
}

-(IBAction)postButtonAction:(UIButton*)sender;

@end
