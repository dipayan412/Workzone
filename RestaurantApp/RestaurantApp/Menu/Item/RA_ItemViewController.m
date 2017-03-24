//
//  RA_ItemViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_ItemViewController.h"
#import "RA_ItemDetailViewController.h"
#import "RA_ItemCell.h"
#import "RA_MenuObject.h"
#import "RA_ImageCache.h"
#import "RA_AppDelegate.h"

@interface RA_ItemViewController ()
{
    NSMutableArray *categoryIdArray;
    RA_ImageCache *imgCh;
}

@property (nonatomic, assign) BOOL isSearchTapped;
@property (nonatomic, retain) ASIHTTPRequest *menuRequest;
@property (nonatomic, retain) ASIHTTPRequest *taxCurrencyRequest;
@property (nonatomic, retain) NSArray *menuItemsArray;
@property (nonatomic, retain) NSArray *filteredArray;
@property (nonatomic, assign) BOOL isItemsShowed;

@end

@implementation RA_ItemViewController

@synthesize isSearchTapped;
@synthesize menuRequest;
@synthesize taxCurrencyRequest;
@synthesize menuItemsArray;
@synthesize filteredArray;
@synthesize categoryId;
@synthesize isItemsShowed;
@synthesize categoryName;

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
    
    //setting background page color and title text color
    self.view.backgroundColor = kPageBGColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = self.categoryName;
    
    self.filteredArray = [[NSArray alloc] init];
    
    categoryIdArray = [[NSMutableArray alloc] init];
    imgCh = [[RA_ImageCache alloc] init];
    
    //serachview initialized. Initially it is above the view as it is hidden from the view
    searchView.frame = CGRectMake(0, -50, 320, 50);
    searchView.backgroundColor = kSearchViewBGColor;
    
    //modifying attributes of the tableview
    containerTableView.frame = CGRectMake(10, 10, 300, 400);
    
    containerTableView.backgroundColor = [UIColor whiteColor];
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    containerTableView.layer.cornerRadius = 4.0f;
    containerTableView.layer.borderWidth = 1.0f;
    containerTableView.separatorColor = [UIColor clearColor];
    containerTableView.layer.borderColor = kBorderColor;
    [containerTableView setSeparatorInset:UIEdgeInsetsZero];
    
    //search textfield icon generated
    searchTextField.leftView = [[UIImageView alloc] initWithImage:kSearchIconImage];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //search button created
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                      target:self
                                                                                      action:@selector(searchButtonAction)];
    searchButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    //whenever the searchtextfild receives an input, textFieldText method get called
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector (textFieldText:)
                               name:UITextFieldTextDidChangeNotification
                             object:searchTextField];
    
    // creating the request for the items of the selected category
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@?accesskey=%@&category_id=%@", MenuAPI,AccessKey,self.categoryId];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    self.menuRequest = [ASIHTTPRequest requestWithURL:url];
    menuRequest.delegate = self;
    
    [menuRequest startAsynchronous];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    searchTextField.placeholder = AMLocalizedString(@"kSearchPlaceHolder", nil);
    
    //if items already loded do not need to show busyscreen
    if(!self.isItemsShowed)
    {
        //show busy screen
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = AMLocalizedString(@"kWait", nil);
        hud.labelColor = [UIColor lightGrayColor];
        
        //tableview height reduced
        CGRect frame = containerTableView.frame;
        frame.size.height = self.view.frame.size.height - 75;
        containerTableView.frame = frame;
    }
}

/**
 * Method name: textFieldText
 * Description: searches through all the item object after every character input and updates the table by search result
 * Parameters: notification
 */

