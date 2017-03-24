//
//  NonWakeUpGridCell.h
//  WakeUp
//
//  Created by World on 8/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NonWakeUpGridCellDelegate;

@interface NonWakeUpGridCell : UICollectionViewCell

@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, strong) IBOutlet UIImageView *contactImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) IBOutlet UIButton *inviteButton;
@property (nonatomic, strong) IBOutlet UILabel *invitationStatusLabel;
@property (nonatomic, assign) id <NonWakeUpGridCellDelegate> delegate;

-(IBAction)inviteButtonPressed:(id)sender;

-(void)invited;

@end


@protocol NonWakeUpGridCellDelegate <NSObject>

-(void)inviteButtonActionAtIndex:(NSIndexPath*)_index;

@end