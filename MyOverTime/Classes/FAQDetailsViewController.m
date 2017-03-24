//
//  FAQDetailsViewController.m
//  MyOvertime
//
//  Created by Ashif on 6/17/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "FAQDetailsViewController.h"
#import "GlobalFunctions.h"
#import "FAQTableCell.h"

#define questionHeight 50
#define answerHeight 202

@interface FAQDetailsViewController ()

@end

@implementation FAQDetailsViewController

@synthesize questions;
@synthesize answers;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        sectionInfoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *qArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<18; i++)
    {
        SectionInfo *sectionInfo = [[SectionInfo alloc] init];
        sectionInfo.open = NO;
        
        [sectionInfo insertObject:[NSNumber numberWithInteger:answerHeight] inRowHeightsAtIndex:1];
        
        [sectionInfoArray addObject:sectionInfo];
        
        NSString *question = [NSString stringWithFormat:@"%@",[self getQuestionFor:i+1]];
        [qArray addObject:question];
    }
    
    self.questions = qArray;
    [qArray release];
    
    NSMutableArray *aArray = [[NSMutableArray alloc] init];
    for(int i=0; i<18; i++)
    {
        NSString *answer = [NSString stringWithFormat:@"%@",[self getAnswerFor:i+1]];
        [aArray addObject:answer];
    }
    
    self.answers = aArray;
    [aArray release];
    
    self.title = NSLocalizedString(@"TITLE_FAQ", nil);
    
    contentView.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
    
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    //	self.tableView.backgroundView = myImageView;
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
	[myImageView release];
    
    if(!stylePerformed)
    {
        stylePerformed = YES;
        CGRect frame = contentView.frame;
        frame.origin.y = 3;
        frame.size.height = self.view.bounds.size.height - 6;
        frame.size.width = self.view.bounds.size.width - 3;
        contentView.frame = frame;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, self.view.bounds.size.width - 6, self.view.bounds.size.height - 6)];
        [containerView.layer setCornerRadius:7.0f];
        [containerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [containerView.layer setBorderWidth:1.0f];
        
        containerView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        [self.view addSubview:containerView];
        [self.view sendSubviewToBack:containerView];
        [containerView release];
    }
    
    openSectionIndex = NSNotFound;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString*)getQuestionFor:(int)_no
{
    NSString *str = [NSString stringWithFormat:@"FAQ_Question_%d", _no];
    NSString *question = NSLocalizedString( str, nil);
    return question;
}

-(NSString*)getAnswerFor:(int)_no
{
    NSString *str = [NSString stringWithFormat:@"FAQ_Answer_%d", _no];
    NSString *answer = NSLocalizedString( str, nil);
    return answer;
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (sectionInfoArray.count > 0) ? sectionInfoArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionInfo *sectionInfo = [sectionInfoArray objectAtIndex:section];
        
    return sectionInfo.open ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SectionInfoCell";
    
    FAQTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[FAQTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withIndex:indexPath.section];
        NSLog(@"section %d", indexPath.section);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
    }
    
    cell.indexPath = indexPath.section;
    [cell setNeedsLayout];
    [cell setAnswerText:[self.answers objectAtIndex:indexPath.section]];
    
    return  cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (sectionInfoArray.count > 0)
    {
        SectionInfo *sectionInfo = [sectionInfoArray objectAtIndex:section];

        if (!sectionInfo.headerView)
        {
            /*
            if(section==6)
            {
                sectionInfo.headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, contentView.bounds.size.width, 78) title:[self.questions objectAtIndex:section] section:section delegate:self];
            }
            else
            {
                sectionInfo.headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, contentView.bounds.size.width, questionHeight) title:[self.questions objectAtIndex:section] section:section delegate:self];
            }
            */
            sectionInfo.headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, contentView.bounds.size.width, questionHeight) title:[self.questions objectAtIndex:section] section:section delegate:self];
        }
        
        return sectionInfo.headerView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if(indexPath.section == 4 ||indexPath.section ==  6 || indexPath.section == 9 || indexPath.section == 10 || indexPath.section == 11 || indexPath.section == 12)
    {
        return 101;
    }
    else
    {
        return answerHeight;
    }
    */
    return answerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if(section == 6)
//    {
//        return 78;
//    }
    return questionHeight;
}


#pragma mark Section header delegate

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
{
	SectionInfo *sectionInfo = [sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    NSInteger countOfRowsToInsert = 1;
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < countOfRowsToInsert; i++)
    {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = openSectionIndex;
    
    if (previousOpenSectionIndex != NSNotFound)
    {
		SectionInfo *previousOpenSection = [sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = 1;
        
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    UITableViewRowAnimation deleteAnimation;
    
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex)
    {
        deleteAnimation = UITableViewRowAnimationFade;
    }
    else
    {
        deleteAnimation = UITableViewRowAnimationFade;
    }

    [contentView beginUpdates];
    [contentView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
    [contentView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [contentView endUpdates];
    openSectionIndex = sectionOpened;
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
{
	SectionInfo *sectionInfo = [sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [contentView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0)
    {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        
        [contentView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
    }
    openSectionIndex = NSNotFound;
}

@end
