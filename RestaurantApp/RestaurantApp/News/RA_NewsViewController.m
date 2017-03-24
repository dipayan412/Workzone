//
//  RA_NewsViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_NewsViewController.h"
#import "RA_NewsDetailViewController.h"
#import "RA_NewsObject.h"

@interface RA_NewsViewController () <NSXMLParserDelegate>
{
    NSXMLParser *parser;
    NSString *element;
    NSString *tempelEment;
    
    NSMutableString *title,*link,*pubDate;
    
    RA_NewsObject *newsObject;
    BOOL dataLoaded;
}

@property (nonatomic, retain) NSMutableArray *newsObjectArray;

@end

@implementation RA_NewsViewController

@synthesize newsObjectArray;

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
    
    newsObjectArray = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //creating the reload button
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:kReloadButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(reloadButtonPressed)];
    self.navigationItem.rightBarButtonItem = reloadButton;
    
    //show busy screen
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = AMLocalizedString(@"kWait", nil);
    hud.labelColor = [UIColor lightGrayColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //if parsing is already done, do not need to parse again
    if(!dataLoaded)
    {
        dataLoaded = YES;
        [self fetchNewsFeed];
    }
}

/**
 * Method name: fetchNewsFeed
 * Description: create the parser and start parsing
 * Parameters: none
 */

-(void)fetchNewsFeed
{
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:NewsFeedAPI]];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

/**
 * Method name: reloadButtonPressed
 * Description: reload the news feed and shows busy screen while loading
 * Parameters: none
 */

-(void)reloadButtonPressed
{
    [newsObjectArray removeAllObjects];
    
    //show busy screen
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = AMLocalizedString(@"kWait", nil);
    hud.labelColor = [UIColor lightGrayColor];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    
    //start fetching newsfeed
    [self fetchNewsFeed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark tableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return newsObjectArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //showing feeds list
    static NSString *identifier = @"NewsCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    }
    RA_NewsObject *news = [newsObjectArray objectAtIndex:indexPath.row];
    cell.textLabel.text = news.titleString;
    cell.detailTextLabel.text = news.publishedDateString;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // showing the tapped feed's link to the next page
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RA_NewsObject *news = [newsObjectArray objectAtIndex:indexPath.row];
    
    RA_NewsDetailViewController *vc = [[RA_NewsDetailViewController alloc] initWithNibName:@"RA_NewsDetailViewController" bundle:nil withUrlString:news.linkString];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: AMLocalizedString(@"kBack", nil) style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark parser delegate methods

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    element = elementName;
    if([element isEqualToString:@"item"])
    {
        //detecting each item in the xml
        newsObject = [[RA_NewsObject alloc] init];
        
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        pubDate = [[NSMutableString alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([element isEqualToString:@"title"])//detecting title of a feed
    {
        [title appendString:string];
    }
    else if ([element isEqualToString:@"link"])//detecting link of a feed
    {
        if(![string isEqualToString:@" "])
        {
            [link appendString:string];
        }
    }
    else if([element isEqualToString:@"pubDate"])//detecting pubDate of a feed
    {
        [pubDate appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"item"])
    {
        // a news object consist of a feed's url,title and publishing date
        newsObject.titleString = title;
        newsObject.publishedDateString = pubDate;
        newsObject.linkString = link;
        
        [newsObjectArray addObject:newsObject];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // parsing ended and hide the busy screen and reload table
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [containerTableview reloadData];
}

@end
