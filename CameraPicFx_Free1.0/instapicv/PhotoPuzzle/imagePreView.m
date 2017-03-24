
//
//  imagePreView.m
//  Puzzle
//
//  Created by muhammad sami ather on 6/6/12.
//  Copyright (c) 2012 swengg-co. All rights reserved.
//


#import "imagePreView.h"
#import "gameView.h"
#import "AppDelegate.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "DataBase.h"
#import <sqlite3.h>

BOOL searching;
@interface imagePreView ()
{
    UIButton *suspend1,*editButton;
}

@end

@implementation imagePreView
@synthesize imageview;
@synthesize productName;
@synthesize imageTableView;

@synthesize pickerView;

@synthesize selectedImage;

@synthesize complexityLevel;
@synthesize fontselection;
@synthesize textfont;

@synthesize records;
@synthesize Complexity;
@synthesize Font;
@synthesize TextPlacement;
@synthesize textplace;
@synthesize Email;
@synthesize fontNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [[singletonClass sharedsingletonClass].pool drain];
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    textplace=[[[NSString alloc]init]autorelease];
//    imageview.image=selectedImage;
    fontsize=[[NSArray alloc]initWithObjects:@"Arial",@"Bradley Hand",@"Chalkboard SE",@"Snell Roundhand",@"Times New Roman", nil];
    numbetrOfrowtape=0;
    
    self.myTextField.text=@"";

 
    [self.navigationItem setHidesBackButton:YES animated:YES];
    editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame=CGRectMake(20, 3, 40, 40);
    editButton.backgroundColor=[UIColor clearColor];
    editButton.backgroundColor=nil;
    editButton.tintColor = nil;
    [editButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(nameOfSomeMethod:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:editButton] autorelease];

    ////////////Done Button//////////////
    UIView *rightview = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,40)];
    suspend1=[[UIButton alloc]initWithFrame:CGRectMake(260, 3, 40, 40)];
    suspend1.backgroundColor=nil;
    suspend1.tintColor=nil;
    suspend1.clipsToBounds=YES;
    
    suspend1.contentMode=UIViewContentModeScaleAspectFit;
    [suspend1 setImage:[UIImage imageNamed:@"next_btn"] forState:UIControlStateNormal];
    [suspend1 addTarget:self action:@selector(Done:) forControlEvents:UIControlEventTouchUpInside];
    [rightview addSubview:suspend1];
