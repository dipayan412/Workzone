//
//  ReviewView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/29/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ReviewView.h"
#import "ReviewTableViewCell.h"

@interface ReviewView() <UITableViewDelegate, UITableViewDataSource>
{
    NSString *productId;
    BOOL isServerCallFinished;
    NSMutableArray *reviewArray;
    NSDateFormatter *df1;
    NSDateFormatter *df2;
    UITableView *reviewTableView;
    
    int totalRatedReview;
    int reviewRating1;
    int reviewRating2;
    int reviewRating3;
    int reviewRating4;
    int reviewRating5;
}

@end

@implementation ReviewView

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
    
    totalRatedReview = 0;
    reviewRating1 = 0;
    reviewRating2 = 0;
    reviewRating3 = 0;
    reviewRating4 = 0;
    reviewRating5 = 0;
    
    reviewArray = [[NSMutableArray alloc] init];
    df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"MMMM'-'dd'-'y"];
    [self getReviewsFromServer];
    
    reviewTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height)];
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
        if([[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] integerValue] > 1)
        {
            int value = [[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] intValue] > 5 ? [[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] intValue] / 2 : [[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] intValue];
            cell.ratingLabel.text = [NSString stringWithFormat:@"Rating: %d / 5", value];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(reviewArray.count < 1)
    {
//        return 82.0f/677 * ([UIScreen mainScreen].bounds.size.width - 40);
        return 0;
    }
    if(totalRatedReview < 1)
    {
//        return 82.0f/677 * ([UIScreen mainScreen].bounds.size.width - 40);
        return 0;
    }
    return 200;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(reviewArray.count < 1 || totalRatedReview < 1)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 82.0f/677 * ([UIScreen mainScreen].bounds.size.width - 40))];
        headerView.backgroundColor = [UIColor clearColor];
        
        UIButton *postReviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [postReviewButton setImage:[UIImage imageNamed:@"postReviewButton.png"] forState:UIControlStateNormal];
        postReviewButton.frame = CGRectMake(20, 0, ([UIScreen mainScreen].bounds.size.width - 40), 82.0f/677 * ([UIScreen mainScreen].bounds.size.width - 40));
        [postReviewButton addTarget:self action:@selector(postReviewButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:postReviewButton];
        
        return headerView;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 240)];
    headerView.backgroundColor = [UIColor clearColor];
    
    int totalWidth = 200;
    
    if([UIScreen mainScreen].bounds.size.width <= 320)
    {
        totalWidth = 100;
    }
    
    UIView *reviewRating5View = [[UIView alloc] initWithFrame:CGRectMake(130, 20, (float)reviewRating5/totalRatedReview*totalWidth, 20)];
    reviewRating5View.backgroundColor = [UIColor colorWithRed:255.0f/255 green:170.0f/255 blue:0.0f/255 alpha:1.0f];
    [headerView addSubview:reviewRating5View];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = reviewRating5View.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0f/255 green:200.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:247.0f/255 green:169.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], nil];
    [reviewRating5View.layer insertSublayer:gradient atIndex:0];
    
    UIView *reviewRating4View = [[UIView alloc] initWithFrame:CGRectMake(130, reviewRating5View.frame.origin.y + reviewRating5View.frame.size.height + 10, (float)reviewRating4/totalRatedReview*totalWidth, 20)];
    reviewRating4View.backgroundColor = [UIColor colorWithRed:255.0f/255 green:170.0f/255 blue:0.0f/255 alpha:1.0f];
    [headerView addSubview:reviewRating4View];
    
    gradient = [CAGradientLayer layer];
    gradient.frame = reviewRating4View.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0f/255 green:200.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:247.0f/255 green:169.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], nil];
    [reviewRating4View.layer insertSublayer:gradient atIndex:0];
    
    UIView *reviewRating3View = [[UIView alloc] initWithFrame:CGRectMake(130, reviewRating4View.frame.origin.y + reviewRating4View.frame.size.height + 10, (float)reviewRating3/totalRatedReview*totalWidth, 20)];
    reviewRating3View.backgroundColor = [UIColor colorWithRed:255.0f/255 green:170.0f/255 blue:0.0f/255 alpha:1.0f];
    [headerView addSubview:reviewRating3View];
    
    gradient = [CAGradientLayer layer];
    gradient.frame = reviewRating3View.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0f/255 green:200.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:247.0f/255 green:169.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], nil];
    [reviewRating3View.layer insertSublayer:gradient atIndex:0];
    
    UIView *reviewRating2View = [[UIView alloc] initWithFrame:CGRectMake(130, reviewRating3View.frame.origin.y + reviewRating3View.frame.size.height + 10, (float)reviewRating2/totalRatedReview*totalWidth, 20)];
    reviewRating2View.backgroundColor = [UIColor colorWithRed:255.0f/255 green:170.0f/255 blue:0.0f/255 alpha:1.0f];
    [headerView addSubview:reviewRating2View];
    
    gradient = [CAGradientLayer layer];
    gradient.frame = reviewRating2View.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0f/255 green:200.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:247.0f/255 green:169.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], nil];
    [reviewRating2View.layer insertSublayer:gradient atIndex:0];
    
    UIView *reviewRating1View = [[UIView alloc] initWithFrame:CGRectMake(130, reviewRating2View.frame.origin.y + reviewRating2View.frame.size.height + 10, (float)reviewRating1/totalRatedReview*totalWidth, 20)];
    reviewRating1View.backgroundColor = [UIColor colorWithRed:255.0f/255 green:170.0f/255 blue:0.0f/255 alpha:1.0f];
    [headerView addSubview:reviewRating1View];
    
    gradient = [CAGradientLayer layer];
    gradient.frame = reviewRating1View.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0f/255 green:200.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:247.0f/255 green:169.0f/255 blue:0.0f/255 alpha:1.0f] CGColor], nil];
    [reviewRating1View.layer insertSublayer:gradient atIndex:0];
    
    UIImageView *rating5title = [[UIImageView alloc] initWithFrame:CGRectMake(5, reviewRating5View.frame.origin.y, 128, 20)];
    rating5title.image = [UIImage imageNamed:@"5Star.png"];
    rating5title.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:rating5title];
    
    UIImageView *rating4title = [[UIImageView alloc] initWithFrame:CGRectMake(5, reviewRating4View.frame.origin.y, 128, 20)];
    rating4title.image = [UIImage imageNamed:@"4Star.png"];
    rating4title.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:rating4title];
    
    UIImageView *rating3title = [[UIImageView alloc] initWithFrame:CGRectMake(5, reviewRating3View.frame.origin.y, 128, 20)];
    rating3title.image = [UIImage imageNamed:@"3Star.png"];
    rating3title.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:rating3title];
    
    UIImageView *rating2title = [[UIImageView alloc] initWithFrame:CGRectMake(5, reviewRating2View.frame.origin.y, 128, 20)];
    rating2title.image = [UIImage imageNamed:@"2Star.png"];
    rating2title.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:rating2title];
    
    UIImageView *rating1title = [[UIImageView alloc] initWithFrame:CGRectMake(5, reviewRating1View.frame.origin.y, 128, 20)];
    rating1title.image = [UIImage imageNamed:@"1Star.png"];
    rating1title.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:rating1title];
    
    UILabel *rating5ratio = [[UILabel alloc] initWithFrame:CGRectMake(reviewRating5View.frame.origin.x + reviewRating5View.frame.size.width + 10, reviewRating5View.frame.origin.y, 80, 20)];
    rating5ratio.text = [NSString stringWithFormat:@"(%.1f %%)",(float)reviewRating5/totalRatedReview * 100];
    [headerView addSubview:rating5ratio];
    
    UILabel *rating4ratio = [[UILabel alloc] initWithFrame:CGRectMake(reviewRating4View.frame.origin.x + reviewRating4View.frame.size.width + 10, reviewRating4View.frame.origin.y, 80, 20)];
    rating4ratio.text = [NSString stringWithFormat:@"(%.1f %%)",(float)reviewRating4/totalRatedReview * 100];
    [headerView addSubview:rating4ratio];
    
    UILabel *rating3ratio = [[UILabel alloc] initWithFrame:CGRectMake(reviewRating3View.frame.origin.x + reviewRating3View.frame.size.width + 10, reviewRating3View.frame.origin.y, 80, 20)];
    rating3ratio.text = [NSString stringWithFormat:@"(%.1f %%)",(float)reviewRating3/totalRatedReview * 100];
    [headerView addSubview:rating3ratio];
    
    UILabel *rating2ratio = [[UILabel alloc] initWithFrame:CGRectMake(reviewRating2View.frame.origin.x + reviewRating2View.frame.size.width + 10, reviewRating2View.frame.origin.y, 80, 20)];
    rating2ratio.text = [NSString stringWithFormat:@"(%.1f %%)",(float)reviewRating2/totalRatedReview * 100];
    [headerView addSubview:rating2ratio];
    
    UILabel *rating1ratio = [[UILabel alloc] initWithFrame:CGRectMake(reviewRating1View.frame.origin.x + reviewRating1View.frame.size.width + 10, reviewRating1View.frame.origin.y, 80, 20)];
    rating1ratio.text = [NSString stringWithFormat:@"(%.1f %%)",(float)reviewRating1/totalRatedReview * 100];
    [headerView addSubview:rating1ratio];
    
    UIButton *postReviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postReviewButton setImage:[UIImage imageNamed:@"postReviewButton.png"] forState:UIControlStateNormal];
    postReviewButton.frame = CGRectMake(20, rating1ratio.frame.origin.y + rating1ratio.frame.size.height + 10, ([UIScreen mainScreen].bounds.size.width - 40), 82.0f/677 * ([UIScreen mainScreen].bounds.size.width - 40));
    [postReviewButton addTarget:self action:@selector(postReviewButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:postReviewButton];
    
    return headerView;
}

