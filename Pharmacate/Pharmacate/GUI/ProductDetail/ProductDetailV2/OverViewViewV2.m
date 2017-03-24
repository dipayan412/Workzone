//
//  OverViewViewV2.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/29/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "OverViewViewV2.h"
#import "CustomScrollView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface OverViewViewV2()
{
    CustomScrollView *scrollView;
    NSString *productId;
    UILabel *loadingLabel;
    UILabel *gradingLabel;
    UIButton *imageButton;
    NSMutableArray *imageArray;
    UIButton *bookmarkButton;
    UIButton *alarmButton;
    UIButton *postReviewButton;
    BOOL isBookmarkSelected;
    BOOL isAlarmSetForProduct;
    UIButton *whyButton;
    UILabel *whyLabel;
    UIButton *shareButton;
    UIButton *fbButton;
    NSString *imageLink;
    
    UIButton *descriptionButton;
    UIButton *ingredientButton;
    UIButton *diseaseButton;
    UIButton *symptomButton;
    UIButton *boxwarningButton;
    UIButton *pregnancyButton;
    UIButton *sideEffectButton;
    UIButton *allergenButton;
    UIButton *contraIndicationButton;
    
    UITextView *contentTextView;
    
    NSMutableString *diseaseString;
    NSMutableString *symptomString;
    NSMutableString *sideEffectString;
    NSMutableString *descriptionString;
    NSMutableString *totalIngredientStr;
    NSMutableString *pregnancyString;
    NSMutableString *boxWarningString;
    NSMutableString *contraindicationsString;
    NSMutableString *allergenString;
    NSMutableAttributedString *finalIngredientString;
    NSMutableAttributedString *finalSideEffectString;
    
    UILabel *sideEffectScoreLabel;
    UILabel *allergenScoreLabel;
    UILabel *boxWarningScoreLabel;
    UILabel *pregnancyScoreLabel;
    UILabel *contraIndicationScoreLabel;
    
    UIButton *prevButton;
}

@end

@implementation OverViewViewV2

@synthesize delegate;
@synthesize productImageView;

- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId
{
    if ((self = [super initWithFrame:rect]))
    {
        productId = _productId;
        [self commonIntialization];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(descriptionReceived:)
                                                     name:@"ProductDetailReceived"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkAlarmButton)
                                                     name:@"AlarmUpdated"
                                                   object:nil];
    }
    return self;
}

-(void)commonIntialization
{
    [self checkProductBookmark];
    
    imageLink = @"";
    
    self.backgroundColor = [UIColor whiteColor];
    
    diseaseString = [[NSMutableString alloc] init];
    symptomString = [[NSMutableString alloc] init];
    sideEffectString = [[NSMutableString alloc] init];
    descriptionString = [[NSMutableString alloc] init];
    totalIngredientStr = [[NSMutableString alloc] init];
    finalIngredientString = [[NSMutableAttributedString alloc] init];
    finalSideEffectString = [[NSMutableAttributedString alloc] init];
    pregnancyString = [[NSMutableString alloc] init];
    boxWarningString = [[NSMutableString alloc] init];
    contraindicationsString = [[NSMutableString alloc] init];
    allergenString = [[NSMutableString alloc] init];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)];
    loadingLabel.text = @"Loading...";
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:loadingLabel];
    
    productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100, 10, 200, 200)];
    productImageView.contentMode = UIViewContentModeScaleAspectFit;
    productImageView.hidden = YES;
    [self addSubview:productImageView];
    
    imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(self.frame.size.width/2 - 100, 10, 200, 200);
    imageButton.hidden = YES;
    imageButton.backgroundColor = [UIColor clearColor];
    [imageButton addTarget:self action:@selector(imageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageButton];
    
    gradingLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageButton.frame.size.width + imageButton.frame.origin.x + 10, 10, 50, 50)];
    gradingLabel.textAlignment = NSTextAlignmentCenter;
    gradingLabel.hidden = YES;
    gradingLabel.layer.borderWidth = 1.5f;
    gradingLabel.layer.borderColor = themeColor.CGColor;
    gradingLabel.layer.cornerRadius = 25.0f;
    gradingLabel.textColor = themeColor;
    gradingLabel.font = [UIFont systemFontOfSize:26.0f];
    [self addSubview:gradingLabel];
    
    whyLabel = [[UILabel alloc] initWithFrame:CGRectMake(gradingLabel.frame.origin.x + gradingLabel.frame.size.width/2 - 22, gradingLabel.frame.origin.y + gradingLabel.frame.size.height + 5, 50, 20)];
    whyLabel.text = @"Why?";
    whyLabel.hidden = YES;
    [self addSubview:whyLabel];
    
    whyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    whyButton.frame = CGRectMake(gradingLabel.frame.origin.x + gradingLabel.frame.size.width/2 - 22, gradingLabel.frame.origin.y, 50, gradingLabel.frame.size.height + whyLabel.frame.size.height + 5);
    whyButton.hidden = YES;
    [whyButton addTarget:self action:@selector(whyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:whyButton];
    
    bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookmarkButton.hidden = YES;
    bookmarkButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 64, imageButton.frame.size.height + imageButton.frame.origin.y + 30, 32, 32);
