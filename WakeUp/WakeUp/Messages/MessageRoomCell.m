//
//  MessageRoomCell.m
//  WakeUp
//
//  Created by World on 7/15/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "MessageRoomCell.h"

@implementation MessageRoomCell

@synthesize senderNameLabel;
@synthesize chatMessageLabel;
@synthesize dateLabel;
@synthesize deliveryIndicator;
@synthesize bubbleImage;
@synthesize senderImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        bubbleImage = [[UIImageView alloc] init];
        bubbleImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bubbleImage];
        
        senderNameLabel = [[UILabel alloc] init];
        senderNameLabel.backgroundColor = [UIColor clearColor];
        senderNameLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:senderNameLabel];
        
        chatMessageLabel = [[UILabel alloc] init];
        chatMessageLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:chatMessageLabel];
        
        dateLabel = [[UILabel alloc] init];
        dateLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:dateLabel];
        
        deliveryIndicator = [[UIActivityIndicatorView alloc] init];
        deliveryIndicator.backgroundColor = [UIColor clearColor];
        deliveryIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        deliveryIndicator.hidesWhenStopped = YES;
        [self.contentView addSubview:deliveryIndicator];
        
        senderImageView = [[UIImageView alloc] init];
        senderImageView.contentMode = UIViewContentModeScaleAspectFit;
        senderImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:senderImageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)indicatorStartAnimating
{
    [deliveryIndicator startAnimating];
}

-(void)indicatorStopAnimating
{
    [deliveryIndicator stopAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
