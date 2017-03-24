//
//  CreatePromoViewController.h
//  iOS Prototype
//
//  Created by World on 3/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopObject.h"

@interface CreatePromoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate,UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *formTableView;
    IBOutlet UITextField *promoNameField;
    IBOutlet UIImageView *promoImageView;
    IBOutlet UIButton *locateButton;
}
@property (nonatomic, retain) ShopObject *shopObject;

-(IBAction)promeImageButtonAction:(UIButton*)btn;
-(IBAction)locatePromoButtonAction:(UIButton*)btn;
-(IBAction)bgTap:(id)sender;

@end
