//
//  BecomeMerchantCell.m
//  iOS Prototype
//
//  Created by World on 3/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "BecomeMerchantCell.h"

@implementation BecomeMerchantCell

@synthesize delegate;

-(id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingBecomeMerchantCell"];
    if (self)
    {
        self.textLabel.text = @"Become a merchant";
        self.textLabel.font = [UIFont systemFontOfSize:14];
        
        becomeMerchantButton = [[UIButton alloc] init];
        becomeMerchantButton.backgroundColor = [UIColor clearColor];
        [becomeMerchantButton setTitle:@"Action" forState:UIControlStateNormal];
        [becomeMerchantButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [becomeMerchantButton addTarget:self action:@selector(becomeMerchantButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:becomeMerchantButton];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    becomeMerchantButton.frame = CGRectMake(260, 0, 60, self.contentView.bounds.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)becomeMerchantButtonAction
{
    if(delegate)
    {
        [delegate becomeMerchantButtonActionDelegateMethod];
    }
}

@end