//    [bookmarkButton setTitle:@"Bookmark" forState:UIControlStateNormal];
    if(!isBookmarkSelected)
    {
//        [bookmarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [bookmarkButton setImage:[UIImage imageNamed:@"bookmarkOff.png"] forState:UIControlStateNormal];
    }
    else
    {
//        [bookmarkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [bookmarkButton setImage:[UIImage imageNamed:@"bookmarkOn.png"] forState:UIControlStateNormal];
    }
    
    [bookmarkButton addTarget:self action:@selector(bookmarkButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:bookmarkButton];
    
    alarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alarmButton.hidden = YES;
//    [alarmButton setTitle:@"Alarm" forState:UIControlStateNormal];
    [alarmButton setImage:[UIImage imageNamed:@"alarmOff.png"] forState:UIControlStateNormal];
    alarmButton.frame = CGRectMake(bookmarkButton.frame.origin.x + bookmarkButton.frame.size.width + 10, bookmarkButton.frame.origin.y, 32, 32);
//    [alarmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    isAlarmSetForProduct = NO;
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
        {
            [alarmButton setImage:[UIImage imageNamed:@"alarmOn.png"] forState:UIControlStateNormal];
            isAlarmSetForProduct = YES;
            break;
        }
    }
    [alarmButton addTarget:self action:@selector(alarmButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:alarmButton];
    
    fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbButton.hidden = YES;
    [fbButton setImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
    fbButton.frame = CGRectMake(alarmButton.frame.origin.x + alarmButton.frame.size.width + 10, bookmarkButton.frame.origin.y, 32, 32);
    [fbButton addTarget:self action:@selector(fbButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:fbButton];
    
    postReviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postReviewButton.hidden = YES;
    postReviewButton.frame = CGRectMake(bookmarkButton.frame.origin.x - 42, bookmarkButton.frame.origin.y, 32, 32);
//    [postReviewButton setTitle:@"Post" forState:UIControlStateNormal];
//    [postReviewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [postReviewButton setImage:[UIImage imageNamed:@"postReview.png"] forState:UIControlStateNormal];
    [postReviewButton addTarget:self action:@selector(postReviewButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:postReviewButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.hidden = YES;
    //    [alarmButton setTitle:@"Alarm" forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(fbButton.frame.origin.x + fbButton.frame.size.width + 10, bookmarkButton.frame.origin.y, 32, 32);
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:shareButton];
    
    imageArray = [[NSMutableArray alloc] init];
    scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, imageButton.frame.size.height + imageButton.frame.origin.y + 10, self.frame.size.width, 100)];
    
//    int x = 0;
//    for (int i = 0; i < 8; i++) {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 100, 100)];
//        [button setTitle:[NSString stringWithFormat:@"Button %d", i] forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor greenColor]];
//        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//        
//        [scrollView addSubview:button];
//        
//        x += button.frame.size.width;
//    }
    float buttonWidth = 120;
    float buttonHeight = 100;
    descriptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [descriptionButton setTitle:@"Description" forState:UIControlStateNormal];
    [descriptionButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [descriptionButton addTarget:self action:@selector(descriptionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    descriptionButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    prevButton = descriptionButton;
    [scrollView addSubview:descriptionButton];
    
    ingredientButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ingredientButton setTitle:@"Ingredient" forState:UIControlStateNormal];
    [ingredientButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ingredientButton addTarget:self action:@selector(ingredientButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    ingredientButton.frame = CGRectMake(descriptionButton.frame.origin.x + descriptionButton.frame.size.width, 0, buttonWidth, buttonHeight);
    [scrollView addSubview:ingredientButton];
    
    diseaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [diseaseButton setTitle:@"Treats" forState:UIControlStateNormal];
    [diseaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [diseaseButton addTarget:self action:@selector(diseaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    diseaseButton.frame = CGRectMake(ingredientButton.frame.origin.x + ingredientButton.frame.size.width, 0, buttonWidth, buttonHeight);
    [scrollView addSubview:diseaseButton];
    
    symptomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [symptomButton setTitle:@"Uses" forState:UIControlStateNormal];
    [symptomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [symptomButton addTarget:self action:@selector(symptomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    symptomButton.frame = CGRectMake(diseaseButton.frame.origin.x + diseaseButton.frame.size.width, 0, buttonWidth, buttonHeight);
    [scrollView addSubview:symptomButton];
    
    sideEffectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sideEffectButton setTitle:@"Side Effects" forState:UIControlStateNormal];
    [sideEffectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sideEffectButton addTarget:self action:@selector(sideEffectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    sideEffectButton.frame = CGRectMake(symptomButton.frame.origin.x + symptomButton.frame.size.width, 0, buttonWidth, buttonHeight);
    [scrollView addSubview:sideEffectButton];
    
    boxwarningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [boxwarningButton setTitle:@"Box Warning" forState:UIControlStateNormal];
    [boxwarningButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [boxwarningButton addTarget:self action:@selector(boxWarninggButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    boxwarningButton.frame = CGRectMake(sideEffectButton.frame.origin.x + sideEffectButton.frame.size.width, 0, buttonWidth, buttonHeight);
    [scrollView addSubview:boxwarningButton];
    
    pregnancyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pregnancyButton setTitle:@"Pregnancy" forState:UIControlStateNormal];
    [pregnancyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pregnancyButton addTarget:self action:@selector(pregnancyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    pregnancyButton.frame = CGRectMake(boxwarningButton.frame.origin.x + boxwarningButton.frame.size.width, 0, buttonWidth, buttonHeight);
    [scrollView addSubview:pregnancyButton];
    
    contraIndicationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contraIndicationButton setTitle:@"Contraindication" forState:UIControlStateNormal];
    [contraIndicationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contraIndicationButton addTarget:self action:@selector(contraIndicationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    contraIndicationButton.frame = CGRectMake(pregnancyButton.frame.origin.x + pregnancyButton.frame.size.width, 0, buttonWidth, buttonHeight);
    [scrollView addSubview:contraIndicationButton];
    
    allergenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allergenButton setTitle:@"Allergen" forState:UIControlStateNormal];
    [allergenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allergenButton addTarget:self action:@selector(allergenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    allergenButton.frame = CGRectMake(contraIndicationButton.frame.origin.x + contraIndicationButton.frame.size.width, 0, buttonWidth, buttonHeight);
    [scrollView addSubview:allergenButton];
    
    scrollView.hidden = YES;
    scrollView.contentSize = CGSizeMake(9 * buttonWidth, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.canCancelContentTouches = YES;
    [scrollView setShowsHorizontalScrollIndicator:NO];
//    [self addSubview:scrollView];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, imageButton.frame.size.height + imageButton.frame.origin.y + 20, self.frame.size.width - 10, self.frame.size.height - imageButton.frame.size.height - imageButton.frame.origin.y - 20)];
    contentTextView.hidden = YES;
    contentTextView.editable = NO;
    contentTextView.font = [UIFont systemFontOfSize:17.0f];
    [self addSubview:contentTextView];
    
//    sideEffectScoreLabel = [UILabel alloc] initWithFrame:CGRectMake(x, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
    
//    [self getProductDetailFromServer];
}

-(void)fbButtonAction
{
    if(delegate)
    {
        [delegate fbShareActionWithImage:imageLink];
    }
}

-(void)shareButtonAction
{
    if(delegate)
    {
        if(imageArray.count == 0)
        {
            [delegate shareButtonActionWithImage:nil];
        }
        else
        {
            [delegate shareButtonActionWithImage:imageButton.currentBackgroundImage];
        }
    }
}

-(void)whyButtonAction
{
    if(delegate)
    {
        [delegate whyButtonAction];
    }
}

-(void)checkAlarmButton
{
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
        {
//            [alarmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [bookmarkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [alarmButton setImage:[UIImage imageNamed:@"alarmOn.png"] forState:UIControlStateNormal];
            [bookmarkButton setImage:[UIImage imageNamed:@"bookmarkOn.png"] forState:UIControlStateNormal];
            isAlarmSetForProduct = YES;
            isBookmarkSelected = YES;
            break;
        }
    }
}

-(void)alarmButtonAction
{
    if(delegate)
    {
        [delegate alarmButtonAction];
    }
}

-(void)postReviewButtonAction
{
    if(delegate)
    {
        [delegate postReviewButtonAction];
    }
}

-(void)bookmarkButtonAction
{
    if([[UserDefaultsManager getUserName] isEqualToString:@""])
    {
        if(delegate)
        {
            [delegate bookmarkButtonAction];
        }
    }
    else
    {
        isBookmarkSelected = !isBookmarkSelected;
        if(!isBookmarkSelected)
        {
            if(isAlarmSetForProduct)
            {
                if(delegate)
                {
                    [delegate bookmarkDeleteActionConfirmation];
                }
            }
            else
            {
                [self bookmarkDeleteCall];
            }
        }
        else
        {
//            [bookmarkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [bookmarkButton setImage:[UIImage imageNamed:@"bookmarkOn.png"] forState:UIControlStateNormal];
            
            NSMutableString *urlStr = [[NSMutableString alloc] init];
            [urlStr appendString:updateUserProducts2];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
            [request setHTTPMethod:@"POST"];
            
            NSError *error;
            NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:productId, @"PRODUCT_ID", [UserDefaultsManager getUserId], @"USR_ID", nil];
            
            NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
            //    NSLog(@"%@",mapData);
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
            [request setHTTPBody:postData];
            
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSDictionary *dataJSON;
                if(data)
                {
                    dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    NSLog(@"insert %@",dataJSON);
                    if(!error)
                    {
                        
                    }
                    else
                    {
                        NSLog(@"%@",error);
                    }
                }
            }];
            [dataTask resume];
        }
    }
}

-(void)bookmarkDeleteCall
{
//    [bookmarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [alarmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [bookmarkButton setImage:[UIImage imageNamed:@"bookmarkOff.png"] forState:UIControlStateNormal];
    [alarmButton setImage:[UIImage imageNamed:@"alarmOff.png"] forState:UIControlStateNormal];
    isAlarmSetForProduct = NO;
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:deleteBookmark];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:productId, @"PRODUCT_ID", [UserDefaultsManager getUserId], @"USR_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    //    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"delete %@",dataJSON);
            if(!error)
            {
                
            }
            else
            {
                NSLog(@"%@",error);
            }
        }
    }];
    [dataTask resume];
}

-(void)checkProductBookmark
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:checkBookmark];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:productId, @"PRODUCT_ID", [UserDefaultsManager getUserId], @"USR_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    //    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"check %@",dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([[dataJSON objectForKey:@"COMMENTS"] isEqualToString:@"TRACKED"])
                    {
                        isBookmarkSelected = YES;
//                        [bookmarkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [bookmarkButton setImage:[UIImage imageNamed:@"bookmarkOn.png"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        isBookmarkSelected = NO;
//                        [bookmarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        [bookmarkButton setImage:[UIImage imageNamed:@"bookmarkOff.png"] forState:UIControlStateNormal];
                    }
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

-(void)buttonAction
{
    NSLog(@"yes");
}

-(void)descriptionButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    contentTextView.text = descriptionString;
}

-(void)ingredientButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    if(![finalIngredientString.string isEqualToString:@""])
    {
        contentTextView.attributedText = finalIngredientString;
    }
    else
    {
        contentTextView.text = totalIngredientStr;
    }
}

-(void)diseaseButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    contentTextView.text = diseaseString;
}

-(void)symptomButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    contentTextView.text = symptomString;
}

-(void)sideEffectButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    if(![finalSideEffectString.string isEqualToString:@""])
    {
        contentTextView.attributedText = finalSideEffectString;
    }
    else
    {
        contentTextView.text = sideEffectString;
    }
}

-(void)boxWarninggButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    contentTextView.text = boxWarningString;
}

-(void)pregnancyButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    contentTextView.text = pregnancyString;
}

-(void)contraIndicationButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    contentTextView.text = contraindicationsString;
}

-(void)allergenButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    contentTextView.text = allergenString;
}

-(void)moveIndicatorViewAccotdingToButton:(UIButton*)button
{
    if(prevButton)
    {
        [prevButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    prevButton = button;
}

-(void)imageButtonAction
{
    if(delegate)
    {
        [delegate imageButtonAction];
    }
}

-(void)descriptionReceived:(NSNotification*)_notification
{
    NSLog(@"%@",_notification.userInfo);
    
    loadingLabel.hidden = YES;
    imageButton.hidden = NO;
    scrollView.hidden = NO;
    contentTextView.hidden = NO;
    gradingLabel.hidden = NO;
    bookmarkButton.hidden = NO;
    alarmButton.hidden = NO;
    postReviewButton.hidden = NO;
    whyLabel.hidden = NO;
    whyButton.hidden = NO;
    shareButton.hidden = NO;
    productImageView.hidden = NO;
    fbButton.hidden = NO;
    
    if(![[_notification.userInfo objectForKey:@"PRODUCT_IMAGE"] isEqualToString:@""])
    {
//        [imageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_notification.userInfo objectForKey:@"PRODUCT_IMAGE"]]]] forState:UIControlStateNormal];
        [productImageView setImageWithURL:[NSURL URLWithString:[_notification.userInfo objectForKey:@"PRODUCT_IMAGE"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        imageLink = [_notification.userInfo objectForKey:@"PRODUCT_IMAGE"];
    }
    else
    {
//        [imageButton setBackgroundImage:[UIImage imageNamed:@"noImageAvailable.png"] forState:UIControlStateNormal];
        productImageView.image = [UIImage imageNamed:@"noImageAvailable.png"];
    }
    
    contentTextView.text = [NSString stringWithFormat:@"%@\n%@",[_notification.userInfo objectForKey:@"DESCRIPTION"], productId];
    gradingLabel.text = [_notification.userInfo objectForKey:@"OVERALL_GRADE"];
}

-(void)getProductDetailFromServer
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:getProductDetail];
    [urlStr appendString:[NSString stringWithFormat:@"?pId=%@",productId]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//            NSLog(@"ProductDetail %@",dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    loadingLabel.hidden = YES;
                    imageButton.hidden = NO;
                    scrollView.hidden = NO;
                    contentTextView.hidden = NO;
                    
                    [imageArray removeAllObjects];
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Image_URL"] && [[[dataJSON objectForKey:@"Data"] objectForKey:@"Image_URL"] count] > 0)
                    {
                        [imageArray addObjectsFromArray:[[dataJSON objectForKey:@"Data"] objectForKey:@"Image_URL"]];
                    }
                    if(imageArray.count > 0)
                    {
                        [imageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[imageArray objectAtIndex:0] objectForKey:@"image_link"]]]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [imageButton setBackgroundImage:[UIImage imageNamed:@"noImageAvailable.png"] forState:UIControlStateNormal];
                    }
                    
                    for(int i = 0; i < [[[dataJSON objectForKey:@"Data"] objectForKey:@"Diseases"] count]; i++)
                    {
                        NSDictionary *disease = [[[dataJSON objectForKey:@"Data"] objectForKey:@"Diseases"] objectAtIndex:i];
                        [diseaseString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"DISEASE_NAME"]]];
                        if(i != [[[dataJSON objectForKey:@"Data"] objectForKey:@"Diseases"] count] - 1)
                        {
                            [diseaseString appendString:@",\n"];
                        }
                    }
                    if([diseaseString isEqualToString:@""])
                    {
                        [diseaseString appendString:@"No data to display"];
                    }
                    
                    NSArray *activeArray = [NSArray arrayWithArray:[[[dataJSON objectForKey:@"Data"] objectForKey:@"Ingredients"] objectForKey:@"Active"]];
                    NSMutableString *activeStr = [[NSMutableString alloc] init];
                    if(activeArray.count != 0)
                    {
                        for(int i = 0; i < activeArray.count; i++)
                        {
                            [activeStr appendString:[NSString stringWithFormat:@"%@",[[activeArray objectAtIndex:i] objectForKey:@"INGREDIENT_NAME"]]];
                            if(i != [activeArray count] - 1)
                            {
                                [activeStr appendString:@", "];
                            }
                        }
                        
                        [activeStr appendString:@"\n\n"];
                        [totalIngredientStr appendString:@"Active: "];
                        [totalIngredientStr appendString:activeStr];
                    }
                    
                    NSArray *inactiveArray = [NSArray arrayWithArray:[[[dataJSON objectForKey:@"Data"] objectForKey:@"Ingredients"] objectForKey:@"Inactive"]];
                    NSMutableString *inactiveStr = [[NSMutableString alloc] init];
                    if(inactiveArray.count != 0)
                    {
                        for(int i = 0; i < inactiveArray.count; i++)
                        {
                            [inactiveStr appendString:[NSString stringWithFormat:@"%@",[[inactiveArray objectAtIndex:i] objectForKey:@"INGREDIENT_NAME"]]];
                            if(i != [inactiveArray count] - 1)
                            {
                                [inactiveStr appendString:@", "];
                            }
                        }
                        
                        [inactiveStr appendString:@"\n\n"];
                        [totalIngredientStr appendString:@"Inactive: "];
                        [totalIngredientStr appendString:inactiveStr];
                    }
                    
                    NSArray *unknownArray = [NSArray arrayWithArray:[[[dataJSON objectForKey:@"Data"] objectForKey:@"Ingredients"] objectForKey:@"Unknown"]];
                    NSMutableString *unknownStr = [[NSMutableString alloc] init];
                    if(unknownArray.count != 0)
                    {
                        for(int i = 0; i < unknownArray.count; i++)
                        {
                            [unknownStr appendString:[NSString stringWithFormat:@"%@",[[unknownArray objectAtIndex:i] objectForKey:@"INGREDIENT_NAME"]]];
                            if(i != [unknownArray count] - 1)
                            {
                                [unknownStr appendString:@", "];
                            }
                        }
                        [totalIngredientStr appendString:@"Unknown: "];
                        [totalIngredientStr appendString:unknownStr];
                    }
                    
                    NSDictionary *defaultAttribute = @{
                                                       NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                       NSForegroundColorAttributeName:[UIColor blackColor]
                                                       };
                    NSDictionary *boldAttribute = @{
                                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:17]
                                                    };
                    if(totalIngredientStr.length > 0)
                    {
                        finalIngredientString = [[NSMutableAttributedString alloc] initWithString:totalIngredientStr attributes:defaultAttribute];
                        NSRange range1 = NSMakeRange(0, 0);
                        if(activeStr.length > 0)
                        {
                            range1 = NSMakeRange(0,8);
                            [finalIngredientString setAttributes:boldAttribute range:range1];
                        }
                        NSRange range2 = NSMakeRange(0, 0);
                        if(inactiveStr.length > 0)
                        {
                            range2 = NSMakeRange(range1.location + range1.length + activeStr.length, 10);
                            [finalIngredientString setAttributes:boldAttribute range:range2];
                        }
                        NSRange range3 = NSMakeRange(0, 0);
                        if(unknownStr.length > 0)
                        {
                            range3 = NSMakeRange(range2.location + range2.length + inactiveStr.length, 9);
                            [finalIngredientString setAttributes:boldAttribute range:range3];
                        }
                    }
                    else
                    {
                        [totalIngredientStr appendString:@"No data to display"];
                    }
                    
                    if([[[dataJSON objectForKey:@"Data"] objectForKey:@"Product"] count] > 0)
                    {
                        if([[[[dataJSON objectForKey:@"Data"] objectForKey:@"Product"] objectAtIndex:0] objectForKey:@"DESCRIPTION"] != [NSNull null] || ![[[[dataJSON objectForKey:@"Data"] objectForKey:@"Product"] objectAtIndex:0] objectForKey:@"DESCRIPTION"])
                        {
                            [descriptionString appendString:[NSString stringWithFormat:@"%@", [[[[dataJSON objectForKey:@"Data"] objectForKey:@"Product"] objectAtIndex:0] objectForKey:@"DESCRIPTION"]]];
                        }
                    }
                    if([descriptionString isEqualToString:@""])
                    {
                        [descriptionString appendString:@"No data to display"];
                    }
                    
                    for(int i = 0; i < [[[dataJSON objectForKey:@"Data"] objectForKey:@"Symptoms"] count]; i++)
                    {
                        NSDictionary *disease = [[[dataJSON objectForKey:@"Data"] objectForKey:@"Symptoms"] objectAtIndex:i];
                        [symptomString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"SYMPTOM_NAME"]]];
                        if(i != [[[dataJSON objectForKey:@"Data"] objectForKey:@"Symptoms"] count] - 1)
                        {
                            [symptomString appendString:@",\n"];
                        }
                    }
                    if([symptomString isEqualToString:@""])
                    {
                        [symptomString appendString:@"No data to display"];
                    }
                    
                    NSMutableString *severeSideEffectString = [[NSMutableString alloc] init];
                    NSMutableString *regularSideEffectString = [[NSMutableString alloc] init];
                    
                    for(int i = 0; i < [[[dataJSON objectForKey:@"Data"] objectForKey:@"SideEffects"] count]; i++)
                    {
                        NSDictionary *disease = [[[dataJSON objectForKey:@"Data"] objectForKey:@"SideEffects"] objectAtIndex:i];
                        if([[disease objectForKey:@"SIDE_EFFECT_TYPE"] isEqualToString:@"SEVERE"])
                        {
                            [severeSideEffectString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"SIDE_EFFECT_NAME"]]];
                            [severeSideEffectString appendString:@" "];
                        }
                        else
                        {
                            [regularSideEffectString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"SIDE_EFFECT_NAME"]]];
                            [regularSideEffectString appendString:@" "];
                        }
                    }
                    
                    if([severeSideEffectString length] > 0)
                    {
                        [severeSideEffectString appendString:@"\n\n"];
                        [sideEffectString appendString:@"Severe: "];
                        [sideEffectString appendString:severeSideEffectString];
                    }
                    
                    if([regularSideEffectString length] > 0)
                    {
                        [sideEffectString appendString:@"Regular: "];
                        [sideEffectString appendString:regularSideEffectString];
                    }
                    
                    if([sideEffectString isEqualToString:@""])
                    {
                        [sideEffectString appendString:@"No data to display"];
                    }
                    else
                    {
                        finalSideEffectString = [[NSMutableAttributedString alloc] initWithString:sideEffectString attributes:defaultAttribute];
                        NSRange range1 = NSMakeRange(0, 0);
                        if(severeSideEffectString.length > 0)
                        {
                            range1 = NSMakeRange(0,8);
                            [finalSideEffectString setAttributes:boldAttribute range:range1];
                        }
                        NSRange range2 = NSMakeRange(0, 0);
                        if(regularSideEffectString.length > 0)
                        {
                            range2 = NSMakeRange(range1.location + range1.length + severeSideEffectString.length, 9);
                            [finalSideEffectString setAttributes:boldAttribute range:range2];
                        }
                    }
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Pregnancy"] != [NSNull null])
                    {
                        if(![[[dataJSON objectForKey:@"Data"] objectForKey:@"Pregnancy"] isEqualToString:@""] && [[dataJSON objectForKey:@"Data"] objectForKey:@"Pregnancy"])
                        {
                            [pregnancyString appendString:[[dataJSON objectForKey:@"Data"] objectForKey:@"Pregnancy"]];
                        }
                        else
                        {
                            [pregnancyString appendString:@"No data to display"];
                        }
                    }
                    else
                    {
                        [pregnancyString appendString:@"No data to display"];
                    }
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Warnings"] != [NSNull null])
                    {
                        if(![[[dataJSON objectForKey:@"Data"] objectForKey:@"Warnings"] isEqualToString:@""] && [[dataJSON objectForKey:@"Data"] objectForKey:@"Warnings"])
                        {
                            [boxWarningString appendString:[[dataJSON objectForKey:@"Data"] objectForKey:@"Warnings"]];
                        }
                        else
                        {
                            [boxWarningString appendString:@"No data to display"];
                        }
                    }
                    else
                    {
                        [boxWarningString appendString:@"No data to display"];
                    }
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Contraindications"] != [NSNull null])
                    {
                        if(![[[dataJSON objectForKey:@"Data"] objectForKey:@"Contraindications"] isEqualToString:@""] && [[dataJSON objectForKey:@"Data"] objectForKey:@"Contraindications"])
                        {
                            [contraindicationsString appendString:[[dataJSON objectForKey:@"Data"] objectForKey:@"Contraindications"]];
                        }
                        else
                        {
                            [contraindicationsString appendString:@"No data to display"];
                        }
                    }
                    else
                    {
                        [contraindicationsString appendString:@"No data to display"];
                    }
                    
                    for(int i = 0; i < [[[dataJSON objectForKey:@"Data"] objectForKey:@"Allergens"] count]; i++)
                    {
                        NSDictionary *disease = [[[dataJSON objectForKey:@"Data"] objectForKey:@"Allergens"] objectAtIndex:i];
                        [allergenString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"ALLERGEN_NAME"]]];
                        if(i != [[[dataJSON objectForKey:@"Data"] objectForKey:@"Allergens"] count] - 1)
                        {
                            [allergenString appendString:@",\n"];
                        }
                    }
                    if([allergenString isEqualToString:@""])
                    {
                        [allergenString appendString:@"No common Allergen found"];
                    }
                    
                    contentTextView.text = descriptionString;
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Scores"] != [NSNull null] && [[dataJSON objectForKey:@"Data"] objectForKey:@"Scores"] != nil)
                    {
                        NSDictionary *tmpDic = [[dataJSON objectForKey:@"Data"] objectForKey:@"Scores"];
                        //                        NSLog(@"scores %@", tmpDic);
                        NSMutableArray *scores = [[NSMutableArray alloc] init];
                        NSMutableArray *grades = [[NSMutableArray alloc] init];
                        
                        if([tmpDic objectForKey:@"WARNING_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"WARNING_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"WARNING_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"PREGNANCY_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"PREGNANCY_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"PREGNANCY_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"SIDE_EFFECT_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"SIDE_EFFECT_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"SIDE_EFFECT_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"DRUG_INTERACTION_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"DRUG_INTERACTION_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"DRUG_INTERACTION_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"CONTRAINDICATION_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"CONTRAINDICATION_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"CONTRAINDICATION_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"ALLERGEN_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"ALLERGEN_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"ALLERGEN_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"LABEL_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"LABEL_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"LABEL_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLabelScoresReceived object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:scores, @"LABEL_SCORES", grades, @"LABEL_GRADES", nil]];
                    }
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

-(NSString*)getGradeForScore:(float)number
{
    if(number >= 1.0f)
    {
        return @"A+";
    }
    else if(number > 0.74 && number < 1)
    {
        return @"A";
    }
    else if(number > 0.49 && number <= 0.74)
    {
        return @"B+";
    }
    else if(number > 0.24 && number <= 49)
    {
        return @"B";
    }
    else if(number > 0.0 && number <= 0.24)
    {
        return @"C";
    }
    else
    {
        return @"D";
    }
}

@end
