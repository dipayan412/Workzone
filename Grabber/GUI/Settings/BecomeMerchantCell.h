//
//  BecomeMerchantCell.h
//  iOS Prototype
//
//  Created by World on 3/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BecomeMerchantCellDelegate <NSObject>

-(void)becomeMerchantButtonActionDelegateMethod;

@end

@interface BecomeMerchantCell : UITableViewCell
{
    UIButton *becomeMerchantButton;
}

-(id)init;

@property (nonatomic, retain) id <BecomeMerchantCellDelegate> delegate;

@end
