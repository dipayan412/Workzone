//
//  RA_InputTextEditCell.m
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_InputTextEditCell.h"

@implementation RA_InputTextEditCell

@synthesize inputTextField;
@synthesize placeHolderString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier placeHolderString:(NSString*)_placeHolderString
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.placeHolderString = _placeHolderString;
        
        //a simple textfield which shows the initial placeholder according to the field name in the form
        inputTextField = [[UITextField alloc] init];
        inputTextField.placeholder = self.placeHolderString;
        inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        
        if([UIScreen mainScreen].bounds.size.width > 568)
        {
            inputTextField.font = [UIFont systemFontOfSize:15.0f];
        }
        else
        {
            inputTextField.font = [UIFont systemFontOfSize:12.0f];
        }
        inputTextField.textColor = [UIColor grayColor];
        
        inputTextField.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:inputTextField];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x;
    CGFloat y = self.contentView.bounds.origin.x;
    CGFloat h = self.contentView.bounds.size.height;
    CGFloat w = self.contentView.bounds.size.width;
    
    inputTextField.frame = CGRectMake(x + 10, y + 5, w - 20, h - 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
