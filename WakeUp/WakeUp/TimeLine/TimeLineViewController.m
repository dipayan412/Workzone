//
//  TimeLineViewController.m
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "TimeLineViewController.h"
#import "RightViewController.h"
#import "ClockSetupViewController.h"
#import "TimelineCell.h"
#import "TimelineObject.h"
#import "RA_ImageCache.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kTextViewPlaceHolder    @"Write a comment..."
#define MAX_POST    6
#define kTimerInterval 60.0f

#define kHeightOfScreen kIsThreePointFiveInch ? 480 : 568

static int timeLineCurrentIndex;

@interface TimeLineViewController () <TimeLineCellDelegate, ASIHTTPRequestDelegate, ClockSetupViewControllerDelegate, NSURLConnectionDelegate>
{
    int expandedRow;
    CGFloat heightOfExpandedCell;
    
    ASIHTTPRequest *getTimelineRequest;
    ASIHTTPRequest *sendMessageRequest;
    
    NSMutableArray *timeLineObjectArray;
    NSMutableArray *cells;
    
    RA_ImageCache *imgCh;
    
    BOOL showMoreButton;
    
    NSTimer *updateTimeLineObjectTimer;
    
    UIRefreshControl *refreshControl;
    
    ClockSetupViewController *clockSetupVC;
    
    TimelineObject *sendMessageTimelineObject;
    
    NSMutableData *_responseData;
    
    NSMutableArray *cellTempArray;
}

@end

@implementation TimeLineViewController

