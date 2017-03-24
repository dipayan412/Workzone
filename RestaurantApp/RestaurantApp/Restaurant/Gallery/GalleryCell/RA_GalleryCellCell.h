//
//  RA_GalleryCellCell.h
//  RestaurantApp
//
//  Created by World on 12/20/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol galleryCellDelegate <NSObject>

-(void)indexOfTappedImage:(int)index;

@end

@interface RA_GalleryCellCell : UITableViewCell
{
    UIImageView *leftImageView;
    UIImageView *rightImageView;
    UIImageView *centerImageView;
    
    UIButton *leftImageButton;
    UIButton *centerImageButton;
    UIButton *rightImageButton;
}

@property (nonatomic, retain) UIImageView *leftImageView;
@property (nonatomic, retain) UIImageView *rightImageView;
@property (nonatomic, retain) UIImageView *centerImageView;

@property (nonatomic, retain) UIButton *leftImageButton;
@property (nonatomic, retain) UIButton *centerImageButton;
@property (nonatomic, retain) UIButton *rightImageButton;

@property (nonatomic, retain) id<galleryCellDelegate> delegate;

-(void)reorderTags:(int)_tag1 tag2:(int)_tag2 tag3:(int)_tag3;

@end
