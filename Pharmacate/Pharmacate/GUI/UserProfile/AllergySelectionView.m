//
//  AllergySelectionView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "AllergySelectionView.h"
#import "SampleDictionary.h"
#import "Allergens.h"
#import "Product.h"

@interface AllergySelectionView() <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITextField *searchTextField;
    UITableView *suggestionTableView;
    UITableView *allergyTableView;
    NSMutableArray *suggestionArray;
    NSMutableArray *allergyNameArray;
    
    NSTimer *typeTimer;
    int maxPage;
    int allergenCount;
    int productCount;
}

@end

@implementation AllergySelectionView

@synthesize delegate;
@synthesize selectedAllergyArray;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showKeyBoardInfo:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeyBoard)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    maxPage = 20;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(kProfileDetailAllergyTitle, nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    titleLabel.numberOfLines = 1;
    titleLabel.minimumScaleFactor = 0.5f;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UIView *separatorLineViewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height, self.frame.size.width, 1)];
    separatorLineViewTitle.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorLineViewTitle];
    
    allergyTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y + titleLabel.frame.size.height + 20, self.frame.size.width - 40, 300) style:UITableViewStylePlain];
    allergyTableView.dataSource = self;
    allergyTableView.delegate = self;
    allergyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    allergyTableView.backgroundColor = [UIColor clearColor];
    //    productTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:allergyTableView];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, allergyTableView.frame.origin.y + allergyTableView.frame.size.height + 20, self.frame.size.width, 30)];
    searchTextField.backgroundColor = [UIColor clearColor];
    searchTextField.placeholder = NSLocalizedString(kProfileDetailAllergyTPlaceholder, nil);
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.delegate = self;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:searchTextField];
    
    UIView *separatorLineViewTextField = [[UIView alloc] initWithFrame:CGRectMake(20, searchTextField.frame.origin.y + searchTextField.frame.size.height - 1, self.frame.size.width - 40, 1)];
    separatorLineViewTextField.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorLineViewTextField];
    
    suggestionTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, separatorLineViewTextField.frame.origin.y + 1, self.frame.size.width - 40, [UIScreen mainScreen].bounds.size.height - (separatorLineViewTextField.frame.origin.y + 1)) style:UITableViewStylePlain];
    suggestionTableView.dataSource = self;
    suggestionTableView.delegate = self;
    suggestionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    suggestionTableView.backgroundColor = [UIColor whiteColor];
    suggestionTableView.hidden = YES;
    suggestionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:suggestionTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    //    NSDictionary *dict = [SampleDictionary getDictionary];
//    allergyNameArray = [[NSMutableArray alloc] initWithArray:[ServerCommunicationUser getAllergenArray]];
//    [allergyNameArray addObjectsFromArray:[ServerCommunicationUser getProductArray]];
    suggestionArray = [[NSMutableArray alloc] init];
    selectedAllergyArray = [[NSMutableArray alloc] init];
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
    [self getAllergenByName:searchTextField.text];
    suggestionTableView.hidden = NO;
    [suggestionTableView reloadData];
}

-(void)textFieldChanged
{
    suggestionTableView.hidden = YES;
    maxPage = 20;
    [self stopTimer];
    if([searchTextField.text length] > 2)
    {
        [self startTimer];
    }
}

-(void)showKeyBoardInfo:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    if(suggestionTableView.frame.origin.y + suggestionTableView.frame.size.height > [UIScreen mainScreen].bounds.size.height - keyboardFrameBeginRect.size.height)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        CGRect frame = self.frame;
        frame.origin.y -= keyboardFrameBeginRect.size.height;
        self.frame = frame;
        
        [UIView commitAnimations];
    }
}

-(void)hideKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.frame;
    frame.origin.y = 0;
    self.frame = frame;
    
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    return selectedAllergyArray.count;
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
//        NSLog(@"%@", NSStringFromClass([[selectedAllergyArray objectAtIndex:indexPath.row] class]));
        NSDictionary *allergenObject = [suggestionArray objectAtIndex:indexPath.row];
//        if([[suggestionArray objectAtIndex:indexPath.row] isKindOfClass:[Allergens class]])
//        {
//            Allergens *allergen = [suggestionArray objectAtIndex:indexPath.row];
//            cell.textLabel.text = allergen.allergenName;
//        }
//        else
//        {
//            Product *product = [suggestionArray objectAtIndex:indexPath.row];
//            cell.textLabel.text = product.productName;
//            cell.detailTextLabel.text = product.productIngredientName;
//        }
        
        cell.textLabel.text = [allergenObject objectForKey:@"ENTITY_NAME"];
        cell.textLabel.minimumScaleFactor = 0.5f;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        if([[allergenObject objectForKey:@"ENTITY"] isEqualToString:@"PRODUCT"])
        {
            cell.detailTextLabel.text = [allergenObject objectForKey:@"NONPROPRIETARY_NAME"];
            cell.detailTextLabel.minimumScaleFactor = 0.5f;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        }
        
        if (indexPath.row == [suggestionArray count] - 1 && (allergenCount == maxPage || productCount == maxPage))
        {
            maxPage += 20;
            [self getAllergenByName:searchTextField.text];
        }
        
        return cell;
    }
    static NSString *cellId = @"cellIdAllergen";
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    NSDictionary *allergenObject = [selectedAllergyArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [allergenObject objectForKey:@"ENTITY_NAME"];
    cell.textLabel.minimumScaleFactor = 0.5f;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    if([[allergenObject objectForKey:@"ENTITY"] isEqualToString:@"PRODUCT"])
    {
        cell.detailTextLabel.text = [allergenObject objectForKey:@"NONPROPRIETARY_NAME"];
        cell.detailTextLabel.minimumScaleFactor = 0.5f;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
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
        [selectedAllergyArray addObject:[suggestionArray objectAtIndex:indexPath.row]];
        searchTextField.text = @"";
        [self textFieldChanged];
        [self changeInSelectedAllergyArray];
        [allergyTableView reloadData];
        [searchTextField resignFirstResponder];
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
        [selectedAllergyArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self changeInSelectedAllergyArray];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)changeInSelectedAllergyArray
{
    if(delegate)
    {
        NSMutableArray *productArray = [[NSMutableArray alloc] init];
        NSMutableArray *allergenArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < selectedAllergyArray.count; i++)
        {
            if([[[selectedAllergyArray objectAtIndex:i] objectForKey:@"ENTITY"] isEqualToString:@"PRODUCT"])
            {
                [productArray addObject:[selectedAllergyArray objectAtIndex:i]];
            }
            else
            {
                [allergenArray addObject:[selectedAllergyArray objectAtIndex:i]];
            }
        }
        [delegate changeInSelectedAllergyArray:allergenArray ProductArray:productArray];
    }
}

-(void)getAllergenByName:(NSString*)name
{
    NSURL *URL = [NSURL URLWithString:searchAllergens];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:maxPage], @"LIMIT", name, @"ALLERGEN_NAME", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
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
                    [suggestionArray addObjectsFromArray:[dataJSON objectForKey:@"ALLERGEN_LIST"]];
                    [suggestionTableView reloadData];
//                    suggestionTableView.hidden = NO;
                    
                    allergenCount = [[dataJSON objectForKey:@"ALLERGEN_COUNT"] intValue];
                    productCount = [[dataJSON objectForKey:@"PRODUCT_COUNT"] intValue];
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
