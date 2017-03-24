//
//  PromoDetailsTopCell.m
//  Grabber
//
//  Created by World on 3/21/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "PromoDetailsTopCell.h"

@implementation PromoDetailsTopCell

@synthesize promoField;
@synthesize promoImageView;

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopCell"];
    if (self)
    {
        promoField = [[UITextField alloc] init];
        promoField.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:promoField];
        
        promoImageView = [[UIImageView alloc] init];
        promoImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:promoImageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    promoField.frame = CGRectMake(120, 0, 200, self.contentView.bounds.size.height);
    promoImageView.frame = CGRectMake(10, 10, 110, self.contentView.bounds.size.height - 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
