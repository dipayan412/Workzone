//
//  VisitByCountryViewController.h
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitByCountryViewController : UIViewController
{
    IBOutlet UIView *visitInfoView;
    
    IBOutlet UIButton *byYearButton;
    IBOutlet UIButton *bySemesterButton;
    IBOutlet UIButton *byQuarterButton;
    IBOutlet UIButton *byMonthButton;
    
    int visitInfoType;
}

-(IBAction)selectCountry:(id)sender;
-(IBAction)selectByYear:(id)sender;
-(IBAction)selectBySemester:(id)sender;
-(IBAction)selectByQuarter:(id)sender;
-(IBAction)selectByMonth:(id)sender;

@end
