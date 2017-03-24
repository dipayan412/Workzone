//
//  SendMessageViewController.m
//  WakeUp
//
//  Created by World on 8/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SendMessageViewController.h"

#define kTextViewPlaceHolder    @"Write a message..."

@interface SendMessageViewController ()
{
    ASIHTTPRequest *sendMessageRequest;
}

@end

@implementation SendMessageViewController

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
    
    shortMessageTextBoxView.layer.cornerRadius = 10.0f;
    messageBoxLowerContainerView.layer.cornerRadius = 10.0f;
    textViewContainerView.layer.cornerRadius = 10.0f;
    recipientImageView.layer.cornerRadius = 20.0f;
    messageTextView.text = kTextViewPlaceHolder;
    messageTextView.textColor = [UIColor lightGrayColor];
    
    messageBGView.alpha = 0;
    
    [recipientImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@downloadimage?imgid=%@",kRootUrl,self.contactObject.uphotoId]] placeholderImage:[UIImage imageNamed:@"ProPicUploadIcon.png"]];
    recipientImageView.layer.cornerRadius = 20.0f;
    recipientImageView.layer.borderWidth = 2.0f;
    recipientImageView.layer.masksToBounds = YES;
    recipientNameLabel.textColor = evenCellColor;
    recipientImageView.layer.borderColor = evenCellColor.CGColor;
    
    recipientNameLabel.text = self.contactObject.givenName;
    characterCountLabel.text = @"0";
    characterCountLabel.textColor = [UIColor lightGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadControllerMessageView) name:kShortTextMessageViewComToFront object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)reloadControllerMessageView
{
    if(kIsThreePointFiveInch)
    {
        CGRect frame2 = shortMessageTextBoxView.frame;
        frame2.origin.y -= 100;
        shortMessageTextBoxView.frame = frame2;
    }
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
    if(self.delegate)
    {
        [self.delegate dismissMessageView];
    }
    
    recipientNameLabel.text = @"";
    characterCountLabel.text = @"0";
    messageTextView.text = @"";
}

#pragma mark AsiHttpRequest Delegate Methods

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == sendMessageRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@ %@ \nresponse %@",responseObject, error.description, request.responseString);
        
        if(self.delegate)
        {
            [self.delegate dismissMessageView];
        }
        
        [UserDefaultsManager hideBusyScreenToView:messageBGView];
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            
        }
        else
        {
            
        }
    }
    
    recipientNameLabel.text = @"";
    characterCountLabel.text = @"0";
    messageTextView.text = @"";
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [UserDefaultsManager hideBusyScreenToView:messageBGView];
    NSLog(@"%@",[request.error localizedDescription]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

#pragma mark textView Delegate Methods

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
