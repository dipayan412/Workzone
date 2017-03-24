//
//  RecallViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/1/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "RecallViewController.h"

@interface RecallViewController ()
{
    UITextView *containerTextView;
    NSMutableDictionary *workableDictionary;
    
    NSMutableDictionary *modifiedKeysDictionary;
}

@end

@implementation RecallViewController

@synthesize recallDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    modifiedKeysDictionary = [[NSMutableDictionary alloc] init];
    [modifiedKeysDictionary setObject:@"Code Information" forKey:@"CODE_INFO"];
    [modifiedKeysDictionary setObject:@"Distribution Pattern" forKey:@"DISTRIBUTION_PATTERN"];
    [modifiedKeysDictionary setObject:@"Product Description" forKey:@"PRODUCT_DESCRIPTION"];
    [modifiedKeysDictionary setObject:@"Product Quantity" forKey:@"PRODUCT_QUANTITY"];
    [modifiedKeysDictionary setObject:@"Reason For Recall" forKey:@"REASON_FOR_RECALL"];
    [modifiedKeysDictionary setObject:@"Recalling Firm" forKey:@"RECALLING_FIRM"];
    [modifiedKeysDictionary setObject:@"Recall Initiation Date" forKey:@"RECALL_INITIATION_DATE"];
    [modifiedKeysDictionary setObject:@"Recall Number" forKey:@"RECALL_NUMBER"];
    [modifiedKeysDictionary setObject:@"Report Date" forKey:@"REPORT_DATE"];
    [modifiedKeysDictionary setObject:@"Status" forKey:@"STATUS"];
    [modifiedKeysDictionary setObject:@"Termination Date" forKey:@"TERMINATION_DATE"];
    [modifiedKeysDictionary setObject:@"Voluntary Mandated" forKey:@"VOLUNTARY_MANDATED"];
    
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, customNavigationBar.frame.size.height/2 - 45/2, 45, 45);;
    [backButton setBackgroundImage:[UIImage imageNamed:@"ThemeColorBackButton.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    [self.view addSubview:customNavigationBar];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [customNavigationBar addSubview:separatorLine];
    
    containerTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - customNavigationBar.frame.size.height)];
    containerTextView.scrollEnabled = YES;
    containerTextView.editable = NO;
//    containerTextView.attributedText = [self buildTextViewStrinWithDictionary:recallDictionary];
    [self.view addSubview:containerTextView];
    
    workableDictionary = [[NSMutableDictionary alloc] init];
    for(NSString *key in [recallDictionary allKeys])
    {
        if([recallDictionary objectForKey:key] != [NSNull null])
        {
            if(![key isEqualToString:@"CLASSIFICATION"] && ![key isEqualToString:@"PRODUCT_TYPE"] && ![key isEqualToString:@"CREATED_AT"] && ![key isEqualToString:@"DATA_SOURCE_ID"] && ![key isEqualToString:@"EVENT_ID"] && ![key isEqualToString:@"IS_DELETED"] && ![key isEqualToString:@"RECALL_ID"] && ![key isEqualToString:@"UPDATED_AT"] && ![[NSString stringWithFormat:@"%@", [recallDictionary objectForKey:key]] isEqualToString:@""])
            {
                [workableDictionary setObject:[recallDictionary objectForKey:key] forKey:[modifiedKeysDictionary objectForKey:key]];
            }
        }
    }
