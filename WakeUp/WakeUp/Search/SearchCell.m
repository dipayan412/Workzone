//
//  SearchCell.m
//  WakeUp
//
//  Created by World on 6/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

@synthesize delegate;
@synthesize indexPath;
@synthesize isRequestSent;
@synthesize sendRequestButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        sendRequestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendRequestButton addTarget:self action:@selector(sendRequestButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [sendRequestButton setTitle:@"Add Request" forState:UIControlStateNormal];
        [sendRequestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendRequestButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        sendRequestButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [sendRequestButton setImage:[UIImage imageNamed:@"SendRequestBG.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:sendRequestButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    sendRequestButton.frame = CGRectMake(240, self.contentView.frame.size.height / 2 - 6, 61, 12);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)sendRequestButtonAction
{
    if(!self.isRequestSent)
    {
        if(self.delegate)
        {
            [self.delegate sendRequestButtonPressedAt:(int)indexPath.row];
        }
        isRequestSent = NO;
        [sendRequestButton setTitle:@"Cancel Request" forState:UIControlStateNormal];
        [sendRequestButton setBackgroundColor:[UIColor lightGrayColor]];
        [sendRequestButton setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        isRequestSent = YES;
        [sendRequestButton setTitle:@"Add Request" forState:UIControlStateNormal];
        [sendRequestButton setBackgroundColor:[UIColor whiteColor]];
        [sendRequestButton setImage:[UIImage imageNamed:@"SendRequestBG.png"] forState:UIControlStateNormal];
    }
}

@end
