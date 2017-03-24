//
//  PreviousSessionViewController.h
//  40Days
//
//  Created by Ashif on 6/13/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviousSessionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *sessionsView;
}

@property (nonatomic, retain) NSArray *audioFiles;

@end
