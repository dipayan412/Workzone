//
//  CalendarSelectionDelegate.h
//  MyOvertime
//
//  Created by Ashif on 2/13/13.
//
//

#import <Foundation/Foundation.h>

@protocol CalendarSelectionDelegate <NSObject>

-(void)delegateDidSelectDate:(NSDate*)_d fromController:(UIViewController*)controller;

@end
