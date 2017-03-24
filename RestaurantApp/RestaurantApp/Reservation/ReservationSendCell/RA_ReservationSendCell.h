//
//  RA_ReservationSendCell.h
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reservationSendCellDelegate <NSObject>

-(void)sendButtonClicked;

@end

@interface RA_ReservationSendCell : UITableViewCell
{
    UIButton *sendButton;
}

@property (nonatomic, retain) id <reservationSendCellDelegate> delegate;

-(void)changeButtonTitleWithkey:(NSString*)key;

@end
