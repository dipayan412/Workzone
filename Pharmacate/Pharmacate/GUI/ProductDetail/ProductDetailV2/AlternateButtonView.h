//
//  AlternateButtonView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 8/12/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlternateButtonView : UIView

-(id)initWithFrame:(CGRect)rect WithArray:(NSMutableArray*)_dataArray ParentView:(UIView*)_parentView;

@property(nonatomic, strong) UILabel *buttonLabel;

@end
