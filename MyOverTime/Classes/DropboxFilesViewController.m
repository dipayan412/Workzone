//
//  DropboxFilesViewController.m
//  MyOvertime
//
//  Created by Ashif on 7/3/13.
//
//

#import "DropboxFilesViewController.h"
#import <Dropbox/Dropbox.h>
#import "DBObject.h"
#import "ScaryBugDoc.h"
#import "MyOvertimeAppDelegate.h"

@interface DropboxFilesViewController ()

@end

@implementation DropboxFilesViewController

@synthesize backupFiles;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self fetchDropBoxFiles];
        });
        selectedIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!added)
    {
        added = YES;
        
        UIActivityIndicatorView *busyIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        busyIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
        busyIndicator.backgroundColor = [UIColor clearColor];
        busyIndicator.hidden = NO;
        [busyIndicator startAnimating];
        
        
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        loadingView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        [loadingView addSubview:busyIndicator];
        
        UILabel *waitingLabel = [[UILabel alloc] initWithFrame:CGRectMake(loadingView.bounds.size.width /2 - 100, busyIndicator.frame.origin.y+busyIndicator.frame.size.height + 5, 200, 40)];
        waitingLabel.text = NSLocalizedString(@"LOADING_TITLE", nil);
        waitingLabel.textAlignment = UITextAlignmentCenter;
        waitingLabel.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:waitingLabel];
        
        [self.view addSubview:loadingView];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = myImageView;
	[myImageView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(backupFiles.count > 0) return backupFiles.count + 1;
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(self.backupFiles.count > 0 && indexPath.row == self.backupFiles.count)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = [NSString stringWithFormat:@"%d %@", self.backupFiles.count, NSLocalizedString(@"FILE", nil)];
    }
    else
    {
        if(self.backupFiles.count > 0)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            DBObject *item = [self.backupFiles objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textAlignment = UITextAlignmentLeft;
            cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
            cell.textLabel.text = item._fileName;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = NSLocalizedString(@"NO_FILE", nil);
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.backupFiles.count > 0 && indexPath.row == self.backupFiles.count)
    {
        return;
    }
    else
    {
        if(self.backupFiles.count > 0)
        {
            selectedIndex = indexPath.row;
            DBObject *item = [self.backupFiles objectAtIndex:selectedIndex];
            NSString *titleStr = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"TITLE_RESTORE", nil), item._fileName];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:titleStr delegate:self cancelButtonTitle:NSLocalizedString(@"BACKGROUND_ACTION_SHEET_CANCEL_BUTTON", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TITLE_RESTORE", nil) ,nil];
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
            [actionSheet release];
        }
    }
}

-(void)fetchDropBoxFiles
{
    NSMutableArray *dbDatas = [[NSMutableArray alloc] init];
    
//    DBPath *folderPath = [[DBPath root] childPath:NSLocalizedString(@"TITLE_BACKUP", nil)];
    DBPath *folderPath = [[DBPath root] childPath:kDropboxFolderName];
    
    NSArray *dataArray = [[DBFilesystem sharedFilesystem] listFolder:folderPath error:nil];
    for(int i=0; i< dataArray.count; i++)
    {
        DBFileInfo *fileInfo = [dataArray objectAtIndex:i];
        NSString *fileName = [fileInfo.path.stringValue lastPathComponent];
        
        DBFile *dataFile = [[DBFilesystem sharedFilesystem] openFile:fileInfo.path error:nil];
        NSData *data = [dataFile readData:nil];
        
        DBObject *object = [[DBObject alloc] init];
        object._fileName = fileName;
        object._data = data;
        
        [dbDatas addObject:object];
    }
    
    self.backupFiles = dbDatas;
    [dbDatas release];
    
    [loadingView removeFromSuperview];
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Action Sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if(selectedIndex >= 0)
        {
            DBObject *item = [self.backupFiles objectAtIndex:selectedIndex];
            ScaryBugDoc *newDoc = [[[ScaryBugDoc alloc] init] autorelease];
            
            if ([newDoc importDropboxData:item._data])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"DM_RESTORE_SUCCESS", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
            else
            {
                NSLog(@"error");
            }
        }
    }
}

#pragma mark -
#pragma mark AlertView delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        MyOvertimeAppDelegate *app = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
        [app resetApp];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
