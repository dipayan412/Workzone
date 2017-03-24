//
//  inputTextCell.m
//  iOS Prototype
//
//  Created by World on 3/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "inputTextCell.h"

@implementation inputTextCell

#define kTextViewPlaceholder    @"Enter product description"

@synthesize fieldTitleLabel;
@synthesize inputField;
@synthesize inputTextView;

- (id)initWithIsDescription:(BOOL)_isDescription
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"formCell"];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        isDescription = _isDescription;
        
        fieldTitleLabel = [[UILabel alloc] init];
        fieldTitleLabel.backgroundColor = [UIColor clearColor];
        fieldTitleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:fieldTitleLabel];
        
        if(isDescription)
        {
            inputTextView = [[UITextView alloc] init];
            inputTextView.backgroundColor = [UIColor clearColor];
            inputTextView.delegate = self;
            inputTextView.textColor = [UIColor lightGrayColor];
            inputTextView.text = kTextViewPlaceholder;
            [self.contentView addSubview:inputTextView];
        }
        else
        {
            inputField = [[UITextField alloc] init];
            inputField.backgroundColor = [UIColor clearColor];
            inputField.textColor = [UIColor lightGrayColor];
            inputField.font = [UIFont systemFontOfSize:13.0f];
            [self.contentView addSubview:inputField];
        }
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.frame.origin.x;
    CGFloat y = self.contentView.frame.origin.y;
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    
    if(isDescription)
    {
        fieldTitleLabel.frame = CGRectMake(x + 15, y, w/4, 44);
        inputTextView.frame = CGRectMake(fieldTitleLabel.frame.size.width + 20, y + 7, w - fieldTitleLabel.frame.size.width - 20, h);
    }
    else
    {
        fieldTitleLabel.frame = CGRectMake(x + 15, y, w/4, h);
        inputField.frame = CGRectMake(fieldTitleLabel.frame.size.width + 25, y, w - fieldTitleLabel.frame.size.width - 25, h);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([inputTextView.text isEqualToString:kTextViewPlaceholder] || [inputTextView.text isEqualToString:@"Enter Store Description"])
    {
        inputTextView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}

@end
