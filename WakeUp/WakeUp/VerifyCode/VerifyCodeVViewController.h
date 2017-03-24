//
//  VerifyCodeVViewController.h
//  WakeUp
//
//  Created by World on 7/1/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyCodeVViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *verifyCodeField;
}
@property (nonatomic, strong) NSString *encodedPhoneNumber;
-(IBAction)verifyButtonAction:(UIButton*)sender;
-(IBAction)resendButtonAction:(UIButton*)sender;

@end
