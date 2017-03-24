//
//  RA_ReservationSendCell.m
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_ReservationSendCell.h"

@implementation RA_ReservationSendCell

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //send button on a cell
        
        //action button attributes set
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        sendButton.titleLabel.text = @"Send reservation";
        sendButton.titleLabel.textColor = [UIColor whiteColor];
        sendButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [sendButton setTitle:@"Send reservation" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:sendButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x;
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat h = self.contentView.bounds.size.height;
    CGFloat w = self.contentView.bounds.size.width;
    
    //alligning the button
    if([UIScreen mainScreen].bounds.size.height > 568)
    {
        sendButton.frame = CGRectMake(x + 150, y + 20, w - 300, h - 20);
    }
    else
    {
        sendButton.frame = CGRectMake(x + 10, y + 5, w - 20, h - 10);
    }
    
    // add gradient to the button color
    [sendButton.layer insertSublayer:[RA_UserDefaultsManager getGradientLayerForBounds:sendButton.bounds] atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/**
 * Method name: sendButtonAction
 * Description: notifies the view controller that the button tapped
 * Parameters: none
 */

-(void)sendButtonAction//confirm the viewController that the button has been tapped
{
    if(delegate)
    {
        [delegate sendButtonClicked];
    }
}

/**
 * Method name: sendButtonAction
 * Description: this cell is used in two pages with different name. Assigning a key to this method will change the title of the button
 * Parameters: none
 */

-(void)changeButtonTitleWithkey:(NSString*)key
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    [sendButton setTitle:AMLocalizedString(key, nil) forState:UIControlStateNormal];
}

@end
