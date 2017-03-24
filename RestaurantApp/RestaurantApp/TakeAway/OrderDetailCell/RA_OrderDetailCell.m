//
//  RA_OrderDetailCell.m
//  RestaurantApp
//
//  Created by World on 12/20/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_OrderDetailCell.h"

@implementation RA_OrderDetailCell

@synthesize orderDetailTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //shows the details of the textview(number of people, total price, vat, item names and so on)
        orderDetailTextView = [[UITextView alloc] init];
        orderDetailTextView.backgroundColor = [UIColor whiteColor];
        orderDetailTextView.layer.cornerRadius = 5.0f;
        [orderDetailTextView setEditable:NO];
        [orderDetailTextView setScrollEnabled:YES];
        orderDetailTextView.textColor = [UIColor grayColor];
        [self.contentView addSubview:orderDetailTextView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x;
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat h = self.contentView.bounds.size.height;
    CGFloat w = self.contentView.bounds.size.width;
    
    orderDetailTextView.frame = CGRectMake(x + 10, y + 5, w - 20, h - 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