//    NSLog(@"workableRecalls %@", workableDictionary);
    int startIndex = 0;
    int range = 0;
    NSMutableArray *rangeArray = [[NSMutableArray alloc] init];
    NSDictionary *defaultAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *boldAttribute = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    NSMutableString *totalString = [[NSMutableString alloc] init];
    for(NSString *key in [workableDictionary allKeys])
    {
        startIndex = (int)[totalString length];
        range = (int)[key length] + 2;
        [totalString appendString:[NSString stringWithFormat:@"%@: ",key]];
        [totalString appendString:[NSString stringWithFormat:@"%@\n\n", [workableDictionary objectForKey:key]]];
        [rangeArray addObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:range], nil]];
    }
    
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] initWithString:totalString attributes:defaultAttribute];
    for(int i = 0; i < [[workableDictionary allKeys] count]; i++)
    {
        NSLog(@"%@",finalString);
        NSArray *rangeObject = [rangeArray objectAtIndex:i];
        [finalString setAttributes:boldAttribute range:NSMakeRange([[rangeObject objectAtIndex:0] intValue], [[rangeObject objectAtIndex:1] intValue])];
    }
    containerTextView.attributedText = finalString;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//-(NSAttributedString*)buildTextViewStrinWithDictionary:(NSDictionary*)dictionary