-(void)postReviewButtonAction
{
    if(delegate)
    {
        [delegate postReviewButtonAction];
    }
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
//            NSLog(@"review %@", dataJSON);
            isServerCallFinished = YES;
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [reviewArray removeAllObjects];
                    totalRatedReview = 0;
                    reviewRating1 = 0;
                    reviewRating2 = 0;
                    reviewRating3 = 0;
                    reviewRating4 = 0;
                    reviewRating5 = 0;
                    
                    NSArray *arr = [NSArray arrayWithArray:[dataJSON objectForKey:@"REVIEW_LIST"]];
                    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                        NSDate *d1 = [df1 dateFromString:obj1[@"REVIEW_DATE"]];
                        NSDate *d2 = [df1 dateFromString:obj2[@"REVIEW_DATE"]];
                        
                        return [d2 compare:d1]; // descending order
                    }];
                    [reviewArray addObjectsFromArray:arr];
                    
                    for(NSDictionary *reviewObject in reviewArray)
                    {
                        if([[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] intValue] > 1)
                        {
                            totalRatedReview++;
                            int value = [[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] intValue] > 5 ? [[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] intValue] / 2 : [[reviewObject objectForKey:@"ORIGINAL_USER_RATING"] intValue];
                            if(value == 1)
                            {
                                reviewRating1++;
                            }
                            else if(value == 2)
                            {
                                reviewRating2++;
                            }
                            else if(value == 3)
                            {
                                reviewRating3++;
                            }
                            else if(value == 4)
                            {
                                reviewRating4++;
                            }
                            else if(value == 5)
                            {
                                reviewRating5++;
                            }
                        }
                    }
                    
                    NSLog(@"Total rated review %d", totalRatedReview);
                    NSLog(@"reviewRating1 %d", reviewRating1);
                    NSLog(@"reviewRating2 %d", reviewRating2);
                    NSLog(@"reviewRating3 %d", reviewRating3);
                    NSLog(@"reviewRating4 %d", reviewRating4);
                    NSLog(@"reviewRating5 %d", reviewRating5);
                    
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