static TimelineCell *curCell = nil;

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
    
    imgCh = [[RA_ImageCache alloc] init];
    
    cellTempArray = [[NSMutableArray alloc] init];
    
    expandedRow = -1;
    heightOfExpandedCell = -1;
    
    self.navigationItem.title = @"Timeline";
    topBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TopBarBG.png"]];
    
    [self.view addSubview:messageBGView];
    
    CGRect frame1 = messageBGView.frame;
    frame1.origin.y = -568;
    messageBGView.frame = frame1;
    
    shortMessageTextBoxView.layer.cornerRadius = 10.0f;
    messageBoxLowerContainerView.layer.cornerRadius = 10.0f;
    textViewContainerView.layer.cornerRadius = 10.0f;
    recipientImageView.layer.cornerRadius = 20.0f;
    messageTextView.text = kTextViewPlaceHolder;
    messageTextView.textColor = [UIColor lightGrayColor];
    
    messageBGView.alpha = 0;
    
    timeLineObjectArray = [[NSMutableArray alloc] init];
    cells = [[NSMutableArray alloc] init];
    
    [self getTimelineRequestCallWithMoreButton:NO];
    
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadControllerTimeline) name:kTimeLineViewControllerToFront object:nil];
    updateTimeLineObjectTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(updateTimelineObjectTime) userInfo:nil repeats:YES];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [containerTableView addSubview:refreshControl];
    
    clockSetupVC = [[ClockSetupViewController alloc] initWithNibName:@"ClockSetupViewController" bundle:nil];
    clockSetupVC.delegate = self;
    clockSetupVC.view.frame = CGRectMake(0, -568, 320, 568);
    [self.view addSubview:clockSetupVC.view];
    
    NSLog(@"kHeightOfScreen %d",kHeightOfScreen);
    
    fullScreenImageBGView.frame = CGRectMake(0, -568, 320, 568);
    fullScreenImageBGView.alpha = 0.0f;
    [self.view addSubview:fullScreenImageBGView];
    
    // Create the request.
    /*
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kGetTimeLineApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&start=%@",[NSString stringWithFormat:@"%d",timeLineCurrentIndex]];
    [urlStr appendFormat:@"&count=%@",[NSString stringWithFormat:@"%d",MAX_POST]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    // Create url connection and fire request
    [NSURLConnection connectionWithRequest:request delegate:self];
    */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAsColorTheme) name:kProfileUpdated object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = nil;
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError *jsonParsingError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&jsonParsingError];
    
    if (jsonParsingError)
    {
        NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
    }
    else
    {
        NSLog(@"OBJECT: %@", responseObject);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

-(void)refresh
{
    [self reloadControllerTimeline];
}

-(void)reloadControllerTimeline
{
    NSLog(@"kHeightOfScreen %d",kHeightOfScreen);
    
    [self backButtonPressedAction];
    [self getTimelineRequestCallWithMoreButton:NO];
}

-(void)getTimelineRequestCallWithMoreButton:(BOOL)callFromMoreButton
{
    if(callFromMoreButton)
    {
        timeLineCurrentIndex += MAX_POST - 1;
    }
    else
    {
        timeLineCurrentIndex = 0;
    }
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kGetTimeLineApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&start=%@",[NSString stringWithFormat:@"%d",timeLineCurrentIndex]];
    [urlStr appendFormat:@"&count=%@",[NSString stringWithFormat:@"%d",MAX_POST]];
    
    NSLog(@"getTimeLineUrl %@",urlStr);
    
    getTimelineRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    getTimelineRequest.delegate = self;
    [getTimelineRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == getTimelineRequest)
    {
        
        if(timeLineCurrentIndex == 0) [timeLineObjectArray removeAllObjects];
        
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@ %@ \nresponse %@",responseObject, error.description, request.responseString);
        
        NSArray *timeLineArray = [[responseObject objectForKey:@"body"] objectForKey:@"timeline"];
        
        showMoreButton = timeLineArray.count == MAX_POST ? YES : NO;
        
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            for(int i = 0; i < (timeLineArray.count - (showMoreButton ? 1 : 0)); i++)
            {
                NSDictionary *tmpDic = [timeLineArray objectAtIndex:i];
                
                TimelineObject *timeLineObject = [[TimelineObject alloc] init];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                df.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
                
                timeLineObject.postDate = [df dateFromString:[tmpDic objectForKey:@"dtime"]];
                
                timeLineObject.postHeader = [tmpDic objectForKey:@"header"];
                timeLineObject.postStatus = [tmpDic objectForKey:@"message"];
                timeLineObject.postPhotoId = [tmpDic objectForKey:@"phaid"];
                timeLineObject.postUserId = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"uid"]];
                timeLineObject.postUserPhotoId = [tmpDic objectForKey:@"uphoto"];
                
                NSMutableString *downloadImageUrlStr = [[NSMutableString alloc] init];
                [downloadImageUrlStr appendFormat:@"%@",@"http://1-dot-geometric-orbit-644.appspot.com/"];
                [downloadImageUrlStr appendFormat:@"%@?",kDownloadImageApi];
                
                [timeLineObjectArray addObject:timeLineObject];
            }
            
            [containerTableView reloadData];
        }
        else if([[responseObject objectForKey:@"status"] intValue] == 5 && responseObject)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid session" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        [refreshControl endRefreshing];
    }
    else if(request == sendMessageRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@ %@ \nresponse %@",responseObject, error.description, request.responseString);
        
        [UserDefaultsManager hideBusyScreenToView:messageBGView];
        [self popOutMessageBox];
        
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            
        }
        else
        {
            
        }
    }
}

-(void)updateTimelineObjectTime
{
    [containerTableView reloadData];
}

