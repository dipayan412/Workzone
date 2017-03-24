//
//  ContactsViewController.m
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ContactsViewController.h"
#import "RightViewController.h"
#import "ContactObject.h"
#import "ContactProfileViewController.h"
#import "RA_ImageCache.h"
#import "AddContactByPhoneBookManager.h"
#import "AppDelegate.h"
#import "Contact.h"
#import "PhoneBookObject.h"
#import "SearchCellV2.h"
#import "PhonebookManager.h"
#import "NonWakeUpGridCell.h"

#import <QuartzCore/QuartzCore.h>

@interface ContactsViewController () <ASIHTTPRequestDelegate, AddContactByPhoneBookDelegate, SearchCellDelegate, NonWakeUpGridCellDelegate>
{
    NSMutableArray *wakeUpUsersArray;
    NSMutableArray *nonWakeUpUsersArray;
    NSMutableArray *cellArray;
    NSMutableArray *invitedUsers;
    
    UIViewController *currentViewController;
    
    int selectedContactIndex;
    
    ContactProfileViewController *profileVC;
    
    BOOL open;
    
    ASIHTTPRequest *getContactRequest;
    ASIHTTPRequest *addRequest;
    
    RA_ImageCache *getCh;
    
    MBProgressHUD *hud;
    
    PhoneBookObject *messageSentToContact;
}

@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    open = NO;
    
    getCh = [[RA_ImageCache alloc] init];
    
    selectedContactIndex = -1;
    
    invitedUsers = [[NSMutableArray alloc] init];
    
    UINib *wakeUpCellNib = [UINib nibWithNibName:@"WakeUpGridCell" bundle:nil];
    
    [wakeUsersCollectionView registerNib:wakeUpCellNib forCellWithReuseIdentifier:@"WakeUpGridContactCell"];
    wakeUsersCollectionView.backgroundColor = [UIColor whiteColor];
    wakeUsersCollectionView.allowsMultipleSelection = NO;
    
    wakeUpUsersArray = [[NSMutableArray alloc] init];
    cellArray = [[NSMutableArray alloc] init];
    
//    UINib *nonWakeUpCellNib = [UINib nibWithNibName:@"NonWakeUpGridCell" bundle:nil];
    
//    [nonWakeUsersCollectionView registerNib:nonWakeUpCellNib forCellWithReuseIdentifier:@"NonWakeUpGridContactCell"];
    [nonWakeUsersCollectionView registerClass:[NonWakeUpGridCell class] forCellWithReuseIdentifier:@"nonWakeUpGridCell"];
    nonWakeUsersCollectionView.backgroundColor = [UIColor whiteColor];
    nonWakeUsersCollectionView.allowsMultipleSelection = NO;
    
    nonWakeUpUsersArray = [[NSMutableArray alloc] init];
    
    wakeUsersTableView.frame = CGRectMake(0, 88, 320, self.view.bounds.size.height - 88);
    wakeUsersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    nonWakeUsersTableView.frame = CGRectMake(0, 88, 320, self.view.bounds.size.height - 88);
    nonWakeUsersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    profileVC = [[ContactProfileViewController alloc] initWithNibName:@"ContactProfileViewController" bundle:nil];
    profileVC.delegate = self;
    
    contactSegment.selectedSegmentIndex = 0;
    nonWakeUsersTableView.hidden = YES;
    wakeUsersTableView.hidden = NO;
    
//    [self getContactRequestCall];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadControllerInContact) name:kContactViewControllerToFront object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PhoneBookSyncFinished) name:kPhoneBookContactAddedNotification object:nil];
    
    [nonWakeUpUsersArray removeAllObjects];
    [self loadNonWakeUpContacts];
    
    self.view.backgroundColor = kAppBGColor;
    wakeUsersTableView.backgroundColor =
    nonWakeUsersTableView.backgroundColor = [UIColor clearColor];
    
//    [self cellConfigurationForArray:nonWakeUpUsersArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)reloadControllerInContact
{
    [wakeUpUsersArray removeAllObjects];
    [self loadContacts];
    [wakeUsersTableView reloadData];
    [wakeUsersCollectionView reloadData];
    
    [self loadNonWakeUpContacts];
    
    [nonWakeUsersTableView reloadData];
    [nonWakeUsersCollectionView reloadData];
}

