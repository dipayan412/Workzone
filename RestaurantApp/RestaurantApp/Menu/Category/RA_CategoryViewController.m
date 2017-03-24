//
//  RA_CategoryViewController.m
//  RestaurantApp
//
//  Created by World on 1/6/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "RA_CategoryViewController.h"
#import "RA_CategoryCell.h"
#import "RA_CategoryObject.h"
#import "RA_ItemViewController.h"
#import "RA_ImageCache.h"

@interface RA_CategoryViewController ()
{
    NSMutableArray *categoryObjectArray;
    
    RA_ImageCache *imgCh;
}

@property (nonatomic, retain) NSMutableArray *categoryObjectArray;
@property (nonatomic, retain) ASIHTTPRequest *categoryRequest;
@property (nonatomic, assign) BOOL isCategoryShowed;

@end

@implementation RA_CategoryViewController

@synthesize categoryObjectArray;
@synthesize categoryRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kPageBGColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    imgCh = [[RA_ImageCache alloc] init];
    categoryObjectArray = [[NSMutableArray alloc] init];
    
    //modifying the attributes of the tableview
    containerTableView.frame = CGRectMake(10, 10, 300, 489);
    containerTableView.backgroundColor = [UIColor whiteColor];
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    containerTableView.layer.cornerRadius = 4.0f;
    containerTableView.layer.borderWidth = 1.0f;
    containerTableView.separatorColor = [UIColor clearColor];
    containerTableView.layer.borderColor = kBorderColor;
    [containerTableView setSeparatorInset:UIEdgeInsetsZero];
    
    //setting reload button
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:kReloadButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(reloadButtonAction)];
    self.navigationItem.rightBarButtonItem = reloadButton;
    
    [self fetchRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //if category items already loaded, do not need to fetch again
    if(!self.isCategoryShowed)
    {
        LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = AMLocalizedString(@"kWait", nil);
        hud.labelColor = [UIColor lightGrayColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * Method name: reloadButtonAction
 * Description: load the category objects and shows busy screen while loading
 * Parameters: none
 */

-(void)reloadButtonAction
{
    //reload button action
    [self.categoryObjectArray removeAllObjects];
    [containerTableView reloadData];
    
    //show the busy screen
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = AMLocalizedString(@"kWait", nil);
    hud.labelColor = [UIColor lightGrayColor];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    
    [self fetchRequest];
}

/**
 * Method name: fetchRequest
 * Description: request to server
 * Parameters: none
 */

-(void)fetchRequest
{
    //send server a request
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@?accesskey=%@", CategoryAPI,AccessKey];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    self.categoryRequest = [ASIHTTPRequest requestWithURL:url];
    categoryRequest.delegate = self;
    
    [categoryRequest startAsynchronous];
}

#pragma mark request delegate methods

-(void)requestFinished:(ASIHTTPRequest *)request
{
    //if request sent successfully
    if(request == self.categoryRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kParseResponse", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        
        NSArray *responseArray = [responseObject objectForKey:@"data"];
        for(int i = 0;i < responseArray.count; i++)
        {
            NSDictionary *dic = [[responseArray objectAtIndex:i] objectForKey:@"Category"];
            
            //a category object is consists of the id of a category,image of the item and its name
            RA_CategoryObject *catObj = [[RA_CategoryObject alloc] init];
            catObj.categoryId = [dic objectForKey:@"Category_ID"];
            catObj.categoryImage = [dic objectForKey:@"Category_image"];
            catObj.categoryName = [dic objectForKey:@"Category_name"];
            
            [self.categoryObjectArray addObject:catObj];
        }
        
        self.isCategoryShowed = YES;
        //hide busyscreen as data loaded from server
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [containerTableView reloadData];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    //could not connect to server. Request failed
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kConnectServer", nil) delegate:Nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles: nil];
    [alert show];
}

#pragma mark tableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryObjectArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //configure the cells for each category object
    static NSString *identifier = @"CellId";
    RA_CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[RA_CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    RA_CategoryObject *obj = [self.categoryObjectArray objectAtIndex:indexPath.row];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@restaurant/%@",AdminPageURL,obj.categoryImage];
    
    UIImage *photo = [imgCh getImage:urlStr];
    
    cell.categoryNameLabel.text = obj.categoryName;
    cell.categoryImageView.image = photo;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([UIScreen mainScreen].bounds.size.height > 568)//if ipad
    {
        return 100;
    }
    return 63;//if iphone
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show the items under the selected category on the next page
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RA_CategoryObject *catObj = [self.categoryObjectArray objectAtIndex:indexPath.row];
    
    RA_ItemViewController *vc = [[RA_ItemViewController alloc] initWithNibName:@"RA_ItemViewController" bundle:nil];
    vc.categoryId = catObj.categoryId;
    vc.categoryName = catObj.categoryName;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
