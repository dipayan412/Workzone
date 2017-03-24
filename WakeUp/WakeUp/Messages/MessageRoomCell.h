//
//  MessageRoomCell.h
//  WakeUp
//
//  Created by World on 7/15/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageRoomCell : UITableViewCell
{
    UILabel *senderNameLabel;
    UILabel *chatMessageLabel;
    UILabel *dateLabel;
    UIActivityIndicatorView *deliveryIndicator;
    UIImageView *bubbleImage;
    
    UIImageView *senderImageView;
}
@property (nonatomic, strong) UILabel *senderNameLabel;
@property (nonatomic, strong) UILabel *chatMessageLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIActivityIndicatorView *deliveryIndicator;
@property (nonatomic, strong) UIImageView *bubbleImage;
@property (nonatomic, strong) UIImageView *senderImageView;

-(void)indicatorStartAnimating;
-(void)indicatorStopAnimating;

@end
