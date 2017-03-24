//
//  AssociatePagesCell.h
//  Grabber
//
//  Created by World on 4/7/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AssociatePagesCellDelegate <NSObject>

-(void)customSwitchTappedChangedValueTo:(BOOL)value forCellType:(kCellTypes)_cellType;

@end

@interface AssociatePagesCell : UITableViewCell
{
    UIImageView *cellIconImageView;
    UILabel *cellNameLabel;
    UIControl *customSwitchControl;
    UIControl *switchView;
    UISwitch *fieldSwitch;
    
    int cellType;
    BOOL isSwitchOn;
}
@property (nonatomic, retain) UIImageView *cellIconImageView;
@property (nonatomic, retain) UILabel *cellNameLabel;
@property (nonatomic, retain) UISwitch *fieldSwitch;
@property (nonatomic, retain) id <AssociatePagesCellDelegate> delegate;

- (id)initWithSwitchValue:(BOOL)_value forCellType:(kCellTypes)_cellType;

@end
