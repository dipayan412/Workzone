//
//  JobItemPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobItemPageViewController : UIViewController
{
    IBOutlet UILabel *customerLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *contactLabel;
    IBOutlet UILabel *phoneLabel;
    IBOutlet UILabel *dueDateLabel;
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *detailsLabel;
    
    IBOutlet UIButton *editJobButton;
    IBOutlet UIButton *removeJobButton;
}
- (IBAction)editJobButtonAction:(UIButton *)sender;
- (IBAction)removeJobButtonAction:(UIButton *)sender;

@end
