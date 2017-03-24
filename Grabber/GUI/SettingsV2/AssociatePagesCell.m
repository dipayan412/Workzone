//
//  AssociatePagesCell.m
//  Grabber
//
//  Created by World on 4/7/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "AssociatePagesCell.h"

@implementation AssociatePagesCell

@synthesize cellIconImageView;
@synthesize cellNameLabel;
@synthesize delegate;
@synthesize fieldSwitch;

- (id)initWithSwitchValue:(BOOL)_value forCellType:(kCellTypes)_cellType;
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssociateCells"];
    if (self)
    {
        isSwitchOn = _value;
        cellType = _cellType;
        
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:131.0f/255.0f green:73.0f/255.0f blue:71.0f/255.0f alpha:1.0f];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cellIconImageView = [[UIImageView alloc] init];
        cellIconImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cellIconImageView];
        
        cellNameLabel = [[UILabel alloc] init];
        cellNameLabel.backgroundColor = [UIColor clearColor];
        cellNameLabel.textColor = [UIColor lightGrayColor];//[UIColor colorWithRed:223.0f/255.0f green:212.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
        cellNameLabel.font = [UIFont systemFontOfSize:11.0f];
        [self.contentView addSubview:cellNameLabel];
        
//        customSwitchControl = [[UIControl alloc] initWithFrame:CGRectMake(240, 10, 50, 23)];
//        customSwitchControl.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
//        customSwitchControl.layer.borderColor = [UIColor whiteColor].CGColor;
//        customSwitchControl.layer.borderWidth = 1.0f;
//        customSwitchControl.layer.cornerRadius = 4.0f;
//        
//        UILabel *onLabel = [[UILabel alloc] init];
//        onLabel.text = @"On";
//        onLabel.backgroundColor = [UIColor clearColor];
//        [customSwitchControl addSubview:onLabel];
//        onLabel.frame = CGRectMake(25, 0, 25, 23);
//        onLabel.font = [UIFont systemFontOfSize:10.0f];
//        onLabel.textAlignment = NSTextAlignmentCenter;
//        
//        UILabel *offLabel = [[UILabel alloc] init];
//        offLabel.text = @"Off";
//        offLabel.backgroundColor = [UIColor clearColor];
//        [customSwitchControl addSubview:offLabel];
//        offLabel.frame = CGRectMake(0, 0, 25, 23);
//        offLabel.font = [UIFont systemFontOfSize:10.0f];
//        offLabel.textAlignment = NSTextAlignmentCenter;
//        
//        if(_value)
//        {
//            switchView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 25, 23)];
//            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SwitchOn.png"]];
//            [customSwitchControl addSubview:switchView];
//        }
//        else
//        {
//            switchView = [[UIControl alloc] initWithFrame:CGRectMake(25, 0, 25, 23)];
//            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SwitchOff.png"]];
//            [customSwitchControl addSubview:switchView];
//        }
//        
//        [switchView addTarget:self action:@selector(switchTapped) forControlEvents:UIControlEventTouchUpInside];
//        [customSwitchControl addTarget:self action:@selector(switchTapped) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.contentView addSubview:customSwitchControl];
        
        fieldSwitch = [[UISwitch alloc] init];
        fieldSwitch.backgroundColor = [UIColor clearColor];
        [fieldSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        [fieldSwitch setOn:_value];
        [fieldSwitch setOnTintColor:[UIColor colorWithRed:222.0f/255.0f green:68.0f/255.0f blue:66.0f/255.0f alpha:1.0f]];//[UIColor colorWithRed:224.0f/255.0f green:91.0f/255.0f blue:88.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:fieldSwitch];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat h = self.contentView.frame.size.height;
    
    cellIconImageView.frame = CGRectMake(10, self.contentView.frame.size.height/2 - 11, 21, 21);
    cellNameLabel.frame = CGRectMake(70, 0, 100, self.contentView.frame.size.height);
//    customSwitchControl.frame = CGRectMake(250, 10, 50, 23);
    
    fieldSwitch.frame = CGRectMake(260, h/2 - 31/2, 40, h);
}

-(void)switchTapped
{
    isSwitchOn = !isSwitchOn;
    if(isSwitchOn)
    {
        [UIView animateWithDuration:0.35f animations:^{
            
            CGRect frame = switchView.frame;
            frame.origin.x = 0;
            switchView.frame = frame;
            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SwitchOn.png"]];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.35f animations:^{
            
            CGRect frame = switchView.frame;
            frame.origin.x = 25;
            switchView.frame = frame;
            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SwitchOff.png"]];
        }];
    }    
    
    if(delegate)
    {
        [delegate customSwitchTappedChangedValueTo:isSwitchOn forCellType:cellType];
    }
}

-(void)switchAction
{
    if(delegate)
    {
        [delegate customSwitchTappedChangedValueTo:fieldSwitch.isOn forCellType:cellType];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
