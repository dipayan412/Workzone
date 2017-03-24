//
//  CheckInCell.m
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "CheckInCell.h"

@implementation CheckInCell

@synthesize dateLabel;
@synthesize cityCountryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.font = [UIFont systemFontOfSize:13];
        
        cityCountryLabel = [[UILabel alloc] init];
        cityCountryLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:131.0f / 255.0f blue:36.0f / 255.0f alpha:1];
        cityCountryLabel.font = [UIFont systemFontOfSize:13];
        
        dateLabel.backgroundColor = [UIColor clearColor];
        cityCountryLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:cityCountryLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x;
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat w = self.contentView.bounds.size.width;
    CGFloat h = self.contentView.bounds.size.height;
    
    dateLabel.frame = CGRectMake(x + 20, y, w/3, h);
    cityCountryLabel.frame = CGRectMake(dateLabel.frame.origin.x + dateLabel.frame.size.width, y, w/3 + 60, h);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
