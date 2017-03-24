//
//  GroupLocationCell.m
//  ETrackPilot
//
//  Created by World on 7/24/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "GroupLocationCell.h"

@implementation GroupLocationCell

@synthesize iconView;
@synthesize nameLabel, addressLabel, timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.iconView = [[UIImageView alloc] init];
        
        self.nameLabel = [[UILabel alloc] init];
        self.addressLabel = [[UILabel alloc] init];
        self.timeLabel = [[UILabel alloc] init];
        
        nameLabel.backgroundColor = [UIColor clearColor];
        addressLabel.backgroundColor = [UIColor clearColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:iconView];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:addressLabel];
        [self.contentView addSubview:timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x + 3;
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat w = self.contentView.bounds.size.width;
    CGFloat h = 35;
    
    iconView.frame = CGRectMake(x, y + 3, h, h);
    
    nameLabel.frame = CGRectMake(x + iconView.frame.size.width + 3, y + 3, w/2, h);
    addressLabel.frame = CGRectMake(x, y + iconView.frame.size.height + 1, w, h);
    timeLabel.frame = CGRectMake(x, y + (2 * iconView.frame.size.height) + 2, w, h);
}

@end
