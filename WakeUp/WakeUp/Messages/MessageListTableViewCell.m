//
//  MessageListTableViewCell.m
//  WakeUp
//
//  Created by Ashif on 8/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "MessageListTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageListTableViewCell

@synthesize partnerPhotoView;
@synthesize partnerNameLabel;
@synthesize messageLabel;
@synthesize timeIconView;
@synthesize timeLabel;

- (void)awakeFromNib
{
    partnerPhotoView.layer.cornerRadius = 25.0f;
    partnerPhotoView.layer.borderWidth = 3.0f;
    partnerPhotoView.layer.borderColor = oddCellColor.CGColor;
    partnerPhotoView.layer.masksToBounds = YES;
    
    partnerPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    
    partnerNameLabel.textColor = oddCellColor;
    partnerNameLabel.font = [UIFont systemFontOfSize:15];
    
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font  = [UIFont systemFontOfSize:11.0f];
    
    messageLabel.font = [UIFont systemFontOfSize:11];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
