//
//  MessageRoomViewController.m
//  WakeUp
//
//  Created by World on 7/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "MessageRoomViewController.h"
#import "AppDelegate.h"
#import "MessageRoomSynchronizer.h"
#import "MessageRoomCell.h"
#import "MessageRoomDummyObject.h"
#import "NSDate+Extension.h"

#define kFontSize 14.0f
#define kTimerInterval 60.0f

@interface MessageRoomViewController ()
{
    ASIHTTPRequest *getMessageRoomRequest;
    ASIHTTPRequest *sendMessageRequest;
    
    NSMutableArray *messageArray;
    
    NSMutableArray *sendMessageRequestArray;
    NSMutableArray *messageToSendArray;
    NSMutableArray *messageRoomDummyObjectArray;
    NSMutableArray *datesArray;
    
    int lastMessageCount;
    
    float lastRowOffset;
    
    NSTimer *updateMessageRoomObjectTimer;
}

@property (nonatomic, strong) NSArray *synchedMessages;

@end

@implementation MessageRoomViewController

@synthesize messageRoomObject;
@synthesize synchedMessages;
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
    
    messageArray = [[NSMutableArray alloc] init];
    sendMessageRequestArray = [[NSMutableArray alloc] init];
    messageToSendArray = [[NSMutableArray alloc] init];
    messageRoomDummyObjectArray = [[NSMutableArray alloc] init];
    datesArray = [[NSMutableArray alloc] init];
    
    [self loadMessages];
    [self mergeViewableMessages];
    lastMessageCount = (int)[[messageRoomDummyObjectArray lastObject] count];
    [containerTableView reloadData];
    
    // show the last synced message item in tableview
    if(messageRoomDummyObjectArray.count > 0)
    {
        NSArray *array = [messageRoomDummyObjectArray lastObject];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(array.count - 1) inSection:(messageRoomDummyObjectArray.count - 1)];
        [containerTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingMessageArrived) name:kIncomingMessageArrivedRemoteNotificationReloadChatRoom object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadControllerMessageRoom) name:kMessageRoomViewControllerToFront object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMessageRoom) name:kMessageRoomSyncSucceededNotification object:nil];
    
    containerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    containerTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chatRoomBG.png"]];
    
    headerView.frame = CGRectMake(0, 0, 320, 44);
    [self.view addSubview:headerView];
    
    updateMessageRoomObjectTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(updateMessageRoomObjectTime) userInfo:nil repeats:YES];
    
    containerTableView.backgroundColor = kAppBGColor;
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
    if(self.delegate)
    {
        AppDelegate *apdl = (AppDelegate*)[UIApplication sharedApplication].delegate;
        apdl.isInChatRoom = YES;
        
        [self.view endEditing:YES];
        [[MessageRoomSynchronizer getInstance] stopSynchronizer];
        [self.delegate showContactViewController];
    }
}

-(void)incomingMessageArrived
{
    [[MessageRoomSynchronizer getInstance] synchronizeOnce:self.messageRoomObject];
}

-(void)reloadControllerMessageRoom
{
    AppDelegate *apdl = (AppDelegate*)[UIApplication sharedApplication].delegate;
    apdl.isInChatRoom = YES;
    [[MessageRoomSynchronizer getInstance] startSynchronizer:self.messageRoomObject];
    [self reloadMessageRoom];
    
    partnerNameLabel.text = self.messageRoomObject.senderName;
}

