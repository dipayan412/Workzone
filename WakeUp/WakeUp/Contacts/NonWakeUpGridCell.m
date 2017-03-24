//
//  NonWakeUpGridCell.m
//  WakeUp
//
//  Created by World on 8/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "NonWakeUpGridCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation NonWakeUpGridCell

@synthesize contactImageView;
@synthesize nameLabel;
@synthesize phoneLabel;
@synthesize indexPath;
@synthesize inviteButton;
@synthesize invitationStatusLabel;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NonWakeUpGridCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        self.contentView.layer.cornerRadius = 7.0f;
        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.clipsToBounds = YES;
        
        self.contactImageView.layer.cornerRadius = 33;
        self.contactImageView.layer.masksToBounds = YES;
        self.contactImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.inviteButton.layer.borderColor = [UIColor greenColor].CGColor;
        self.inviteButton.layer.borderWidth = 1.0f;
        self.inviteButton.layer.cornerRadius = 4.0f;
        self.inviteButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
        [self.inviteButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        self.invitationStatusLabel.backgroundColor = [UIColor greenColor];
        self.invitationStatusLabel.font = [UIFont systemFontOfSize:12.0f];
        self.invitationStatusLabel.textColor = [UIColor whiteColor];
        self.invitationStatusLabel.layer.cornerRadius = 4.0f;
    }
    
    return self;
    
}

-(IBAction)inviteButtonPressed:(id)sender
{
    if(delegate)
    {
        [delegate inviteButtonActionAtIndex:self.indexPath];
//        [delegate inviteButtonActionAtCell:self];
    }
}

-(void)invited
{
    inviteButton.alpha = 0;
    invitationStatusLabel.alpha = 1.0f;
}

@end
