//
//  SearchViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/11/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "SearchViewController.h"
#import "Product.h"
#import "ProductDetailV2ViewController.h"
#import "HistoryViewController.h"
#import "SearchCell.h"
#import "OverViewLegendView.h"
#import "FilterViewController.h"

#define resultsPerPage 200

#define kOtc            @"OTC"
#define kSupplement     @"Supplement"
#define kPrescription   @"Prescription"
#define kHomeopathic    @"Homeopathic"
#define kMedicine       @"proprietary_name"
#define kIngredient     @"ingredient_synonyms"
#define kDisease        @"disease_synonyms"
#define kSymptom        @"symptom_synonyms"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView *searchTableView;
    
    NSMutableArray *productNameArray;
    NSMutableArray *suggestionArray;
    NSMutableArray *historyProductNameArray;
    NSMutableArray *rawResultArray;
    UITextField *searchTextField;
    
    NSTimer *typeTimer;
    BOOL isServerCallFinished;
    
    UIView *legendView;
    UIButton *legendButton;
    
    int maxPage;
    
    NSString *otcString;
    NSString *supplementString;
    NSString *prescriptionString;
    NSString *homeopathicString;
    NSString *medicineNameString;
    NSString *ingredientString;
    NSString *diseaseString;
    NSString *symptomString;
}

@end

@implementation SearchViewController

@synthesize historyArray;

