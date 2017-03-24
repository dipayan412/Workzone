//
//  YoutubeLoginViewController.m
//  SocialShare
//
//  Created by Ashif on 2/20/14.
//  Copyright (c) 2014 algonyx. All rights reserved.
//

#import "YoutubeLoginViewController.h"
#import "GDataServiceGoogleYouTube.h"
#import "GDataEntryYouTubeUpload.h"

#define DEVELOPER_KEY @"AI39si6kqeuHgYTFQ7KeHoQVNuLggDiadTT8B_4J5juUeqw9VJTcRSNGRhbz5RwNE8eJAA9k2he701FvyZVKJ6iXtOH7W7INUw"

@interface YoutubeLoginViewController ()

- (GDataServiceTicket *)uploadTicket;
- (void)setUploadTicket:(GDataServiceTicket *)ticket;
- (GDataServiceGoogleYouTube *)youTubeService;

@end

@implementation YoutubeLoginViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)cancelButtonPressed:(id)sender
{
    if(delegate)
    {
        [delegate dismissYoutubeShareView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(IBAction)shareToYoutube
{
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    if(userNameField.text.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter Username" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(passwordField.text.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if([self login:userNameField.text password:passwordField.text])
    {
        GDataServiceGoogleYouTube* service = [self youTubeService];

        NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:kGDataServiceDefaultUser];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"YouTubeTest" ofType:@"m4v"];
        NSURL *urlToVideoFile = [[NSURL alloc] initFileURLWithPath:path isDirectory:NO];
        
        NSLog(@"urlToVideoFile %@", urlToVideoFile);
        
        //    NSData *data = [NSData dataWithContentsOfFile:self.videoPath];
        NSData *data = [NSData dataWithContentsOfURL:urlToVideoFile];
        
        NSString *filename = @"My Cool Video";
        NSString *titleStr = @"Title";
        GDataMediaTitle *mediaTitle = [GDataMediaTitle textConstructWithString:titleStr];
        
        NSString *categoryStr = @"Comedy";
        GDataMediaCategory *mediaCategory = [GDataMediaCategory mediaCategoryWithString:categoryStr];
        [mediaCategory setScheme:kGDataSchemeYouTubeCategory];
        
        NSString *descStr = @"Description";
        GDataMediaDescription *mediaDesc = [GDataMediaDescription textConstructWithString:descStr];
        
        NSString *keywordsStr = @"iOS";
        GDataMediaKeywords *mediaKeywords = [GDataMediaKeywords keywordsWithString:keywordsStr];
        
        GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
        [mediaGroup setMediaTitle:mediaTitle];
        [mediaGroup setMediaDescription:mediaDesc];
        [mediaGroup addMediaCategory:mediaCategory];
        [mediaGroup setMediaKeywords:mediaKeywords];
        [mediaGroup setIsPrivate:NO];
        
        NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:path
                                                   defaultMIMEType:@"video/mp4"];
        
        GDataEntryYouTubeUpload *entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                                                       data:data
                                                                                   MIMEType:mimeType
                                                                                       slug:filename];
        
        SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
        [service setServiceUploadProgressSelector:progressSel];
        
        GDataServiceTicket *ticket = [service fetchEntryByInsertingEntry:entry
                                                              forFeedURL:url
                                                                delegate:self
                                                       didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
        [self setUploadTicket:ticket];
        
//        CGRect frame = videoUploadView.frame;
//        frame.origin = CGPointMake(0, 0);
//        videoUploadView.frame = frame;
//        [self.view addSubview:videoUploadView];
//        
//        [videoUploadProgressView setProgress: 0.0];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong user id or password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark -


// get a YouTube service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleYouTube *)youTubeService
{
    static GDataServiceGoogleYouTube* service = nil;
    
    if (!service)
    {
        service = [[GDataServiceGoogleYouTube alloc] init];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    // update the username/password each time the service is requested
    
    NSString *username = userNameField.text;
    NSString *password = passwordField.text;
    
    if ([username length] > 0 && [password length] > 0)
    {
        [service setUserCredentialsWithUsername:userNameField.text
                                       password:passwordField.text];
    }
    else
    {
        // fetch unauthenticated
        NSLog(@"error, no user name or password");
        [service setUserCredentialsWithUsername:nil
                                       password:nil];
    }
    
    NSString *devKey = DEVELOPER_KEY;
    [service setYouTubeDeveloperKey:devKey];
    
    return service;
}

// progress callback
- (void)ticket:(GDataServiceTicket *)ticket
hasDeliveredByteCount:(unsigned long long)numberOfBytesRead
ofTotalByteCount:(unsigned long long)dataLength
{
    NSLog(@"%f",(double)numberOfBytesRead/ (double)dataLength);
    [videoUploadProgressView setProgress:(double)numberOfBytesRead / (double)dataLength];
}

// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error
{
    if (error == nil)
    {
        // tell the user that the add worked
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uploaded!"
                                                        message:[NSString stringWithFormat:@"%@ succesfully uploaded",
                                                                 [[videoEntry title] stringValue]]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:[NSString stringWithFormat:@"Error: %@",
                                                                 [error description]]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        NSLog(@"%@", [error description]);
        
        [alert show];
    }
    
//    [videoUploadView removeFromSuperview];
//    [videoUploadProgressView setProgress: 0.0];
    [self setUploadTicket:nil];
}

#pragma mark -
#pragma mark Setters

- (GDataServiceTicket *)uploadTicket
{
    return mUploadTicket;
}

- (void)setUploadTicket:(GDataServiceTicket *)ticket
{
    mUploadTicket = nil;
    mUploadTicket = ticket;
}

- (BOOL)login:(NSString *)strusername password:(NSString *)strpassword
{
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"https://www.google.com/accounts/ClientLogin"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"Email=%@&Passwd=%@&service=youtube&source=&continue=http://www.google.com/",strusername,strpassword];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    //    [params release];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    [request setTimeoutInterval:120];
    NSData *replyData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *replyString = [[NSString alloc] initWithData:replyData encoding:NSUTF8StringEncoding];
    if([replyString rangeOfString:@"Auth="].location!=NSNotFound)
    {
        NSString *authToken=[[replyString componentsSeparatedByString:@"Auth="] objectAtIndex:1];
        NSLog(@"Auth : %@",authToken);
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(delegate)
    {
        [delegate dismissYoutubeShareView];
    }
}

@end
