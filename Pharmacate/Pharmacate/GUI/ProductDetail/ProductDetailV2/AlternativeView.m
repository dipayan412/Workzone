//
//  AlternativeView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "AlternativeView.h"
#import "AlternateButtonView.h"
#import "AlternativeCell.h"

@interface AlternativeView() <UITableViewDelegate, UITableViewDataSource, AlternativeCellDelegate>
{
    UIControl *similarProductControl;
    UIControl *homeopathicControl;
    UITableView *similarProductTableView;
    UIImageView *similarProductsButtonImageView;
    NSMutableArray *similarProductArray;
    
    BOOL IsSimilarProductExpanded;
    BOOL isServerCallFinished;
    NSString *productId;
    
    NSIndexPath *selectedIndexPath;
    UITableView *alternativeTableView;
    
    NSMutableArray *otcArray;
    NSMutableArray *homeopathicArray;
    NSMutableArray *prescriptionArray;
    NSMutableArray *supplementArray;
}

@end

@implementation AlternativeView

@synthesize delegate;

- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId
{
    if ((self = [super initWithFrame:rect]))
    {
        productId = _productId;
        [self commonInitialization];
    }
    return self;
}

-(void)commonInitialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    otcArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(kAlternativeLoading, nil), nil];
    homeopathicArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(kAlternativeLoading, nil), nil];
    prescriptionArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(kAlternativeLoading, nil), nil];
    supplementArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(kAlternativeLoading, nil), nil];
    
    isServerCallFinished = NO;
    selectedIndexPath = [NSIndexPath indexPathForRow:1000 inSection:0];
    
    alternativeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height) style:UITableViewStylePlain];
    alternativeTableView.delegate = self;
    alternativeTableView.dataSource = self;
    alternativeTableView.backgroundColor = [UIColor clearColor];
    alternativeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    alternativeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:alternativeTableView];
    
    [self getSimilarProductFromServerForProduct:productId];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    AlternativeCell *cell;
    if(cell == nil)
    {
        cell = [[AlternativeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if(selectedIndexPath.row != indexPath.row)
    {
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"forwardButtonGray.png"];
    }
    else
    {
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"downButtonBlack.png"];
    }
    
    cell.delegate = self;
    
    if(indexPath.row == 0)
    {
        cell.cellTitleLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(kFilterOTC, nil)];
        cell.dataArray = otcArray;
    }
    else if(indexPath.row == 1)
    {
        cell.cellTitleLabel.text = [NSString stringWithFormat:@"%@",  NSLocalizedString(kFilterSupplement, nil)];
        cell.dataArray = supplementArray;
    }
    else if(indexPath.row == 2)
    {
        cell.cellTitleLabel.text = [NSString stringWithFormat:@"%@",  NSLocalizedString(kFilterHomeopathic, nil)];
        cell.dataArray = homeopathicArray;
    }
    else if(indexPath.row == 3)
    {
        cell.cellTitleLabel.text = [NSString stringWithFormat:@"%@",  NSLocalizedString(kFilterPrescription, nil)];
        cell.dataArray = prescriptionArray;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIndexPath && selectedIndexPath.row == indexPath.row)
    {
        if(indexPath.row == 0)
        {
            return otcArray.count * 44.0f + 60.0f;
        }
        else if(indexPath.row == 1)
        {
            return supplementArray.count * 44.0f + 60.0f;
        }
        else if(indexPath.row == 2)
        {
            return homeopathicArray.count * 44.0f + 60.0f;
        }
        else if(indexPath.row == 3)
        {
            return prescriptionArray.count * 44.0f + 60.0f;
        }
    }
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(selectedIndexPath)
    {
        AlternativeCell *cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"forwardButtonGray.png"];
    }
    AlternativeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.rightAccessoryImageView.image = [UIImage imageNamed:@"downButtonBlack.png"];
    
    if(selectedIndexPath && selectedIndexPath.row == indexPath.row)
    {
        selectedIndexPath = [NSIndexPath indexPathForRow:1000 inSection:0];
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"forwardButtonGray.png"];
    }
    else
    {
        selectedIndexPath = indexPath;
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"downButtonBlack.png"];
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(void)alternativeProductSelectedWithProductId:(NSString *)_productId andName:(NSString *)_name
{
    if(delegate)
    {
        [delegate similarProductSelectionAction:_productId productName:_name];
    }
}

-(void)getSimilarProductFromServerForProduct:(NSString*)_productId
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:getSimilarProductUrl];
    [urlStr appendString:[NSString stringWithFormat:@"?pId=%@",_productId]];
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
        isServerCallFinished = YES;
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//            NSLog(@"similarProducts %@", dataJSON);  
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [homeopathicArray removeAllObjects];
                    [homeopathicArray addObjectsFromArray:[[dataJSON objectForKey:@"Data"] objectForKey:@"Homeopathic"]];
                    if(homeopathicArray.count == 0)
                    {
                        [homeopathicArray addObject:NSLocalizedString(kAlternativeNoData, nil)];
                    }
                    
                    [otcArray removeAllObjects];
                    [otcArray addObjectsFromArray:[[dataJSON objectForKey:@"Data"] objectForKey:@"OTC"]];
                    if(otcArray.count == 0)
                    {
                        [otcArray addObject:NSLocalizedString(kAlternativeNoData, nil)];
                    }
                    
                    [prescriptionArray removeAllObjects];
                    [prescriptionArray addObjectsFromArray:[[dataJSON objectForKey:@"Data"] objectForKey:@"Prescription"]];
                    if(prescriptionArray.count == 0)
                    {
                        [prescriptionArray addObject:NSLocalizedString(kAlternativeNoData, nil)];
                    }
                    
                    [supplementArray removeAllObjects];
                    [supplementArray addObjectsFromArray:[[dataJSON objectForKey:@"Data"] objectForKey:@"Supplement"]];
                    if(supplementArray.count == 0)
                    {
                        [supplementArray addObject:NSLocalizedString(kAlternativeNoData, nil)];
                    }
                    
                    [alternativeTableView reloadData];
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
