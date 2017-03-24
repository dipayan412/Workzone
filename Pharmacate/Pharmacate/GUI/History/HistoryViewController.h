//
//  HistoryViewController.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/6/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController
{
    UITableView *historyTableView;
    IBOutlet UIView *topBarView;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withHistoryArray:(NSArray*)_historyArray DateArray:(NSArray*)_dateArray;
-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)resetButtonAction:(UIButton*)sender;

@end