-(void)loadView
{
    [super loadView];
    
    maxPage = resultsPerPage;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showKeyBoardInfo:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeyBoard)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filteredArrayReceived:)
                                                 name:@"filteredArrayPosted"
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self initializeFilterStrings];
    
    isServerCallFinished = NO;
    
    typeTimer = [[NSTimer alloc] init];
    
    productNameArray = [[NSMutableArray alloc] initWithArray:[ServerCommunicationUser getProductArray]];
    suggestionArray = [[NSMutableArray alloc] init];
    rawResultArray = [[NSMutableArray alloc] init];
    
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
    
    searchTextField = [[UITextField alloc] init];
    searchTextField.delegate = self;
    searchTextField.placeholder = NSLocalizedString(kSearchTextFieldPlaceholder, nil);
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchTextField.autocapitalizationType = UITextAutocorrectionTypeNo;
    searchTextField.frame = CGRectMake(5, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width - 10, 40);
    [searchTextField becomeFirstResponder];
    [self.view addSubview:searchTextField];
    
    UIView *separatorLineTextField = [[UIView alloc] initWithFrame:CGRectMake(5, searchTextField.frame.origin.y + searchTextField.frame.size.height + 1, [UIScreen mainScreen].bounds.size.width - 10, 1)];
    separatorLineTextField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:separatorLineTextField];
    
    searchTableView = [[UITableView alloc] init];
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTableView.backgroundColor = [UIColor whiteColor];
    searchTableView.hidden = NO;
    searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    searchTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchTableView.layer.borderWidth = 0.5f;
    searchTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [self.view addSubview:searchTableView];
    
    historyProductNameArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in historyArray)
    {
        [historyProductNameArray addObject:[dict objectForKey:@"PROPRIETARY_NAME"]];
    }
    historyProductNameArray = [historyProductNameArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    historyProductNameArray = (NSMutableArray*)[historyProductNameArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    searchTableView.frame = CGRectMake(0, searchTextField.frame.origin.y + searchTextField.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - searchTextField.frame.size.height);
    
    legendView = [[UIView alloc] initWithFrame:CGRectMake(customNavigationBar.frame.size.width - 120, 59, 120, 0)];
    legendView.backgroundColor = [UIColor whiteColor];
    legendView.clipsToBounds = YES;
    legendView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    legendView.layer.borderWidth = 1.0f;
    [self.view addSubview:legendView];
    
    legendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    legendButton.frame = CGRectMake(customNavigationBar.frame.size.width - 60, 15, 30, 30);
    [legendButton setBackgroundImage:[UIImage imageNamed:@"filterIcon.png"] forState:UIControlStateNormal];
    [legendButton setBackgroundImage:[UIImage imageNamed:@"filterIcon.png"] forState:UIControlStateHighlighted];
    [legendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [legendButton addTarget:self action:@selector(legendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:legendButton];
    
    OverViewLegendView *otc = [[OverViewLegendView alloc] init];
    otc.legendTitleLabel.text = @"OTC";
    otc.legendView.backgroundColor = [UIColor yellowColor];
    otc.frame = CGRectMake(0, 5, 120, 20);
    otc.legendTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [legendView addSubview:otc];
    
    OverViewLegendView *prescription = [[OverViewLegendView alloc] init];
    prescription.legendTitleLabel.text = @"Prescription";
    prescription.legendView.backgroundColor = [UIColor blueColor];
    prescription.frame = CGRectMake(0, 30, 120, 20);
    prescription.legendTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [legendView addSubview:prescription];
    
    OverViewLegendView *homeopathic = [[OverViewLegendView alloc] init];
    homeopathic.legendTitleLabel.text = @"Homeopathic";
    homeopathic.legendView.backgroundColor = [UIColor cyanColor];
    homeopathic.frame = CGRectMake(0, 55, 120, 20);
    homeopathic.legendTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [legendView addSubview:homeopathic];
    
    OverViewLegendView *supplement = [[OverViewLegendView alloc] init];
    supplement.legendTitleLabel.text = @"Supplement";
    supplement.legendView.backgroundColor = [UIColor greenColor];
    supplement.frame = CGRectMake(0, 80, 120, 20);
    supplement.legendTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [legendView addSubview:supplement];
    
    OverViewLegendView *other = [[OverViewLegendView alloc] init];
    other.legendTitleLabel.text = @"Other";
    other.legendView.backgroundColor = [UIColor grayColor];
    other.frame = CGRectMake(0, 105, 120, 20);
    other.legendTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [legendView addSubview:other];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [searchTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initializeFilterStrings
{
    otcString = kOtc;
    supplementString = kSupplement;
    prescriptionString = kPrescription;
    homeopathicString = kHomeopathic;
    medicineNameString = kMedicine;
    ingredientString = kIngredient;
    diseaseString = kDisease;
    symptomString = kSymptom;
}

-(void)legendButtonAction
{
    FilterViewController *vc = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    vc.resultArray = rawResultArray;
    vc.otcString = otcString;
    vc.supplementString = supplementString;
    vc.prescriptionString = prescriptionString;
    vc.homeopathicString = homeopathicString;
    vc.medicineNameString = medicineNameString;
    vc.ingredientString = ingredientString;
    vc.diseaseString = diseaseString;
    vc.symptomString = symptomString;
    [self presentViewController:vc animated:YES completion:nil];
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    
//    if(legendView.frame.size.height == 0) 
//    {
//        CGRect frame = legendView.frame;
//        frame.size.height = 130;
//        legendView.frame = frame;
//    }
//    else
//    {
//        CGRect frame = legendView.frame;
//        frame.size.height = 0;
//        legendView.frame = frame;
//    }
//    
//    [UIView commitAnimations];
}

-(void)filteredArrayReceived:(NSNotification*)_notification
{
    [suggestionArray removeAllObjects];
    [suggestionArray addObjectsFromArray:[_notification.userInfo objectForKey:@"Filtered"]];
    
    otcString = [_notification.userInfo objectForKey:kOtc];
    supplementString = [_notification.userInfo objectForKey:kSupplement];
    prescriptionString = [_notification.userInfo objectForKey:kPrescription];
    homeopathicString = [_notification.userInfo objectForKey:kHomeopathic];
    medicineNameString = [_notification.userInfo objectForKey:kMedicine];
    ingredientString = [_notification.userInfo objectForKey:kIngredient];
    diseaseString = [_notification.userInfo objectForKey:kDisease];
    symptomString = [_notification.userInfo objectForKey:kSymptom];
    
    [searchTableView reloadData];
}

-(void)showKeyBoardInfo:(NSNotification*)notification
{
    if([searchTextField.text length] == 0)
    {
        searchTableView.hidden = NO;
        [searchTableView reloadData];
    }
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    searchTableView.frame = CGRectMake(0, searchTextField.frame.origin.y + searchTextField.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - searchTextField.frame.size.height - searchTextField.frame.origin.y - keyboardFrameBeginRect.size.height - 2);
    
    [UIView commitAnimations];
}

-(void)hideKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    searchTableView.frame = CGRectMake(0, searchTextField.frame.origin.y + searchTextField.frame.size.height + 1, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - searchTextField.frame.size.height);
    
    [UIView commitAnimations];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)tempButtonAction:(UIButton*)sender
{
    ProductDetailV2ViewController *vc = [[ProductDetailV2ViewController alloc] initWithNibName:@"ProductDetailV2ViewController" bundle:nil];
    vc.productId = [NSString stringWithFormat:@"%@",@"1000000001"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)startTimer
{
    [self stopTimer];
    typeTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                 target:self
                                               selector:@selector(timerAction)
                                               userInfo:nil
                                                repeats:NO];
}

-(void)stopTimer
{
    [typeTimer invalidate];
    typeTimer = nil;
}

-(void)timerAction
{
    [self searchInDB];
    [self stopTimer];
}

-(void)searchInDB
{
    [suggestionArray removeAllObjects];
    [self getProductsByName:searchTextField.text];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Search"
                                                           label:searchTextField.text
                                                           value:nil] build]];
    searchTableView.hidden = NO;
    isServerCallFinished = NO;
    [searchTableView reloadData];
}

-(void)textFieldChanged
{
    searchTableView.hidden = YES;
    [self initializeFilterStrings];
    maxPage = resultsPerPage;
    [self stopTimer];
    if([searchTextField.text length] > 2)
    {
        [self startTimer];
    }
    
    if([searchTextField.text length] == 0)
    {
        searchTableView.hidden = NO;
        [searchTableView reloadData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchInDB];
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([searchTextField.text length] == 0)
    {
        return historyProductNameArray.count + 1;
    }
    else if(!isServerCallFinished)
    {
        return 1;
    }
    else if(isServerCallFinished && suggestionArray.count == 0)
    {
        return 1;
    }
    return suggestionArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdProduct";
    SearchCell *cell;
    if(cell == nil)
    {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if([searchTextField.text length] == 0)
    {
        if(indexPath.row < historyProductNameArray.count)
        {
            cell.textLabel.text = [historyProductNameArray objectAtIndex:indexPath.row];
            cell.textLabel.minimumScaleFactor = 0.5f;
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
        }
        else
        {
            cell.textLabel.text = NSLocalizedString(kAllHistory, nil);
            cell.textLabel.textColor = [UIColor greenColor];
            cell.textLabel.font = [UIFont systemFontOfSize:19.0f];
        }
    }
    else
    {
        if(!isServerCallFinished)
        {
            cell.textLabel.text = NSLocalizedString(kSearching, nil);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        else if(isServerCallFinished && suggestionArray.count == 0)
        {
            cell.textLabel.text = NSLocalizedString(kNoResult, nil);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        else
        {
            NSDictionary *product = [suggestionArray objectAtIndex:indexPath.row];
            if([product objectForKey:@"PRODUCT_PROPRIETARY_NAME"] && [product objectForKey:@"PRODUCT_PROPRIETARY_NAME"] != [NSNull null])
            {
                cell.productNameLabel.text = [product objectForKey:@"PRODUCT_PROPRIETARY_NAME"];
            }
            
            NSMutableString *typeFinalString = [[NSMutableString alloc] init];
            
            if([product objectForKey:@"PRODUCT_TYPE"] && [product objectForKey:@"PRODUCT_TYPE"] != [NSNull null])
            {
                NSString *typeString = [product objectForKey:@"PRODUCT_TYPE"];
                if([typeString isEqualToString:@"OTC"])
                {
                    [typeFinalString appendString:NSLocalizedString(kFilterOTC, nil)];
                }
                else if([typeString isEqualToString:@"Prescription"])
                {
                    [typeFinalString appendString:NSLocalizedString(kFilterPrescription, nil)];
                }
                else if([typeString isEqualToString:@"Homeopathic"])
                {
                    [typeFinalString appendString:NSLocalizedString(kFilterHomeopathic, nil)];
                }
                else if([typeString isEqualToString:@"Supplement"])
                {
                    [typeFinalString appendString:NSLocalizedString(kFilterSupplement, nil)];
                }
            }
            
            [typeFinalString appendString:@" "];
            
            if([product objectForKey:@"ENTITY_TYPE"] && [product objectForKey:@"ENTITY_TYPE"] != [NSNull null])
            {
                NSString *typeString = [product objectForKey:@"ENTITY_TYPE"];
                if([typeString isEqualToString:@"ingredient_synonyms"])
                {
                    [typeFinalString appendString:NSLocalizedString(kFilterIngredient, nil)];
                }
                else if([typeString isEqualToString:@"proprietary_name"])
                {
                    [typeFinalString appendString:NSLocalizedString(kFilterName, nil)];
                }
                else if([typeString isEqualToString:@"symptom_synonyms"])
                {
                    [typeFinalString appendString:NSLocalizedString(kFilterSymptom, nil)];
                }
                else if([typeString isEqualToString:@"disease_synonyms"])
                {
                    [typeFinalString appendString:NSLocalizedString(kFilterDiseaseName, nil)];
                }
            }
            
            cell.sourceLabel.text = typeFinalString;
            
            NSArray *imageArray = [product objectForKey:@"Image_Link"];
            if(imageArray.count > 0)
            {
                [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:[[imageArray objectAtIndex:0] objectForKey:@"image_link"]] placeholderImage:[UIImage imageNamed:@"noImageAvailable.png"]];
            }
            else
            {
                cell.productImageView.image = [UIImage imageNamed:@"noImageAvailable.png"];
            }
            
            cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.contentView.layer.borderWidth = 0.25f;
            
            if (indexPath.row == [suggestionArray count] - 1 && [rawResultArray count] == maxPage)
            {
                maxPage += resultsPerPage;
                [self getProductsByName:searchTextField.text];
            }
        }
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(searchTextField.text.length == 0)
    {
        return 44.0f;
    }
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *productId = @"";
    if([searchTextField.text length] == 0)
    {
        if(indexPath.row < historyProductNameArray.count)
        {
            for(NSDictionary *dict in historyArray)
            {
                if([[dict objectForKey:@"PROPRIETARY_NAME"] isEqualToString:[historyProductNameArray objectAtIndex:indexPath.row]])
                {
                    productId = [dict objectForKey:@"PRODUCT_ID"];
                    break;
                }
            }
            [self goToProductDetailWithProductId:productId ProductName:[historyProductNameArray objectAtIndex:indexPath.row]];
        }
        else
        {
            NSArray *arr = historyArray;
            NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
            [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
            NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
            [df2 setDateFormat:@"MMMM'-'dd'-'y"];
            NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
            [df3 setDateFormat:@"hh':'mm' 'a"];
            
            arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                NSDate *d1 = [df1 dateFromString:obj1[@"Date"]];
                NSDate *d2 = [df1 dateFromString:obj2[@"Date"]];
                
                return [d2 compare:d1]; // descending order
            }];
            NSMutableArray *dateArray = [[NSMutableArray alloc] init];
            NSMutableArray *uniqueDateArray = [NSMutableArray array];
            NSMutableSet *processedSet = [[NSMutableSet alloc] init];
            for(NSDictionary *dict in arr)
            {
                NSDate *date = [df1 dateFromString: [dict objectForKey:@"Date"]];
                [dateArray addObject:[df2 stringFromDate:date]];
            }
            
            for(NSString *str in dateArray)
            {
                if(![processedSet containsObject:str])
                {
                    [uniqueDateArray addObject:str];
                    [processedSet addObject:str];
                }
            }
            
            NSMutableArray *finalArray = [[NSMutableArray alloc] init];
            for(int i = 0; i < [uniqueDateArray count]; i++)
            {
                NSMutableArray *tmpProdArr = [[NSMutableArray alloc] init];
                NSMutableArray *tmpProdIdArr = [[NSMutableArray alloc] init];
                NSMutableArray *timeArr = [[NSMutableArray alloc] init];
                
                for(NSDictionary *dict in arr)
                {
                    if([[uniqueDateArray objectAtIndex:i] isEqualToString:[df2 stringFromDate:[df1 dateFromString:[dict objectForKey:@"Date"]]]])
                    {
                        [tmpProdArr addObject:[dict objectForKey:@"PROPRIETARY_NAME"]];
                        [tmpProdIdArr addObject:[dict objectForKey:@"PRODUCT_ID"]];
                        [timeArr addObject:[df3 stringFromDate:[df1 dateFromString:[dict objectForKey:@"Date"]]]];
                    }
                }
                NSDictionary *totalObjectDict = [[NSDictionary alloc] initWithObjectsAndKeys:tmpProdArr, @"productName", tmpProdIdArr, @"productId", timeArr, @"time", nil];
                NSDictionary *tmpDic = [[NSDictionary alloc] initWithObjectsAndKeys:totalObjectDict, [uniqueDateArray objectAtIndex:i], nil];
                [finalArray addObject:tmpDic];
            }
            
            HistoryViewController *vc = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil withHistoryArray:finalArray DateArray:uniqueDateArray];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        if(!isServerCallFinished || (isServerCallFinished && suggestionArray.count == 0))
        {
            
        }
        else
        {
            productId = [[suggestionArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_ID"];
            [self goToProductDetailWithProductId:productId ProductName:[[suggestionArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_PROPRIETARY_NAME"]];
        }
    }
}

-(void)goToProductDetailWithProductId:(NSString*)productId ProductName:(NSString*)name;
{
    [ServerCommunicationUser insertIntoSearchHistoryByProductId:productId byUserId:[UserDefaultsManager getUserId]];
    ProductDetailV2ViewController *vc = [[ProductDetailV2ViewController alloc] initWithNibName:@"ProductDetailV2ViewController" bundle:nil];
    vc.productId = productId;
    vc.productName = name;
    [self stopTimer];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Selected Product"
                                                           label:name
                                                           value:nil] build]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getProductsByName:(NSString*)name
{
//    NSURL *URL = [NSURL URLWithString:searchProduct];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
//    [request setHTTPMethod:@"POST"];
//    
//    NSError *error;
//    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"PROPRIETARY_NAME", nil];
//    
//    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:maxPage], @"maxPerPage", queryDictionary, @"Queries",nil];
//    NSLog(@"%@",mapData);
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    [request setHTTPBody:postData];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:productGenericAutoComplete];
    [urlStr appendString:[NSString stringWithFormat:@"?term=%@",name]];
    [urlStr appendString:[NSString stringWithFormat:@"&maxPerPage=%@",[NSString stringWithFormat:@"%d",maxPage]]];
    [urlStr appendString:[NSString stringWithFormat:@"&currPage=%@",@"0"]];
    
    NSString *finalUrlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"search product %@",finalUrlStr);
    NSURL *url = [NSURL URLWithString:finalUrlStr];
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
//            NSLog(@"%@",dataJSON);
            isServerCallFinished = YES;
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [rawResultArray removeAllObjects];
                    [rawResultArray addObjectsFromArray:[dataJSON objectForKey:@"Data"]];
                    
                    [suggestionArray removeAllObjects];
                    for(NSDictionary *dict in [dataJSON objectForKey:@"Data"])
                    {
                        if([[dict objectForKey:@"PRODUCT_TYPE"] isEqualToString:otcString])
                        {
                            if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:medicineNameString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:ingredientString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:diseaseString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:symptomString])
                            {
                                [suggestionArray addObject:dict];
                            }
                        }
                        else if([[dict objectForKey:@"PRODUCT_TYPE"] isEqualToString:supplementString])
                        {
                            if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:medicineNameString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:ingredientString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:diseaseString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:symptomString])
                            {
                                [suggestionArray addObject:dict];
                            }
                        }
                        else if([[dict objectForKey:@"PRODUCT_TYPE"] isEqualToString:prescriptionString])
                        {
                            if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:medicineNameString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:ingredientString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:diseaseString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:symptomString])
                            {
                                [suggestionArray addObject:dict];
                            }
                        }
                        else if([[dict objectForKey:@"PRODUCT_TYPE"] isEqualToString:homeopathicString])
                        {
                            if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:medicineNameString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:ingredientString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:diseaseString])
                            {
                                [suggestionArray addObject:dict];
                            }
                            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:symptomString])
                            {
                                [suggestionArray addObject:dict];
                            }
                        }
                    }
                    [searchTableView reloadData];
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
