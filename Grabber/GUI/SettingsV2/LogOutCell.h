//
//  LogOutCell.h
//  Grabber
//
//  Created by World on 4/29/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogOutCellDelegate <NSObject>

-(void)logOutButtonTapped;

@end

@interface LogOutCell : UITableViewCell
{
    UIButton *logOutButton;
}

@property (nonatomic, retain) id <LogOutCellDelegate> delegate;

@end
