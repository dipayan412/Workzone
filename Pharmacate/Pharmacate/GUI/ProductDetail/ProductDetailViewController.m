//
//  ProductDetailViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/21/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "OverViewTableViewCell.h"
#import "ExplanationsTableViewCell.h"
#import "ReminderViewController.h"
#import "XYPieChart.h"

@interface ProductDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,XYPieChartDataSource, XYPieChartDelegate>
{
    UIButton *overviewButton;
    UIButton *explanationsButton;
    UIButton *newsButton;
    UIButton *alternativeButton;
    
    UIView *indicatorView;
    
    UIView *overViewContainerView;
    UITableView *overViewTableView;
    UIButton *likeButton;
    UIButton *dislikeButton;
    UIButton *alarmButton;
    
    BOOL likeBoolean;
    BOOL dislikeBoolean;
    BOOL isViewUp;
    BOOL isExplanationTableFirstTimeLoaded;
    
    UIView *explanationsContainerView;
    UITableView *explanationsTableView;
    NSIndexPath *explanationsTableSelectedIndexPath;
    UIImageView *explanationsRightPortionImageView;
    
    UIView *newsContainerView;
    UIImageView *newsCell1ImageView;
    UIImageView *newsCell2ImageView;
    UIImageView *newsCell3ImageView;
    
    UIView *alternativesContainerView;
    UIView *similarProductsView;
    UIView *homeopathicView;
    UIImageView *similarProductsButtonImageView;
    UIImageView *similarProductsExpnadedImageView;
    BOOL isSimilarProductViewExpanded;
    int pid;
    int numRows;
    
    NSMutableArray *ingredientList;
}
@end

@implementation ProductDetailViewController

