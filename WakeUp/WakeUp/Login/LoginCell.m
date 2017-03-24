//
//  LoginCell.m
//  WakeUp
//
//  Created by World on 6/23/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "LoginCell.h"

@implementation LoginCell

@synthesize cellField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        cellField = [[UITextField alloc] init];
        cellField.backgroundColor = [UIColor clearColor];
        cellField.textColor = [UIColor lightGrayColor];
        cellField.font = [UIFont systemFontOfSize:13.0f];
        cellField.textAlignment  = NSTextAlignmentCenter;
        [self.contentView addSubview:cellField];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    cellField.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
