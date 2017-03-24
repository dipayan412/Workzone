//
//  OffersViewController.h
//  iOS Prototype
//
//  Created by World on 3/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    IBOutlet UITableView *containerTableView;
    UIAlertView *loadingAlert;
}

@end