@synthesize isTempValue;
@synthesize productId;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isTempValue:(BOOL)tempValue numRows:(int)rows
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nil])) {
        self.isTempValue = tempValue;
        numRows = rows;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pid = [self.productId intValue];
    
    [self getProductDetails];
    
    likeBoolean = NO;
    dislikeBoolean = NO;
    isViewUp = NO;
    isExplanationTableFirstTimeLoaded = NO;
    isSimilarProductViewExpanded = NO;
    
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 60, 60);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, customNavigationBar.frame.size.height)];
    titleLabel.text = @"Advil";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
    [customNavigationBar addSubview:titleLabel];
    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, 60)];
    topBar.backgroundColor = [UIColor colorWithRed:226.0f/255 green:226.0f/255 blue:226.0f/255 alpha:1.0];
    
    UIImageView *vs1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verticalSeparator.png"]];
    UIImageView *vs2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verticalSeparator.png"]];
    UIImageView *vs3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verticalSeparator.png"]];
    
    vs1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/4, 15, 2, topBar.frame.size.height - 30);
    vs2.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2, 15, 2, topBar.frame.size.height - 30);
    vs3.frame = CGRectMake(3 * [UIScreen mainScreen].bounds.size.width/4, 15, 2, topBar.frame.size.height - 30);
    [topBar addSubview:vs1];
    [topBar addSubview:vs2];
    [topBar addSubview:vs3];
    
    overviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [overviewButton setTitle:@"Overview" forState:UIControlStateNormal];
    [overviewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    overviewButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/4, topBar.frame.size.height);
    overviewButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    overviewButton.tag = 1;
    [overviewButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:overviewButton];
    
    explanationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [explanationsButton setTitle:@"Explanations" forState:UIControlStateNormal];
    [explanationsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    explanationsButton.frame = CGRectMake(overviewButton.frame.size.width, 0, [UIScreen mainScreen].bounds.size.width/4, topBar.frame.size.height);
    explanationsButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    explanationsButton.tag = 2;
    [explanationsButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:explanationsButton];
    
    newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsButton setTitle:@"News" forState:UIControlStateNormal];
    [newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    newsButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/4, topBar.frame.size.height);
    newsButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    newsButton.tag = 3;
    [newsButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:newsButton];
    
    alternativeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alternativeButton setTitle:@"Alternatives" forState:UIControlStateNormal];
    [alternativeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    alternativeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + [UIScreen mainScreen].bounds.size.width/4, 0, [UIScreen mainScreen].bounds.size.width/4, topBar.frame.size.height);
    alternativeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    alternativeButton.tag = 4;
    [alternativeButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:alternativeButton];
    
    indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.frame.size.height - 5, [UIScreen mainScreen].bounds.size.width/4, 5)];
    indicatorView.backgroundColor = [UIColor colorWithRed:227.0f/255 green:69.0f/255 blue:84.0f/255 alpha:1.0f];
    [topBar addSubview:indicatorView];
    
    overViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.frame.origin.y + topBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (topBar.frame.origin.y + topBar.frame.size.height))];
    overViewContainerView.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1.0f];
    overViewTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, overViewContainerView.frame.size.width, overViewContainerView.frame.size.height)];
    overViewTableView.backgroundColor = [UIColor clearColor];
    overViewTableView.delegate = self;
    overViewTableView.dataSource = self;
    overViewTableView.allowsSelection = NO;
    CGFloat dummyViewHeight = 600;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, overViewTableView.bounds.size.width, dummyViewHeight)];
    overViewTableView.tableHeaderView = dummyView;
    overViewTableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 44, 0);
    overViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [overViewContainerView addSubview:overViewTableView];
    
    explanationsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.frame.origin.y + topBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (topBar.frame.origin.y + topBar.frame.size.height))];
    explanationsContainerView.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1.0f];
    explanationsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, explanationsContainerView.frame.size.width, explanationsContainerView.frame.size.height)];
    explanationsTableView.backgroundColor = [UIColor clearColor];
    explanationsTableView.delegate = self;
    explanationsTableView.dataSource = self;
    dummyViewHeight = 600;
    dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, explanationsTableView.bounds.size.width, dummyViewHeight)];
    explanationsTableView.tableHeaderView = dummyView;
    explanationsTableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 44, 0);
    explanationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [explanationsContainerView addSubview:explanationsTableView];
    
    newsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.frame.origin.y + topBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (topBar.frame.origin.y + topBar.frame.size.height))];
    newsContainerView.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1.0f];
    
    newsCell1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsCell1.png"]];
    newsCell1ImageView.frame = CGRectMake(10, 18, [UIScreen mainScreen].bounds.size.width - 20, 104);
    newsCell1ImageView.backgroundColor = [UIColor blueColor];
    newsCell1ImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    newsCell2ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsCell2.png"]];
    newsCell2ImageView.frame = CGRectMake(10, newsCell1ImageView.frame.origin.y + newsCell1ImageView.frame.size.height + 18, [UIScreen mainScreen].bounds.size.width - 20, 104);
    newsCell2ImageView.backgroundColor = [UIColor blueColor];
    newsCell2ImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    newsCell3ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsCell3.png"]];
    newsCell3ImageView.frame = CGRectMake(10, newsCell2ImageView.frame.origin.y + newsCell2ImageView.frame.size.height + 18, [UIScreen mainScreen].bounds.size.width - 20, 104);
    newsCell3ImageView.backgroundColor = [UIColor blueColor];
    newsCell3ImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if(self.isTempValue)
    {
        [newsContainerView addSubview:newsCell1ImageView];
        [newsContainerView addSubview:newsCell2ImageView];
        [newsContainerView addSubview:newsCell3ImageView];
    }
    
    alternativesContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.frame.origin.y + topBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (topBar.frame.origin.y + topBar.frame.size.height))];
    alternativesContainerView.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1.0f];
    
    similarProductsView = [[UIView alloc] initWithFrame:CGRectMake(10, 18, [UIScreen mainScreen].bounds.size.width - 20, 94)];
    similarProductsView.backgroundColor = [UIColor whiteColor];
    similarProductsView.layer.borderColor = [UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255].CGColor;
    similarProductsView.layer.borderWidth = 1.0f;
    
    UILabel *similarProductsViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, similarProductsView.frame.size.width/2, similarProductsView.frame.size.height)];
    similarProductsViewLabel.text = @"Similar Products";
    similarProductsViewLabel.font = [UIFont systemFontOfSize:19.0];
    similarProductsViewLabel.textAlignment = NSTextAlignmentLeft;
    similarProductsViewLabel.backgroundColor = [UIColor clearColor];
    [similarProductsView addSubview:similarProductsViewLabel];
    
    similarProductsButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forwardButton.png"]];
    similarProductsButtonImageView.contentMode = UIViewContentModeScaleAspectFit;
    similarProductsButtonImageView.frame = CGRectMake(similarProductsView.frame.size.width - 60, similarProductsViewLabel.frame.size.height/2 - 20, 40, 40);
    similarProductsButtonImageView.backgroundColor = [UIColor clearColor];
    [similarProductsView addSubview:similarProductsButtonImageView];
    
    similarProductsExpnadedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlternateCells.png"]];
    similarProductsExpnadedImageView.frame = CGRectMake(-2, similarProductsViewLabel.frame.size.height, similarProductsView.frame.size.width + 4, 0);
    similarProductsExpnadedImageView.backgroundColor = [UIColor clearColor];
    similarProductsExpnadedImageView.contentMode = UIViewContentModeScaleAspectFit;
    if(self.isTempValue)
    {
        [similarProductsView addSubview:similarProductsExpnadedImageView];
    }
    
    
    UIControl *similarProductsViewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, similarProductsView.frame.size.width, similarProductsView.frame.size.height)];
    similarProductsViewControl.backgroundColor = [UIColor clearColor];
    [similarProductsViewControl addTarget:self action:@selector(similarProductViewControlAction) forControlEvents:UIControlEventTouchUpInside];
    [similarProductsView addSubview:similarProductsViewControl];
    [alternativesContainerView addSubview:similarProductsView];
    
    homeopathicView = [[UIView alloc] initWithFrame:CGRectMake(10, similarProductsView.frame.size.height + similarProductsView.frame.origin.y + 18, [UIScreen mainScreen].bounds.size.width - 20, 94)];
    homeopathicView.backgroundColor = [UIColor whiteColor];
    homeopathicView.layer.borderColor = [UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255].CGColor;
    homeopathicView.layer.borderWidth = 1.0f;
    
    UILabel *homeopathicViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, homeopathicView.frame.size.width/2, homeopathicView.frame.size.height)];
    homeopathicViewLabel.text = @"Homeopathic";
    homeopathicViewLabel.font = [UIFont systemFontOfSize:19.0];
    homeopathicViewLabel.textAlignment = NSTextAlignmentLeft;
    homeopathicViewLabel.backgroundColor = [UIColor clearColor];
    [homeopathicView addSubview:homeopathicViewLabel];
    
    UIImageView *homeopathicViewButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forwardButton.png"]];
    homeopathicViewButtonImageView.contentMode = UIViewContentModeScaleAspectFit;
    homeopathicViewButtonImageView.frame = CGRectMake(homeopathicView.frame.size.width - 60, homeopathicView.frame.size.height/2 - 20, 40, 40);
    homeopathicViewButtonImageView.backgroundColor = [UIColor clearColor];
    [homeopathicView addSubview:homeopathicViewButtonImageView];
    [alternativesContainerView addSubview:homeopathicView];
    
    [self.view addSubview:alternativesContainerView];
    [self.view addSubview:newsContainerView];
    [self.view addSubview:explanationsContainerView];
    [self.view addSubview:overViewContainerView];
    [self.view addSubview:topBar];
    [self.view addSubview:customNavigationBar];
}

