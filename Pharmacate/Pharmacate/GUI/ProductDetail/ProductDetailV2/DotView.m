//
//  DotView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/12/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "DotView.h"

@interface DotView()
{
    UIControl *containerControl;
}

@end

@implementation DotView

@synthesize index;
@synthesize circleView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)rect withIndex:(int)_index
{
    if ((self = [super initWithFrame:rect]))
    {
        self.index = _index;
        [self commonInitialization];
    }
    return self;
}

-(void)commonInitialization
{
    float circleWidth = 5;
    
    circleView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - circleWidth/2, self.frame.size.height/2 - circleWidth/2, circleWidth, circleWidth)];
    circleView.layer.cornerRadius = circleWidth/2;
    circleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:circleView];
    
    containerControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    containerControl.backgroundColor = [UIColor clearColor];
    [containerControl addTarget:self action:@selector(containerControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:containerControl];
}

-(void)containerControlAction
{
    if(delegate)
    {
        [delegate dotViewClickedWithIndex:self.index];
    }
}

@end
