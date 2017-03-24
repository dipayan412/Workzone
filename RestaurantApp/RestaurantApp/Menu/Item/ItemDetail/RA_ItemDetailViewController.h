//
//  RA_ItemDetailViewController.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RA_MenuObject.h"

@interface RA_ItemDetailViewController : UIViewController <ASIHTTPRequestDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UIImageView *itemImageView;
    
    IBOutlet UIView *itemImageViewBGView;
    IBOutlet UIView *tabView;
    IBOutlet UIView *detailsView;
    IBOutlet UIView *backGroundBorderForDetailsView;
    IBOutlet UIView *backGroundBorderForTabView;
    
    IBOutlet UITextView *itemDescriptionTextView;
    IBOutlet UILabel *itemNameLabel;
    IBOutlet UILabel *itemPriceLabel;
    IBOutlet UILabel *descriptioTitleLabel;
    
    IBOutlet UIButton *orderButton;
    RA_MenuObject *menuObject;
    
    UIAlertView *takeOrderInAlertView;
}

@property (nonatomic, retain) UIImage *itemImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMenuObject:(RA_MenuObject*)_object;

-(IBAction)orderButtonAction:(UIButton*)sender;

//-(IBAction)addToButtonOrderAction:(id)sender;
//-(IBAction)shareButtonAction:(id)sender;

@end
