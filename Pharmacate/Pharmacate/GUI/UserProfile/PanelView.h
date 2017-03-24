//
//  PanelView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PanelViewDelegate <NSObject>

-(void)backButtonAction;
-(void)userInfoButtonAction;
-(void)productButtonAction;
-(void)diseaseButtonAction;
-(void)allergyButtonAction;
-(void)allergyProductButtonAction;

@end

@interface PanelView : UIView

@property(nonatomic) id<PanelViewDelegate> delegate;
@property(nonatomic, strong) UIControl *userInfoButtonAction;
@property(nonatomic, strong) UIControl *diseaseButtonAction;
@property(nonatomic, strong)UIControl *allergyButtonAction;

-(void)userInfoButtonAction:(UIControl*)control;
-(void)diseaseButtonAction:(UIControl*)control;
-(void)allergyButtonAction:(UIControl*)control;

@end
