//
//  OverViewView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "OverViewView.h"
#import "XYPieChart.h"
#import "ReviewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "OverViewLegendView.h"

@interface OverViewView() <UITableViewDelegate, UITableViewDataSource, XYPieChartDataSource, XYPieChartDelegate, UIGestureRecognizerDelegate>
{
    NSString *productId;
    UITableView *reviewTableView;
    NSMutableArray *reviewArray;
    
    NSDateFormatter *df1;
    NSDateFormatter *df2;
    
    BOOL isServerCallFinished;
    BOOL isAlarmSetForProduct;
    
    OverViewLegendView *boxWarningLegendView;
    OverViewLegendView *pregnancyLegendView;
    OverViewLegendView *sideEffectLegendView;
    OverViewLegendView *drugInteractionLegendView;
    OverViewLegendView *contradictionLegendView;
    OverViewLegendView *allergenLegendView;
    
    UILabel *gradeLabel;
    NSDictionary *overViewDataDictionary;
    BOOL isBookmarkSelected;
    
    UIButton *bookmarkButton;
    UIButton *alarmButton;
}

@end

@implementation OverViewView

@synthesize delegate;

- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId
{
    if ((self = [super initWithFrame:rect]))
    {
        productId = _productId;
        [self commonIntialization];
    }
    return self;
}

-(void)commonIntialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(labelScoreReceived:)
                                                 name:kLabelScoresReceived
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(labelScoreMissing:)
                                                 name:kLabelScoresMissing
                                               object:nil];
    
    overViewDataDictionary = [[NSDictionary alloc] init];
//    NSMutableArray *labelScores = [[NSMutableArray alloc] init];
//    [labelScores addObject:[NSNumber numberWithFloat:25]];
//    [labelScores addObject:[NSNumber numberWithFloat:25]];
//    [labelScores addObject:[NSNumber numberWithFloat:25]];
//    [labelScores addObject:[NSNumber numberWithFloat:25]];
//    [labelScores addObject:[NSNumber numberWithFloat:25]];
//    [labelScores addObject:[NSNumber numberWithFloat:25]];
//    [labelScores addObject:[NSNumber numberWithFloat:25]];
//    
//    NSMutableArray *labelGrades = [[NSMutableArray alloc] init];
//    [labelGrades addObject:@"A"];
//    [labelGrades addObject:@"B"];
//    [labelGrades addObject:@"C"];
//    [labelGrades addObject:@"D"];
//    [labelGrades addObject:@"E"];
//    [labelGrades addObject:@"F"];
//    [labelGrades addObject:@"G"];
//    
//    [overViewDataDictionary setObject:labelScores forKey:@"LABEL_SCORES"];
//    [overViewDataDictionary setObject:labelGrades forKey:@"LABEL_GRADES"];
    
    isBookmarkSelected = NO;
    
    boxWarningLegendView = [[OverViewLegendView alloc] init];
    boxWarningLegendView.legendTitleLabel.text = NSLocalizedString(kOverViewLegendBoxWarning, nil);
    boxWarningLegendView.legendView.backgroundColor = [UIColor colorWithRed:240.0f/255 green:109.0f/255 blue:43.0f/255 alpha:1.0f];
    
    pregnancyLegendView = [[OverViewLegendView alloc] init];
    pregnancyLegendView.legendTitleLabel.text = NSLocalizedString(kOverViewLegendPregnancy, nil);
    pregnancyLegendView.legendView.backgroundColor = [UIColor colorWithRed:157.0f/255 green:198.0f/255 blue:218.0f/255 alpha:1.0f];
    
    sideEffectLegendView = [[OverViewLegendView alloc] init];
    sideEffectLegendView.legendTitleLabel.text = NSLocalizedString(kOverViewLegendSideEffect, nil);
    sideEffectLegendView.legendView.backgroundColor = [UIColor colorWithRed:1.0f/255 green:95.0f/255 blue:133.0f/255 alpha:1.0f];
    
    drugInteractionLegendView = [[OverViewLegendView alloc] init];
    drugInteractionLegendView.legendTitleLabel.text = NSLocalizedString(kOverViewLegendDrugInteractions, nil);
    drugInteractionLegendView.legendView.backgroundColor = [UIColor colorWithRed:40.0f/255 green:143.0f/255 blue:176.0f/255 alpha:1.0f];
    
    contradictionLegendView = [[OverViewLegendView alloc] init];
    contradictionLegendView.legendTitleLabel.text = @"Contraindication";
    contradictionLegendView.legendView.backgroundColor = [UIColor colorWithRed:30.0f/255 green:123.0f/255 blue:26.0f/255 alpha:1.0f];
    
    allergenLegendView = [[OverViewLegendView alloc] init];
    allergenLegendView.legendTitleLabel.text = @"Allergen";
    allergenLegendView.legendView.backgroundColor = [UIColor colorWithRed:100.0f/255 green:43.0f/255 blue:8.0f/255 alpha:1.0f];
    
    reviewArray = [[NSMutableArray alloc] init];
    [self getReviewsFromServer];
    [self checkProductBookmark];
    
    reviewTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    reviewTableView.backgroundColor = [UIColor clearColor];
    reviewTableView.delegate = self;
    reviewTableView.dataSource = self;
    CGFloat dummyViewHeight = 600;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, reviewTableView.bounds.size.width, dummyViewHeight)];
    reviewTableView.tableHeaderView = dummyView;
    reviewTableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 200, 0);
    reviewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    reviewTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:reviewTableView];
    
    df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"MMMM'-'dd'-'y"];
}

