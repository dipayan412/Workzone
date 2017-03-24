//
//  DropboxViewController.h
//  MyOvertime
//
//  Created by Ashif on 5/30/13.
//
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>
#import "ScaryBugDoc.h"
#import "ScaryBugData.h"

@interface DropboxViewController : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UIButton *linkDropboxButton;
    IBOutlet UILabel *lastBackupLabel;
    
    IBOutlet UIButton *mondayCheckbox;
    IBOutlet UIButton *tuesdayCheckbox;
    IBOutlet UIButton *wednesdayCheckbox;
    IBOutlet UIButton *thursdayCheckbox;
    IBOutlet UIButton *fridayCheckbox;
    IBOutlet UIButton *saturdayCheckbox;
    IBOutlet UIButton *sundayCheckbox;
    
    BOOL stylePerformed;
}

-(IBAction)toggleAction:(id)sender;
-(IBAction)linkDropbox:(id)sender;
-(IBAction)createBackup:(id)sender;
-(IBAction)restoreBackup:(id)sender;

@end