-(void)reloadMessageRoom
{
    [self loadMessages];
    [self mergeViewableMessages];
    [containerTableView reloadData];
    
//    if([[messageRoomDummyObjectArray lastObject] count] > 0)
//    {
//        NSArray *array = [messageRoomDummyObjectArray lastObject];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(array.count - 1) inSection:(messageRoomDummyObjectArray.count - 1)];
//        [containerTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        
//        lastRowOffset = containerTableView.contentOffset.y;
//        
//        lastMessageCount = [[messageRoomDummyObjectArray lastObject] count];
//    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == getMessageRoomRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@ %@ \nresponse %@",responseObject, error.description, request.responseString);
    }
    else
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@ %@ \nresponse %@",responseObject, error.description, request.responseString);
        NSString *messageId = [[responseObject objectForKey:@"body"] objectForKey:@"mid"];
        
        int index = (int)[sendMessageRequestArray indexOfObject:request];
        [sendMessageRequestArray removeObject:request];
        if(index > -1)
        {
            [messageToSendArray removeObjectAtIndex:index];
        }
        
        for(int i = 0; i < messageRoomDummyObjectArray.count; i++)
        {
            NSArray *array = [messageRoomDummyObjectArray objectAtIndex:i];
            for(int j = 0; j < array.count; j++)
            {
                MessageRoomDummyObject *dummy = [array objectAtIndex:j];
                
                if(request == dummy.sendMessageRequest)
                {
                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    NSManagedObjectContext *context = appDelegate.foregroundManagedObjectContext;
                    Messages *message = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:context];
                    
                    message.messageId = messageId;
                    message.receiverId = dummy.receiverId;
                    message.message = dummy.message;
                    message.sentOn = dummy.sentOn;
                    message.senderName = dummy.senderName;
                    message.senderId = dummy.senderId;
                    
                    [context save:&error];
                    
                    [messageRoomDummyObjectArray removeObject:dummy];
                    
                    [self loadMessages];
                    [self mergeViewableMessages];
                    [containerTableView reloadData];
                }
            }
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"error %@",[request.error localizedDescription]);
    
    int index = (int)[sendMessageRequestArray indexOfObject:request];
    [sendMessageRequestArray removeObject:request];
    if(index > -1)
    {
        [messageToSendArray removeObjectAtIndex:index];
    }
    
    for(int i = 0; i < messageRoomDummyObjectArray.count; i++)
    {
        NSArray *array = [messageRoomDummyObjectArray objectAtIndex:i];
        for(int j = 0; j < array.count; j++)
        {
            MessageRoomDummyObject *dummy = [array objectAtIndex:j];
            
            if(request == dummy.sendMessageRequest)
            {
                [messageRoomDummyObjectArray removeObject:dummy];
                
                [self loadMessages];
                [self mergeViewableMessages];
                [containerTableView reloadData];
            }
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return messageRoomDummyObjectArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = [messageRoomDummyObjectArray objectAtIndex:section];
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ChatRoomCellId";
    MessageRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[MessageRoomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSMutableArray *array = [messageRoomDummyObjectArray objectAtIndex:indexPath.section];
    MessageRoomDummyObject *dummy = [array objectAtIndex:indexPath.row];
    
    cell.senderImageView.hidden = YES;
    
    cell.chatMessageLabel.text = dummy.message;
    
    if (![dummy.messageId isEqualToString:@""])
    {
        cell.senderNameLabel.text = dummy.senderName;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"HH:mm:ss";
        
        cell.dateLabel.text = [df stringFromDate:dummy.sentOn];
        
        CGSize boundingSize = CGSizeMake(190, 100000);
        
        CGRect textRect = CGRectZero;
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:kFontSize];
        
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        
        textRect = [dummy.message boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        CGSize itemTextSize = textRect.size;
        
        if(itemTextSize.width < 190)
        {
            itemTextSize.width = 190;
        }
        if(itemTextSize.height < 20)
        {
            itemTextSize.height = 20;
        }
        
        if([dummy.senderId isEqualToString:self.messageRoomObject.pid])
        {
            cell.senderImageView.hidden = NO;
            
            UIEdgeInsets insets = UIEdgeInsetsMake(20, 30, 20, 20);
            cell.bubbleImage.image = [[UIImage imageNamed:@"senderBubbleWhiteBG.png"] resizableImageWithCapInsets:insets];
            cell.bubbleImage.frame = CGRectMake(10, 20, itemTextSize.width + 30, itemTextSize.height + 20);
            
            cell.senderImageView.frame = CGRectMake(cell.bubbleImage.frame.origin.x + cell.bubbleImage.frame.size.width - 20, 0, 40, 40);
            [cell.senderImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@", kRootUrl,self.messageRoomObject.partnerPhotoId]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
            cell.senderImageView.layer.cornerRadius = 20;
            cell.senderImageView.layer.borderColor = evenCellColor.CGColor;
            cell.senderImageView.layer.borderWidth = 4.0f;
            cell.senderImageView.layer.masksToBounds = YES;
            
            cell.chatMessageLabel.frame = CGRectMake(25, 30, itemTextSize.width, itemTextSize.height);
            cell.chatMessageLabel.font = font;
            cell.chatMessageLabel.numberOfLines = 0;
            cell.chatMessageLabel.textColor = [UIColor lightGrayColor];
            cell.chatMessageLabel.textAlignment = NSTextAlignmentLeft;
            
            NSString *dateStr = [NSString stringWithFormat:@"%d:%@%@",[dummy.sentOn hour12], [dummy.sentOn mm], [dummy.sentOn am_pm]];
            
            cell.dateLabel.frame = CGRectMake(320 - 70, 20, 60, 10);
            cell.dateLabel.textAlignment = NSTextAlignmentRight;
            cell.dateLabel.font = [UIFont systemFontOfSize:11];
            cell.dateLabel.textColor = [UIColor lightGrayColor];
            cell.dateLabel.text = dateStr;
            
            cell.senderNameLabel.textAlignment = cell.chatMessageLabel.textAlignment = NSTextAlignmentLeft;
        }
        else
        {
            UIEdgeInsets insets = UIEdgeInsetsMake(20, 20, 20, 30);
            cell.bubbleImage.image = [[UIImage imageNamed:@"receiverBubbleWhiteBG.png"] resizableImageWithCapInsets:insets];
            cell.bubbleImage.frame = CGRectMake(310 - itemTextSize.width - 30, 10, itemTextSize.width + 30, itemTextSize.height + 20);
            
            cell.chatMessageLabel.frame = CGRectMake(310 - itemTextSize.width - 15, 20, itemTextSize.width, itemTextSize.height);
            cell.chatMessageLabel.font = font;
            cell.chatMessageLabel.numberOfLines = 0;
            cell.chatMessageLabel.textAlignment = NSTextAlignmentRight;
            cell.chatMessageLabel.textColor = [UIColor lightGrayColor];
            
            NSString *dateStr = [NSString stringWithFormat:@"%d:%@%@",[dummy.sentOn hour12], [dummy.sentOn mm], [dummy.sentOn am_pm]];
            
            cell.dateLabel.frame = CGRectMake(10, 20, 60, 10);
            cell.dateLabel.textAlignment = NSTextAlignmentLeft;
            cell.dateLabel.font = [UIFont systemFontOfSize:11];
            cell.dateLabel.textColor = [UIColor lightGrayColor];
            cell.dateLabel.text = dateStr;
            
            cell.senderNameLabel.textAlignment = cell.chatMessageLabel.textAlignment = NSTextAlignmentRight;
        }
    }
    else
    {
        CGSize boundingSize = CGSizeMake(190, 100000);
        
        CGRect textRect = CGRectZero;
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:kFontSize];
        
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        
        textRect = [dummy.message boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        CGSize itemTextSize = textRect.size;
        
        if(itemTextSize.width < 190)
        {
            itemTextSize.width = 190;
        }
        if(itemTextSize.height < 20)
        {
            itemTextSize.height = 20;
        }
        
        UIEdgeInsets insets = UIEdgeInsetsMake(20, 20, 20, 30);
        cell.bubbleImage.image = [[UIImage imageNamed:@"receiverBubble.png"] resizableImageWithCapInsets:insets];
        cell.bubbleImage.frame = CGRectMake(310 - itemTextSize.width - 30, 10, itemTextSize.width + 30, itemTextSize.height + 20);
        
        cell.chatMessageLabel.frame = CGRectMake(310 - itemTextSize.width - 15, 20, itemTextSize.width, itemTextSize.height);
        cell.chatMessageLabel.font = font;
        cell.chatMessageLabel.numberOfLines = 0;
        cell.chatMessageLabel.textAlignment = NSTextAlignmentRight;
        cell.chatMessageLabel.textColor = [UIColor lightGrayColor];
        
        NSString *dateStr = [NSString stringWithFormat:@"%d:%@%@",[dummy.sentOn hour12], [dummy.sentOn mm], [dummy.sentOn am_pm]];
        
        cell.dateLabel.frame = CGRectMake(10, 20, 60, 10);
        cell.dateLabel.textAlignment = NSTextAlignmentLeft;
        cell.dateLabel.font = [UIFont systemFontOfSize:11];
        cell.dateLabel.textColor = [UIColor lightGrayColor];
        cell.dateLabel.text = dateStr;
        
        cell.senderNameLabel.textAlignment = cell.chatMessageLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [messageRoomDummyObjectArray objectAtIndex:indexPath.section];
    MessageRoomDummyObject *dummy = [array objectAtIndex:indexPath.row];
    
    CGSize boundingSize = CGSizeMake(190, 100000);
    
    CGRect textRect = CGRectZero;
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:kFontSize];
    
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle};
    
    textRect = [dummy.message boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    CGFloat itemHeight = textRect.size.height;
    
    if(itemHeight < 20)
    {
        itemHeight = 20;
    }
    
    if([dummy.senderId isEqualToString:self.messageRoomObject.pid])
    {
        itemHeight += 10;
    }
    
    return (itemHeight + 40);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *array = [messageRoomDummyObjectArray objectAtIndex:section];
    MessageRoomDummyObject *object = array.lastObject;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    
    NSString *str = [df stringFromDate:object.sentOn];
    
    static NSString *identifier = @"defaultHeader";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footerView)
    {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    v.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    [footerView addSubview:v];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.text = str;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:13.0];
    lbl.textColor = [UIColor lightGrayColor];
    [footerView addSubview:lbl];
    
    return footerView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"");
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self commitAnimationY:-216];//(568 - 216 - 55)];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self commitAnimationY:0];//(568 - 55)];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"] && [textView.text isEqualToString:@""])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)commitAnimationY:(int)y
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = y;
        self.view.frame = frame;
        
        if(y < 0)
        {
            CGRect frame = headerView.frame;
            frame.origin.y = 216;
            headerView.frame = frame;
        }
        else
        {
            CGRect frame = headerView.frame;
            frame.origin.y = 0;
            headerView.frame = frame;
        }
    }];
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