-(void)labelScoreReceived:(NSNotification*)notification
{
    overViewDataDictionary = [notification userInfo];
    [reviewTableView reloadData];
}

-(void)labelScoreMissing:(NSNotification*)notification
{
    overViewDataDictionary = [notification userInfo];
    [reviewTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!isServerCallFinished)
    {
        return 1;
    }
    else if(isServerCallFinished && reviewArray.count == 0)
    {
        return 1;
    }
    return reviewArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ReviewCellId";
    ReviewTableViewCell *cell;
    if(cell == nil)
    {
        cell = [[ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if(!isServerCallFinished)
    {
        cell.textLabel.text = NSLocalizedString(kReviewLoading, nil);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else if(isServerCallFinished && reviewArray.count == 0)
    {
        cell.textLabel.text = NSLocalizedString(kReviewNoData, nil);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        NSDictionary *reviewObject = [reviewArray objectAtIndex:indexPath.row];
        if([reviewObject objectForKey:@"FIRST_NAME"] != [NSNull null] && [reviewObject objectForKey:@"FIRST_NAME"] != nil)
        {
            cell.nameLabel.text = [reviewObject objectForKey:@"FIRST_NAME"];
        }
        else
        {
            if([reviewObject objectForKey:@"USER_INFO"] != nil && [reviewObject objectForKey:@"USER_INFO"] != [NSNull null])
            {
                if(![[reviewObject objectForKey:@"USER_INFO"] isEqualToString:@""])
                {
                    cell.nameLabel.text = [reviewObject objectForKey:@"USER_INFO"];
                }
                else
                {
                    cell.nameLabel.text = NSLocalizedString(kReviewAnonymus, nil);
                }
            }
            else
            {
                cell.nameLabel.text = NSLocalizedString(kReviewAnonymus, nil);
            }
        }
        
        cell.dateLabel.text = [df2 stringFromDate:[df1 dateFromString:[reviewObject objectForKey:@"REVIEW_DATE"]]];
        if([[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] integerValue] > 0)
        {
            cell.ratingLabel.text = [NSString stringWithFormat:@"Rating: %@ / 10",[reviewObject objectForKey:@"ORIGINAL_USER_RATING"]];
        }
        cell.contentLabel.text = [reviewObject objectForKey:@"CONTENT"];
        if([reviewObject objectForKey:@"IMAGE_LINK"] != [NSNull null] && [reviewObject objectForKey:@"IMAGE_LINK"] != nil)
        {
            [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[reviewObject objectForKey:@"IMAGE_LINK"]] placeholderImage:[UIImage imageNamed:@"ProfileIcon.png"]];
        }
        else
        {
            cell.userImageView.image = [UIImage imageNamed:@"ProfileIcon.png"];
        }
        
        if([reviewObject objectForKey:@"DATA_SOURCE_ID"] != [NSNull null] && [reviewObject objectForKey:@"DATA_SOURCE_ID"] != nil && [[reviewObject objectForKey:@"DATA_SOURCE_ID"] integerValue] != 1001)
        {
            cell.dataSourceLabel.text = [NSString stringWithFormat:@"Source: %@",[reviewObject objectForKey:@"DATA_SOURCE_NAME"]];
        }
        
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 0.5f;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGSize textSize = [[[reviewArray objectAtIndex:indexPath.row] objectForKey:@"CONTENT"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    if(!isServerCallFinished)
    {
        return 80.0f;
    }
    else if(isServerCallFinished && reviewArray.count == 0)
    {
        return 80.0f;
    }
    CGRect r = [[[reviewArray objectAtIndex:indexPath.row] objectForKey:@"CONTENT"] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 1000)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                  context:nil];
    
    if(indexPath.row == (reviewArray.count - 1))
    {
        reviewTableView.contentInset = UIEdgeInsetsMake(-600, 0, r.size.height + 40.0f + r.size.height + 40.0f, 0);
    }
    
    return r.size.height + 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 320.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25)];
    if (section == 0)
    {
        [headerView setBackgroundColor:[UIColor clearColor]];
        CGRect frame = headerView.frame;
        frame.size.height = 320;
        headerView.frame = frame;
        
        bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bookmarkButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, headerView.frame.size.height - 40, 100, 40);
        [bookmarkButton setTitle:@"Bookmark" forState:UIControlStateNormal];
        if(!isBookmarkSelected)
        {
            [bookmarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            [bookmarkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        [bookmarkButton addTarget:self action:@selector(bookmarkButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:bookmarkButton];
        
        alarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [alarmButton setTitle:@"Alarm" forState:UIControlStateNormal];
        alarmButton.frame = CGRectMake(bookmarkButton.frame.origin.x + bookmarkButton.frame.size.width + 10, bookmarkButton.frame.origin.y, 100, 40);
        [alarmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        isAlarmSetForProduct = NO;
        for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
        {
            if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
            {
                [alarmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                isAlarmSetForProduct = YES;
                break;
            }
        }
        [alarmButton addTarget:self action:@selector(alarmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:alarmButton];
        
        UIButton * postReviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        postReviewButton.frame = CGRectMake(0, bookmarkButton.frame.origin.y, bookmarkButton.frame.origin.x, 40);
        [postReviewButton setTitle:@"Post" forState:UIControlStateNormal];
        [postReviewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [postReviewButton addTarget:self action:@selector(postReviewButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:postReviewButton];
        
        if(![overViewDataDictionary objectForKey:@"LABEL_SCORES"])
        {
            UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 40)];
            loadingLabel.text = @"Loading...";
            loadingLabel.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:loadingLabel];
        }
        else if([[overViewDataDictionary objectForKey:@"LABEL_SCORES"] count] == 0)
        {
            UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 40)];
            noDataLabel.text = @"No score available for this product";
            noDataLabel.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:noDataLabel];
        }
        else
        {
            boxWarningLegendView.frame = CGRectMake(0, headerView.frame.origin.y + 10, [UIScreen mainScreen].bounds.size.width/4, [[[overViewDataDictionary objectForKey:@"LABEL_SCORES"] objectAtIndex:0] floatValue] == 0 ? 0 : 20);
            [headerView addSubview:boxWarningLegendView];
            pregnancyLegendView.frame = CGRectMake(0, boxWarningLegendView.frame.origin.y + boxWarningLegendView.frame.size.height, [UIScreen mainScreen].bounds.size.width/4, [[[overViewDataDictionary objectForKey:@"LABEL_SCORES"] objectAtIndex:1] floatValue] == 0 ? 0 : 20);
            [headerView addSubview:pregnancyLegendView];
            sideEffectLegendView.frame = CGRectMake(0, pregnancyLegendView.frame.origin.y + pregnancyLegendView.frame.size.height, [UIScreen mainScreen].bounds.size.width/4, [[[overViewDataDictionary objectForKey:@"LABEL_SCORES"] objectAtIndex:2] floatValue] == 0 ? 0 : 20);
//            NSLog(@"%d", [[[overViewDataDictionary objectForKey:@"LABEL_SCORES"] objectAtIndex:2] intValue] == 0 ? 0 : 20);
            [headerView addSubview:sideEffectLegendView];
            drugInteractionLegendView.frame = CGRectMake(0, sideEffectLegendView.frame.origin.y + sideEffectLegendView.frame.size.height, [UIScreen mainScreen].bounds.size.width/4, [[[overViewDataDictionary objectForKey:@"LABEL_SCORES"] objectAtIndex:3] floatValue] == 0 ? 0 : 20);
            [headerView addSubview:drugInteractionLegendView];
            contradictionLegendView.frame = CGRectMake(0, drugInteractionLegendView.frame.origin.y + drugInteractionLegendView.frame.size.height, [UIScreen mainScreen].bounds.size.width/4, [[[overViewDataDictionary objectForKey:@"LABEL_SCORES"] objectAtIndex:4] floatValue] == 0 ? 0 : 20);
            [headerView addSubview:contradictionLegendView];
            allergenLegendView.frame = CGRectMake(0, contradictionLegendView.frame.origin.y + contradictionLegendView.frame.size.height, [UIScreen mainScreen].bounds.size.width/4, [[[overViewDataDictionary objectForKey:@"LABEL_SCORES"] objectAtIndex:5] floatValue] == 0 ? 0 : 20);
            [headerView addSubview:allergenLegendView];
            
            XYPieChart *pieChart1 = [[XYPieChart alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4, 40, 200, 200)];
            float viewWidth = pieChart1.bounds.size.width/2;
            float viewHeight = pieChart1.bounds.size.height/2;
            [pieChart1 setDelegate:self];
            [pieChart1 setDataSource:self];
            [pieChart1 setStartPieAngle:0];
            [pieChart1 setUserInteractionEnabled:YES];
            [pieChart1 setLabelColor:[UIColor blackColor]];
            [pieChart1 setPieRadius:100];
            [pieChart1 setShowPercentage:NO];
            [pieChart1 setShowLabel:NO];
            [headerView addSubview:pieChart1];
            [pieChart1 setPieCenter:CGPointMake(pieChart1.bounds.origin.x + viewWidth, pieChart1.bounds.origin.y + viewHeight)];
            [pieChart1 reloadData];
            
            gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4 + viewWidth/2, pieChart1.bounds.origin.y + viewHeight/2 + 40, 100, 100)];
            gradeLabel.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
            gradeLabel.text = [NSString stringWithFormat:@"%@",[[overViewDataDictionary objectForKey:@"LABEL_GRADES"] lastObject]];
            gradeLabel.font = [UIFont boldSystemFontOfSize:33.0f];
            gradeLabel.textAlignment = NSTextAlignmentCenter;
            gradeLabel.layer.masksToBounds = YES;
            [gradeLabel.layer setCornerRadius:50];
            [headerView addSubview:gradeLabel];
        }
    }
    else
    {
        [headerView setBackgroundColor:[UIColor clearColor]];
    }
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 6;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    NSArray *scores = [overViewDataDictionary objectForKey:@"LABEL_SCORES"];
    if(scores.count > 0)
    {
        return [[scores objectAtIndex:index] floatValue];
    }
    return 0;
}
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return [UIColor colorWithRed:240.0f/255 green:109.0f/255 blue:43.0f/255 alpha:1.0f];
        case 1:
            return [UIColor colorWithRed:157.0f/255 green:198.0f/255 blue:218.0f/255 alpha:1.0f];
        case 2:
            return [UIColor colorWithRed:1.0f/255 green:95.0f/255 blue:133.0f/255 alpha:1.0f];
        case 3:
            return [UIColor colorWithRed:40.0f/255 green:143.0f/255 blue:176.0f/255 alpha:1.0f];
        case 4:
            return [UIColor colorWithRed:30.0f/255 green:123.0f/255 blue:26.0f/255 alpha:1.0f];
        case 5:
            return [UIColor colorWithRed:100.0f/255 green:43.0f/255 blue:8.0f/255 alpha:1.0f];
            
        default:
            break;
    }
    return [UIColor whiteColor];
}

//-(NSString*)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
//{
//    return @"BOX warning";
//}

-(void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    float alphaLevel = 0.3f;
    boxWarningLegendView.alpha = alphaLevel;
    pregnancyLegendView.alpha = alphaLevel;
    sideEffectLegendView.alpha = alphaLevel;
    drugInteractionLegendView.alpha = alphaLevel;
    contradictionLegendView.alpha = alphaLevel;
    allergenLegendView.alpha = alphaLevel;
    if(index == 0)
    {
        boxWarningLegendView.alpha = 1.0f;
    }
    else if(index == 1)
    {
        pregnancyLegendView.alpha = 1.0f;
    }
    else if(index == 2)
    {
        sideEffectLegendView.alpha = 1.0f;
    }
    else if(index == 3)
    {
        drugInteractionLegendView.alpha = 1.0f;
    }
    else if(index == 4)
    {
        contradictionLegendView.alpha = 1.0f;
    }
    else if(index == 5)
    {
        allergenLegendView.alpha = 1.0f;
    }
    NSArray *grades = [overViewDataDictionary objectForKey:@"LABEL_GRADES"];
    gradeLabel.text = [NSString stringWithFormat:@"%@",[grades objectAtIndex:index]];
}

-(void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    boxWarningLegendView.alpha = 1.0f;
    pregnancyLegendView.alpha = 1.0f;
    sideEffectLegendView.alpha = 1.0f;
    drugInteractionLegendView.alpha = 1.0f;
    contradictionLegendView.alpha = 1.0f;
    allergenLegendView.alpha = 1.0f;
    gradeLabel.text = [NSString stringWithFormat:@"%@",[[overViewDataDictionary objectForKey:@"LABEL_GRADES"] lastObject]];
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
            [bookmarkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
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
    [bookmarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [alarmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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
                        [bookmarkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    }
                    else
                    {
                        isBookmarkSelected = NO;
                        [bookmarkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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

-(void)getReviewsFromServer
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:getUserReviews];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:productId, @"PRODUCT_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
//    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            isServerCallFinished = YES;
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [reviewArray removeAllObjects];
                    NSArray *arr = [NSArray arrayWithArray:[dataJSON objectForKey:@"REVIEW_LIST"]];
                    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                        NSDate *d1 = [df1 dateFromString:obj1[@"REVIEW_DATE"]];
                        NSDate *d2 = [df1 dateFromString:obj2[@"REVIEW_DATE"]];
                        
                        return [d2 compare:d1]; // descending order
                    }];
                    [reviewArray addObjectsFromArray:arr];
                    [reviewTableView reloadData];
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