-(void)getProductDetails
{
    NSURL *URL = [NSURL URLWithString:productDetailURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@", self.productId], @"PRODUCT_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error)
        {
            ingredientList = [[NSMutableArray alloc] init];
            NSLog(@"%@",dataJSON);
            
            for(int i = 0; i < [[[[dataJSON objectForKey:@"Data"] objectForKey:@"Ingredients"] objectAtIndex:0] count]; i++)
            {
                NSArray *tmpArr = [[[[dataJSON objectForKey:@"Data"] objectForKey:@"Ingredients"] objectAtIndex:0] objectAtIndex:i];
                [ingredientList addObject:[tmpArr objectAtIndex:0]];
                NSLog(@"%@", [tmpArr objectAtIndex:0]);
            }
        }
        else
        {
            NSLog(@"%@",error);
        }
        
    }];
    [dataTask resume];
}

-(void)similarProductViewControlAction
{
    float expandedHeight = 0;;
    if(!isSimilarProductViewExpanded)
    {
        similarProductsButtonImageView.image = [UIImage imageNamed:@"downButton.png"];
        expandedHeight = 276;
    }
    else
    {
        similarProductsButtonImageView.image = [UIImage imageNamed:@"forwardButton.png"];
        expandedHeight = 0;
    }
    if(self.isTempValue)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = similarProductsExpnadedImageView.frame;
            frame.size.height = expandedHeight;
            similarProductsExpnadedImageView.frame = frame;
            
            frame = homeopathicView.frame;
            frame.origin.y = similarProductsExpnadedImageView.frame.origin.y + similarProductsExpnadedImageView.frame.size.height + 36;
            homeopathicView.frame = frame;
        } completion:^(BOOL finished) {
            if(finished)
            {
                //            similarProductsExpnadedImageView.hidden = !similarProductsExpnadedImageView.hidden;
            }
        }];
    }
    
    
    isSimilarProductViewExpanded = !isSimilarProductViewExpanded;
}

