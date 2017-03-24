//
//  NewsView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "NewsView.h"
#import "NewsTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface NewsView() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *productNewsTableView;
    NSMutableArray *newsArray;
    int maxRow;
    NSString *productId;
    
    BOOL isServerCallFinished;
}

@end

@implementation NewsView

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
//    self.backgroundColor = loginPageBGColor;
    self.backgroundColor = [UIColor whiteColor];
    maxRow = 20;
    newsArray = [[NSMutableArray alloc] init];
    
    productNewsTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, self.frame.size.height - 5)];
    productNewsTableView.delegate = self;
    productNewsTableView.dataSource = self;
    productNewsTableView.backgroundColor = [UIColor clearColor];
    productNewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    productNewsTableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    [self addSubview:productNewsTableView];
    
    [self getRecallsFromServerForProduct:productId];
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
    else if(isServerCallFinished && newsArray.count == 0)
    {
        return 1;
    }
    return newsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellId";
    NewsTableViewCell *cell;
    if(cell == nil)
    {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if(!isServerCallFinished)
    {
        cell.textLabel.text = NSLocalizedString(kNewsLoading, nil);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else if(isServerCallFinished && newsArray.count == 0)
    {
        cell.textLabel.text = NSLocalizedString(kNewsNoData, nil);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    else
    {
        NSDictionary *newsObject = [newsArray objectAtIndex:indexPath.row];
        if([newsObject objectForKey:@"RECALL_ID"])
        {
            cell.newsTitleLabel.text = [newsObject objectForKey:@"PRODUCT_DESCRIPTION"];
            cell.newsImageView.image = [UIImage imageNamed:@"noImageAvailable.png"];
        }
        else
        {
            cell.newsTitleLabel.text = [[[newsObject objectForKey:@"TITLE"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            if([[newsArray objectAtIndex:indexPath.row] objectForKey:@"NEWS_IMAGE_URL"] != [NSNull null] && [[newsArray objectAtIndex:indexPath.row] objectForKey:@"NEWS_IMAGE_URL"] != nil)
            {
                NSString *urlString = [[newsArray objectAtIndex:indexPath.row] objectForKey:@"NEWS_IMAGE_URL"];
                [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"noImageAvailable.png"]];
            }
            else
            {
                //        cell.newsImageView.image = [UIImage imageNamed:@"fdaSymbol1.png"];
            }
        }
        
        cell.layer.borderWidth = 0.5f;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        if (indexPath.row == [newsArray count] - 1 && [newsArray count] == maxRow)
        {
            maxRow += 20;
            [self getRecallsFromServerForProduct:productId];
            
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"%@", newsObject);
    if(!isServerCallFinished || (isServerCallFinished && newsArray.count == 0))
    {
        
    }
    else
    {
        NSDictionary *newsObject = [newsArray objectAtIndex:indexPath.row];
        if([newsObject objectForKey:@"RECALL_ID"])
        {
            if(delegate)
            {
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                      action:@"Product Recall Selection"
                                                                       label:[newsObject objectForKey:@"RECALL_ID"]
                                                                       value:nil] build]];
                [delegate recallCellActionForDictionary:newsObject];
            }
        }
        else
        {
            if(delegate)
            {
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                      action:@"Product News Selection"
                                                                       label:[[[newsObject objectForKey:@"TITLE"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""]
                                                                       value:nil] build]];
                
                [delegate newsCellActionUrlString:[[newsArray objectAtIndex:indexPath.row] objectForKey:@"NEWS_URL"]];
            }
        }
    }
}

-(void)getRecallsFromServerForProduct:(NSString*)_productId
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:getProductRecalls];
    [urlStr appendString:[NSString stringWithFormat:@"?maxPerPage=%@",[NSString stringWithFormat:@"%d",maxRow]]];
    [urlStr appendString:[NSString stringWithFormat:@"&currPage=%@",@"0"]];
    [urlStr appendString:[NSString stringWithFormat:@"&pId=%@",_productId]];
//    NSLog(@"newsUrl %@",urlStr);
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
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if(!error)
            {
                [self getProductNewsFromServerForProduct:productId WithRecallArray:[dataJSON objectForKey:@"Data"]];
            }
            else
            {
                NSLog(@"Error %@",error);
                [self getProductNewsFromServerForProduct:productId WithRecallArray:[dataJSON objectForKey:@"Data"]];
            }
        }
    }];
    [dataTask resume];
}

-(void)getProductNewsFromServerForProduct:(NSString*)_productId WithRecallArray:(NSArray*)recallArray
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:getProductNews];
    [urlStr appendString:[NSString stringWithFormat:@"?maxPerPage=%@",[NSString stringWithFormat:@"%d",maxRow]]];
    [urlStr appendString:[NSString stringWithFormat:@"&currPage=%@",@"0"]];
    [urlStr appendString:[NSString stringWithFormat:@"&pId=%@",_productId]];
    //    [urlStr appendString:[NSString stringWithFormat:@"?maxPerPage=%@",[NSString stringWithFormat:@"%d",maxRow]]];
//    NSLog(@"newsUrl %@",urlStr);
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
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//            NSLog(@"news %@",dataJSON);
            isServerCallFinished = YES;
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [newsArray removeAllObjects];
                    [newsArray addObjectsFromArray:recallArray];
                    [newsArray addObjectsFromArray:[dataJSON objectForKey:@"Data"]];
                    [productNewsTableView reloadData];
                });
            }
            else
            {
                NSLog(@"Error %@",error);
            }
        }
    }];
    [dataTask resume];
}

@end