//    [suspend1 release];
//    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
//    self.navigationItem.rightBarButtonItem = customItem;
//    [customItem release];
    [rightview release];
    
    
    
    self.myTextField.tag = 2;
    self.myTextField.placeholder=@"Please write your text here.";
    self.myTextField.delegate = self;
    self.myTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    [self.myTextField addTarget:self action:@selector(textPasswordField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
//    self.fontName = [[[UILabel alloc] init]autorelease];
    
    
    NSArray *fonts=[fontselection componentsSeparatedByString:@","];
    self.fontNameLabel.text=[fonts objectAtIndex:0];
    
    [self.smallBtn setSelected:YES];
    [self.topBtn setSelected:YES];
    [self updateView];
    
    [DataBase checkAndCreateDatabase];
}
-(void)updateView
{
    if([self.smallBtn isSelected])
    {
        [self.smallBtn setBackgroundImage:[UIImage imageNamed:@"small_orange.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.smallBtn setBackgroundImage:[UIImage imageNamed:@"small_text.png"] forState:UIControlStateNormal];
    }
    if([self.mediumBtn isSelected])
    {
        [self.mediumBtn setBackgroundImage:[UIImage imageNamed:@"medium_orange.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.mediumBtn setBackgroundImage:[UIImage imageNamed:@"medium_text.png"] forState:UIControlStateNormal];
    }
    if ([self.largeBtn isSelected])
    {
        [self.largeBtn setBackgroundImage:[UIImage imageNamed:@"large_orange.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.largeBtn setBackgroundImage:[UIImage imageNamed:@"large_text.png"] forState:UIControlStateNormal];
    }
    /////////
    if([self.topBtn isSelected])
    {
        [self.topBtn setBackgroundImage:[UIImage imageNamed:@"top_orange.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.topBtn setBackgroundImage:[UIImage imageNamed:@"top_text.png"] forState:UIControlStateNormal];
    }
    if([self.middleBtn isSelected])
    {
        [self.middleBtn setBackgroundImage:[UIImage imageNamed:@"middle_orange.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.middleBtn setBackgroundImage:[UIImage imageNamed:@"middle_text.png"] forState:UIControlStateNormal];
    }
    if([self.bottomBtn isSelected])
    {
        [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"bottom_orange.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"bottom_text.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)textLengthSelected:(id)sender
{
    UIButton * temp = (UIButton*)sender;
    if(temp.tag == 122)
    {
        [self.smallBtn setSelected:YES];
        [self.mediumBtn setSelected:NO];
        [self.largeBtn setSelected:NO];
    }
    else if(temp.tag == 123)
    {
        [self.smallBtn setSelected:NO];
        [self.mediumBtn setSelected:YES];
        [self.largeBtn setSelected:NO];
    }
    else if (temp.tag == 124)
    {
        [self.smallBtn setSelected:NO];
        [self.mediumBtn setSelected:NO];
        [self.largeBtn setSelected:YES];
    }
    [self updateView];
}
-(IBAction)textPlacementSelected:(id)sender
{
    UIButton * temp = (UIButton*)sender;
    if(temp.tag == 125)
    {
        [self.topBtn setSelected:YES];
        [self.middleBtn setSelected:NO];
        [self.bottomBtn setSelected:NO];
    }
    else if(temp.tag == 126)
    {
        [self.topBtn setSelected:NO];
        [self.middleBtn setSelected:YES];
        [self.bottomBtn setSelected:NO];
    }
    else if (temp.tag == 127)
    {
        [self.topBtn setSelected:NO];
        [self.middleBtn setSelected:NO];
        [self.bottomBtn setSelected:YES];
    }
    [self updateView];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
        return YES;
}
-(IBAction)nameOfSomeMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Adwhril

- (NSString *)adWhirlApplicationKey {
    NSString *key;
    key=@"d03363079b004be1bd89e9ff4f4e49d9";
    return key;
}

- (UIViewController *)viewControllerForPresentingModalView {
    //Remember that UIViewController we created in the Game.h file? AdMob will use it.
    //If you want to use "return self;" instead, AdMob will cancel the Ad requests.
    return self;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{ 
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return ([newString length] <= 30);
}
-(void)viewWillAppear:(BOOL)animated
{
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header_edit.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBarHidden = YES;
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    [self.view addSubview:iv];
    [self.view addSubview:suspend1];
    [self.view addSubview:editButton];
    
    if(appDelegate.TopAd==NO)
    {
        //[imageview setFrame:CGRectMake(0, 46, 320, 122)];
        //[myTextField setFrame:CGRectMake(30, 106, 262, 55)];
        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView actualAdSize];
        CGRect newFrame ;
        newFrame.size = adSize;
        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
        newFrame.origin.y=46.0f;
        newFrame.size.height=50.0f;
        [singletonClass sharedsingletonClass].adWhrilView.frame = newFrame;
        
        if (![UserDefaultsManager isProUpgradePurchaseDone])
        {
//            [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
        }
    }
    else
    {
//        [imageview setFrame:CGRectMake(0, 46, 320, 170)];
        //[myTextField setFrame:CGRectMake(30, 46, 262, 55)];
    }
    
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        [imageview setFrame:CGRectMake(0, 46, 320, 222)];
        [myTextField setFrame:CGRectMake(30, 164, 262, 55)];
    }
    else
    {
        [imageview setFrame:CGRectMake(0, 46, 320, 122)];
        [myTextField setFrame:CGRectMake(30, 89, 262, 88)];
    }
    
    if(integer>=0)
    {
        dataArray1=[DataBase viewAllPuzzle:Email];
        NSDictionary *dict=[[[NSDictionary alloc]initWithDictionary:[dataArray1 objectAtIndex:integer]] autorelease];
        NSString *fontselection1=[dict objectForKey:@"fontsize"];
        NSArray *fonts=[fontselection1 componentsSeparatedByString:@","];
        fontselection=[[NSString alloc]initWithFormat:@"%@",[fonts objectAtIndex:0]];
        NSLog(@"%@",fontselection);
        if ([[fonts objectAtIndex:1] isEqualToString:@"Small"]) {
            [self.smallBtn setSelected:YES];
            [self.mediumBtn setSelected:NO];
            [self.largeBtn setSelected:NO];
        }
        else if ([[fonts objectAtIndex:1] isEqualToString:@"Medium"]) {
//            Font.selectedSegmentIndex=1;
            [self.smallBtn setSelected:NO];
            [self.mediumBtn setSelected:YES];
            [self.largeBtn setSelected:NO];
        }
        else
        {
//            Font.selectedSegmentIndex=2;
            [self.smallBtn setSelected:NO];
            [self.mediumBtn setSelected:NO];
            [self.largeBtn setSelected:YES];
        }
//        complexityLevel=[NSString stringWithFormat:@"%@",[dict objectForKey:@"complexitylevel"]];
//        if ([complexityLevel isEqualToString:@"Easy"]) {
//            Complexity.selectedSegmentIndex=0;
//            
//        }
//        else if ([complexityLevel isEqualToString:@"Medium"]) {
//            Complexity.selectedSegmentIndex=1;
//           
//        }
//        else
//        {
//           
//        }
        //Complexity.selectedSegmentIndex
        textplace=[NSString stringWithFormat:@"%@",[dict objectForKey:@"textplace"]];
        if ([textplace isEqualToString:@"Top"]) {
//            TextPlacement.selectedSegmentIndex=0;
            [self.topBtn setSelected:YES];
            [self.middleBtn setSelected:NO];
            [self.bottomBtn setSelected:NO];
        }
        else if ([textplace isEqualToString:@"Middle"]) {
//            TextPlacement.selectedSegmentIndex=1;
            [self.topBtn setSelected:NO];
            [self.middleBtn setSelected:YES];
            [self.bottomBtn setSelected:NO];
        }
        else
        {
//            TextPlacement.selectedSegmentIndex=2;
            [self.topBtn setSelected:NO];
            [self.middleBtn setSelected:NO];
            [self.bottomBtn setSelected:YES];
        }
        self.myTextField.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Text"]];
        [self.myTextField resignFirstResponder];
        [self updateView];
        dict=nil;
        
    }
    else
    {
        fontselection=[[NSString alloc]init];
        fontselection=@"Arial";
    }
    self.navigationItem.rightBarButtonItem.enabled=YES;
}
-(IBAction)Done:(id)sender{
    NSData *data=UIImageJPEGRepresentation(selectedImage, 0.1);
    if(integer<0)
    {
        NSString *fontselection1;
        NSLog(@"%@",fontselection);
        if ([self.smallBtn isSelected]) {
            fontselection1=[[NSString alloc]initWithFormat:@"%@,Small",fontselection];
        }
        else if ([self.mediumBtn isSelected]) {
            fontselection1=[[NSString alloc]initWithFormat:@"%@,Medium",fontselection];
        }
        else if ([self.largeBtn isSelected])
        {
            fontselection1=[[NSString alloc]initWithFormat:@"%@,Large",fontselection];
        }
        if ([self.topBtn isSelected])
        {
            textplace=[NSString stringWithFormat:@"Top"];
        }
        else if ([self.middleBtn isSelected])
        {
            textplace=[NSString stringWithFormat:@"Middle"];
        }
        else if([self.bottomBtn isSelected])
        {
            textplace=[NSString stringWithFormat:@"Bottom"];
        }
//        if (Complexity.selectedSegmentIndex==0)
//        {
//            complexityLevel=[NSString stringWithFormat:@"Easy"];
//        }
//        else if (Complexity.selectedSegmentIndex==1) {
//            complexityLevel=[NSString stringWithFormat:@"Medium"];
//        }
//        else
//        {
//            complexityLevel=[NSString stringWithFormat:@"Hard"];
//        }
        fontselection=fontselection1;
        fontselection1=nil;
        [fontselection1 release];
        [DataBase AddPuzzle:Email puzzleImage:data Font_Selection:fontselection Text_Place:textplace Complexity_Level:complexityLevel Text:self.myTextField.text];
        dataArray1=[DataBase viewAllPuzzle:Email];
        integer=[dataArray1 count]-1;
    }
    else
    {
        NSString *fontselection1;
        NSLog(@"%@",fontselection);
        if ([self.smallBtn isSelected]) {
            fontselection1=[[NSString alloc]initWithFormat:@"%@,Small",fontselection];
        }
        else if ([self.mediumBtn isSelected]) {
            fontselection1=[[NSString alloc]initWithFormat:@"%@,Medium",fontselection];
        }
        else if ([self.largeBtn isSelected])
        {
            fontselection1=[[NSString alloc]initWithFormat:@"%@,Large",fontselection];
        }
        if ([self.topBtn isSelected]) {
            textplace=[NSString stringWithFormat:@"Top"];
        }
        else if ([self.middleBtn isSelected]) {
            textplace=[NSString stringWithFormat:@"Middle"];
        }
        else if ([self.bottomBtn isSelected])
        {
            textplace=[NSString stringWithFormat:@"Bottom"];
        }
//        if (Complexity.selectedSegmentIndex==0) {
//            complexityLevel=[NSString stringWithFormat:@"Easy"];
//        }
//        else if (Complexity.selectedSegmentIndex==1) {
//            complexityLevel=[NSString stringWithFormat:@"Medium"];
//        }
//        else
//        {
//            complexityLevel=[NSString stringWithFormat:@"Hard"];
//        }
        fontselection=fontselection1;
        fontselection1=nil;
        [fontselection1 release];
        [DataBase UpdatePuzzle:Email Font_Selection:fontselection Text_Place:textplace Complexity_Level:complexityLevel Text:self.myTextField.text ID:[[[dataArray1 objectAtIndex:integer] objectForKey:@"id"]intValue]];
        dataArray1=[DataBase viewAllPuzzle:Email];
            
    }
    gameView *gameview=[[[gameView alloc]init] autorelease];
    gameview.image=[UIImage imageWithData:data];
    gameview.fontselection=[[[NSString alloc]initWithFormat:@"%@",fontselection] autorelease];
    gameview.complexityLevel=[[[NSString alloc]initWithFormat:@"%@",complexityLevel] autorelease];
    gameview.textplace=[[[NSString alloc]initWithFormat:@"%@",textplace] autorelease];
    gameview.text=self.myTextField.text;
    gameview.Email=Email;
    [self.navigationController pushViewController:gameview animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.TopAd==NO)
    {
        [[singletonClass sharedsingletonClass].adWhrilView removeFromSuperview];
    }
    [fontselection release];
    
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload
{
    [self.myTextField release];
    font=nil;
    fontsize=nil;
    fontmode=nil;
    [font release];
    [fontsize release];
    selectedImage=nil;
    self.myTextField=nil;
    [self.myTextField release];
    [self setImageview:nil];
    [self setImageTableView:nil];
    [self setFont:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.myTextField resignFirstResponder];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    self.fontNameLabel = nil;
    [imageview release];
    [imageTableView release];
   // [Complexity release];
    [Font release];
   // [TextPlacement release];
    [super dealloc];
}

- (IBAction)selectFont:(id)sender {
    
    [self showPicker:0];
}

-(void)setint:(int)integer1
{
    integer=integer1;
}
#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    int numberofcomponenets=0;
    if (numbetrOfrowtape==0) {
        numberofcomponenets=1;
    }
    return numberofcomponenets;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int numberofcomponenets=0;
    if (numbetrOfrowtape==0) {
        numberofcomponenets=[fontsize count];
    }
    return numberofcomponenets;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // NSString *s=@"";
    if (numbetrOfrowtape==0) {
        return [fontsize objectAtIndex:row];
        
    }
    return 0;
    
    // return s;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    UITextField *numberTextField;
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
         
        
    } 
    // Configure the cell...
//    if (indexPath.row==0) {
//        cell.textLabel.text=@"Complexity Level";
//        NSLog(@"%@",complexityLevel);
//        cell.detailTextLabel.text=complexityLevel;
//        
//    }
    if(indexPath.row==1)
    {
        
        self.myTextField.tag = 2;
        self.myTextField.placeholder=@"Please write your text here.";
        self.myTextField.delegate = self;
        self.myTextField.autocorrectionType=UITextAutocorrectionTypeNo;
        [self.myTextField addTarget:self action:@selector(textPasswordField:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:self.myTextField];
    }   
    
    if (indexPath.row==0)
    {
        cell.textLabel.text=@"Select Font";
//        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.textLabel.font=[UIFont boldSystemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         NSArray *fonts=[fontselection componentsSeparatedByString:@","];
        cell.detailTextLabel.text=[fonts objectAtIndex:0];
        cell.detailTextLabel.font=[UIFont fontWithName:cell.detailTextLabel.font.familyName size:12];
    }  
    return cell;
}

-(IBAction)textPasswordField:(id)sender {
    
    [sender resignFirstResponder];
    
}
#pragma mark ---TextField
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.1];
    [self.view setFrame:CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.1];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

-(void)showPicker:(int)rowTape{
    if (rowTape==0) {
        NSString *dateTitle;
        dateTitle = @"";
        NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n" ;
        UIActionSheet *actionSheet = [[[UIActionSheet alloc] 
                                       initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(dateTitle, @"")]
                                       delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"OK",nil]autorelease];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        self.pickerView= [[[UIPickerView alloc] init] autorelease];
        self.pickerView.showsSelectionIndicator=TRUE;
        self.pickerView.dataSource=self;
        self.pickerView.delegate =self;
        [actionSheet addSubview:self.pickerView];
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    numbetrOfrowtape=indexPath.row;
    [self showPicker:indexPath.row];

    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
  //  cell.selectedBackgroundView.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
}
#pragma mark --- actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 1:
			NSLog(@"ljsdf");
			break;
		case 0:
			NSLog(@"0");
            int a=[self.pickerView selectedRowInComponent:0];
             if(numbetrOfrowtape==0)
            {
                fontselection=[fontsize objectAtIndex:a];
                NSLog(@"%@",fontselection);
//                [self.imageTableView reloadData];
                self.fontNameLabel.text = fontselection;
            }
			break;
            
		default:
			break;
	}
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}

@end
