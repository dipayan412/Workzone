//
//  UserFeedbackViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/21/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "UserFeedbackViewController.h"

@interface UserFeedbackViewController () <UITextViewDelegate>
{
    UITextView *contentTextView;
}

@end

@implementation UserFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithRed:237.0f/255 green:237.0f/255 blue:237.0f/255 alpha:1.0f];
    
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 60);
    [backButton setTitle:NSLocalizedString(kFeedbackCancelButton, nil) forState:UIControlStateNormal];
    [backButton setTitleColor:themeColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 80, 60);
    [postButton setTitleColor:themeColor forState:UIControlStateNormal];
    [postButton setTitle:NSLocalizedString(kFeedbackSubmitButton, nil) forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:postButton];
    [self.view addSubview:customNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backButton.frame.size.width, 0, [UIScreen mainScreen].bounds.size.width - postButton.frame.size.width * 2, customNavigationBar.frame.size.height)];
    titleLabel.text = @"Feedback";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [customNavigationBar addSubview:separatorLine];
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, 100)];
    [headerTitle setTextAlignment:NSTextAlignmentCenter];
    headerTitle.numberOfLines = 3;
    headerTitle.font = [UIFont systemFontOfSize:15.0f];
    headerTitle.text = @"Your feedback is important to us.\nPlease help us improve your experience by\nsharing comments and suggestions";
    [self.view addSubview:headerTitle];
    
    UILabel *commentsTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, headerTitle.frame.origin.y + headerTitle.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width, 20)];
    commentsTitle.font = [UIFont systemFontOfSize:15.0f];
    commentsTitle.text = @"COMMENTS";
    commentsTitle.textColor = [UIColor lightGrayColor];
    [self.view addSubview:commentsTitle];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, commentsTitle.frame.origin.y + commentsTitle.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
    contentTextView.text = NSLocalizedString(kFeedbackContentPlaceholder, nil);
    contentTextView.textColor = [UIColor lightGrayColor];
    contentTextView.delegate = self;
    [self.view addSubview:contentTextView];
}

-(void)postButtonAction
{
    if([contentTextView.text isEqualToString:@""] || [contentTextView.text isEqualToString:NSLocalizedString(kFeedbackContentPlaceholder, nil)])
    {
        [contentTextView resignFirstResponder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(kFeedbackAlertMessage, nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(kFeedbackAlertDismiss, nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:dismiss];

        [self presentViewController:alertController animated:YES completion:^{

            return;
        }];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(kFeedbackFeedbackLoading, nil);
        
        [self insertFeedbackToServer];
    }
    
}

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:NSLocalizedString(kFeedbackContentPlaceholder, nil)])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        textView.text = NSLocalizedString(kFeedbackContentPlaceholder, nil);
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)insertFeedbackToServer
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:insertUserFeedback];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSMutableDictionary *queryDictionary = [[NSMutableDictionary alloc] init];
    
    [queryDictionary setObject:[UserDefaultsManager getUserId] forKey:@"USR_ID"];
    [queryDictionary setObject:contentTextView.text forKey:@"CONTENT"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"insertFeedback %@", dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self backButtonAction];
                });
            }
            else
            {
                NSLog(@"%@",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    }];
    [dataTask resume];
}

@end
