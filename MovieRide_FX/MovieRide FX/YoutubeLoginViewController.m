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

// Developer Key
// To get your developer key go to: http://code.google.com/apis/youtube/dashboard/gwt/index.html#newProduct


#define DEVELOPER_KEY @"AI39si6kqeuHgYTFQ7KeHoQVNuLggDiadTT8B_4J5juUeqw9VJTcRSNGRhbz5RwNE8eJAA9k2he701FvyZVKJ6iXtOH7W7INUw"

@interface YoutubeLoginViewController ()

- (GDataServiceTicket *)uploadTicket;
- (void)setUploadTicket:(GDataServiceTicket *)ticket;
- (GDataServiceGoogleYouTube *)youTubeService;

@end

@implementation YoutubeLoginViewController

@synthesize delegate;
@synthesize filePath;

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
}

-(void)cancelButtonPressed:(id)sender
{
    [youtubeUploadTicket cancelTicket];
    
    [self setUploadTicket:nil];
    
    if(delegate)
    {
        // call delegate to dismiss the view
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
        
        NSLog(@"filePath %@", self.filePath);
        
        NSArray *array = [self.filePath componentsSeparatedByString:@"/"];
        NSLog(@"array %@", array);
        NSString *video = [array lastObject];
        NSString *videoName = [video stringByDeletingPathExtension];
        array = [videoName componentsSeparatedByString:@"_"];
        NSString *fileName = [array objectAtIndex:0];

        NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:kGDataServiceDefaultUser];
        
        NSURL *urlToVideoFile = [[NSURL alloc] initFileURLWithPath:self.filePath isDirectory:NO];
        
//        NSLog(@"urlToVideoFile %@", urlToVideoFile);
        
        NSData *data = [NSData dataWithContentsOfURL:urlToVideoFile];
        
        // need to include the below data.
        
        NSString *filename = fileName;
        NSString *titleStr = videoName;
        GDataMediaTitle *mediaTitle = [GDataMediaTitle textConstructWithString:titleStr];
        
        NSString *categoryStr = @"Entertainment";
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
        
        NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:self.filePath
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
        
        // setting up the progress view
        
//        CGRect frame = videoUploadView.frame;
//        frame.origin = CGPointMake(0, 0);
//        videoUploadView.frame = frame;
        [self.view addSubview:videoUploadView];
        
        [videoUploadProgressView setProgress: 0.0];
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
                                                        message:[NSString stringWithFormat:@"%@ successfully uploaded",
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
    
    // remove the progress view
    
    [videoUploadView removeFromSuperview];
    [videoUploadProgressView setProgress: 0.0];
    
    [self setUploadTicket:nil];
}

#pragma mark -
#pragma mark Setters

- (GDataServiceTicket *)uploadTicket
{
    return youtubeUploadTicket;
}

- (void)setUploadTicket:(GDataServiceTicket *)ticket
{
    youtubeUploadTicket = nil;
    youtubeUploadTicket = ticket;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if (touch.view != userNameField || touch.view != passwordField)
    {
        [userNameField resignFirstResponder];
        [passwordField resignFirstResponder];
    }
}

@end
