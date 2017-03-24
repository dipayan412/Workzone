//
//  HomeCell.h
//  iOS Prototype
//
//  Created by World on 3/12/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
{
    UILabel *cellName;
    UIImageView *cellImageView;
    
    UIView *customAccessoryView;
    UIImageView *customAccessoryViewBG;
    UILabel *customAccessoryViewLabel;
}
- (id)initWithAccessoryView:(BOOL)_isAccessoryViewPresent;

@property (nonatomic, retain) UILabel *cellName;
@property (nonatomic, retain) UIImageView *cellImageView;
@property (nonatomic, assign) BOOL isAccessoryViewPresent;
@property (nonatomic, retain) NSString *customAccessoryViewLabelText;
@end
