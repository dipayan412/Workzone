//
//  PolicyView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/7/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PolicyViewDelegate <NSObject>

-(void)backgroundControlAction;

@end

@interface PolicyView : UIView

@property(nonatomic) id<PolicyViewDelegate> delegate;

@end
