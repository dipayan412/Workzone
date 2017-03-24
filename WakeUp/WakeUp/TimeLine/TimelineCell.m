//
//  TimelineCell.m
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "TimelineCell.h"

@implementation TimelineCell

@synthesize userImageView;
@synthesize usernameLabel;
@synthesize moodLabel;
@synthesize timeLabel;
@synthesize statusLabel;
@synthesize uploadedPhotoImageView;
@synthesize commentButton;
@synthesize likeButton;
@synthesize sendGiftButton;
@synthesize showImageFullButton;
@synthesize isCellExpanded;
@synthesize isUploadedPhotoAvailable;
@synthesize indexPath;
@synthesize delegate;
@synthesize isOwnPost;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thisCellTapped)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        
        userImageView = [[UIImageView alloc] init];
        userImageView.layer.cornerRadius = 25.0f;
        userImageView.layer.borderWidth = 3.0f;
        userImageView.layer.borderColor = oddCellColor.CGColor;
        userImageView.layer.masksToBounds = YES;
        userImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:userImageView];
        
        usernameLabel = [[UILabel alloc] init];
        usernameLabel.textColor = oddCellColor;
        usernameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:usernameLabel];
        
        moodLabel = [[UILabel alloc] init];
        moodLabel.text = @"Just Woken up!";
        moodLabel.textColor = [UIColor lightGrayColor];
        moodLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:moodLabel];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.font  = [UIFont systemFontOfSize:11.0f];
        [self.contentView addSubview:timeLabel];
        
        timeIconImageView = [[UIImageView alloc] init];
        timeIconImageView.image = [UIImage imageNamed:@"TimeIcon.png"];
        [self.contentView addSubview:timeIconImageView];
        
        statusLabel = [[UILabel alloc] init];
        statusLabel.numberOfLines = 0;
        statusLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:statusLabel];
        
        uploadedPhotoImageView = [[UIImageView alloc] init];
        uploadedPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
        uploadedPhotoImageView.backgroundColor = [UIColor redColor];
        [uploadedPhotoImageView setClipsToBounds:YES];
        [self.contentView addSubview:uploadedPhotoImageView];
        
        showImageFullButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [showImageFullButton setImage:[UIImage imageNamed:@"FullPictureButtonIcon.png"] forState:UIControlStateNormal];
        [showImageFullButton addTarget:self action:@selector(seeFullPictureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:showImageFullButton];
        
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentButton setImage:[UIImage imageNamed:@"SendMessageIcon.png"] forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(messageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:commentButton];
        
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setImage:[UIImage imageNamed:@"LikeButtonIcon.png"] forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(likeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:likeButton];
        
        sendGiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendGiftButton setImage:[UIImage imageNamed:@"SendGiftIcon.png"] forState:UIControlStateNormal];
        [sendGiftButton addTarget:self action:@selector(sendGiftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:sendGiftButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.frame.origin.x;
    CGFloat y = self.contentView.frame.origin.y;
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    
    if(self.isCellExpanded)
    {
        userImageView.frame = CGRectMake(x + 10, y + 20, 50, 50);
        usernameLabel.frame = CGRectMake(userImageView.frame.origin.x + userImageView.frame.size.width + 10, userImageView.frame.origin.y, 70, 20);
        moodLabel.frame = CGRectMake(usernameLabel.frame.origin.x + usernameLabel.frame.size.width + 10, usernameLabel.frame.origin.y, 120, 20);
        timeLabel.frame = CGRectMake(w - 45, usernameLabel.frame.origin.y, 50, 20);
        timeIconImageView.frame = CGRectMake(w - 60, usernameLabel.frame.origin.y + 5, 8, 9);
        statusLabel.frame = CGRectMake(userImageView.frame.origin.x + userImageView.frame.size.width + 10, usernameLabel.frame.origin.y + usernameLabel.frame.size.height + 10, 220, 40);
        
        if(self.isUploadedPhotoAvailable)
        {
            uploadedPhotoImageView.frame = CGRectMake(x, statusLabel.frame.origin.y + statusLabel.frame.size.height, w, 160);
            showImageFullButton.frame = CGRectMake(100, uploadedPhotoImageView.frame.origin.y + uploadedPhotoImageView.frame.size.height - 40, 120, 30);
        }
        
        commentButton.frame = CGRectMake(70, h - 30, 18, 17);
        likeButton.frame = CGRectMake(commentButton.frame.origin.x + commentButton.frame.size.width + 20, h - 30, 18, 17);
        sendGiftButton.frame = CGRectMake(likeButton.frame.origin.x + likeButton.frame.size.width + 20, h - 33, 18, 19);
    }
    else
    {
        userImageView.frame = CGRectMake(x + 10, y + 20, 50, 50);
        usernameLabel.frame = CGRectMake(userImageView.frame.origin.x + userImageView.frame.size.width + 10, userImageView.frame.origin.y, 70, 20);
        moodLabel.frame = CGRectMake(usernameLabel.frame.origin.x + usernameLabel.frame.size.width + 50, usernameLabel.frame.origin.y, 120, 20);
        timeLabel.frame = CGRectMake(w - 45, h - 35, 50, 20);
        timeIconImageView.frame = CGRectMake(w - 60, h - 30, 8, 9);
    }
}

-(void)setIsUploadedPhotoAvailable:(BOOL)_isUploadedPhotoAvailable
{
    isUploadedPhotoAvailable = _isUploadedPhotoAvailable;
    
    [UIView animateWithDuration:0.5f animations:^{
        uploadedPhotoImageView.alpha = showImageFullButton.alpha = (!isUploadedPhotoAvailable || !isCellExpanded) ? 1 : 0;
    }];
}

-(void)setIsCellExpanded:(BOOL)_isCellExpanded
{
    isCellExpanded = _isCellExpanded;
    
    BOOL hideStatus = !isCellExpanded;
    
    [UIView animateWithDuration:0.5f animations:^{
        statusLabel.alpha = commentButton.alpha = likeButton.alpha = sendGiftButton.alpha = isCellExpanded ? 1 : 0;
        uploadedPhotoImageView.alpha = showImageFullButton.alpha = (!isUploadedPhotoAvailable || !isCellExpanded) ? 0 : 1;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setIsOwnPost:(BOOL)_isOwnPost
{
    if(_isOwnPost)
    {
        commentButton.alpha =
        likeButton.alpha =
        sendGiftButton.alpha = 0;
    }
    else
    {
        commentButton.alpha =
        likeButton.alpha =
        sendGiftButton.alpha = 1;
    }
}

-(void)messageButtonPressed
{
    if(delegate)
    {
        [delegate messageButtonActionWithIndex:(int)indexPath.row];
    }
}

-(void)likeButtonPressed
{
    if(delegate)
    {
        [delegate likeButtonActionWithIndex:(int)indexPath.row];
    }
}

-(void)sendGiftButtonPressed
{
    if(delegate)
    {
        [delegate sendGiftButtonActionWithIndex:(int)indexPath.row];
    }
}

-(void)seeFullPictureButtonPressed
{
    if(delegate)
    {
        [delegate seeFullPictureButtonActionWithIndex:(int)indexPath.row];
    }
}

-(void)thisCellTapped
{
    NSLog(@"row %d",(int)self.indexPath.row);
}

@end