-(void)updateAsColorTheme
{
    [containerTableView reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [refreshControl endRefreshing];
    [UserDefaultsManager hideBusyScreenToView:messageBGView];
    [UserDefaultsManager hideBusyScreenToView:self.view];
    NSLog(@"%@",[request.error localizedDescription]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + (showMoreButton ? 1 : 0);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(timeLineObjectArray.count == 0)
        {
            containerTableView.backgroundColor = [UIColor lightGrayColor];
            containerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 1;
        }
        else
        {
            containerTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            containerTableView.backgroundColor = [UIColor whiteColor];
            return timeLineObjectArray.count;
        }
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(timeLineObjectArray.count == 0)
    {
        NSLog(@"in null cell");
        static NSString *cellId = @"nullCellId";
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 320, 0, 0);
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 380)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 4.0f;
        
        UIImageView *profilePicIcon = [[UIImageView alloc] initWithFrame:CGRectMake(150 - 53, 50, 105, 105)];
        profilePicIcon.layer.cornerRadius = 53;
        profilePicIcon.layer.masksToBounds = YES;
        profilePicIcon.contentMode = UIViewContentModeScaleAspectFit;
        if(![[UserDefaultsManager userProfilePicId] isEqualToString:@""])
        {
            NSMutableString *downloadImageUrlStr = [[NSMutableString alloc] init];
            [downloadImageUrlStr appendFormat:@"%@/",kRootUrl];
            [downloadImageUrlStr appendFormat:@"%@?",kDownloadImageApi];
            
            profilePicIcon.image = [imgCh getImage:[NSString stringWithFormat:@"%@imgid=%@",downloadImageUrlStr,[UserDefaultsManager userProfilePicId]]];
        }
        else
        {
            profilePicIcon.image = [UIImage imageNamed:@"ProPicUploadIcon.png"];
        }
        
        UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 300, 30)];
        welcomeLabel.text = @"Welcome to WakeUp";
        welcomeLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        
        UILabel *welcomeDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 260, 155)];
        welcomeDescriptionLabel.text = @"Currently you have no results in your timeline. Please check the other features from the left menu, build up your social network by adding more and more people. A lot more exciting features coming soon.";
        welcomeDescriptionLabel.numberOfLines = 0;
        welcomeDescriptionLabel.font = [UIFont systemFontOfSize:15.0f];
        
        [bgView addSubview:welcomeDescriptionLabel];
        [bgView addSubview:welcomeLabel];
        [bgView addSubview:profilePicIcon];
        [cell addSubview:bgView];
        
        return cell;
    }
    if(indexPath.section == 1 && showMoreButton)
    {
        static NSString *cellId = @"moreCellId";
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"More";
        return cell;
    }
    NSString *identifier = [NSString stringWithFormat:@"R%dS%d",indexPath.row,indexPath.section];
    
    TimelineObject *timeLineObject = [timeLineObjectArray objectAtIndex:indexPath.row];
    
    NSLog(@"%@ %d",timeLineObject.postStatus, indexPath.row);
    
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[TimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if(timeLineObject.postPhotoId)
        {
            [cell.uploadedPhotoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@", kRootUrl,timeLineObject.postPhotoId]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage.png"]];
            cell.isUploadedPhotoAvailable = YES;
            timeLineObject.postPhoto = cell.uploadedPhotoImageView.image;
        }
        else
        {
            cell.isUploadedPhotoAvailable = NO;
        }
        
        cell.delegate = self;
        
        if(indexPath.row % 2 == 0)
        {
            cell.userImageView.layer.borderColor = evenCellColor.CGColor;
            cell.usernameLabel.textColor = evenCellColor;
        }
        else
        {
            cell.userImageView.layer.borderColor = oddCellColor.CGColor;
            cell.usernameLabel.textColor = oddCellColor;
        }
        
        cell.timeLabel.text = [self getTimeIntervalOfPost:timeLineObject.postDate];
        if([timeLineObject.postUserId isEqualToString:[UserDefaultsManager UserId]])
        {
            cell.usernameLabel.text = @"Me";
            
            cell.userImageView.layer.borderColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]].CGColor;
            cell.usernameLabel.textColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]];
        }
        else
        {
            cell.usernameLabel.text = [[timeLineObject.postHeader componentsSeparatedByString:@" "] objectAtIndex:0];
        }
        
        cell.statusLabel.text = timeLineObject.postStatus;
        cell.indexPath = indexPath;
        
        if(expandedRow == indexPath.row)
        {
            cell.isCellExpanded = YES;
        }
        
        cell.userImageView.image = [UIImage imageNamed:@"ProPicUploadIcon.png"];
        if(timeLineObject.postUserPhotoId)
        {
            [cell.userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@",kRootUrl,timeLineObject.postUserPhotoId]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
        }
    }
    
    if([timeLineObject.postUserId isEqualToString:[UserDefaultsManager UserId]])
    {
        cell.isOwnPost = YES;
        
        cell.userImageView.layer.borderColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]].CGColor;
        cell.usernameLabel.textColor = [UserDefaultsManager getColorForTheme:[UserDefaultsManager userColorTheme]];
    }
    else
    {
        cell.isOwnPost = NO;
    }
    
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
    if(indexPath.section == 0)
    {
        if(timeLineObjectArray.count == 0)
        {
            return 400.0f;
        }
        
        if(indexPath.row == expandedRow)
        {
            return heightOfExpandedCell;
        }
        return 90;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 50;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(timeLineObjectArray.count == 0)
    {
        return;
    }
    
    if(indexPath.section == 1)
    {
        [self getTimelineRequestCallWithMoreButton:YES];
        return;
    }
    
    NSLog(@"didselectrow %d",indexPath.row);
    
    TimelineObject *timeLineObject = [timeLineObjectArray objectAtIndex:indexPath.row];
    
    TimelineCell *prevCell = (TimelineCell*)[cellTempArray lastObject];
    TimelineCell *cell = (TimelineCell*)[containerTableView cellForRowAtIndexPath:indexPath];
    [cellTempArray removeAllObjects];
    [cellTempArray addObject:cell];
    
    if(indexPath.row == expandedRow)
    {
        prevCell.isCellExpanded = NO;
        expandedRow = -1;
    }
    else
    {
        prevCell.isCellExpanded = NO;
        cell.isCellExpanded = YES;
        expandedRow = indexPath.row;
        
        if([timeLineObject.postUserId isEqualToString:[UserDefaultsManager UserId]])
        {
            cell.isOwnPost = YES;
        }
        else
        {
            cell.isOwnPost = NO;
        }
        
        if(cell.isUploadedPhotoAvailable)
        {
            heightOfExpandedCell = 300.0f;
        }
        else
        {
            heightOfExpandedCell = 130.0f;
        }
    }

    [containerTableView beginUpdates];
    [containerTableView endUpdates];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.drawerViewDelegate)
    {
        [self.drawerViewDelegate showDrawerView];
    }
}

