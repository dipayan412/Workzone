//
//  ProductSelectionView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ProductSelectionView.h"
#import "SampleDictionary.h"
#import "Product.h"

@interface ProductSelectionView() <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITextField *searchTextField;
    UITableView *suggestionTableView;
    UITableView *productTableView;
    NSMutableArray *suggestionArray;
    NSMutableArray *productNameArray;
    
    NSTimer *typeTimer;
    
    int maxPage;
}

@end

@implementation ProductSelectionView

@synthesize delegate;
@synthesize selectedProductArray;

- (id)initWithFrame:(CGRect)rect
{
    if ((self = [super initWithFrame:rect]))
    {
        [self commonIntialization];
    }
    return self;
}

-(void)commonIntialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    maxPage = 20;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Products you are takeing";
    titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    titleLabel.numberOfLines = 1;
    titleLabel.minimumScaleFactor = 0.5f;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UIView *separatorLineViewTitile = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height - 1, self.frame.size.width, 1)];
    separatorLineViewTitile.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorLineViewTitile];
    
    productTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y + titleLabel.frame.size.height + 20, self.frame.size.width - 40, 300) style:UITableViewStylePlain];
    productTableView.dataSource = self;
    productTableView.delegate = self;
    productTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    productTableView.backgroundColor = [UIColor clearColor];
    //    productTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:productTableView];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, productTableView.frame.origin.y + productTableView.frame.size.height + 20, self.frame.size.width, 30)];
    searchTextField.backgroundColor = [UIColor clearColor];
    searchTextField.placeholder = @"Add products";
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.delegate = self;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:searchTextField];
    
    UIView *separatorLineViewTextField = [[UIView alloc] initWithFrame:CGRectMake(20, searchTextField.frame.origin.y + searchTextField.frame.size.height - 1, self.frame.size.width - 40, 1)];
    separatorLineViewTextField.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorLineViewTextField];
    
    suggestionTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, separatorLineViewTextField.frame.origin.y + 1, self.frame.size.width - 40, 176) style:UITableViewStylePlain];
    suggestionTableView.dataSource = self;
    suggestionTableView.delegate = self;
    suggestionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    suggestionTableView.backgroundColor = [UIColor whiteColor];
    suggestionTableView.hidden = YES;
    suggestionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    suggestionTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    suggestionTableView.layer.borderWidth = 0.5f;
    [self addSubview:suggestionTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    //    NSDictionary *dict = [SampleDictionary getDictionary];
    productNameArray = [[NSMutableArray alloc] initWithArray:[ServerCommunicationUser getProductArray]];
    suggestionArray = [[NSMutableArray alloc] init];
    selectedProductArray = [[NSMutableArray alloc] init];
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
    suggestionTableView.hidden = NO;
    [suggestionTableView reloadData];
}

-(void)textFieldChanged
{
    suggestionTableView.hidden = YES;
    maxPage = 20;
    [self stopTimer];
    if([searchTextField.text length] != 0)
    {
        [self startTimer];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == suggestionTableView)
    {
        return suggestionArray.count;
    }
    return selectedProductArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == suggestionTableView)
    {
        static NSString *cellId = @"cellIdSuggestion";
        UITableViewCell *cell;
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        NSDictionary *product = [suggestionArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [product objectForKey:@"PROPRIETARY_NAME"];
        cell.textLabel.minimumScaleFactor = 0.5f;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.text = [product objectForKey:@"NONPROPRIETARY_NAME"];
        cell.detailTextLabel.minimumScaleFactor = 0.5f;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        
        if (indexPath.row == [suggestionArray count] - 1 && [suggestionArray count] == maxPage)
        {
            maxPage += 20;
            [self getProductsByName:searchTextField.text];
            
        }
        return cell;
    }
    static NSString *cellId = @"cellIdProduct";
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NSDictionary *productObject = [selectedProductArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [productObject objectForKey:@"PROPRIETARY_NAME"];
    cell.textLabel.minimumScaleFactor = 0.5f;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = [productObject objectForKey:@"NONPROPRIETARY_NAME"];
    cell.detailTextLabel.minimumScaleFactor = 0.5f;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == suggestionTableView)
    {
        [selectedProductArray addObject:[suggestionArray objectAtIndex:indexPath.row]];
        searchTextField.text = @"";
        [self textFieldChanged];
        [self changeInSelectedProductArray];
        [productTableView reloadData];
//        [productNameArray addObjectsFromArray:[ServerCommunicationUser getProductArray]];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == suggestionTableView)
    {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [selectedProductArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self changeInSelectedProductArray];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)changeInSelectedProductArray
{
    if(delegate)
    {
        [delegate changeInSelectedProductArray:selectedProductArray];
    }
}

-(void)getProductsByName:(NSString*)name
{
    NSURL *URL = [NSURL URLWithString:searchProduct];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"PROPRIETARY_NAME", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:maxPage], @"maxPerPage", queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@",dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [suggestionArray removeAllObjects];
                    [suggestionArray addObjectsFromArray:[dataJSON objectForKey:@"Data"]];
                    [suggestionTableView reloadData];
                    suggestionTableView.hidden = NO;
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
