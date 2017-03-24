//
//  HistoryTableViewCell.m
//  MyPosition
//
//  Created by World on 11/17/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

@synthesize cityCountryLabel;
@synthesize dateLabel;
@synthesize attachmentImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        cityCountryLabel = [[UILabel alloc] init];
        dateLabel = [[UILabel alloc] init];
        attachmentImageView = [[UIImageView alloc] init];
        
        cityCountryLabel.font = dateLabel.font = [UIFont systemFontOfSize:13];
        
        cityCountryLabel.backgroundColor = [UIColor clearColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        attachmentImageView.backgroundColor = [UIColor clearColor];
        
        cityCountryLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:131.0f / 255.0f blue:36.0f / 255.0f alpha:1];
        
        [self.contentView addSubview:cityCountryLabel];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:attachmentImageView];
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
    
    attachmentImageView.frame = CGRectMake(x + 5, y + 10, 20, 20);
    dateLabel.frame = CGRectMake(attachmentImageView.frame.origin.x + attachmentImageView.frame.size.width + 5, y + 10, w/3 - 15, h - y - 20);
    cityCountryLabel.frame = CGRectMake(dateLabel.frame.origin.x + dateLabel.frame.size.width, y + 10, w/3 + 60, h - y - 20);
}

@end
