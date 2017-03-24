//
//  ProfilePicCell.m
//  iOS Prototype
//
//  Created by World on 3/13/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ProfilePicCell.h"

@implementation ProfilePicCell

@synthesize proPicChooseButton;
@synthesize proPicImageView;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        proPicImageView = [[UIImageView alloc] init];
        proPicImageView.backgroundColor = [UIColor clearColor];
        proPicImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:proPicImageView];
        
        proPicChooseButton = [[UIButton alloc] init];
        proPicChooseButton.backgroundColor = [UIColor clearColor];
        [proPicChooseButton addTarget:self action:@selector(proPicChooseButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:proPicChooseButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    proPicImageView.frame = CGRectMake(self.contentView.frame.size.width/2 - 50, self.contentView.frame.size.height / 2 - 50, 100, 100);
    proPicChooseButton.frame = CGRectMake(self.contentView.frame.size.width/2 - 50, self.contentView.frame.size.height / 2 - 50, 100, 100);
}

-(void)proPicChooseButtonAction
{
    if(delegate)
    {
        [delegate proPicButtonAction];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
