//
//  DotView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 8/12/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DotViewDelegate <NSObject>

-(void)dotViewClickedWithIndex:(int)index;

@end

@interface DotView : UIView

- (id)initWithFrame:(CGRect)rect withIndex:(int)_index;

@property(nonatomic) int index;
@property(nonatomic, strong) UIView *circleView;
@property(nonatomic) id <DotViewDelegate> delegate;

@end
