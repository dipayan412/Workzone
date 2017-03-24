//
//  PromoDetailsTopCell.h
//  Grabber
//
//  Created by World on 3/21/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromoDetailsTopCell : UITableViewCell
{
    UITextField *promoField;
    UIImageView *promoImageView;
}
@property (nonatomic, retain) UITextField *promoField;
@property (nonatomic, retain) UIImageView *promoImageView;

- (id)init;

@end
