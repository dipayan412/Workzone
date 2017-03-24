//
//  DropboxFilesViewController.h
//  MyOvertime
//
//  Created by Ashif on 7/3/13.
//
//

#import <UIKit/UIKit.h>

@interface DropboxFilesViewController : UITableViewController <UIAlertViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    int selectedIndex;
    UIView *loadingView;
    BOOL added;
}

@property (nonatomic, retain) NSArray *backupFiles;

@end