-(void)tabButtonAction:(UIButton*)button
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = indicatorView.frame;
    frame.origin.x = button.frame.origin.x;
    indicatorView.frame = frame;
    
    [UIView commitAnimations];
    
    if(button.tag == 1)
    {
        [self.view bringSubviewToFront:overViewContainerView];
    }
    else if(button.tag == 2)
    {
        [self.view bringSubviewToFront:explanationsContainerView];
    }
    else if(button.tag == 3)
    {
        [self.view bringSubviewToFront:newsContainerView];
    }
    else if(button.tag == 4)
    {
        [self.view bringSubviewToFront:alternativesContainerView];
    }
}

#pragma mark uiTableView delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == explanationsTableView)
    {
        return 5;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == explanationsTableView)
    {
        return 1;
    }
    
    if(tableView == overViewTableView)
    {
        return numRows;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == explanationsTableView)
    {
        static NSString *cellId = @"cellId";
        ExplanationsTableViewCell *cell;// = (ExplanationsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        if(cell == nil)
        {
            cell = [[ExplanationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        if(indexPath.section == 0)
        {
            cell.cellTitleLabel.text = @"Bow Warning";
            if(self.isTempValue)
            {
                cell.ratingImageView.image = [UIImage imageNamed:@"explanationsRatingB.png"];
            }
        }
        else if(indexPath.section == 1)
        {
            cell.cellTitleLabel.text = @"Side Effects";
            if(self.isTempValue)
            {
                cell.ratingImageView.image = [UIImage imageNamed:@"explanationsRatingC.png"];
            }
        }
        else if(indexPath.section == 2)
        {
            cell.cellTitleLabel.text = @"Pregnency & Breastfeeding";
            if(self.isTempValue)
            {
                cell.ratingImageView.image = [UIImage imageNamed:@"explanationsRatingB.png"];
            }
        }
        else if(indexPath.section == 3)
        {
            cell.cellTitleLabel.text = @"Drug Interactions";
            if(self.isTempValue)
            {
                cell.ratingImageView.image = [UIImage imageNamed:@"explanationsRatingA-.png"];
            }
        }
        else if(indexPath.section == 4)
        {
            cell.cellTitleLabel.text = @"Ingredients";
            if(self.isTempValue)
            {
                cell.ratingImageView.image = [UIImage imageNamed:@"explanationsRatingA-.png"];
            }
        }
        
        if(self.isTempValue)
        {
            cell.expandedImageView.image = [UIImage imageNamed:@"expandedCellExplanations.png"];
        }
        return cell;
    }
    int position = 2;
    int cellType = 2;
    static NSString *cellIdentifier = @"cellID";
    OverViewTableViewCell *cell;
    if(cell == nil)
    {
        if(numRows == 1)
        {
            if(indexPath.row == 0)
            {
                position = 0;
                cellType = 1;
            }
        }
        else
        {
            if(indexPath.row == 0)
            {
                cellType = 1;
            }
            else if(indexPath.row == 3)
            {
                position = 3;
            }
        }
        cell = [[OverViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withCellPosition:position withCellType:cellType indexPath:indexPath];
        if(cellType == 1)
        {
            cell.userCommentTextField.delegate = self;
        }
    }
    cell.tempImageView.image = [UIImage imageNamed:@"commentTempCell.tiff"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView == explanationsTableView)
    {
        ExplanationsTableViewCell *cell = (ExplanationsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if(self.isTempValue)
        {
            if(explanationsTableSelectedIndexPath == indexPath)
            {
                explanationsTableSelectedIndexPath = NULL;
                cell.isExpanded = NO;
            }
            else
            {
                ExplanationsTableViewCell *prevExpandedCell = (ExplanationsTableViewCell*)[tableView cellForRowAtIndexPath:explanationsTableSelectedIndexPath];
                prevExpandedCell.isExpanded = NO;
                
                explanationsTableSelectedIndexPath = indexPath;
                cell.isExpanded = YES;
            }
        }
        
        
        //        [explanationsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
        [explanationsTableView beginUpdates];
        [explanationsTableView endUpdates];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == explanationsTableView)
    {
        if(explanationsTableSelectedIndexPath == indexPath)
        {
            return 309;
        }
        return 80;
    }
    if(indexPath.row == 0)
    {
        return 140.0f;
    }
    return 110.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == explanationsTableView)
    {
        if(section != 0)
        {
            return 30;
        }
        return 250.0f;
    }
    return 320.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == explanationsTableView)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
        if (section == 0)
        {
            [headerView setBackgroundColor:[UIColor clearColor]];
            CGRect frame = headerView.frame;
            frame.size.height = 250;
            headerView.frame = frame;
            
            if(self.isTempValue)
            {
                //            if(explanationsTableSelectedIndexPath != NULL)
                //            {
                //                explanationsRightPortionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"explanationsAlternateRightPortion"]];
                //            }
                //            else
                //            {
                //                explanationsRightPortionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overviewCircular.tiff"]];
                //            }
                
                //            explanationsRightPortionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overviewCircular.tiff"]];
                //
                //            explanationsRightPortionImageView.frame = CGRectMake(0, 60, 150, 150);
                //            explanationsRightPortionImageView.contentMode = UIViewContentModeScaleAspectFit;
                //            [headerView addSubview:explanationsRightPortionImageView];
                
                XYPieChart *pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(0, 60, 150, 150)];
                float viewWidth = pieChart.bounds.size.width / 2;
                float viewHeight = pieChart.bounds.size.height / 2;
                [pieChart setDelegate:self];
                [pieChart setDataSource:self];
                [pieChart setStartPieAngle:M_PI_2];
                [pieChart setUserInteractionEnabled:NO];
                [pieChart setLabelColor:[UIColor whiteColor]];
                [pieChart setLabelShadowColor:[UIColor blackColor]];
                [pieChart setShowPercentage:NO];
                [pieChart setShowLabel:NO];
                [pieChart setPieBackgroundColor:[UIColor whiteColor]];
                [headerView addSubview:pieChart];
                
                //To make the chart at the center of view
                [pieChart setPieCenter:CGPointMake(pieChart.bounds.origin.x + viewWidth, pieChart.bounds.origin.y + viewHeight)];
                
                //Method to display the pie chart with values.
                [pieChart reloadData];
                
                UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75 - 30, 60 + 30 + 15, 60, 60)];
                gradeLabel.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
                gradeLabel.text = [NSString stringWithFormat:@"%s","B+"];
                gradeLabel.font = [UIFont boldSystemFontOfSize:19.0f];
                gradeLabel.textAlignment = NSTextAlignmentCenter;
                gradeLabel.layer.masksToBounds = YES;
                [gradeLabel.layer setCornerRadius:30];
                [headerView addSubview:gradeLabel];
                
                UIImageView *leftPortionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"explanationsLeftPortion.png"]];
                leftPortionImageView.frame = CGRectMake(pieChart.frame.size.width , -10, 250, 250);
                leftPortionImageView.contentMode = UIViewContentModeScaleAspectFit;
                [headerView addSubview:leftPortionImageView];
            }
        }
        else
        {
            [headerView setBackgroundColor:[UIColor clearColor]];
        }
        return headerView;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
    if (section == 0)
    {
        alarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [alarmButton setImage:[UIImage imageNamed:@"alarmButton.tiff"] forState:UIControlStateNormal];
        alarmButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 120, 0, 75, 80);
        [alarmButton addTarget:self action:@selector(alarmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:alarmButton];
        if(self.isTempValue)
        {
            [headerView setBackgroundColor:[UIColor clearColor]];
            CGRect frame = headerView.frame;
            frame.size.height = 320;
            headerView.frame = frame;
            
            UIImageView *leftPortionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftPortionOverView.tiff"]];
            leftPortionImageView.frame = CGRectMake(15, -10, 160, 300);
            leftPortionImageView.contentMode = UIViewContentModeScaleAspectFit;
            [headerView addSubview:leftPortionImageView];
            
            //        UIImageView *rightCircularImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overviewCircular.tiff"]];
            //        rightCircularImageView.frame = CGRectMake(leftPortionImageView.frame.origin.x + leftPortionImageView.frame.size.width + 30, 70, 190, 200);
            //        rightCircularImageView.contentMode = UIViewContentModeScaleAspectFit;
            //        rightCircularImageView.backgroundColor = [UIColor redColor];
            //        [headerView addSubview:rightCircularImageView];
            
            XYPieChart *pieChart1 = [[XYPieChart alloc] initWithFrame:CGRectMake(leftPortionImageView.frame.origin.x + leftPortionImageView.frame.size.width + 30, 70, 190, 200)];
            float viewWidth = pieChart1.bounds.size.width / 2;
            float viewHeight = pieChart1.bounds.size.height / 2;
            [pieChart1 setDelegate:self];
            [pieChart1 setDataSource:self];
            [pieChart1 setStartPieAngle:M_PI_2];
            [pieChart1 setUserInteractionEnabled:YES];
            [pieChart1 setLabelColor:[UIColor whiteColor]];
            [pieChart1 setLabelShadowColor:[UIColor blackColor]];
            pieChart1.tag = 100;
            [pieChart1 setShowPercentage:NO];
            [pieChart1 setShowLabel:NO];
            [headerView addSubview:pieChart1];
            
            //To make the chart at the center of view
            [pieChart1 setPieCenter:CGPointMake(pieChart1.bounds.origin.x + viewWidth, pieChart1.bounds.origin.y + viewHeight)];
            
            //Method to display the pie chart with values.
            [pieChart1 reloadData];
            
            UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPortionImageView.frame.origin.x + leftPortionImageView.frame.size.width + 76, 120, 100, 100)];
            gradeLabel.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
            gradeLabel.text = [NSString stringWithFormat:@"%s","B+"];
            gradeLabel.font = [UIFont boldSystemFontOfSize:33.0f];
            gradeLabel.textAlignment = NSTextAlignmentCenter;
            gradeLabel.layer.masksToBounds = YES;
            [gradeLabel.layer setCornerRadius:50];
            [headerView addSubview:gradeLabel];
            
            UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, leftPortionImageView.frame.size.height - 10, 100, 25)];
            likeLabel.text = @"73% like";
            likeLabel.textColor = [UIColor lightGrayColor];
            likeLabel.backgroundColor = [UIColor clearColor];
            [headerView addSubview:likeLabel];
            
            UILabel *dislikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(likeLabel.frame.origin.x + likeLabel.frame.size.width + 100, leftPortionImageView.frame.size.height - 10, 100, 25)];
            dislikeLabel.text = @"15% dislike";
            dislikeLabel.textColor = [UIColor lightGrayColor];
            dislikeLabel.backgroundColor = [UIColor clearColor];
            [headerView addSubview:dislikeLabel];
            
            likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [likeButton setImage:[UIImage imageNamed:@"likeButton.tiff"] forState:UIControlStateNormal];
            likeButton.frame = CGRectMake(likeLabel.frame.origin.x - 50, likeLabel.frame.origin.y - 20, 50, 50);
            [likeButton addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:likeButton];
            
            dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [dislikeButton setImage:[UIImage imageNamed:@"dislikeButton.tiff"] forState:UIControlStateNormal];
            dislikeButton.frame = CGRectMake(dislikeLabel.frame.origin.x - 50, dislikeLabel.frame.origin.y - 20, 50, 50);
            [dislikeButton addTarget:self action:@selector(dislikeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:dislikeButton];
            
            alarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [alarmButton setImage:[UIImage imageNamed:@"alarmButton.tiff"] forState:UIControlStateNormal];
            alarmButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 120, 0, 75, 80);
            [alarmButton addTarget:self action:@selector(alarmButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:alarmButton];
        }
    }
    else
        [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 4;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            return 27;
        case 1:
            return 30;
        case 2:
            return 19;
        case 3:
            return 24;
            
        default:
            break;
    }
    return 0;
}
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            return [UIColor colorWithRed:253.0f/255 green:190.0f/255 blue:58.0f/255 alpha:1.0f];
        case 1:
            return [UIColor colorWithRed:1.0f/255 green:95.0f/255 blue:133.0f/255 alpha:1.0f];
        case 2:
            return [UIColor colorWithRed:157.0f/255 green:198.0f/255 blue:218.0f/255 alpha:1.0f];
        case 3:
            return [UIColor colorWithRed:40.0f/255 green:143.0f/255 blue:176.0f/255 alpha:1.0f];
            
        default:
            break;
    }
    return [UIColor whiteColor];
}

