//
//  TimeLineV2Cell.m
//  WakeUp
//
//  Created by World on 8/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "TimeLineV2Cell.h"

@implementation TimeLineV2Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.frame.origin.x;
    CGFloat y = self.contentView.frame.origin.y;
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
