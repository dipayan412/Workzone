//
//  RA_OrderLaterCheckBoxCell.h
//  RestaurantApp
//
//  Created by World on 12/20/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RA_OrderLaterCheckBoxCellDelegate <NSObject>

-(void)checkBoxButtonSelected:(BOOL)selected;

@end

@interface RA_OrderLaterCheckBoxCell : UITableViewCell
{
    UIImageView *checkBoxImageView;
    UILabel *orderLaterLabel;
    UIButton *checkBoxButton;
}

@property (nonatomic, assign) BOOL isCheckBoxSelected;
@property (nonatomic, retain) id<RA_OrderLaterCheckBoxCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCheckboxSelected:(BOOL)isSeleted;
-(void)changeLabel;

@end
