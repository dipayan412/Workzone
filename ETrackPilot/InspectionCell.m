//
//  InspectionCell.m
//  ETrackPilot
//
//  Created by World on 7/22/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "InspectionCell.h"

@implementation InspectionCell

@synthesize nameLabel;
@synthesize inspectionItemStatus;
@synthesize radio1;
@synthesize radio2;
@synthesize radio3;
@synthesize notes;
@synthesize itemIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexNumber:(int)index withStatus:(EP_InspectionItemStatus)_status andNotes:(NSString *)_notes
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.notes = _notes;
        self.inspectionItemStatus = _status;
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        
        passLabel = [[UILabel alloc] init];
        passLabel.backgroundColor = [UIColor clearColor];
        passLabel.text = @"Pass";
        [self.contentView addSubview:passLabel];
        
        failLabel = [[UILabel alloc] init];
        failLabel.backgroundColor = [UIColor clearColor];
        failLabel.text = @"Failed";
        [self.contentView addSubview:failLabel];
        
        repairedLabel = [[UILabel alloc] init];
        repairedLabel.backgroundColor = [UIColor clearColor];
        repairedLabel.text = @"Repaired";
        [self.contentView addSubview:repairedLabel];
        
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.titleLabel.text = @"Button";
        [btn addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        radio1 = [[UIButton alloc] init];
        [radio1 setTag:1];
        [radio1 setBackgroundImage:[UIImage imageNamed:@"RadioButton_Deselected"] forState:UIControlStateNormal];
        [radio1 setBackgroundImage:[UIImage imageNamed:@"RadioButton_Selected"] forState:UIControlStateSelected];
        [radio1 addTarget:self action:@selector(radioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        radio2 = [[UIButton alloc] init];
        [radio2 setTag:2];
        [radio2 setBackgroundImage:[UIImage imageNamed:@"RadioButton_Deselected"] forState:UIControlStateNormal];
        [radio2 setBackgroundImage:[UIImage imageNamed:@"RadioButton_Selected"] forState:UIControlStateSelected];
        [radio2 addTarget:self action:@selector(radioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        radio3 = [[UIButton alloc] init];
        [radio3 setTag:3];
        [radio3 setBackgroundImage:[UIImage imageNamed:@"RadioButton_Deselected"] forState:UIControlStateNormal];
        [radio3 setBackgroundImage:[UIImage imageNamed:@"RadioButton_Selected"] forState:UIControlStateSelected];
        [radio3 addTarget:self action:@selector(radioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (inspectionItemStatus)
        {
            case EP_PASSED:
                radio1.selected = YES;
                radio2.selected = NO;
                radio3.selected = NO;
                break;
                
            case EP_FAILED:
                
                radio1.selected = NO;
                radio2.selected = YES;
                radio3.selected = NO;
                
                break;
                
            case EP_REPAIRED:
                
                radio1.selected = NO;
                radio2.selected = NO;
                radio3.selected = YES;
                
                break;
                
            default:
                break;
        }
        
        
        [self.contentView addSubview:radio1];
        [self.contentView addSubview:radio2];
        [self.contentView addSubview:radio3];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.contentView.bounds.size.width;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        nameLabel.frame = CGRectMake(2, 2, w, 35);
        
        radio1.frame = CGRectMake(2, nameLabel.frame.size.height + 2, 32, 32);
        passLabel.frame = CGRectMake(radio1.frame.origin.x + radio1.frame.size.width + 2, nameLabel.frame.size.height + 2, 50, 32);
        
        radio2.frame = CGRectMake(passLabel.frame.origin.x + passLabel.frame.size.width + 2, nameLabel.frame.size.height + 2, 32, 32);
        failLabel.frame = CGRectMake(radio2.frame.origin.x + radio2.frame.size.width + 2, nameLabel.frame.size.height + 2, 50, 32);
        
        radio3.frame = CGRectMake(failLabel.frame.origin.x + failLabel.frame.size.width + 2, nameLabel.frame.size.height + 2, 32, 32);
        repairedLabel.frame = CGRectMake(radio3.frame.origin.x + radio3.frame.size.width + 2, nameLabel.frame.size.height + 2, 80, 32);
    }
    else
    {
        nameLabel.frame = CGRectMake(2, 2, w, 35);
        
        passLabel.font =
        failLabel.font =
        repairedLabel.font = [UIFont systemFontOfSize:12.0f];
        
        radio1.frame = CGRectMake(2, nameLabel.frame.size.height + 2, 25, 25);
        passLabel.frame = CGRectMake(radio1.frame.origin.x + radio1.frame.size.width + 2, nameLabel.frame.size.height, 30, 32);
        
        radio2.frame = CGRectMake(passLabel.frame.origin.x + passLabel.frame.size.width + 2, nameLabel.frame.size.height + 2, 25, 25);
        failLabel.frame = CGRectMake(radio2.frame.origin.x + radio2.frame.size.width + 2, nameLabel.frame.size.height, 35, 32);
        
        radio3.frame = CGRectMake(failLabel.frame.origin.x + failLabel.frame.size.width + 2, nameLabel.frame.size.height + 2, 25, 25);
        repairedLabel.frame = CGRectMake(radio3.frame.origin.x + radio3.frame.size.width + 2, nameLabel.frame.size.height, 50, 32);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)radioButtonSelected:(id)sender
{
    switch([sender tag])
    {
        case 1:
            if(![radio1 isSelected])
            {
                [radio1 setSelected:YES];
                [radio2 setSelected:NO];
                [radio3 setSelected:NO];
            }
            break;
        case 2:
            if(![radio2 isSelected])
            {
                [radio2 setSelected:YES];
                [radio1 setSelected:NO];
                [radio3 setSelected:NO];
            }
            break;
        case 3:
            if(![radio3 isSelected])
            {
                [radio3 setSelected:YES];
                [radio2 setSelected:NO];
                [radio1 setSelected:NO];
            }
            break;
    }
}

@end