//{
//    NSDictionary *defaultAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]};
//    NSDictionary *boldAttribute = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
////
////    NSRange range1 = NSMakeRange(0,8);
////    NSRange range2 = NSMakeRange(range1.location + range1.length + activeStr.length, 10);
////    NSRange range3 = NSMakeRange(range2.location + range2.length + inactiveStr.length, 9);
////    finalIngredientString = [[NSMutableAttributedString alloc] initWithString:totalIngredientStr attributes:defaultAttribute];
////    [finalIngredientString setAttributes:boldAttribute range:range1];
////    [finalIngredientString setAttributes:boldAttribute range:range2];
////    [finalIngredientString setAttributes:boldAttribute range:range3];
//    NSMutableString *totalRecallString = [[NSMutableString alloc] init];
////    [totalRecallString appendString:[NSString stringWithFormat:@"Classification: %@\n\n", [dictionary objectForKey:@"CLASSIFICATION"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Code Information: %@\n\n", [dictionary objectForKey:@"CODE_INFO"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Distribution Pattern: %@\n\n", [dictionary objectForKey:@"DISTRIBUTION_PATTERN"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Product Description: %@\n\n", [dictionary objectForKey:@"PRODUCT_DESCRIPTION"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Product Quantity: %@\n\n", [dictionary objectForKey:@"PRODUCT_QUANTITY"]]];
////    [totalRecallString appendString:[NSString stringWithFormat:@"Product Type: %@\n\n", [dictionary objectForKey:@"PRODUCT_TYPE"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Reason For Recall: %@\n\n", [dictionary objectForKey:@"REASON_FOR_RECALL"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Recalling Firm: %@\n\n", [dictionary objectForKey:@"RECALLING_FIRM"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Recall Initiation Date: %@\n\n", [dictionary objectForKey:@"RECALL_INITIATION_DATE"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Recall Number: %@\n\n", [dictionary objectForKey:@"RECALL_NUMBER"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Report Date: %@\n\n", [dictionary objectForKey:@"REPORT_DATE"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Status: %@\n\n", [dictionary objectForKey:@"STATUS"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Termination Date: %@\n\n", [dictionary objectForKey:@"TERMINATION_DATE"] == [NSNull null] ? @"" : [dictionary objectForKey:@"TERMINATION_DATE"]]];
//    [totalRecallString appendString:[NSString stringWithFormat:@"Voluntary Mandated: %@\n\n", [dictionary objectForKey:@"VOLUNTARY_MANDATED"]]];
//    
//    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] initWithString:totalRecallString];
////    NSRange range1 = NSMakeRange(0,[[NSString stringWithFormat:@"Classification: "] length]);
////    [finalString setAttributes:boldAttribute range:range1];
//    
////    NSRange range2 = NSMakeRange(range1.location + range1.length + [[dictionary objectForKey:@"CLASSIFICATION"] length] + 2,[[NSString stringWithFormat:@"Code Information: "] length]);
////    [finalString setAttributes:boldAttribute range:range2];
//    
//    NSRange range2 = NSMakeRange(0,[[NSString stringWithFormat:@"Code Information: "] length]);
//    [finalString setAttributes:boldAttribute range:range2];
//    
//    NSRange range3 = NSMakeRange(range2.location + range2.length + [[dictionary objectForKey:@"CODE_INFO"] length] + 2,[[NSString stringWithFormat:@"Distribution Pattern: "] length]);
//    [finalString setAttributes:boldAttribute range:range3];
//    
//    NSRange range4 = NSMakeRange(range3.location + range3.length + [[dictionary objectForKey:@"DISTRIBUTION_PATTERN"] length] + 2,[[NSString stringWithFormat:@"Product Description: "] length]);
//    [finalString setAttributes:boldAttribute range:range4];
//    
//    NSRange range5 = NSMakeRange(range4.location + range4.length + [[dictionary objectForKey:@"PRODUCT_DESCRIPTION"] length] + 2,[[NSString stringWithFormat:@"Product Quantity: "] length]);
//    [finalString setAttributes:boldAttribute range:range5];
//    
////    NSRange range6 = NSMakeRange(range5.location + range5.length + [[dictionary objectForKey:@"PRODUCT_QUANTITY"] length] + 2,[[NSString stringWithFormat:@"Product Type: "] length]);
////    [finalString setAttributes:boldAttribute range:range6];
//    
//    NSRange range7 = NSMakeRange(range5.location + range5.length + [[dictionary objectForKey:@"PRODUCT_QUANTITY"] length] + 2,[[NSString stringWithFormat:@"Reason For Recall: "] length]);
//    [finalString setAttributes:boldAttribute range:range7];
//    
//    NSRange range8 = NSMakeRange(range7.location + range7.length + [[dictionary objectForKey:@"REASON_FOR_RECALL"] length] + 2,[[NSString stringWithFormat:@"Recalling Firm: "] length]);
//    [finalString setAttributes:boldAttribute range:range8];
//    
//    NSRange range9 = NSMakeRange(range8.location + range8.length + [[dictionary objectForKey:@"RECALLING_FIRM"] length] + 2,[[NSString stringWithFormat:@"Recall Initiation Date: "] length]);
//    [finalString setAttributes:boldAttribute range:range9];
//    
//    NSRange range10 = NSMakeRange(range9.location + range9.length + [[dictionary objectForKey:@"RECALL_INITIATION_DATE"] length] + 2,[[NSString stringWithFormat:@"Recall Number: "] length]);
//    [finalString setAttributes:boldAttribute range:range10];
//    
//    NSRange range11 = NSMakeRange(range10.location + range10.length + [[dictionary objectForKey:@"RECALL_NUMBER"] length] + 2,[[NSString stringWithFormat:@"Report Date: "] length]);
//    [finalString setAttributes:boldAttribute range:range11];
//    
//    NSRange range12 = NSMakeRange(range11.location + range11.length + [[dictionary objectForKey:@"REPORT_DATE"] length] + 2,[[NSString stringWithFormat:@"Status: "] length]);
//    [finalString setAttributes:boldAttribute range:range12];
//    
//    NSRange range13 = NSMakeRange(range12.location + range12.length + [[dictionary objectForKey:@"STATUS"] length] + 2,[[NSString stringWithFormat:@"Termination Date: "] length]);
//    [finalString setAttributes:boldAttribute range:range13];
//    
//    NSRange range14 = NSMakeRange(range13.location + range13.length + [[dictionary objectForKey:@"TERMINATION_DATE"] length] + 2,[[NSString stringWithFormat:@"Voluntary Mandated: "] length]);
//    [finalString setAttributes:boldAttribute range:range14];
//    
//    if([dictionary objectForKey:@"TERMINATION_DATE"] != [NSNull null])
//    {
////        int length = [[dictionary objectForKey:@"TERMINATION_DATE"] length];
//        
//    }
//    
//        
//    return finalString;
//}

-(void)backButtonAction:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
