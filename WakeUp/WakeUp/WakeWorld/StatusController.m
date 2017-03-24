//
//  StatusController.m
//  WakeUp
//
//  Created by World on 8/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "StatusController.h"

#define kTexviewPlaceholder @"Share your thoughts..."

typedef enum{
    kHappyMood = 1,
    kSadMood,
    kConfusedMood,
    kTiredMood,
    kChillMood,
    kThumbsUpMood,
    kThumbsDownMood
}emoticonButton;

@interface StatusController ()
{
    ASIHTTPRequest *statusRequest;
}

@end

@implementation StatusController

@synthesize delegate;
@synthesize attachedImage;
@synthesize attachedImageId;

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
    
    if(self.attachedImage)
    {
        statusImageView.image = self.attachedImage;
    }
    
    statusTextView.text = kTexviewPlaceholder;
    statusTextView.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)smilyButtonPressd:(id)sender
{
    UIButton *btn = (UIButton*)sender;
}

-(IBAction)updateStatusButtonPressed:(id)sender
{
    if(statusTextView.text.length < 1)
    {
        return;
    }
    
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Status updating"];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kAddWakeUpApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    if(![statusTextView.text isEqualToString:kTexviewPlaceholder])
    {
        [urlStr appendFormat:@"&msg=%@",[statusTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if(self.attachedImageId.length > 0)
    {
        [urlStr appendFormat:@"&patt=%@",self.attachedImageId];
    }
    
    NSLog(@"statusRqstUrl %@",urlStr);
    
    statusRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    statusRequest.delegate = self;
    [statusRequest startAsynchronous];
}

-(IBAction)statusBGAction:(UIControl*)sender
{
    if(self.delegate)
    {
        [self.delegate dismissStatusViewController:self];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:kTexviewPlaceholder])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    if(kIsThreePointFiveInch)
    {
        [self commitAnimationsToViewFrameWithYValue:-200];
    }
    else
    {
        [self commitAnimationsToViewFrameWithYValue:-100];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        textView.text = kTexviewPlaceholder;
        textView.textColor = [UIColor lightGrayColor];
    }
    
    if(kIsThreePointFiveInch)
    {
        [self commitAnimationsToViewFrameWithYValue:200];
    }
    else
    {
        [self commitAnimationsToViewFrameWithYValue:100];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [statusTextView resignFirstResponder];
        return NO;
    }
    
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if([str length] > 50)
    {
        return NO;
    }
    if(![textView.text isEqualToString:kTexviewPlaceholder])
    {
        textCounterLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[str length]];
    }
    
    return YES;
}

-(void)commitAnimationsToViewFrameWithYValue:(int)_value
{
    [UIView animateWithDuration:0.35f animations:^{
        CGRect frame = statusContainerView.frame;
        frame.origin.y += _value;
        statusContainerView.frame = frame;
    }];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"%@ %@ \n %@",responseObject, error.description, request.responseString);
    
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    if(self.delegate)
    {
        [self.delegate dismissStatusViewController:self];
    }
    
    if([[responseObject objectForKey:@"status"] intValue] == 0)
    {
        statusTextView.text = kTexviewPlaceholder;
        statusTextView.textColor = [UIColor lightGrayColor];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Status published successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [UserDefaultsManager hideBusyScreenToView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

@end
