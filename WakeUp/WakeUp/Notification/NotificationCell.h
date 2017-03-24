//
//  NotificationCell.h
//  WakeUp
//
//  Created by World on 6/26/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationCellDelegate <NSObject>

-(void)acceptButtonActionAtRow:(int)_row;
-(void)denyButtonActionAtRow:(int)_row;

@end

@interface NotificationCell : UITableViewCell
{
    UIButton *acceptButton;
    UIButton *denyButton;
    UILabel *afterActionStatusLabel;
}
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *denyButton;
@property (nonatomic, strong) UILabel *afterActionStatusLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id <NotificationCellDelegate> delegate;

-(void)contactRequestPerformAction:(BOOL)isAccepted;

@end
