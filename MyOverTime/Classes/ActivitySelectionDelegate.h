//
//  ActivitySelectionDelegate.h
//  MyOvertime
//
//  Created by Ashif on 5/16/13.
//
//

#import <Foundation/Foundation.h>

@protocol ActivitySelectionDelegate <NSObject>

-(void)delegateDidSelectActivities:(NSArray*)_selectedActivities;
-(void)delegateDidCancelSelection;

@end
