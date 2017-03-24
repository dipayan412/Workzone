//
//  ReviewDetailViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/19/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ReviewDetailViewController.h"

@interface ReviewDetailViewController () <UITextViewDelegate, UITextFieldDelegate>
{
    UITextView *contentTextView;
    UITextField *durationTextField;
    UITextField *conditionTextField;
    UITextField *ratingTextField;
    UIImageView *hideIdentityImageView;
    UIButton *postButton;
    
    BOOL isAnonymus;
    
    NSString *productId;
}

@end

@implementation ReviewDetailViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ProductId:(NSString*)_productId
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nil]))
    {
        productId = _productId;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    isAnonymus = NO;
    
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 60);
    [backButton setTitle:NSLocalizedString(kPostReviewBackButton, nil) forState:UIControlStateNormal];
    [backButton setTitleColor:themeColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    
    postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 80, 60);
    [postButton setTitleColor:themeColor forState:UIControlStateNormal];
    [postButton setTitle:NSLocalizedString(kPostReviewSubmitButton, nil) forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:postButton];
    [self.view addSubview:customNavigationBar];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [customNavigationBar addSubview:separatorLine];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, customNavigationBar.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height/4)];
    contentTextView.text = NSLocalizedString(kPostReviewContentPlaceholder, nil);
    contentTextView.textColor = [UIColor lightGrayColor];
    contentTextView.delegate = self;
    contentTextView.layer.borderWidth = 0.5f;
    contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentTextView.layer.cornerRadius = 5.0f;
    [self.view addSubview:contentTextView];
    
    durationTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, contentTextView.frame.origin.y + contentTextView.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width - 10, 40)];
    durationTextField.placeholder = NSLocalizedString(kPostReviewDurationPlaceholder, nil);
    durationTextField.font = contentTextView.font;
    durationTextField.layer.borderWidth = 0.5f;
    durationTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    durationTextField.layer.cornerRadius = 5.0f;
    [self.view addSubview:durationTextField];
    
    conditionTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, durationTextField.frame.origin.y + durationTextField.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width - 10, 40)];
    conditionTextField.placeholder = NSLocalizedString(kPostReviewConditionPlaceholder, nil);
    conditionTextField.font = contentTextView.font;
    conditionTextField.layer.borderWidth = 0.5f;
    conditionTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    conditionTextField.layer.cornerRadius = 5.0f;
    [self.view addSubview:conditionTextField];
    
    ratingTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, conditionTextField.frame.origin.y + conditionTextField.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width/2 - 10, 40)];
    ratingTextField.placeholder = NSLocalizedString(kPostReviewRatingPlaceholder, nil);
    ratingTextField.font = contentTextView.font;
    ratingTextField.keyboardType = UIKeyboardTypeDecimalPad;
    ratingTextField.layer.borderWidth = 0.5f;
    ratingTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ratingTextField.layer.cornerRadius = 5.0f;
    ratingTextField.delegate = self;
    [self.view addSubview:ratingTextField];
    
    UIControl *hideIdentityControl = [[UIControl alloc] initWithFrame:CGRectMake(ratingTextField.frame.origin.x + ratingTextField.frame.size.width + 15, conditionTextField.frame.origin.y + conditionTextField.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width/2 - 10, 40)];
    hideIdentityControl.backgroundColor = [UIColor clearColor];
    [hideIdentityControl addTarget:self action:@selector(hideIdentityControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideIdentityControl];
    
    hideIdentityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, hideIdentityControl.frame.size.height/2 - 11, 22, 22)];
    hideIdentityImageView.image = [UIImage imageNamed:@"checkBox_deSelected.png"];
    hideIdentityImageView.contentMode = UIViewContentModeScaleAspectFit;
    hideIdentityImageView.backgroundColor = [UIColor clearColor];
    [hideIdentityControl addSubview:hideIdentityImageView];
    
    UILabel *hideIdentityLabel = [[UILabel alloc] initWithFrame:CGRectMake(hideIdentityImageView.frame.size.width + 5,0,hideIdentityControl.frame.size.width - 20, hideIdentityControl.frame.size.height)];
    hideIdentityLabel.text = NSLocalizedString(kPostReviewAnonymus, nil);
    hideIdentityLabel.minimumScaleFactor = 0.5f;
    hideIdentityLabel.adjustsFontSizeToFitWidth = YES;
    [hideIdentityControl addSubview:hideIdentityLabel];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:NSLocalizedString(kPostReviewContentPlaceholder, nil)])
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
        textView.text = NSLocalizedString(kPostReviewContentPlaceholder, nil);
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == ratingTextField)
    {
        if([textField.text isEqualToString:@""])
        {
            
        }
        else if([textField.text intValue] > 5)
        {
            textField.text = @"5";
        }
        else if([textField.text intValue] < 1)
        {
            textField.text = @"1";
        }
    }
    return YES;
}

-(void)hideIdentityControlAction
{
    isAnonymus = !isAnonymus;
    if(!isAnonymus)
    {
        hideIdentityImageView.image = [UIImage imageNamed:@"checkBox_deSelected.png"];
    }
    else
    {
        hideIdentityImageView.image = [UIImage imageNamed:@"checkBox_selected.png"];
    }
}

-(void)postButtonAction
{
    if([contentTextView.text isEqualToString:@""] || [contentTextView.text isEqualToString:NSLocalizedString(kPostReviewContentPlaceholder, nil)])
    {
        [contentTextView resignFirstResponder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Can not post empty review" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:dismiss];
        
        [self presentViewController:alertController animated:YES completion:^{
            
            return;
        }];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(kPostReviewPosting, nil);
        
        [self insertReviewToServer];
    }
}

-(void)backButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)insertReviewToServer
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:insertReview];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    
    NSError *error;
    NSMutableDictionary *queryDictionary = [[NSMutableDictionary alloc] init];
    
    [queryDictionary setObject:productId forKey:@"PRODUCT_ID"];
    [queryDictionary setObject:[df1 stringFromDate:[NSDate date]] forKey:@"REVIEW_DATE"];
    if(isAnonymus)
    {
        [queryDictionary setObject:@"" forKey:@"USR_ID"];
    }
    else
    {
        [queryDictionary setObject:[UserDefaultsManager getUserId] forKey:@"USR_ID"];
    }
    [queryDictionary setObject:contentTextView.text forKey:@"CONTENT"];
    [queryDictionary setObject:ratingTextField.text forKey:@"ORIGINAL_USER_RATING"];
    [queryDictionary setObject:conditionTextField.text forKey:@"CONDITION_INFO"];
    [queryDictionary setObject:durationTextField.text forKey:@"TREATEMENT_DURATION"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"insertReview %@",dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kReviewPosted object:nil];
                    [self backButtonAction];
                });
            }
            else
            {
                NSLog(@"%@",error);
            }
        }
    }];
    [dataTask resume];
}

@end
