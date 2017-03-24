//
//  MessagesViewController.m
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "MessagesViewController.h"
#import "InboxObject.h"
#import "AppDelegate.h"
#import "MessageRoom.h"
#import "MessageListTableViewCell.h"

#define kTimerInterval 60.0f

@interface MessagesViewController ()
{
    NSMutableArray *inboxObjectArray;
    
    ASIHTTPRequest *getInboxRequest;
    
    UIViewController *currentViewController;
    
    MessageRoomViewController *messageRoomVc;
    
    NSTimer *updateMessageRoomObjectTimer;
}

@end

@implementation MessagesViewController

@synthesize delegate;

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
    
    messageRoomVc = [[MessageRoomViewController alloc] initWithNibName:@"MessageRoomViewController" bundle:nil];
    messageRoomVc.delegate = self;
    
    inboxObjectArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadController) name:kInboxSynchronizedNotification object:nil];
    
    [self getMessageRooms];
    
    updateMessageRoomObjectTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(updateMessageRoomObjectTime) userInfo:nil repeats:YES];
   
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [containerTableView reloadData];
}

-(void)updateMessageRoomObjectTime
{
    [containerTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(delegate)
    {
        [delegate showDrawerView];
    }
}

-(void)reloadController
{
    [self getMessageRooms];
    [containerTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return inboxObjectArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"IR%dS%d",(int)indexPath.row,(int)indexPath.section];
    
    MessageListTableViewCell *cell = (MessageListTableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MessageListTableViewCell" owner:self options:nil];
    cell = [arr objectAtIndex:0];
    
    MessageRoom *messageRoom = [inboxObjectArray objectAtIndex:indexPath.row];
    
    if(messageRoom.partnerPhotoId)
    {
        [cell.partnerPhotoView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@", kRootUrl,messageRoom.partnerPhotoId]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
    }
    
    cell.partnerNameLabel.text = messageRoom.senderName;
    cell.messageLabel.text = messageRoom.lastMsgText;
    cell.timeLabel.text = [self getTimeIntervalOfPost:messageRoom.time];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0f];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageRoom *messageRoomObject = [inboxObjectArray objectAtIndex:indexPath.row];
    
    messageRoomVc.messageRoomObject = messageRoomObject;
    currentViewController = messageRoomVc;
    [self showChildViewController];
}

-(void)showChildViewController
{
    currentViewController.view.frame = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:currentViewController.view];
    [self.view bringSubviewToFront:currentViewController.view];
    [UIView animateWithDuration:0.3f animations:^{
        currentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageRoomViewControllerToFront object:nil];
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

-(void)getMessageRooms
{
    NSError *error = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate foregroundManagedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"MessageRoom" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    [fetchRequest setEntity:chartEntity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if(fetchedResult.count > 0) [inboxObjectArray removeAllObjects];
    
    for(int i = 0; i < fetchedResult.count; i++)
    {
        MessageRoom *room = [fetchedResult objectAtIndex:i];
        if(![room.pid isEqualToString:[UserDefaultsManager userPhoneNumber]])
        {
            [inboxObjectArray addObject:room];
        }
    }
    
//    inboxObjectArray = fetchedResult;
}

-(NSString*)getTimeIntervalOfPost:(NSDate*)postDate
{
    float interval = fabs([postDate timeIntervalSinceNow]);
    if(interval < 60)
    {
        return @"Now";
    }
    else if((interval / 60) > 1440)
    {
        return [NSString stringWithFormat:@"%d days",(int)((interval / 60) / 1440)];
    }
    else if((interval / 60) > 59)
    {
        return [NSString stringWithFormat:@"%d hour%@",(int)((interval / 60) / 60), (int)((interval / 60) / 60) > 1 ? @"s" : @""];
    }
    else
    {
        return [NSString stringWithFormat:@"%dm.",(int)(interval / 60)];
    }
    return @"";
}

@end
