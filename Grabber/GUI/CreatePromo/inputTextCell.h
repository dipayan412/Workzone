//
//  inputTextCell.h
//  iOS Prototype
//
//  Created by World on 3/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface inputTextCell : UITableViewCell <UITextViewDelegate>
{
    UILabel *fieldTitleLabel;
    UITextField *inputField;
    UIImageView *separatorImageView;
    UITextView *inputTextView;
    
    BOOL isDescription;
}
@property (nonatomic, retain) UILabel *fieldTitleLabel;
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UITextView *inputTextView;

- (id)initWithIsDescription:(BOOL)_isDescription;

@end
