//
//  FAQDetailsViewController.h
//  MyOvertime
//
//  Created by Ashif on 6/17/13.
//
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"
#import "SectionInfo.h"

@interface FAQDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SectionHeaderViewDelegate>
{
    NSMutableArray *sectionInfoArray;
    
    IBOutlet UITableView *contentView;
    
    BOOL stylePerformed;
    NSInteger openSectionIndex;
}

@property (nonatomic, retain) NSArray *questions;
@property (nonatomic, retain) NSArray *answers;

@end