-(void)loadNonWakeUpContacts
{
    nonWakeUpUsersArray = (NSMutableArray*)[UserDefaultsManager phoneBookArray];//(NSMutableArray*) [[PhonebookManager getInstance] getPhoneBookContact];
}

-(void)loadContacts
{
    NSError *error = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    for(int i = 0; i < fetchedResult.count; i++)
    {
        Contact *contact = [fetchedResult objectAtIndex:i];
//        NSLog(@"contact UID %@ and phone %@", contact.uid, contact.phoneNumber);
        if(![contact.uid isEqualToString:[UserDefaultsManager userPhoneNumber]])
        {
            [wakeUpUsersArray addObject:contact];
        }
    }
}

-(void)getContactRequestCall
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@&",kGetContactListApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    
    NSLog(@"getCntctUrl %@",urlStr);
    
    getContactRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    getContactRequest.delegate = self;
//    [getContactRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [wakeUpUsersArray removeAllObjects];
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"getContactRequest return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
    
    if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
    {
        for(int i = 0; i < [[[responseObject objectForKey:@"body"] objectForKey:@"contactlist"] count]; i++)
        {
            ContactObject *contactObject = [[ContactObject alloc] init];
            contactObject.contactName = [[[[responseObject objectForKey:@"body"] objectForKey:@"contactlist"] objectAtIndex:i] objectForKey:@"name"];
            contactObject.contactPhotoId = [[[[responseObject objectForKey:@"body"] objectForKey:@"contactlist"] objectAtIndex:i] objectForKey:@"uphoto"];
            
            [wakeUpUsersArray addObject:contactObject];
        }
        [wakeUsersTableView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error localizedDescription]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(IBAction)contactSengemtValueShanged:(UISegmentedControl*)sender
{
    [self reloadControllerInContact];
    
    wakeUsersTableView.hidden = YES;
    nonWakeUsersTableView.hidden = YES;
    
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            wakeUsersTableView.hidden = NO;
            break;
            
        case 1:
            nonWakeUsersTableView.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark collectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(contactSegment.selectedSegmentIndex == 0)
    {
        return wakeUpUsersArray.count;
    }
    return nonWakeUpUsersArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(contactSegment.selectedSegmentIndex == 0)
    {
        static NSString *identifier = @"WakeUpGridContactCell";
        UICollectionViewCell *cell = [wakeUsersCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        Contact *contactObject = [wakeUpUsersArray objectAtIndex:indexPath.row];
        
        UIImageView *iv = (UIImageView*)[cell viewWithTag:100];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.cornerRadius = 35;
        iv.layer.masksToBounds = YES;
        [iv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@",kRootUrl,contactObject.uphotoId]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
        
        
        UILabel *lbl = (UILabel*)[cell viewWithTag:101];
        lbl.text = contactObject.givenName;
        
        UILabel *phnNumbr = (UILabel*)[cell viewWithTag:102];
        phnNumbr.text = contactObject.phoneNumber;
        
        cell.contentView.layer.cornerRadius = 7.0f;
        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.borderWidth = 1.0f;
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"nonWakeUpGridCell";
        
        NonWakeUpGridCell *cell =  (NonWakeUpGridCell *)[nonWakeUsersCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.indexPath = indexPath;
        cell.delegate = self;
        
        PhoneBookObject *obj = [nonWakeUpUsersArray objectAtIndex:indexPath.row];
        
        [cell.nameLabel setText:obj.name];
        cell.phoneLabel.text = obj.phoneNumber;
        if(obj.image)
        {
            cell.contactImageView.image = obj.image;
        }
        else
        {
            cell.contactImageView.image = [UIImage imageNamed:@"ProPicUploadIcon.png"];;
        }
        
        NSLog(@"index row %ld, isInvited %d", (long)indexPath.item, obj.isInvited);
        
        if(obj.isInvited)
        {
            cell.inviteButton.alpha = 0;
            cell.invitationStatusLabel.alpha = 1.0f;
        }
        else
        {
            cell.inviteButton.alpha = 1.0f;
            cell.invitationStatusLabel.alpha = 0.0f;
        }
        
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(contactSegment.selectedSegmentIndex == 0)
    {
        Contact *contactObject = [wakeUpUsersArray objectAtIndex:indexPath.row];
        
        profileVC.contactObject = contactObject;
        currentViewController = profileVC;
        [self showChildViewController];
    }
}

#pragma mark TableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(contactSegment.selectedSegmentIndex == 0)
    {
        return wakeUpUsersArray.count;
    }
    return nonWakeUpUsersArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(contactSegment.selectedSegmentIndex == 0)
    {
        static NSString *identifier = @"WakeUpContactCell";
        SearchCellV2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[SearchCellV2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        Contact *contactObject = [wakeUpUsersArray objectAtIndex:indexPath.row];
        
        [cell.userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@", kRootUrl,contactObject.uphotoId]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
        cell.userNameLabel.text = contactObject.givenName;
        cell.phoneLabel.text = contactObject.phoneNumber;
        
        cell.invitationStatusLabel.alpha = 0.0f;
        cell.actionButton.alpha = 0.0f;
        
        return cell;
    }
    else
    {
        NSString *identifier = [NSString stringWithFormat:@"R%dS%d",indexPath.row,indexPath.section];
        SearchCellV2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[SearchCellV2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.delegate = self;
        }
        PhoneBookObject *phoneObject = [nonWakeUpUsersArray objectAtIndex:indexPath.row];
        
        cell.userNameLabel.text = phoneObject.name;
        cell.phoneLabel.text = phoneObject.phoneNumber;
        if(phoneObject.image)
        {
            cell.userImageView.image = phoneObject.image;
        }
        
        cell.indexPath = indexPath;
        
        if(phoneObject.isInvited)
        {
            cell.invitationStatusLabel.alpha = 1.0f;
            cell.actionButton.alpha = 0.0f;
        }
        else
        {
            cell.invitationStatusLabel.alpha = 0.0f;
            cell.actionButton.alpha = 1.0f;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(contactSegment.selectedSegmentIndex == 0)
    {
        Contact *contactObject = [wakeUpUsersArray objectAtIndex:indexPath.row];
        
        profileVC.contactObject = contactObject;
        currentViewController = profileVC;
        [self showChildViewController];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark NonwakeUp cell delegate methods

-(void)userButtonActionAtIndex:(int)row
{
    [self makeInviteServerCallForObjectAtIndex:row];
}

-(void)inviteButtonActionAtIndex:(NSIndexPath *)_index
{
    [self makeInviteServerCallForObjectAtIndex:(int)_index.item];
}

-(void)makeInviteServerCallForObjectAtIndex:(int)_index
{
    selectedContactIndex = _index;
    PhoneBookObject *object = [nonWakeUpUsersArray objectAtIndex:_index];
    messageSentToContact = object;
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = [NSString stringWithFormat:@"Hi %@, Come and join Milkywake",object.name];
		controller.recipients = [NSArray arrayWithObjects:object.phoneNumber, nil];
		controller.messageComposeDelegate = self;
		[self presentViewController:controller animated:YES completion:nil];
	}
    
//    NSMutableString *urlStr = [[NSMutableString alloc] init];
//    [urlStr appendFormat:@"%@",kBaseUrl];
//    [urlStr appendFormat:@"cmd=%@",kAddContact];
//    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
//    [urlStr appendFormat:@"&cphone=%@",[[object.phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSLog(@"addCntact urlStr %@",urlStr);
//    
//    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    request.timeOutSeconds = 60;
//    [request setCompletionBlock:^{
//        NSError *error = nil;
//        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
//        NSLog(@"SendContactRequest request return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
//        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
//        {
//            object.isInvited = YES;
//            
//            [nonWakeUsersTableView reloadData];
//            [nonWakeUsersCollectionView reloadData];
//            
//            [UserDefaultsManager setPhoneBookArray:nonWakeUpUsersArray];
//        }
//    }];
//    [request setFailedBlock:^{
//        NSLog(@"%@",[request.error localizedDescription]);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
//        [alert show];
//    }];
//    [request startAsynchronous];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
		case MessageComposeResultCancelled:
			messageSentToContact.isInvited = NO;
			break;
		case MessageComposeResultFailed:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
			[alert show];
            messageSentToContact.isInvited = NO;
        }
			break;
		case MessageComposeResultSent:
            messageSentToContact.isInvited = YES;
            
            [nonWakeUsersTableView reloadData];
            [nonWakeUsersCollectionView reloadData];

            [UserDefaultsManager setPhoneBookArray:nonWakeUpUsersArray];
            
			break;
		default:
			break;
	}
    
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark User defined actions

-(IBAction)syncPhoneBookButtonAction:(UIButton*)sender
{
    AddContactByPhoneBookManager *phoneBookManager = [AddContactByPhoneBookManager getInstance];
    phoneBookManager.delegate = self;
    
    [[AddContactByPhoneBookManager getInstance] getAddressBook];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Syncing Contacts";
    hud.labelColor = [UIColor lightGrayColor];
}

-(void)phoneBookSyncProgress:(int)value totalContacts:(int)total syncedContacts:(int)synced
{
    hud.labelText = [NSString stringWithFormat:@"%d / %d numbers synced",synced, total];
}

-(void)PhoneBookSyncFinished
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    [self reloadControllerInContact];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.drawerViewDelegate)
    {
        [self.drawerViewDelegate showDrawerView];
    }
}

-(IBAction)gridOrTableButtonAction:(UIButton*)sender
{
//    if(contactSegment.selectedSegmentIndex == 0)
//    {
        UIView *fromView, *toView;
        
        if (wakeUsersTableView.superview == self.view)
        {
            fromView = wakeUsersTableView;
            toView = wakeUsersCollectionView;
            
            [gridOrTableButton setTitle:@"Table" forState:UIControlStateNormal];
        }
        else
        {
            fromView = wakeUsersCollectionView;
            toView = wakeUsersTableView;
            
            [gridOrTableButton setTitle:@"Grid" forState:UIControlStateNormal];
        }
    
        if (nonWakeUsersTableView.superview == self.view)
        {
            fromView = nonWakeUsersTableView;
            toView = nonWakeUsersCollectionView;
            
            [gridOrTableButton setTitle:@"Table" forState:UIControlStateNormal];
        }
        else
        {
            fromView = nonWakeUsersCollectionView;
            toView = nonWakeUsersTableView;
            
            [gridOrTableButton setTitle:@"Grid" forState:UIControlStateNormal];
        }
    
        toView.frame = CGRectMake(0, 88, 320, self.view.bounds.size.height - 88);
        
        [UIView transitionFromView:fromView
                            toView:toView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve//UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL completed){
                        }];
//    }
}

-(void)showChildViewController
{
    currentViewController.view.frame = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:currentViewController.view];
    [self.view bringSubviewToFront:currentViewController.view];
    [UIView animateWithDuration:0.3f animations:^{
        currentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactProfileViewControllerToFront object:nil];
}

-(void)hideChildViewController
{
    [UIView animateWithDuration:0.3f animations:^{
        currentViewController.view.frame = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)showContactViewController
{
    [self hideChildViewController];
}

// churi

-(void)cellConfigurationForArray:(NSMutableArray*)array
{
    [cellArray removeAllObjects];
    for(int i = 0; i < array.count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        static NSString *identifier = @"nonWakeUpGridCell";
        NonWakeUpGridCell *cell = [nonWakeUsersCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if(cell == nil)
        {
            cell = [[NonWakeUpGridCell alloc] init];
        }
        
        cell.delegate = self;
        
        PhoneBookObject *obj = [nonWakeUpUsersArray objectAtIndex:indexPath.row];
        
        cell.indexPath = indexPath;
        [cell.nameLabel setText:obj.name];
        cell.phoneLabel.text = obj.phoneNumber;
        if(obj.image)
        {
            cell.contactImageView.image = obj.image;
        }
        else
        {
            cell.contactImageView.image = [UIImage imageNamed:@"ProPicUploadIcon.png"];;
        }
        [cellArray addObject:cell];
    }
    [nonWakeUsersCollectionView reloadData];
}

@end
