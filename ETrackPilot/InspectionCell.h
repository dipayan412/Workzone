//
//  InspectionCell.h
//  ETrackPilot
//
//  Created by World on 7/22/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultsManager.h"

@interface InspectionCell : UITableViewCell
{
    UILabel *nameLabel;
    UIButton *btn;
    
    UILabel *passLabel;
    UILabel *failLabel;
    UILabel *repairedLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexNumber:(int)index withStatus:(EP_InspectionItemStatus)_status andNotes:(NSString*)_notes;

@property (nonatomic,assign) EP_InspectionItemStatus inspectionItemStatus;
@property (nonatomic,assign) int itemIndex;
@property (nonatomic, retain) NSString *notes;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIButton *radio1;
@property (nonatomic, retain) UIButton *radio2;
@property (nonatomic, retain) UIButton *radio3;

@end