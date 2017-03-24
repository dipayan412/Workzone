//
//  PreviousSessionViewController.m
//  40Days
//
//  Created by Ashif on 6/13/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "PreviousSessionViewController.h"
#import "AppData.h"
#import "PlayerViewController.h"

@interface PreviousSessionViewController ()

@property (nonatomic, retain) NSString *filePath;

@end

@implementation PreviousSessionViewController

@synthesize audioFiles;
@synthesize filePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kAppBackGroung]];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    NSError *error = nil;
    self.filePath = [NSString stringWithFormat:@"%@/40Days", documentPath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];
    int currenntDay = [AppData getCurrentDay];
    NSMutableArray *audioArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<files.count; i++)
    {
        NSString *str = [files objectAtIndex:i];
        NSArray *array = [str componentsSeparatedByString:@"_"];
        NSString *number = [array objectAtIndex:1];
        NSArray *fileNo = [number componentsSeparatedByString:@"."];
        NSNumber *name = [[NSNumber alloc] init];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        name = [formatter numberFromString:[fileNo objectAtIndex:0]];
        [audioArray addObject:name];
    }
    
    NSArray *array = [audioArray sortedArrayUsingSelector:@selector(compare:)];

    NSMutableArray *mut = [[NSMutableArray alloc] init];
    for(int i=0; i<currenntDay; i++)
    {
        [mut addObject:[array objectAtIndex:i]];
    }
    self.audioFiles = mut;
    [mut release];
    [audioArray release];
    
    sessionsView.backgroundColor = [UIColor clearColor];
    sessionsView.backgroundView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return audioFiles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"SettingsMenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"40 Days With Christ - %@", [audioFiles objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *file = [NSString stringWithFormat:@"Day_%@.mp3", [audioFiles objectAtIndex:indexPath.row]];
    NSString *fullPath = [filePath stringByAppendingPathComponent:file];
    
//    NSString *textData = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    
    NSData *data = [NSData dataWithContentsOfFile:fullPath];
    PlayerViewController *playerVC = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    playerVC.audioData = data;
    playerVC.currnetDay = [[audioFiles objectAtIndex:indexPath.row] intValue];
    [self.navigationController pushViewController:playerVC animated:YES];
    [playerVC release];
    
}

@end
