//
//  DrawerViewController.h
//  iOS Prototype
//
//  Created by World on 3/5/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"

@interface DrawerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DrawerViewDelegate>
{
    IBOutlet UITableView *containerTableView;
    UITapGestureRecognizer *tapRecognizer;
}

@property (nonatomic, strong) UIViewController *currentViewController;

@end
