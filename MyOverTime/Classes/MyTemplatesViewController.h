//
//  MyTemplatesViewController.h
//  MyOvertime
//
//  Created by Ashif on 2/19/13.
//
//

#import <UIKit/UIKit.h>
#import "MyTemplate.h"


@interface MyTemplatesViewController : UITableViewController
{
    NSArray *myTemplates;
}

@property (nonatomic, retain) NSArray *myTemplates;

@end