-(IBAction)timeLineSwitchButtonAction:(UIButton*)sender
{
    
}

-(IBAction)alarmButtonAction:(UIButton*)sender
{
    
//  ****** this code is for bouncing animation to a view ********
//    [UIView animateWithDuration:0.5f
//                          delay:0
//         usingSpringWithDamping:0.5f
//          initialSpringVelocity:0.3f
//                        options:UIViewAnimationOptionTransitionNone animations:^{
//                            
//                        }
//                     completion:^(BOOL finished) {
//                         
//                     }];
    
    [UIView animateWithDuration:0.35f animations:^{
        clockSetupVC.view.frame = CGRectMake(0, 0, 320, 568);
    }completion:^(BOOL finished){
        if(finished)
        {
            
        }
    }];
}

-(void)backButtonPressedAction
{
    [UIView animateWithDuration:0.35f animations:^{
        clockSetupVC.view.frame = CGRectMake(0, -568, 320, 568);
    }];
}

-(IBAction)sendMessageButtonAction:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    if([messageTextView.text isEqualToString:@""] || [messageTextView.text isEqualToString:kTextViewPlaceHolder])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Can not send blank message"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [messageTextView resignFirstResponder];
    
    [UserDefaultsManager showBusyScreenToView:messageBGView WithLabel:@"Sending..."];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kSendMessgaeApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&uid=%@",sendMessageTimelineObject.postUserId];
    [urlStr appendFormat:@"&msg=%@",[messageTextView.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    NSLog(@"sendMessageUrl %@",urlStr);
    
    sendMessageRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    sendMessageRequest.delegate = self;
    [sendMessageRequest startAsynchronous];
}

#pragma mark Timeline Cell Delegate Methods

-(void)likeButtonActionWithIndex:(int)_index
{
    
}

-(void)sendGiftButtonActionWithIndex:(int)_index
{
    
}

-(void)messageButtonActionWithIndex:(int)_index
{
    [messageTextView becomeFirstResponder];
    
    TimelineObject *timeLineObject = [timeLineObjectArray objectAtIndex:_index];
    sendMessageTimelineObject = timeLineObject;
    
    [recipientImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@",kRootUrl,timeLineObject.postUserPhotoId]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
    recipientImageView.layer.cornerRadius = 20.0f;
    recipientImageView.layer.borderWidth = 2.0f;
    recipientImageView.layer.masksToBounds = YES;
    if(_index % 2 == 0)
    {
        recipientNameLabel.textColor = evenCellColor;
        recipientImageView.layer.borderColor = evenCellColor.CGColor;
    }
    else
    {
        recipientNameLabel.textColor = oddCellColor;
        recipientImageView.layer.borderColor = oddCellColor.CGColor;
    }
    
    recipientNameLabel.text = [[timeLineObject.postHeader componentsSeparatedByString:@" "] objectAtIndex:0];
    recipientModeLabel.text = @"Just Woken up!";
    recipientModeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.text = [self getTimeIntervalOfPost:timeLineObject.postDate];
    timeLabel.textColor = [UIColor lightGrayColor];
    characterCountLabel.text = @"0";
    characterCountLabel.textColor = [UIColor lightGrayColor];
    
    CGRect frame1 = messageBGView.frame;
    frame1.origin.y = 0;
    messageBGView.frame = frame1;
    
    if(kIsThreePointFiveInch)
    {
        CGRect frame2 = shortMessageTextBoxView.frame;
        frame2.origin.y = 66;
        shortMessageTextBoxView.frame = frame2;
    }
    
    [UIView animateWithDuration:0.35f animations:^{
        messageBGView.alpha = 1;
    }];
}

-(void)popOutMessageBox
{
    [messageTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.35f animations:^{
        messageBGView.alpha = 0;
    }completion:^(BOOL finished){
        if(finished)
        {
            CGRect frame1 = messageBGView.frame;
            frame1.origin.y = -568;
            messageBGView.frame = frame1;
        }
    }];
    
    recipientNameLabel.text = @"";
    recipientModeLabel.text = @"";
    timeLabel.text = @"";
    characterCountLabel.text = @"0";
    messageTextView.text = @"";
}

-(void)seeFullPictureButtonActionWithIndex:(int)_index
{
    TimelineObject *timeLineObject = [timeLineObjectArray objectAtIndex:_index];
    
    [fullScreenImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@", kRootUrl,timeLineObject.postPhotoId]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage.png"]];
    
    CGRect frame1 = fullScreenImageBGView.frame;
    frame1.origin.y = 0;
    fullScreenImageBGView.frame = frame1;
    
    if(kIsThreePointFiveInch)
    {
        CGRect frame2 = fullScreenImageView.frame;
        frame2.size.height = 440;
        fullScreenImageView.frame = frame2;
    }
    
    [UIView animateWithDuration:0.35f animations:^{
        fullScreenImageBGView.alpha = 1;
    }];
}

#pragma mark Textview Delegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:kTextViewPlaceHolder])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        textView.text = kTextViewPlaceHolder;
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if([str length] > 125)
    {
        return NO;
    }
    if(![textView.text isEqualToString:kTextViewPlaceHolder])
    {
        characterCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[str length]];
    }
    return YES;
}

-(IBAction)shortMessageBoxBGTap:(UIControl*)sender
{
    [self popOutMessageBox];
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

-(IBAction)dismissFullScreenImage:(id)sender
{
    [UIView animateWithDuration:0.35f animations:^{
        fullScreenImageBGView.alpha = 0;
    }completion:^(BOOL finished){
        if(finished)
        {
            CGRect frame1 = fullScreenImageBGView.frame;
            frame1.origin.y = -568;
            fullScreenImageBGView.frame = frame1;
        }
    }];
}

@end
