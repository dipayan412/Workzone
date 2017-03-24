//
//  MessageListTableViewCell.h
//  WakeUp
//
//  Created by Ashif on 8/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *partnerPhotoView;
@property (nonatomic, weak) IBOutlet UILabel *partnerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *timeIconView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end
