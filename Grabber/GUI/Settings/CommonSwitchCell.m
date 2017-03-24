//
//  CommonSwitchCell.m
//  iOS Prototype
//
//  Created by World on 3/5/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "CommonSwitchCell.h"


@implementation CommonSwitchCell

@synthesize delegate;
@synthesize fieldSwitch;
@synthesize subtitleString;

- (id)initWithValue:(BOOL)_value withTitle:(NSString*)_titleString withSubtitle:(NSString*)_subtitle withCellTypes:(kCellTypes)_type
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"commonSwitch"];
    if (self)
    {
        type = _type;
        
        self.textLabel.text = _titleString;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        
        self.detailTextLabel.text = _subtitle;
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        
        self.subtitleString = _subtitle;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switchValue = _value;
        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        fieldSwitch = [[UISwitch alloc] init];
        fieldSwitch.backgroundColor = [UIColor clearColor];
        [fieldSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        [fieldSwitch setOn:_value];
        [fieldSwitch setOnTintColor:[UIColor colorWithRed:224.0f/255.0f green:91.0f/255.0f blue:88.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:fieldSwitch];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat x = self.contentView.frame.origin.x;
//    CGFloat y = self.contentView.frame.origin.y;
//    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    
    fieldSwitch.frame = CGRectMake(260, h/2 - 31/2, 40, h);
    
    self.detailTextLabel.text = subtitleString;
}

-(void)switchAction
{
    switchValue = !switchValue;
    if(delegate)
    {
        [delegate switchValueChangedTo:switchValue forCellType:type];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
