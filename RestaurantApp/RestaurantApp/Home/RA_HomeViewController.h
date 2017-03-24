//
//  RA_HomeViewController.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RA_HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *containerTableView;
    IBOutlet UIImageView *slideshowImageView;
    IBOutlet UIView *slightShowBGView;
    
    IBOutlet UIButton *leftButton;
    IBOutlet UIButton *rightButton;
}

-(IBAction)leftButtonAction:(UIButton*)sender;
-(IBAction)rightButtonAction:(UIButton*)sender;


@end
