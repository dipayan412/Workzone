//
//  CredentialView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 6/29/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CredentialViewDelegate <NSObject>

@optional
-(void)emailFieldBeganEditing;
-(void)emailFieldEndedEditing:(NSString*)emailString;
-(void)passWordFieldBeganEditing;
-(void)passWordFieldEndedEditing:(NSString*)passWordString;
-(void)facebookButtonAction;
-(void)googleButtonAction;
-(void)twitterButtonAction;
-(void)skipSignInButtonAction;
-(void)forgotPassWordButtonAction;
-(void)signInButtonAction;
-(void)signUpButtonAction;
-(void)termsButtonAction;

@end

@interface CredentialView : UIView

@property(nonatomic) id <CredentialViewDelegate> delegate;
@property(nonatomic) CGRect googleButtonFrame;

@end
