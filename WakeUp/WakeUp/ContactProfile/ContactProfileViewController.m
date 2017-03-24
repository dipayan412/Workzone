//
//  ContactProfileViewController.m
//  WakeUp
//
//  Created by World on 8/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ContactProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kTextViewPlaceHolder    @"Write a comment..."

@interface ContactProfileViewController () <UITextViewDelegate, ASIHTTPRequestDelegate>
{
    ASIHTTPRequest *sendMessageRequest;
}

@end

@implementation ContactProfileViewController

@synthesize delegate;
@synthesize contactObject;

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
    
//    [self.view addSubview:messageBGView];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadControllerProfile) name:kContactProfileViewControllerToFront object:nil];
    
    sendMessageVC = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    sendMessageVC.delegate = self;
    sendMessageVC.view.frame = CGRectMake(0, -568, 320, 568);
    [self.view addSubview:sendMessageVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)reloadControllerProfile
{
    contactNameLabel.text = self.contactObject.givenName;
    [contactImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@",kRootUrl,self.contactObject.uphotoId]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
}

-(IBAction)sendGiftButtonAction:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This feature will be added in later versions" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(IBAction)sendMessageButtonAction:(UIButton*)sender
{
//    [messageTextView becomeFirstResponder];
//    
//    [recipientImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@",kRootUrl,self.contactObject.uphotoId]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
//    recipientImageView.layer.cornerRadius = 20.0f;
//    recipientImageView.layer.borderWidth = 2.0f;
//    recipientImageView.layer.masksToBounds = YES;
//    recipientNameLabel.textColor = evenCellColor;
//    recipientImageView.layer.borderColor = evenCellColor.CGColor;
//    
//    recipientNameLabel.text = self.contactObject.givenName;
//    characterCountLabel.text = @"0";
//    characterCountLabel.textColor = [UIColor lightGrayColor];
//    
//    CGRect frame1 = messageBGView.frame;
//    frame1.origin.y = 0;
//    messageBGView.frame = frame1;
//    
//    if(kIsThreePointFiveInch)
//    {
//        CGRect frame2 = shortMessageTextBoxView.frame;
//        frame2.origin.y -= 100;
//        shortMessageTextBoxView.frame = frame2;
//    }
//    
//    [UIView animateWithDuration:0.35f animations:^{
//        messageBGView.alpha = 1;
//    }];
    
    sendMessageVC.view.frame = CGRectMake(0, 0, 320, 568);
    
    [UIView animateWithDuration:0.35f animations:^{
        sendMessageVC.view.alpha = 1.0f;
    }completion:^(BOOL finished){
        if(finished)
        {
            
        }
    }];
}

-(void)dismissMessageView
{
    [UIView animateWithDuration:0.35f animations:^{
        sendMessageVC.view.alpha = 0.0f;
    }completion:^(BOOL finished){
        if(finished)
        {
            sendMessageVC.view.frame = CGRectMake(0, -568, 320, 568);
        }
    }];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.delegate)
    {
        [self.delegate showContactViewController];
    }
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
    characterCountLabel.text = @"0";
    messageTextView.text = @"";
}

-(IBAction)sendShortMessageButtonAction:(UIButton*)sender
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
    
    [UserDefaultsManager showBusyScreenToView:messageBGView WithLabel:@"Sending..."];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kSendMessgaeApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&uid=%@",self.contactObject.uid];
    [urlStr appendFormat:@"&msg=%@",[messageTextView.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    NSLog(@"sendMessageUrl %@",urlStr);
    
    sendMessageRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    sendMessageRequest.delegate = self;
    [sendMessageRequest startAsynchronous];
}

-(IBAction)shortMessageBoxBGTap:(UIControl*)sender
{
    [self popOutMessageBox];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == sendMessageRequest)
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

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [UserDefaultsManager hideBusyScreenToView:messageBGView];
    NSLog(@"%@",[request.error localizedDescription]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

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


@end
