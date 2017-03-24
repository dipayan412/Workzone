//
//  LoginViewController.h
//  Pharmacate
//
//  Created by Dipayan Banik on 6/21/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UIButton *signInButton;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIButton *signUpButton;
}
- (IBAction)signInButtonAction:(UIButton *)sender;
- (IBAction)signUpButtonAction:(UIButton *)sender;

@end