-(void)likeButtonAction
{
    likeBoolean = !likeBoolean;
    if(likeBoolean)
    {
        [likeButton setImage:[UIImage imageNamed:@"likeButtonSelected.tiff"] forState:UIControlStateNormal];
        if(dislikeBoolean)
        {
            [dislikeButton setImage:[UIImage imageNamed:@"dislikeButton.tiff"] forState:UIControlStateNormal];
            dislikeBoolean = !dislikeBoolean;
        }
    }
    else
    {
        [likeButton setImage:[UIImage imageNamed:@"likeButton.tiff"] forState:UIControlStateNormal];
    }
}

-(void)dislikeButtonAction
{
    dislikeBoolean = !dislikeBoolean;
    if(dislikeBoolean)
    {
        [dislikeButton setImage:[UIImage imageNamed:@"dislikeButtonSelected.tiff"] forState:UIControlStateNormal];
        if(likeBoolean)
        {
            [likeButton setImage:[UIImage imageNamed:@"likeButton.tiff"] forState:UIControlStateNormal];
            likeBoolean = !likeBoolean;
        }
    }
    else
    {
        [dislikeButton setImage:[UIImage imageNamed:@"dislikeButton.tiff"] forState:UIControlStateNormal];
    }
}

-(void)alarmButtonAction
{
    ReminderViewController *vc = [[ReminderViewController alloc] initWithNibName:@"ReminderViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)backButtonAction:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)explanationsHeaderChangeRightPortion
{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSIndexPath *nip = [NSIndexPath indexPathForRow:0 inSection:0];
    CGRect cellPositionRect = [overViewContainerView convertRect:[overViewTableView rectForRowAtIndexPath:nip] fromView:overViewTableView];
    if(cellPositionRect.origin.y > 251.0f)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        self.view.frame = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
        isViewUp = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(isViewUp)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
        isViewUp = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
