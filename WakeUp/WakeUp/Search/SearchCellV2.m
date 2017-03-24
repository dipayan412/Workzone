//
//  SearchCellV2.m
//  WakeUp
//
//  Created by World on 8/5/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SearchCellV2.h"

@implementation SearchCellV2

@synthesize invitationStatusLabel;
@synthesize actionButton;
@synthesize delegate;
@synthesize indexPath;
@synthesize userImageView;
@synthesize userNameLabel;
@synthesize phoneLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        userNameLabel = [[UILabel alloc] init];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.font = [UIFont systemFontOfSize:13.0f];
        userNameLabel.textColor = [UIColor blackColor];
        
        phoneLabel = [[UILabel alloc] init];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.font = [UIFont systemFontOfSize:10.0f];
        phoneLabel.textColor = [UIColor darkGrayColor];
        
        userImageView = [[UIImageView alloc] init];
        userImageView.backgroundColor = [UIColor clearColor];
        userImageView.contentMode = UIViewContentModeScaleAspectFill;
        userImageView.image = [UIImage imageNamed:@"ProPicUploadIcon.png"];
        userImageView.layer.cornerRadius = 15;
        userImageView.layer.masksToBounds = YES;
        
        actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionButton addTarget:self action:@selector(actionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        actionButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [actionButton setTitle:@"Invite" forState:UIControlStateNormal];
        [actionButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        actionButton.layer.cornerRadius = 4.0f;
        actionButton.layer.borderColor = [UIColor greenColor].CGColor;
        actionButton.layer.borderWidth = 1.0f;
        
        invitationStatusLabel = [[UILabel alloc] init];
        invitationStatusLabel.backgroundColor = [UIColor greenColor];
        invitationStatusLabel.textAlignment = NSTextAlignmentCenter;
        invitationStatusLabel.textColor = [UIColor lightGrayColor];
        invitationStatusLabel.font = [UIFont systemFontOfSize:12.0f];
        invitationStatusLabel.text = @"Invited";
        invitationStatusLabel.textColor = [UIColor whiteColor];
        invitationStatusLabel.alpha = 0.0f;
        invitationStatusLabel.layer.cornerRadius = 4.0f;
        
        [self.contentView addSubview:invitationStatusLabel];
        [self.contentView addSubview:actionButton];
        [self.contentView addSubview:userImageView];
        [self.contentView addSubview:userNameLabel];
        [self.contentView addSubview:phoneLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    actionButton.frame = CGRectMake(240, self.contentView.frame.size.height / 2 - 10, 60, 20);
    invitationStatusLabel.frame = actionButton.frame;
    userImageView.frame = CGRectMake(7, self.contentView.frame.size.height / 2 - 15, 30, 30);
    userNameLabel.frame = CGRectMake(userImageView.frame.size.width + 20, 0, 180, self.contentView.frame.size.height / 2);
    phoneLabel.frame = CGRectMake(userImageView.frame.size.width + 20, userNameLabel.frame.size.height, 180, self.contentView.frame.size.height / 2);
}

-(void)actionButtonAction
{
    if(self.delegate)
    {
        [self.delegate userButtonActionAtIndex:(int)indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
