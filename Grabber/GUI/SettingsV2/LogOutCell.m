//
//  LogOutCell.m
//  Grabber
//
//  Created by World on 4/29/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "LogOutCell.h"

@implementation LogOutCell

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:68.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
        
        logOutButton = [[UIButton alloc] init];
        logOutButton.backgroundColor = [UIColor clearColor];
        [logOutButton setTitle:@"LOGOUT" forState:UIControlStateNormal];
        [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logOutButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [logOutButton addTarget:self action:@selector(logOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:logOutButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = self.contentView.frame.size.height;
    
    logOutButton.frame = CGRectMake(240, h/2 - 10, 60, 20);
}

-(void)logOutButtonAction
{
    if(delegate)
    {
        [delegate logOutButtonTapped];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
