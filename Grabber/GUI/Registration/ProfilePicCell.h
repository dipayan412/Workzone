//
//  ProfilePicCell.h
//  iOS Prototype
//
//  Created by World on 3/13/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProPicCellDelegate <NSObject>

-(void)proPicButtonAction;

@end

@interface ProfilePicCell : UITableViewCell
{
    UIImageView *proPicImageView;
    UIButton *proPicChooseButton;
}
@property (nonatomic, readonly) UIImageView *proPicImageView;
@property (nonatomic, readonly) UIButton *proPicChooseButton;
@property (nonatomic, retain) id <ProPicCellDelegate> delegate;

@end
