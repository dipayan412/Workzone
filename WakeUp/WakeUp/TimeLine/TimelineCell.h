//
//  TimelineCell.h
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeLineCellDelegate <NSObject>

-(void)messageButtonActionWithIndex:(int)_index;
-(void)likeButtonActionWithIndex:(int)_index;
-(void)sendGiftButtonActionWithIndex:(int)_index;
-(void)seeFullPictureButtonActionWithIndex:(int)_index;

@end

@interface TimelineCell : UITableViewCell
{
    UIImageView *userImageView;
    UILabel *usernameLabel;
    UILabel *moodLabel;
    UILabel *timeLabel;
    UILabel *statusLabel;
    UIImageView *uploadedPhotoImageView;
    UIImageView *timeIconImageView;
    
    UIButton *commentButton;
    UIButton *likeButton;
    UIButton *sendGiftButton;
    UIButton *showImageFullButton;
}
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *moodLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *uploadedPhotoImageView;

@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *sendGiftButton;
@property (nonatomic, strong) UIButton *showImageFullButton;
@property (nonatomic, assign) BOOL isCellExpanded;
@property (nonatomic, assign) BOOL isUploadedPhotoAvailable;
@property (nonatomic, assign) BOOL isOwnPost;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) id <TimeLineCellDelegate> delegate;

@end
