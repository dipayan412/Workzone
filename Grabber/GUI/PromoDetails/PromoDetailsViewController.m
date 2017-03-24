//
//  PromoDetailsViewController.m
//  iOS Prototype
//
//  Created by World on 3/17/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "PromoDetailsViewController.h"
#import "inputTextCell.h"
#import "CreateStoreTopCell.h"

@interface PromoDetailsViewController ()
{
    CreateStoreTopCell *topCell;
    
    inputTextCell *titleCell;
    inputTextCell *typeCell;
    inputTextCell *passesCell;
    inputTextCell *whenCell;
    inputTextCell *descriptionCell;
}

@end

@implementation PromoDetailsViewController

@synthesize promo;

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
    
    self.navigationItem.title = promo.promoName;
    [self cellConfiguration];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CreatePromoBG.png"]];
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    promoNameField.text = promo.promoName;
    
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        containerTableView.scrollEnabled = YES;
    }
    else
    {
        containerTableView.scrollEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark tableView delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return topCell;
            
        case 1:
            return titleCell;
            
        case 2:
            return typeCell;
            
        case 3:
            return passesCell;
            
        case 4:
            return whenCell;
            
        case 5:
            return descriptionCell;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 120.0f;
    }
    if(indexPath.row == 5)
    {
        return 120.0f;
    }
    return 44.0f;
}

-(void)cellConfiguration
{
    topCell = [[CreateStoreTopCell alloc] init];
    topCell.storeNameField.text = promo.promoName;
    topCell.storeNameField.enabled = NO;
    
    titleCell = [[inputTextCell alloc] initWithIsDescription:NO];
    titleCell.fieldTitleLabel.text = @"Title";
    titleCell.inputField.text = promo.promoName;
    titleCell.inputField.tag = 0;
    titleCell.inputField.returnKeyType = UIReturnKeyNext;
    titleCell.inputField.enabled = NO;
    titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    typeCell = [[inputTextCell alloc] initWithIsDescription:NO];
    typeCell.fieldTitleLabel.text = @"Type";
    typeCell.inputField.text = @"";
    typeCell.inputField.tag = 1;
    typeCell.inputField.returnKeyType = UIReturnKeyNext;
    typeCell.inputField.enabled = NO;
    typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    passesCell = [[inputTextCell alloc] initWithIsDescription:NO];
    passesCell.fieldTitleLabel.text = @"Passes";
    passesCell.inputField.text = @"";
    passesCell.inputField.tag = 2;
    passesCell.inputField.returnKeyType = UIReturnKeyNext;
    passesCell.inputField.enabled = NO;
    passesCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    whenCell = [[inputTextCell alloc] initWithIsDescription:NO];
    whenCell.fieldTitleLabel.text = @"When";
    whenCell.inputField.text = @"";
    whenCell.inputField.tag = 3;
    whenCell.inputField.returnKeyType = UIReturnKeyNext;
    whenCell.inputField.enabled = NO;
    whenCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    descriptionCell = [[inputTextCell alloc] initWithIsDescription:YES];
    descriptionCell.fieldTitleLabel.text = @"Description";
    descriptionCell.inputTextView.text = promo.promoDetails;
    descriptionCell.inputTextView.returnKeyType = UIReturnKeyDone;
    descriptionCell.inputTextView.editable = NO;
    descriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
