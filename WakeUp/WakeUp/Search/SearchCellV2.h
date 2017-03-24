//
//  SearchCellV2.h
//  WakeUp
//
//  Created by World on 8/5/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchCellDelegate <NSObject>

-(void)userButtonActionAtIndex:(int)row;

@end

@interface SearchCellV2 : UITableViewCell
{
    UIImageView *userImageView;
    UIButton *actionButton;
    UILabel *userNameLabel;
    UILabel *phoneLabel;
}
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UILabel *invitationStatusLabel;
@property (nonatomic, assign) id <SearchCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@end
