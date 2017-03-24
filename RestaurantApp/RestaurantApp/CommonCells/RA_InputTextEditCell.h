//
//  RA_InputTextEditCell.h
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_InputTextEditCell : UITableViewCell
{
    UITextField *inputTextField;
    
    NSString *placeHolderString;
}

@property (nonatomic, retain) UITextField *inputTextField;
@property (nonatomic, retain) NSString *placeHolderString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier placeHolderString:(NSString*)_placeHolderString;

@end
