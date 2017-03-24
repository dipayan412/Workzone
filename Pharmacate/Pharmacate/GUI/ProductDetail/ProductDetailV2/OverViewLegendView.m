//
//  OverViewLegendView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/3/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "OverViewLegendView.h"

@implementation OverViewLegendView

@synthesize legendView;
@synthesize legendTitleLabel;

- (id)init
{
    if ((self = [super init]))
    {
        [self commonInitialization];
    }
    return self;
}

-(void)commonInitialization
{
    self.backgroundColor = [UIColor clearColor];
    
    legendView = [[UIView alloc] init];
    [self addSubview:legendView];
    
    legendTitleLabel = [[UILabel alloc] init];
    legendTitleLabel.numberOfLines = 3;
    legendTitleLabel.font = [UIFont systemFontOfSize:8.0f];
    legendTitleLabel.backgroundColor = [UIColor clearColor];
    legendTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:legendTitleLabel];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    legendView.frame = CGRectMake(self.frame.size.height - 17, self.frame.size.height/2 - (self.frame.size.height - 5)/2, self.frame.size.height - 5, self.frame.size.height - 5);
    legendTitleLabel.frame = CGRectMake(legendView.frame.origin.x + legendView.frame.size.width + 5, 0, self.frame.size.width - legendView.frame.origin.x - legendView.frame.size.width - 5, self.frame.size.height);
}

@end