-(void)textFieldText:(id)notification
{
    if([searchTextField.text isEqualToString:@""])//if searchTextField does not have any character all the items to be showed
    {
        self.filteredArray = menuItemsArray;
    }
    else//if seachfield got a charater, then fetches the items which contain the character/characters. this is handled as case insensitive
    {
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"menuName CONTAINS[c] %@",searchTextField.text];
        self.filteredArray = [menuItemsArray filteredArrayUsingPredicate:predicate2];
    }
    
    [containerTableView reloadData];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    // request to server succeeded
    if(request == self.menuRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                       options:kNilOptions
                                                                         error:&error];
        if (error)
        {
            LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kParseResponse", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        
        NSArray *responseArray = [responseObject objectForKey:@"data"];
        NSMutableArray *menuItemArray = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < responseArray.count; i++)
        {
            NSDictionary *dic = [[responseArray objectAtIndex:i] objectForKey:@"Menu"];
            
            // a menu object consists of the item's id,item image,name,price,menuSerFor and numberOfPeople. Last two items get populated in the next page itamDetailsViewController
            RA_MenuObject *menuObject = [[RA_MenuObject alloc] init];
            menuObject.menuId = [dic objectForKey:@"Menu_ID"];
            menuObject.menuImagePath = [dic objectForKey:@"Menu_image"];
            menuObject.menuName = [dic objectForKey:@"Menu_name"];
            menuObject.menuPrice = [dic objectForKey:@"Price"];
            
            //populate the menuobjects in an array
            [menuItemArray addObject:menuObject];
        }
        
        self.filteredArray = menuItemArray;
        menuItemsArray = [[NSArray alloc] initWithArray:menuItemArray];
        [containerTableView reloadData];
        self.isItemsShowed = YES;
        
        //busy screen get hidden
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //next request created for determining the currency of the price
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"%@?accesskey=%@", TaxCurrencyAPI,AccessKey];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        self.taxCurrencyRequest = [ASIHTTPRequest requestWithURL:url];
        taxCurrencyRequest.delegate = nil;
        
        [taxCurrencyRequest startAsynchronous];
    }
    if(request == self.taxCurrencyRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        if (error)
        {
            LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kParseResponse", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        
        NSArray *responseArray = [responseObject objectForKey:@"data"];
        if(responseArray.count == 2)
        {
//            NSDictionary *dic = [[responseArray objectAtIndex:0] objectForKey:@"tax_n_currency"];
//            NSString *taxValue = [dic objectForKey:@"Value"];
//            float taxAmount = taxValue.floatValue;
//
//            NSDictionary *dic2 = [[responseArray objectAtIndex:1] objectForKey:@"tax_n_currency"];
//            NSString *currency = [dic2 objectForKey:@"Value"];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    //request failed. could not connect to server
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kConnectServer", nil) delegate:Nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles: nil];
    [alert show];
}

/**
 * Method name: searchButtonAction
 * Description: search button action. this method shows/hides the searchTextField
 * Parameters: none
 */

-(void)searchButtonAction
{
    // search button action. this method shows/hides the searchTextField
    int y;
    
    self.isSearchTapped = !self.isSearchTapped;
    
    if(self.isSearchTapped)
    {
        y = 0;
    }
    else
    {
        y = -50;
        [self.view endEditing:YES];
        searchTextField.text = @"";
    }
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    searchView.frame = CGRectMake(0, y, searchView.frame.size.width, 50);
    containerTableView.frame = CGRectMake(10, y + 60, containerTableView.frame.size.width, containerTableView.frame.size.height);
    if(y < 0)
    {
        CGRect frame = containerTableView.frame;
        frame.size.height = self.view.frame.size.height - 75;
        containerTableView.frame = frame;
    }
    else
    {
        CGRect frame = containerTableView.frame;
        frame.size.height = self.view.frame.size.height - 125;
        containerTableView.frame = frame;
    }
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark TextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark Tableview Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //configuring each cells for each item
    static NSString *identifier = @"ItemCellId";
    RA_ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[RA_ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    RA_MenuObject *menuObject = [self.filteredArray objectAtIndex:indexPath.row];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@restaurant/%@",AdminPageURL,menuObject.menuImagePath];
    UIImage *photo = [imgCh getImage:urlStr];
    
    cell.recipeNameLabel.text = menuObject.menuName;
    cell.recipeImageView.image = photo;
    RA_AppDelegate *appDel = (RA_AppDelegate*)[[UIApplication sharedApplication] delegate];
    cell.priceLabel.text = [NSString stringWithFormat:@"%0.1f %@", menuObject.menuPrice.floatValue, appDel.currency];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([UIScreen mainScreen].bounds.size.height > 568)//ipad
    {
        return 100;
    }
    return 63;//iphone
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //details of the selected menu shown in the next page
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RA_MenuObject *menuObject = [self.filteredArray objectAtIndex:indexPath.row];
    RA_ItemDetailViewController *itemDetailVC = [[RA_ItemDetailViewController alloc] initWithNibName:@"RA_ItemDetailViewController" bundle:nil withMenuObject:menuObject];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: AMLocalizedString(@"kBack", nil) style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [self.navigationController pushViewController:itemDetailVC animated:YES];
}

/**
 * Method name: backGroundTap
 * Description: hides the keyboard
 * Parameters: button which has been tapped
 */

-(IBAction)backGroundTap:(id)sender
{
    [self.view endEditing:YES];
}
@end