-(IBAction)chatSendButtonAction:(UIButton*)sender
{
    if ([chatTextView.text isEqualToString:@""])
    {
        return;
    }
    
    [self.view endEditing:YES];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kSendMessgaeApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&uid=%@",messageRoomObject.pid];
    [urlStr appendFormat:@"&msg=%@",[chatTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"sendMessageUrl %@",urlStr);
    
    ASIHTTPRequest *sendRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    sendRequest.delegate = self;
    [sendMessageRequestArray addObject:sendRequest];
    sendRequest.tag = 100 + sendMessageRequestArray.count;
    
    [sendRequest startAsynchronous];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    MessageRoomDummyObject *dummy = [[MessageRoomDummyObject alloc] init];
    dummy.message = chatTextView.text;
    dummy.messageId = @"";
    dummy.senderName = [UserDefaultsManager userName];
    dummy.receiverId = self.messageRoomObject.pid;
    dummy.sentOn = [df dateFromString:[df stringFromDate:[NSDate date]]];
    dummy.senderId = @"";
    dummy.sendMessageRequest = sendRequest;
    
    [messageToSendArray addObject:dummy];
    
    [self loadMessages];
    [self mergeViewableMessages];
    
    [containerTableView reloadData];
    
    if(messageRoomDummyObjectArray.count > 0)
    {
        NSArray *array = [messageRoomDummyObjectArray lastObject];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(array.count - 1) inSection:(messageRoomDummyObjectArray.count - 1)];
        [containerTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    chatTextView.text = @"";
}

-(void)mergeViewableMessages
{
    [messageRoomDummyObjectArray removeAllObjects];
    
    for(Messages *msg in self.synchedMessages)
    {
        MessageRoomDummyObject *dummy = [[MessageRoomDummyObject alloc] init];
        dummy.messageId = msg.messageId;
        dummy.message = msg.message;
        dummy.senderId = msg.senderId;
        dummy.receiverId = msg.receiverId;
        dummy.senderName = msg.senderName;
        dummy.sentOn = msg.sentOn;
        
        if (messageRoomDummyObjectArray.count > 0)
        {
            NSMutableArray *lastArray = messageRoomDummyObjectArray.lastObject;
            MessageRoomDummyObject *lastObject = lastArray.lastObject;
            
            if ([lastObject.sentOn matchesDateWith:dummy.sentOn])
            {
                [lastArray addObject:dummy];
            }
            else
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:dummy];
                
                [messageRoomDummyObjectArray addObject:array];
            }
        }
        else
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:dummy];
            
            [messageRoomDummyObjectArray addObject:array];
        }
    }
    
    for(MessageRoomDummyObject *msg in messageToSendArray)
    {
        if (messageRoomDummyObjectArray.count > 0)
        {
            NSMutableArray *lastArray = messageRoomDummyObjectArray.lastObject;
            MessageRoomDummyObject *lastObject = lastArray.lastObject;
            
            if ([lastObject.sentOn matchesDateWith:msg.sentOn])
            {
                [lastArray addObject:msg];
            }
            else
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:msg];
                
                [messageRoomDummyObjectArray addObject:array];
            }
        }
        else
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:msg];
            
            [messageRoomDummyObjectArray addObject:array];
        }
    }
}

-(void)loadMessages
{
    NSError *error = nil;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate foregroundManagedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.senderId = %@ OR SELF.receiverId = %@", self.messageRoomObject.pid, self.messageRoomObject.pid];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"sentOn" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(fetchedResult && fetchedResult.count > 0)
    {
        self.synchedMessages = fetchedResult;
    }
    else
    {
        self.synchedMessages = [NSArray array];
    }
}

@end
