//
//  NotificationCell.m
//  WakeUp
//
//  Created by World on 6/26/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

@synthesize acceptButton;
@synthesize denyButton;
@synthesize indexPath;
@synthesize afterActionStatusLabel;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
        [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [acceptButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [acceptButton setImage:[UIImage imageNamed:@"AcceptButton.png"] forState:UIControlStateNormal];
        [acceptButton addTarget:self action:@selector(acceptButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:acceptButton];
        
        denyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [denyButton setTitle:@"Deny" forState:UIControlStateNormal];
        [denyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [denyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [denyButton setImage:[UIImage imageNamed:@"DenyButton.png"] forState:UIControlStateNormal];
        [denyButton addTarget:self action:@selector(denyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:denyButton];
        
        afterActionStatusLabel = [[UILabel alloc] init];
        afterActionStatusLabel.backgroundColor = [UIColor clearColor];
        afterActionStatusLabel.textColor = [UIColor lightGrayColor];
        afterActionStatusLabel.font = [UIFont systemFontOfSize:11];
        afterActionStatusLabel.alpha = 0;
        [self.contentView addSubview:afterActionStatusLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    acceptButton.frame = CGRectMake(220, 2, 40, 40);
    denyButton.frame = CGRectMake(270, 2, 40, 40);
    afterActionStatusLabel.frame = CGRectMake(200, 0, 120, self.contentView.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)acceptButtonAction
{
    if(self.delegate)
    {
        [self.delegate acceptButtonActionAtRow:(int)indexPath.row];
    }
}

-(void)denyButtonAction
{
    if(self.delegate)
    {
        [self.delegate denyButtonActionAtRow:(int)indexPath.row];
    }
}

-(void)contactRequestPerformAction:(BOOL)isAccepted
{
    if(isAccepted)
    {
        afterActionStatusLabel.text = @"Contact Accepted";
        
        [UIView animateWithDuration:0.5f animations:^{
            acceptButton.alpha = 0;
            denyButton.alpha = 0;
            afterActionStatusLabel.alpha = 1;
        }];
    }
    else
    {
        afterActionStatusLabel.text = @"Contact Denied";
        
        [UIView animateWithDuration:0.5f animations:^{
            acceptButton.alpha = 0;
            denyButton.alpha = 0;
            afterActionStatusLabel.alpha = 1;
        }];
    }
}

@end
