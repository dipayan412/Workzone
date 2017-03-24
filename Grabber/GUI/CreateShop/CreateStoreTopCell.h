//
//  CreateStoreTopCell.h
//  Grabber
//
//  Created by World on 3/23/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateStoreTopCell : UITableViewCell
{
    UIImageView *storeImageView;
    UITextField *storeNameField;
}
@property (nonatomic, retain) UIImageView *storeImageView;
@property (nonatomic, retain) UITextField *storeNameField;

- (id)init;

@end
