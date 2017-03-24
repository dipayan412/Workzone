//
//  CreatePromoViewController.m
//  iOS Prototype
//
//  Created by World on 3/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "CreatePromoViewController.h"
#import "inputTextCell.h"
#import "CreateStoreTopCell.h"

#define kTextViewPlaceholder @"Enter product description"

@interface CreatePromoViewController () <ASIHTTPRequestDelegate>
{
    CreateStoreTopCell *topCell;
    
    inputTextCell *titleCell;
    inputTextCell *typeCell;
    inputTextCell *passesCell;
    inputTextCell *whenCell;
    inputTextCell *descriptionCell;
    
    UIAlertView *loadingAlert;
}
@property (nonatomic, retain) ASIHTTPRequest *createPromoRequest;

@end

@implementation CreatePromoViewController

@synthesize createPromoRequest;
@synthesize shopObject;

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
    
    self.navigationItem.title = @"NEW PROMO";
    
    [self cellConfiguration];
    
    formTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CreatePromoBG.png"]];
    promoImageView.image = [UIImage imageNamed:@"ProPicIcon.png"];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
    gestureRecognizer.delegate = self;
    [formTableView addGestureRecognizer:gestureRecognizer];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    formTableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark tableView delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return topCell;
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                return titleCell;
                
            case 1:
                return typeCell;
                
            case 2:
                return passesCell;
                
            case 3:
                return whenCell;
                
            case 4:
                return descriptionCell;
                
            default:
                break;
        }
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 120.0f;
    }
    else
    {
        if(indexPath.row == 4)
        {
            return 120.0f;
        }
    }
    return 44.0f;
}

-(void)cellConfiguration
{
    topCell = [[CreateStoreTopCell alloc] init];
    
    titleCell = [[inputTextCell alloc] initWithIsDescription:NO];
    titleCell.fieldTitleLabel.text = @"Title";
    titleCell.inputField.placeholder = @"Title of the product";
    titleCell.inputField.delegate = self;
    titleCell.inputField.tag = 0;
    titleCell.inputField.returnKeyType = UIReturnKeyNext;
    
    typeCell = [[inputTextCell alloc] initWithIsDescription:NO];
    typeCell.fieldTitleLabel.text = @"Type";
    typeCell.inputField.placeholder = @"Type of Offer";
    typeCell.inputField.delegate = self;
    typeCell.inputField.tag = 1;
    typeCell.inputField.returnKeyType = UIReturnKeyNext;
    
    passesCell = [[inputTextCell alloc] initWithIsDescription:NO];
    passesCell.fieldTitleLabel.text = @"Passes";
    passesCell.inputField.placeholder = @"Enter passes";
    passesCell.inputField.delegate = self;
    passesCell.inputField.tag = 2;
    passesCell.inputField.returnKeyType = UIReturnKeyNext;
    
    whenCell = [[inputTextCell alloc] initWithIsDescription:NO];
    whenCell.fieldTitleLabel.text = @"When";
    whenCell.inputField.placeholder = @"Timimg of the offer";
    whenCell.inputField.delegate = self;
    whenCell.inputField.tag = 3;
    whenCell.inputField.returnKeyType = UIReturnKeyNext;
    
    descriptionCell = [[inputTextCell alloc] initWithIsDescription:YES];
    descriptionCell.fieldTitleLabel.text = @"Description";
    descriptionCell.inputField.placeholder = @"Product details";
    descriptionCell.inputTextView.delegate = self;
    descriptionCell.inputTextView.returnKeyType = UIReturnKeyDone;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        if([UIScreen mainScreen].bounds.size.height < 568)
        {
            [self commitAnimations:-30];
        }
        else
        {
            [self commitAnimations:0];
        }
    }
    if(textField.tag == 2)
    {
        if([UIScreen mainScreen].bounds.size.height <= 568)
        {
            [self commitAnimations:-60];
        }
        else
        {
            [self commitAnimations:0];
        }
    }
    if(textField.tag == 3)
    {
        if([UIScreen mainScreen].bounds.size.height <= 568)
        {
            [self commitAnimations:-120];
        }
        else
        {
            [self commitAnimations:0];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self commitAnimations:64];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 0)
    {
        [typeCell.inputField becomeFirstResponder];
    }
    else if(textField.tag == 1)
    {
        [passesCell.inputField becomeFirstResponder];
    }
    else if(textField.tag == 2)
    {
        [whenCell.inputField becomeFirstResponder];
    }
    else if(textField.tag == 3)
    {
        [descriptionCell.inputTextView becomeFirstResponder];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [formTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:kTextViewPlaceholder])
    {
        textView.text = @"";
    }
    
    if([UIScreen mainScreen].bounds.size.height <= 568)
    {
        [self commitAnimations:-120];
    }
    else
    {
        [self commitAnimations:0];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        textView.text = kTextViewPlaceholder;
    }
    [self commitAnimations:64];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [self locatePromoAction];
        return NO;
    }
    return YES;
}

-(void)commitAnimations:(int)y
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect frame = self.view.frame;
    frame.origin.y = y;
    self.view.frame = frame;
    [UIView commitAnimations];
}

-(IBAction)promeImageButtonAction:(UIButton*)btn
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    promoImageView.image = img;
}

-(IBAction)locatePromoButtonAction:(UIButton*)btn
{
    [self locatePromoAction];
}

-(void)locatePromoAction
{
    [titleCell.inputField resignFirstResponder];
    [typeCell.inputField resignFirstResponder];
    [passesCell.inputField resignFirstResponder];
    [whenCell.inputField resignFirstResponder];
    [descriptionCell resignFirstResponder];
    
    if([titleCell.inputField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter a title of the promo"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if([descriptionCell.inputTextView.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please give a description of the promo"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    
    [urlStr appendFormat:@"%@", baseUrl];
    [urlStr appendFormat:@"%@", createPromoApi];
    [urlStr appendFormat:@"%@/", [UserDefaultsManager sessionToken]];
    [urlStr appendFormat:@"%@", shopObject.shopId];
    
    if(![titleCell.inputField.text isEqualToString:@""])
    {
        [urlStr appendFormat:@"/%@/", titleCell.inputField.text];//[titleCell.inputField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if(![descriptionCell.inputTextView.text isEqualToString:@""])
    {
        [urlStr appendFormat:@"%@", descriptionCell.inputTextView.text];//[descriptionCell.inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    urlStr = (NSMutableString*)[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url %@",urlStr);
    self.createPromoRequest = [ASIHTTPRequest requestWithURL:url];
    self.createPromoRequest.delegate = self;
    [self.createPromoRequest startAsynchronous];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"%@",request.responseString);
    if([responseObject objectForKey:@"status"] != nil)
    {
        if([[responseObject objectForKey:@"status"] intValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:[responseObject objectForKey:@"message"]
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[responseObject objectForKey:@"message"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Something went wrong. Try again later"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:[request.error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)bgTap:(id)sender
{
    [self commitAnimations:64];
    [self.view endEditing:YES];
}

@end
