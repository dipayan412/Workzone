//
//  VisitByYearViewController.h
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitByYearViewController : UIViewController
{
    IBOutlet UITableView *countryTable;
}

-(IBAction)selectYear:(id)sender;

@end
