
//
//  GraphicalReportController.m
//  MyOvertime
//
//  Created by Prashant Choudhary on 6/16/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import "GraphicalReportController.h"
#import "BarView.h"
#import "PDFReportRenderer.h"
#import "PrintItem.h"
#import "Schedule.h"
#import "Activity.h"
#import "TimeSheet.h"
#import "ReportItem.h"
#import "Localizator.h"
#import "MyOvertimeAppDelegate.h"
#import "SVProgressHUD.h"
#import "StaticConstants.h"
#import "GlobalFunctions.h"

#define kTagMainLabelHeader 1
#define kTagMainLabel 2
#define kTagMainLabel2 3
#define kTagMainLabel3 4
#define kTagMainLabel4 5
#define kTagMainLabel5 6
#define kTagGraphical 7
#define kTagMainLabelWeekDay 8
#define kTagScaleLeft 9
#define kTagScaleRight 10
#define kTagSeparator 11

#define kIncrementPDF 20

#define kStartPosition 90
#define kIncrementRowHeight 16
#define kMaxPagePositionToPrint 720
#define kPageYPosition 50
#define kGraphLeftRightArea 100
#define kBarOrigin 100
#define kBarWidth 170

@interface GraphicalReportController ()

@end

@implementation GraphicalReportController
@synthesize listArray;
@synthesize segmentControl;
@synthesize managedObjectContext;
@synthesize reportData;
@synthesize dictionary;
@synthesize tableView;
@synthesize userName,companyName;
@synthesize startingDate,endingDate;

-(void) dealloc
{
    [listArray release];listArray=nil;
    self.tableView=nil;
    [dictionary release];dictionary=nil;
    
    [super dealloc];
}



-(void) makeToolBarButtons{
    // Add profile button.
    UIImage *buttonImageBig = [UIImage imageNamed:@"ButtonBlack.png"];
    UIImage *buttonImageBig2 = [UIImage imageNamed:@"ButtonBlackHighlighted.png"];
    
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundImage:buttonImageBig forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageBig2 forState:UIControlStateHighlighted];
    
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    
    [button setTitle:NSLocalizedString(@"EMAIL_BUTTON", @"") forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted=YES;
	button.frame = CGRectMake(0.0, 0.0, 50, 30);	
	UIBarButtonItem *systemItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	[button addTarget:self action:@selector(generatePdf:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = systemItem;
    [systemItem release];
    
    
}

-(IBAction)generatePdf:(id)sender
{    
#ifdef INAPP_VERSION	
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!app.isProduct2Purchased)
    {
        /*
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: kAlertHeader
                              message: kAlertMessage
                              delegate:self
                              cancelButtonTitle:kAlertOK
                              otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        */
        [app showEmailAlert];
        return;
    }
#endif	
    
    
    [self makePDFFile];
    [self emailPressed:nil];
    
}
#pragma mark -
#pragma mark PcasoPDFModules

-(NSString*)getPDFFileName
{
    NSString* fileName = @"Report.PDF";
    
    NSArray *arrayPaths = 
    NSSearchPathForDirectoriesInDomains(
                                        NSCachesDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
    
}
-(void) makePDFFile
{
    NSString* fileName = [self getPDFFileName];
    NSMutableArray *array=[self makePrintingItems];
    
    //Make dictionaries for page items
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    for (int i=1;i<=numberOfPages;i++)
    {
        NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"page==%d",i];
        NSMutableArray *temp=[NSMutableArray arrayWithArray:[array filteredArrayUsingPredicate:firstPredicate]];
        [dict setObject:temp forKey:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    [PDFReportRenderer drawPDF:fileName forArray:dict andHeaderText:@"" andAdjust:NO];
}

-(NSMutableArray *) makePrintingItems
{
    NSMutableArray *temp=[[[NSMutableArray alloc]init] autorelease];
    int page=1;
    int yposition=kStartPosition;
    
    NSString *headerString=[self getFormContentHeader];
    NSString *headerUser=
    [NSString stringWithFormat:
     @"%@  %@",self.userName,self.companyName];
    PrintItem *printHeaderUser=[PrintItem productWithName:headerUser increment:0 page:page kindOfItem:kKindSectionRowUser xPosition:30 yPosition:yposition];
    [temp addObject:printHeaderUser];
    yposition+=kIncrementPDF;
    
    
    PrintItem *printHeader=[PrintItem productWithName:headerString increment:0 page:page kindOfItem:kKindSectionRowUser xPosition:30 yPosition:yposition];
    [temp addObject:printHeader];
    
    
    for (int k=0;k<3 ;k++)
    {
        yposition+=2*kIncrementRowHeight;
        NSString *reportPeriod=@"WEEKLY";
        NSString *reportPeriodLabel=NSLocalizedString(@"SEGMENT_WEEKLY", @"");

        NSString *tableHeaderTitle=NSLocalizedString(@"MY_OVERTIME_GRAPH_TITLE", @"");
        
        tableHeaderTitle=NSLocalizedString(@"MY_OVERTIME_GRAPH_TITLE", @"");
        
        if (k==1)
        {
            reportPeriod=@"MONTHLY";
            reportPeriodLabel=NSLocalizedString(@"SEGMENT_MONTHLY", @"");
        }
        else if (k==2)
        {
            reportPeriod=@"YEARLY";
            reportPeriodLabel=NSLocalizedString(@"SEGMENT_YEARLY", @"");
        }
        
        
        PrintItem *print=[PrintItem productWithName:reportPeriodLabel increment:0 page:page kindOfItem:kKindSectionFirstPage xPosition:30 yPosition:yposition];
        [temp addObject:print];
        yposition+=kIncrementPDF;
        PrintItem *print2=[PrintItem productWithName:tableHeaderTitle increment:0 page:page kindOfItem:kKindSectionStart xPosition:30 yPosition:yposition];
        
        print2.isGraphical=YES;
        NSString *string= [NSString stringWithFormat:@"%@",[self convertPeriodToString:minWeek]];
        NSString *string2= [NSString stringWithFormat:@"%@",[self convertPeriodToString:maxWeek]];

        if (k==1)
        {
        string= [NSString stringWithFormat:@"%@",[self convertPeriodToString:minMonth]];
        string2= [NSString stringWithFormat:@"%@",[self convertPeriodToString:maxMonth]];

        }
        if (k==2)
        {
            string= [NSString stringWithFormat:@"%@",[self convertPeriodToString:minYear]];
            string2= [NSString stringWithFormat:@"%@",[self convertPeriodToString:maxYear]];    
        }
       
        print2.text1=string;
        print2.text2=string2;
        
        [temp addObject:print2];
        
        NSMutableArray *tempArray=[self.dictionary objectForKey:reportPeriod];
        for (int i=0;i<[tempArray count];i++)
        {
            ReportItem *reportItem=[tempArray objectAtIndex:i];
            yposition+=kIncrementRowHeight;
            if (yposition>kMaxPagePositionToPrint)
            {
                page++;
                yposition=kPageYPosition;
            }
            PrintItem *print=[PrintItem productWithName:@"Report" increment:0 page:page kindOfItem:kKindSectionRow xPosition:50 yPosition:yposition];
//            print.text1=reportItem.reportingLabel;
            
            NSString *weekNameText;
            
            if([reportItem.reportingLabel rangeOfString:NSLocalizedString(@"TITLE_WEEK", @"") options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                weekNameText = [NSString stringWithFormat:@"%@, %@", reportItem.reportingLabel, reportItem.weekDay];
            }
            else
            {
                weekNameText = [NSString stringWithFormat:@"%@", reportItem.reportingLabel];
            }
            
            print.text1 = [NSString stringWithFormat:@"%@",weekNameText];
            print.text2 = [NSString stringWithFormat:@"%@",reportItem.ingoingConverted];
            print.text3 = [NSString stringWithFormat:@"%@",reportItem.inrangeConverted];
            print.text4 = [NSString stringWithFormat:@"%@",reportItem.outgoingConverted];
            
            print.isGraphical=YES;
            print.widthGraph=reportItem.inrange;

            print.widthGraphMaximum=0;
            int graphArea=400;
            if (k==0)
            {
                //barView.graphMaximumWidth=8*60;
                NSInteger range=maxWeek-minWeek;
                if (range==0)
                {
                    range=1;
                }
               // barView.origin=-minWeek*200/range;
                print.origin=-minWeek*graphArea/range;
                print.widthGraphMaximum=range;
                
            }
            else if (k==1)
            {
                //barView.graphMaximumWidth=10*60;
                NSInteger range=maxMonth-minMonth;
                if (range==0)
                {
                    range=1;
                }
                print.origin=-minMonth*graphArea/range;
                print.widthGraphMaximum=range;
            }
            else if (k==2)
            {
                //barView.graphMaximumWidth=20*60;
                NSInteger range=maxYear-minYear;
                if (range==0)
                {
                    range=1;
                }
                print.origin=-minYear*graphArea/range;

                print.widthGraphMaximum=range;
            }

            print.text2=reportItem.ingoingConverted ?[NSString stringWithFormat:@"%@",reportItem.ingoingConverted]:@"0:00";//Changed
//            print.text2=reportItem.inrangeConverted ?[NSString stringWithFormat:@"%@",reportItem.inrangeConverted]:@"0:00";//Changed
            [temp addObject:print];
        }
    }
    numberOfPages=page;
    return temp;
    
}

-(void) startUpTasks{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];		
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage)) {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}	
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = myImageView;
	[myImageView release];

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"dd/MM/YY"];
    NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
    if ([string isEqualToString:@"en_GB"]) {
        [dateFormatter setDateFormat:@"dd/MM/YY"];
    }
    else if ([string isEqualToString:@"en_US"]) {
        [dateFormatter setDateFormat:@"MM/dd/YY"];
    }
    else if ([string isEqualToString:@"sv_SE"]) {
        [dateFormatter setDateFormat:@"YY-MM-dd"];
    }
    else if ([string isEqualToString:@"pl_PL"]||[string isEqualToString:@"tr_TR"]) {
        [dateFormatter setDateFormat:@"dd.MM.YY"];
    }

	[self fetchReportDataFrom:self.startingDate to:self.endingDate];
    [self refreshHeaderInSection];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableDictionary *dictionaryTemp=[[NSMutableDictionary alloc]initWithCapacity:3];
    self.dictionary=dictionaryTemp;
    [dictionaryTemp release];
    
    NSMutableArray *arrayTemp=[[NSMutableArray alloc]init];
    self.listArray=arrayTemp;
    [arrayTemp release];
    
    
    
    //isGraphical=YES;
    [self makeToolBarButtons];
    
    UISegmentedControl * seg1 = [[UISegmentedControl alloc]
                                 initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"SEGMENT_WEEKLY", @""),NSLocalizedString(@"SEGMENT_MONTHLY", @""),NSLocalizedString(@"SEGMENT_YEARLY", @""), nil]];
    [seg1 setSegmentedControlStyle:UISegmentedControlStyleBar];
    self.segmentControl=seg1;
    self.segmentControl.selectedSegmentIndex=0;
    [segmentControl addTarget:self action:@selector(actionSegment:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentControl;
    [seg1 release];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!startUp)
    {
        [self startUpTasks];
        startUp=YES;
    }
    
}
-(void) viewWillDisAppear:(BOOL)animated
{
    [self dismiss];
}

-(IBAction) actionSegment:(id) sender
{
	UISegmentedControl *segment=(UISegmentedControl *) sender;
	segmentControl.selectedSegmentIndex=segment.selectedSegmentIndex;
    
    switch (segmentControl.selectedSegmentIndex)
    {
        case 0:
            self.listArray=[self.dictionary objectForKey:@"WEEKLY"];
            break;
        case 1:
            self.listArray=[self.dictionary objectForKey:@"MONTHLY"];
            break;
        case 2:
            self.listArray=[self.dictionary objectForKey:@"YEARLY"];
            break;
            
        default:
            break;
    }
    
    countItem=[listArray count];
    [self.tableView reloadData];
    [self refreshHeaderInSection];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"li %d",[listArray count]);
    return [listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
    static NSString *FirstLevelCell= @"FirstLevelCell";
  
    UITableViewCell *cell =  [self.tableView dequeueReusableCellWithIdentifier:
                              FirstLevelCell];
    if (cell == nil )
    {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier: FirstLevelCell] autorelease];
        
        UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 240, 20)];
        mainLabel.textAlignment = UITextAlignmentLeft;
        mainLabel.font =[UIFont systemFontOfSize:11];
        mainLabel.tag=kTagMainLabel;
        mainLabel.textColor=[UIColor blackColor];
        mainLabel.backgroundColor=[UIColor clearColor];
        mainLabel.highlightedTextColor=[UIColor whiteColor];
        [cell.contentView addSubview: mainLabel];
        [mainLabel release];
        
        UILabel *mainLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 240, 20)];
        mainLabel2.textAlignment = UITextAlignmentLeft;
        mainLabel2.font =[UIFont systemFontOfSize:11];
        mainLabel2.tag=kTagMainLabelWeekDay;
        mainLabel2.textColor=[UIColor blackColor];
        mainLabel2.backgroundColor=[UIColor clearColor];
        mainLabel2.highlightedTextColor=[UIColor whiteColor];
        [cell.contentView addSubview: mainLabel2];
        [mainLabel2 release];
        
        UIView *v=[[UIView alloc] init];
        CGRect frame;
        frame.origin.x=kBarOrigin;//`_____
        frame.origin.y=0;
        frame.size.height=32;
        frame.size.width=1;
        
        v.frame=frame;
        v.tag= kTagSeparator;
        v.clipsToBounds=NO;
        v.backgroundColor=[UIColor lightGrayColor];
        v.clipsToBounds=NO;
        [cell.contentView addSubview:v];
        [v release];
        
        BarView *dv=[[BarView alloc] init];
        frame.origin.y=5;
        frame.size.height=20;
        frame.size.width=kBarWidth+50;
        frame.origin.x=kBarOrigin;
        dv.frame=frame;
        dv.width=0;
        dv.clipsToBounds=NO;
        dv.tag=kTagGraphical;
        dv.backgroundColor=[UIColor clearColor];
        dv.clipsToBounds=NO;
        [cell.contentView addSubview:dv];
        [dv release];
        
    }
    
    if (indexPath.row>=0)
    {    
        ReportItem *reportItem=[listArray objectAtIndex:indexPath.row];
        UILabel *myLabel = (UILabel *)[cell.contentView viewWithTag:kTagMainLabel];
        myLabel.text = reportItem.reportingLabel;
        
        
        UILabel *myLabelWeek = (UILabel *)[cell.contentView viewWithTag:kTagMainLabelWeekDay];
        myLabelWeek.text = reportItem.weekDay;
        if (segmentControl.selectedSegmentIndex==0)
        {
            myLabelWeek.hidden=NO;
        }
        else
        {
            myLabelWeek.hidden=YES;    
        }
        UILabel *myLabel2 = (UILabel *)[cell.contentView viewWithTag:kTagMainLabel2];
        myLabel2.text =reportItem.ingoingConverted ? [NSString stringWithFormat:@"%@",reportItem.ingoingConverted]:@"0:00";
        myLabel2.hidden=NO;
        
        UILabel *myLabel3 = (UILabel *)[cell.contentView viewWithTag:kTagMainLabel3];
        myLabel3.text =reportItem.inrangeConverted? [NSString stringWithFormat:@"%@",reportItem.inrangeConverted]:@"0:00";

        UILabel *myLabel4 = (UILabel *)[cell.contentView viewWithTag:kTagMainLabel4];
        myLabel4.text = reportItem.outgoingConverted?[NSString stringWithFormat:@"%@",reportItem.outgoingConverted]:@"0:00";

        UIView *lineView = (UIView *)[cell.contentView viewWithTag:kTagSeparator];
        NSInteger range=maxWeek-minWeek;
        if (segmentControl.selectedSegmentIndex==1)
        {
            range=maxMonth-minMonth;
        }
        else if (segmentControl.selectedSegmentIndex==2)
        {
            range=maxYear-minYear;
        }
        if (range==0)
        {
            range=1.0;
        }
        
        CGRect frame=lineView.frame;
        if (segmentControl.selectedSegmentIndex==0)
        {
            frame.origin.x=kBarOrigin-minWeek*kBarWidth/range;
        }
        else if (segmentControl.selectedSegmentIndex==1)
        {
            frame.origin.x=kBarOrigin-minMonth*kBarWidth/range;
        }
        else if (segmentControl.selectedSegmentIndex==2)
        {
            frame.origin.x=kBarOrigin-minYear*kBarWidth/range;
        }
        lineView.frame=frame;
            
        BarView *barView = (BarView *)[cell.contentView viewWithTag:kTagGraphical];
        barView.width = reportItem.inrange;
        if (segmentControl.selectedSegmentIndex==0)
        {
            //barView.graphMaximumWidth=8*60;
            NSInteger range = maxWeek-minWeek;
            if (range==0)
            {
                range=1.0;
            }
            barView.origin=-minWeek*kBarWidth/range;
            barView.graphMaximumWidth=range;

        }
        else if (segmentControl.selectedSegmentIndex==1)
        {
            //barView.graphMaximumWidth=10*60;
            NSInteger range=maxMonth-minMonth;
            if (range==0)
            {
                range=1.0;
            }
            barView.origin=-minMonth*kBarWidth/range;
            barView.graphMaximumWidth=range;
        }
        else if (segmentControl.selectedSegmentIndex==2)
        {
            //barView.graphMaximumWidth=20*60;
            NSInteger range=maxYear-minYear;
            if (range==0)
            {
                range=1.0;
            }
            barView.origin=-minYear*kBarWidth/range;
            barView.graphMaximumWidth=range;
        }

                    
        barView.widthConverted=[self convertPeriodToString:(int) barView.width];
        [barView setNeedsDisplay];
        
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    cell.backgroundColor=[UIColor whiteColor];

    return cell;
    
}

#pragma mark -
#pragma mark Table View Delegaasste Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentControl.selectedSegmentIndex == 0)
    {
        return 32;
    }
    return 32;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(void)refreshHeaderInSection
{
    if (customTitleView.superview)
    {
        [customTitleView removeFromSuperview];
    }
    
    customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    
    UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    
    titleLabel.textColor = [UIColor blackColor];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    customTitleView.backgroundColor = [UIColor whiteColor];
    
    [customTitleView addSubview:titleLabel];
    
    
    UILabel *mainLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 310, 20)];
    mainLabel1.textAlignment = UITextAlignmentLeft;
    mainLabel1.font =[UIFont boldSystemFontOfSize:14];
    mainLabel1.tag=kTagMainLabelHeader;
    mainLabel1.textColor=[UIColor blackColor];
    mainLabel1.backgroundColor=[UIColor clearColor];
    mainLabel1.highlightedTextColor=[UIColor whiteColor];
    NSString *title=nil;
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            title=NSLocalizedString(@"SEGMENT_WEEKLY", @"");
            break;
        case 1:
            title=NSLocalizedString(@"SEGMENT_MONTHLY", @"");
            
            break;
        case 2:
            title=NSLocalizedString(@"SEGMENT_YEARLY", @"");
            
            break;
        default:
            break;
    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    NSString *string1=nil;
    NSString *string2=nil;
    
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            string1=[dateFormatter stringFromDate:startingDate];
            string2=[dateFormatter stringFromDate:endingDate];
            mainLabel1.text=[NSString stringWithFormat:@"%@ (%@ - %@)",title,string1,string2];
            break;
            
        case 1:
            [dateFormatter setDateFormat:@"MMM YYYY"];
            string1=[dateFormatter stringFromDate:startingDate];
            string2=[dateFormatter stringFromDate:endingDate];
            mainLabel1.text=[NSString stringWithFormat:@"%@ (%@ - %@)",title,string1,string2];
            
            break;
        case 2:
            [dateFormatter setDateFormat:@"YYYY"];
            string1=[dateFormatter stringFromDate:startingDate];
            string2=[dateFormatter stringFromDate:endingDate];
            mainLabel1.text=[NSString stringWithFormat:@"%@ (%@ - %@)",title, string1, string2];
            
            break;
        default:
            break;
    }
    
    [customTitleView addSubview: mainLabel1];
    [mainLabel1 release];
    
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 20)];
    mainLabel.textAlignment = UITextAlignmentLeft;
    mainLabel.font =[UIFont boldSystemFontOfSize:14];
    mainLabel.tag=kTagMainLabelHeader;
    mainLabel.textColor=[UIColor blackColor];
    mainLabel.backgroundColor=[UIColor clearColor];
    mainLabel.highlightedTextColor=[UIColor whiteColor];
    mainLabel.text=NSLocalizedString(@"MY_OVERTIME_GRAPH_TITLE", @"");
    [customTitleView addSubview: mainLabel];
    [mainLabel release];
    
        mainLabel.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"MY_OVERTIME_GRAPH_TITLE", @"")];
        //LEFT AXIS
        int adjust=10;
        UIView *v=[[UIView alloc] init];
        CGRect frame;
        frame.origin.y=40;
        frame.size.height=32;
        frame.size.width=1;
        frame.origin.x=kBarOrigin+100+adjust;
        v.frame=frame;
        v.clipsToBounds=NO;
        v.backgroundColor=[UIColor lightGrayColor];
        v.clipsToBounds=NO;
        //[cell.contentView addSubview:v];
        [v release];
        
        //RIGHT AXIS
        UIView *vRight=[[UIView alloc] init];
        frame.origin.y=40;
        frame.size.height=32;
        frame.size.width=1;
        frame.origin.x=180+kGraphLeftRightArea;
        vRight.frame=frame;
        vRight.clipsToBounds=NO;
        vRight.backgroundColor=[UIColor lightGrayColor];
        vRight.clipsToBounds=NO;
        //[cell.contentView addSubview:vRight];
        [vRight release];
        
        UIView *vLeft=[[UIView alloc] init];
        frame.origin.y=40;
        frame.size.height=32;
        frame.size.width=1;
        frame.origin.x=kBarOrigin+10;
        vLeft.frame=frame;
        vLeft.clipsToBounds=NO;
        vLeft.backgroundColor=[UIColor lightGrayColor];
        vLeft.clipsToBounds=NO;
        //[customTitleView addSubview:vLeft];
        [vLeft release];
        
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBarOrigin+10, 40, 300, 20)];
        leftLabel.textAlignment = UITextAlignmentLeft;
        leftLabel.tag=kTagScaleLeft;
        leftLabel.font =[UIFont boldSystemFontOfSize:14];
        leftLabel.textColor=[UIColor blackColor];
        leftLabel.backgroundColor=[UIColor clearColor];
        leftLabel.highlightedTextColor=[UIColor whiteColor];
        [customTitleView addSubview: leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+kBarOrigin+kBarWidth-10, 40, 300, 20)];
        rightLabel.textAlignment = UITextAlignmentLeft;
        rightLabel.tag=kTagScaleRight;
        rightLabel.font =[UIFont boldSystemFontOfSize:14];
        rightLabel.textColor=[UIColor blackColor];
        rightLabel.backgroundColor=[UIColor clearColor];
        rightLabel.highlightedTextColor=[UIColor whiteColor];
        [customTitleView addSubview: rightLabel];
        
        
        NSString *string= [NSString stringWithFormat:@"%@",[self convertPeriodToString:minWeek]];
        
        if (segmentControl.selectedSegmentIndex==1) {
            string= [NSString stringWithFormat:@"%@",[self convertPeriodToString:minMonth]];        }
        else if (segmentControl.selectedSegmentIndex==2) {
            // string=@"-20:00";
            string= [NSString stringWithFormat:@"%@",[self convertPeriodToString:minYear]];
        }
        
        
        leftLabel.text = string;
        string=[NSString stringWithFormat:@"%@",[self convertPeriodToString:maxWeek]];
        
        // string=@"08:00";
        if (segmentControl.selectedSegmentIndex==1) {
            //string=@"10:00";
            string= [NSString stringWithFormat:@"%@",[self convertPeriodToString:maxMonth]];
        }
        else if (segmentControl.selectedSegmentIndex==2) {
            //string=@"20:00";
            
            string= [NSString stringWithFormat:@"%@",[self convertPeriodToString:maxYear]];
            
            
        }
        
        rightLabel.text = string;
        
        [leftLabel release];
        
        [rightLabel release];
        
    
    UIView *line=[[[UIView alloc]init] autorelease];
    line.frame=CGRectMake(0,35,320,1);
    line.backgroundColor=[UIColor blackColor];
    [customTitleView addSubview:line];
    
    UIView *line2=[[[UIView alloc]init] autorelease];
    line2.frame=CGRectMake(0,70,320,1);
    line2.backgroundColor=[UIColor blackColor];
    [customTitleView addSubview:line2];
    
    [self.view addSubview:customTitleView];
}

- (IBAction)emailPressed:(id)sender
{
    
    [self showWithStatus:NSLocalizedString(@"PREPARING_MAIL", @"")];
    NSString *fileName=NSLocalizedString(@"MY_OVERTIME_SUMMARY", @"");
    
    
    fileName=NSLocalizedString(@"MY_OVERTIME_GRAPH", @"");
    
	// email the PDF File.
	MFMailComposeViewController* mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
	mailComposer.mailComposeDelegate = self;
    
    [mailComposer setSubject:NSLocalizedString(@"MY_OVERTIME_GRAPH_SUBJECT", @"")];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:[GlobalFunctions getDefaultEmail], nil];
	
	[mailComposer setToRecipients:toRecipients];
    NSString *path=[self getPDFFileName];
    
	[mailComposer addAttachmentData:[NSData dataWithContentsOfFile:path]
						   mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",fileName]];
    NSString *emailBody = fileName;
    
    emailBody= NSLocalizedString(@"MY_OVERTIME_GRAPH_BODY", @"");

	[mailComposer setMessageBody:emailBody isHTML:NO];
    
    mailComposer.navigationBar.tintColor=[UIColor blackColor];
    
	[self presentModalViewController:mailComposer animated:YES];
    [self dismiss];
    
}
#pragma mark - MFMailComposerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark - Get Maximum
-(void) prepareMaxValueForArray:(NSArray *)array andKind:(NSInteger) kind
{
    NSInteger max=0;

    for (int i=0;i<[array count];i++)
    {
        ReportItem *reportItem=[array objectAtIndex:i];

        if (reportItem.inrange>max)
        {
            max=reportItem.inrange;
        }
    }
    
    if (max<0)
    {
        max=0;
    }
    
    switch (kind)
    {
        case 0:
            maxWeek=max;
            break;
        case 1:
            maxMonth=max;
        case 2:
            maxYear=max;
        default:
            break;
    }
}

#pragma mark - Get Min
-(void) prepareMinValueForArray:(NSArray *)array andKind:(NSInteger) kind{
    NSInteger min=0;
    
    for (int i=0;i<[array count];i++)
    {
        ReportItem *reportItem=[array objectAtIndex:i];
        if (reportItem.inrange<min)
        {
            min=reportItem.inrange;
        }

    }
    switch (kind)
    {
        case 0:
            minWeek=min;
            break;
        case 1:
            minMonth=min;
        case 2:
            minYear=min;
        default:
            break;
    }
    
}




#pragma mark -
#pragma mark Report Data Managemnent

- (void) fetchReportDataFrom:(NSDate*)startDate to:(NSDate*)finalDate
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	    
    //Added by Meghan
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleDate < %@",
                              [finalDate dateByAddingTimeInterval:24*3600]];
	[request setPredicate:predicate];
    
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scheduleDate" ascending:NO];
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scheduleDate" ascending:NO selector:@selector(localizedCompare:)];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSArray *mutableFetchResults = [managedObjectContext executeFetchRequest:request error:&error];
	if (mutableFetchResults != nil)
    {
        NSArray *temp = [[NSArray alloc] initWithArray:mutableFetchResults];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for(int i=0; i<temp.count; i++)
        {
            Schedule *schedule = [temp objectAtIndex:i];
            
            if(schedule.settingsDayTemplate == nil && schedule.myTemplate == nil)
            {
                NSEnumerator *enumerator = [schedule.timeSheets objectEnumerator];
                NSMutableArray *items = [[NSMutableArray alloc] init];
                TimeSheet *item;
                while (item = [enumerator nextObject])
                {
                    [items addObject:item];
                }
                if(items.count > 0)
                {
                    [array addObject:schedule];
                }
            }
        }
        
        self.reportData = [NSArray arrayWithArray:array];
        
        [temp release];
        [array release];
        
	}
	[request release];
    
	for (Schedule *schedule in reportData)
    {
        [schedule makeDateComponents];
    }
    
    //Get week ,month, year wrt base
    NSInteger weekNumberStart = [self getWeekNumberForDate:startDate];
    NSInteger weekNumberEnd = [self getWeekNumberForDate:finalDate];
    
    NSInteger yearNumberStart = [self getYearNumberForDate:startDate];
    NSInteger yearNumberEnd = [self getYearNumberForDate:finalDate];
    
    NSInteger monthNumberStart = [self getMonthNumberForDate:startDate];
    NSInteger monthNumberEnd = [self getMonthNumberForDate:finalDate];
    
    if (weekNumberStart == 1 && monthNumberStart == 12)
    {
        yearNumberStart += 1;
    }
    
    int baseYr=kBaseYear;
    //Calculate week since base
    NSInteger weekNumberSince2010Start = weekNumberStart + 52 * (yearNumberStart - baseYr);
    if (weekNumberStart == 52 && monthNumberStart == 1)
    {
        weekNumberSince2010Start = weekNumberStart + 52 * (yearNumberStart - baseYr - 1);
    }
    
    NSInteger weekNumberSince2010End = weekNumberEnd + 52 * (yearNumberEnd - baseYr);

    if (weekNumberEnd==52 && monthNumberEnd==1)
    {
        weekNumberSince2010End=weekNumberEnd+52*(yearNumberEnd-baseYr-1);
    }
    
    NSInteger monthNumberSince2010Start=monthNumberStart+12*(yearNumberStart-baseYr);
    if (monthNumberSince2010Start>12)
    {
        // monthNumberSince2010Start-=12;
    }
    NSInteger monthNumberSince2010End=monthNumberEnd+12*(yearNumberEnd-baseYr);
    if (monthNumberSince2010End<monthNumberSince2010Start)
    {
        monthNumberSince2010End=monthNumberSince2010Start;
    }
    
    //Make Weekly Data
    NSMutableArray *array = [[[NSMutableArray alloc]init] autorelease];
    for (int i = weekNumberSince2010Start; i <= weekNumberSince2010End; i++)
    {
        ReportItem *reportItem = [self displayFetchedDataForType:kWeekly andIdentifierStart:i ];
        if (!reportItem)
        {
            reportItem = [[[ReportItem alloc]init] autorelease];
            reportItem.reportingType=kWeekly;
        }
        int week = i % 52;
        reportItem.period=i;
        
        int year;
        year = 2010 + i / 52 + 1;
        
        if (week == 0)
        {
            week = 52;
            year -= 1;
        }
        
        reportItem.reportingLabel=[NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"TITLE_WEEK", @""),week];
        reportItem.weekDay=[self getWeekDayForWeek:i ];
        
        [array addObject:reportItem];
    }
    
    if ([array count] > 0)
    {
        NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"period" ascending:NO] autorelease];
        NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
        NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
        
        [self prepareMaxValueForArray:sortedArray andKind:0];
        [self prepareMinValueForArray:sortedArray andKind:0];

        [self.dictionary setObject:sortedArray forKey:@"WEEKLY"];
    }
    
    yearNumberStart = [self getYearNumberForDate:startDate];
    yearNumberEnd = [self getYearNumberForDate:finalDate];
    
    monthNumberStart = [self getMonthNumberForDate:startDate];
    monthNumberEnd = [self getMonthNumberForDate:finalDate];
    
    //Make monthly data
    NSMutableArray *array2=[[[NSMutableArray alloc]init] autorelease];
    for (int i=monthNumberSince2010Start;i<=monthNumberSince2010End;i++)
    {
        ReportItem *reportItem=[self displayFetchedDataForType:kMonthly andIdentifierStart:i ];
        if (!reportItem)
        {
            //Make empty item.
            reportItem=[[[ReportItem alloc]init] autorelease];
            reportItem.reportingType=kMonthly;
        }
        reportItem.period=i;
        int year;//base
        year=2010+i/12+1;
        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        // int monthNumber=11;
        int month=i%12-1;
        if (month<0)
        {
            month=11;
            year-=1;
        }
        NSString *monthName = [[df monthSymbols] objectAtIndex:(month)];
        // NSLog(@"month %d %d---%d",monthNumberSince2010Start,monthNumberStart,i);
        
        reportItem.reportingLabel=[NSString stringWithFormat:@"%@,%d",monthName,year];
        [array2 addObject:reportItem];
    }
    if ([array2 count]>0)
    {
        NSSortDescriptor *sortDescriptor=[[[NSSortDescriptor alloc] initWithKey:@"period" ascending:NO] autorelease];
        NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
        NSArray *sortedArray=[array2 sortedArrayUsingDescriptors:sortDescriptors];
        [self prepareMaxValueForArray:sortedArray andKind:1];
        [self prepareMinValueForArray:sortedArray andKind:1];

        [self.dictionary setObject:sortedArray forKey:@"MONTHLY"];
    }
    
    
    
    //Make yearly data
    NSMutableArray *array3=[[[NSMutableArray alloc]init] autorelease];
    for (int i=yearNumberStart;i<=yearNumberEnd;i++) {
        ReportItem *reportItem=[self displayFetchedDataForType:kYearly andIdentifierStart:i ];
        if (!reportItem) {
            //Make empty item.
            reportItem=[[[ReportItem alloc]init] autorelease];
            reportItem.reportingType=kYearly;
        }
        reportItem.period=i;
        reportItem.reportingLabel=[NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"TITLE_YEAR", @""),i];
        [array3 addObject:reportItem];
    }
    if ([array3 count]>0) {
        NSSortDescriptor *sortDescriptor=[[[NSSortDescriptor alloc] initWithKey:@"period" ascending:NO] autorelease];
        NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
        NSArray *sortedArray=[array3 sortedArrayUsingDescriptors:sortDescriptors];
        [self prepareMaxValueForArray:sortedArray andKind:2];
        [self prepareMinValueForArray:sortedArray andKind:2];

        [self.dictionary setObject:sortedArray forKey:@"YEARLY"];
    }
    
    
    [self.listArray removeAllObjects];
    [self.listArray addObjectsFromArray:[self.dictionary objectForKey:@"WEEKLY"]];
}

-(NSString *) getWeekDayForWeek:(NSInteger) week
{
    int year = 2010 + week / 52 + 1;
    int weekNumber = week % 52;
    
    if (weekNumber == 0)
    {
        weekNumber = 52;
        year -= 1;
    }
    
    //NSLog(@"wee %d %d ",weekNumber,year);
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
    [comps setWeekOfYear:weekNumber];
    [comps setYearForWeekOfYear:year];
    [comps setWeekday:2];
    
    NSDate *resultDate = [cal dateFromComponents:comps];
    NSString *locDate = [self getFormatedDate:resultDate];
    return locDate;
}

-(NSString *)getFormatedDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    [dateFormatter release];
    
    return   dateString;
}

//Gets week, month , year for a date
-(NSInteger) getWeekNumberForDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    return [components weekOfYear];
}

-(NSInteger) getYearNumberForDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    return [components year];
}

-(NSInteger) getMonthNumberForDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    return [components month];
}

//..............

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)sDate andDate:(NSDate*)eDate
{
    if ([date compare:sDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:eDate] == NSOrderedDescending) 
        return NO;
    
    return YES;
}

-(NSMutableArray *) getReportDataForIdentifier:(NSInteger) identifier andIdentifierStart:(NSInteger) identifierStart {
    
    if (identifier==0)
    {
        NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"weekNumberSince2010<=%d ",identifierStart];
        NSMutableArray *tempReportData=[NSMutableArray arrayWithArray:[self.reportData filteredArrayUsingPredicate:firstPredicate]]; 
        return tempReportData;
    }
    else if (identifier==1)
    {
        NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"monthNumberSince2010<=%d",identifierStart];
        NSMutableArray *tempReportData=[NSMutableArray arrayWithArray:[self.reportData filteredArrayUsingPredicate:firstPredicate]]; 
        return tempReportData;
    }
    else if (identifier==2)
    {
        NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"yearNumber<=%d",identifierStart];
        NSMutableArray *tempReportData=[NSMutableArray arrayWithArray:[self.reportData filteredArrayUsingPredicate:firstPredicate]]; 
        return tempReportData;    
    }
    
    return nil ;
}

- (ReportItem *) displayFetchedDataForType:(NSInteger) periodType andIdentifierStart:(NSInteger) identifierStart
{    
    NSMutableArray *tempReportData=[self getReportDataForIdentifier:periodType andIdentifierStart:identifierStart ];
    if ([tempReportData count]>0)
    {
        //NSLog(@"count %d ",identifierStart);
    }
    else
    {
        return nil;
    }
	
	int balance = 0;
    int balanceRange = 0;
    
    BOOL inRange = NO;
    int count=0;
	for (Schedule *schedule in tempReportData)
    {    
        if (periodType==kWeekly &&  schedule.weekNumberSince2010 ==identifierStart)
        {
            inRange = YES;
        }
        else if (periodType==kMonthly &&  schedule.monthNumberSince2010 ==identifierStart)
        {
            inRange = YES;
        }
        else if (periodType==kYearly &&  schedule.yearNumber ==identifierStart)
        {
            inRange = YES;
        }
        else
        {
            inRange = NO;
        }
        
        if ([schedule.timeSheets count]==0)
        {
            continue;
        }	
        
        int offset = [schedule.offset intValue];
        int offsetRange=0;
        if (inRange)
        {
            offsetRange = [schedule.offset intValue]; 
        }
        
        int total = 0;
        int totalinRange = 0;
        for (TimeSheet *timeSheet in schedule.timeSheets) {
            if ((!timeSheet.activity)||(!timeSheet.activity.estimateMode)) {
                continue;
            }
            
            
            
            if ([timeSheet.activity.flatMode boolValue]) {
                if ([timeSheet.flatTime intValue]<0){
                    continue;
                }			
            } else {
                if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0)){
                    continue;
                }
            }			
            
            if ([timeSheet.activity.estimateMode boolValue])
            {
                if (inRange)
                {
                    if ([timeSheet.activity.flatMode boolValue])
                    {
                        if(timeSheet.activity.overtimeReduce.boolValue)
                        {
                            totalinRange -= [timeSheet.flatTime intValue];
                        }
                        else
                        {
                            totalinRange += [timeSheet.flatTime intValue];
                        }
                    }
                    else
                    {
                        if ([timeSheet.endTime intValue]<[timeSheet.startTime intValue])
                        {
                            totalinRange += 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
                        } 
                        else
                        {
                            totalinRange += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
                        }					
                        if ([timeSheet.breakTime intValue]>0)
                        {
                            totalinRange -= [timeSheet.breakTime intValue];
                        }	
                    }
                }
                if ([timeSheet.activity.flatMode boolValue])
                {
                    if(timeSheet.activity.overtimeReduce.boolValue)
                    {
                        total -= [timeSheet.flatTime intValue];
                    }
                    else
                    {
                        total += [timeSheet.flatTime intValue];
                    }
                } 
                else
                {
                    if ([timeSheet.endTime intValue]<[timeSheet.startTime intValue])
                    {
                        total += 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
                    }
                    else
                    {
                        total += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
                    }					
                    if ([timeSheet.breakTime intValue]>0)
                    {
                        total -= [timeSheet.breakTime intValue];
                    }	
                }
            }		
        }
        balance += (total - offset);
        if (inRange)
        {
            balanceRange += (totalinRange - offsetRange);
        }
        count++;
        //NSLog(@"ssssss :%d %d ANd : %d  %d--%d",count,offset,offsetRange,balanceRange,total);
        
    }
    
    ReportItem *reportItem=[[[ReportItem alloc]init] autorelease];
    //reportItem.schedule=schedule;
    reportItem.outgoing=balance;
    reportItem.ingoing=balance-balanceRange;
    reportItem.inrange=balanceRange;
    reportItem.reportingType=periodType;
    reportItem.ingoingConverted=[self convertPeriodToString:reportItem.ingoing];
    reportItem.inrangeConverted=[self convertPeriodToString:reportItem.inrange];
    reportItem.outgoingConverted=[self convertPeriodToString:reportItem.outgoing];
    
    return reportItem;
}	

- (NSString*) convertPeriodToString:(int)period
{
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    if(timeStyle != StyleDecimal)
    {
        if (period < 0)
        {
            period *= (-1);
            
            int hours = (period/60.0);
            int minutes = period - hours * 60;
            
            if (minutes < 10)
            {
                return [NSString stringWithFormat:@"-%d:0%d", hours, minutes];
            }
            else
            {
                return [NSString stringWithFormat:@"-%d:%d", hours, minutes];
            }
        }
        else
        {
            int hours = (period/60.0);
            int minutes = period - hours * 60;
            
            if (minutes < 10)
            {
                return [NSString stringWithFormat:@"%d:0%d", hours, minutes];
            }
            else
            {
                return [NSString stringWithFormat:@"%d:%d", hours, minutes];
            }
        }
    }
    else
    {
        if (period < 0)
        {
            period *= (-1);
            
            int hours = (period/60.0);
            int minutes = period - hours * 60;
            
            CGFloat floatHours = hours;
            CGFloat floatMinutes = minutes;
            
            CGFloat decimalHours = floatHours + (floatMinutes/60);
            
            return [NSString stringWithFormat:@"-%0.2f", decimalHours];
        }
        else
        {
            int hours = (period/60.0);
            int minutes = period - hours * 60;
            
            CGFloat floatHours = hours;
            CGFloat floatMinutes = minutes;
            
            CGFloat decimalHours = floatHours + (floatMinutes/60);
            
            return [NSString stringWithFormat:@"%0.2f", decimalHours];
        }
    }
}	


#pragma mark -
#pragma mark HTML Content
- (NSString*)formHTMLContent
{
    BOOL isIOS5 = [[[UIDevice currentDevice] systemVersion] intValue] == 5;
    
    NSString * htmlString = 
    [ NSString stringWithFormat: 
     @"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=%@\"></head><body><table border=\"1\">",
     isIOS5 ? [ Localizator charsetForActiveLanguage ] : @"utf-8"
     ];
    
    htmlString = 
    [htmlString stringByAppendingString:
     [NSString stringWithFormat:
      @"\n<tr><td>%@</td><td>%@</td></tr>\n",userName,companyName]
     ];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *string1=[dateFormatter stringFromDate:startingDate];
    NSString *string2=[dateFormatter stringFromDate:endingDate];
    
    htmlString =
    [htmlString stringByAppendingString:
     [NSString stringWithFormat:
      @"<tr><td>%@ : %@ - %@</td></tr>\n",
      NSLocalizedString(@"REPORT_MYDATERANGE", @""),string1,string2]];
    

    for (int k=0;k<3 ;k++) {
        NSString *reportPeriod=@"WEEKLY";
        NSString *tableHeaderTitle=NSLocalizedString(@"SEGMENT_WEEKLY", @"");
        
        if (k==1) {
            reportPeriod=@"MONTHLY";
            tableHeaderTitle=NSLocalizedString(@"SEGMENT_MONTHLY", @"");
        }
        else if (k==2) {
            reportPeriod=@"YEARLY";
            tableHeaderTitle=NSLocalizedString(@"SEGMENT_YEARLY", @"");
        }
        
        
        
        htmlString = 
        [htmlString stringByAppendingString:
         [NSString stringWithFormat:
          @"\n<tr><td>%@ </td></tr>\n",tableHeaderTitle]
         ];
        // NSLog(@"html %@",htmlString);
        htmlString =  [htmlString stringByAppendingString:
                       [NSString stringWithFormat:
                        @"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",tableHeaderTitle,NSLocalizedString(@"INGOING", @""),NSLocalizedString(@"INRANGE", @""),NSLocalizedString(@"OUTGOING", @"")]];
        
        NSMutableArray *tempArray=[self.dictionary objectForKey:reportPeriod];
        
        for (int i=0;i<[tempArray count];i++)
        {
            ReportItem *reportItem=[tempArray objectAtIndex:i];
            
            NSString *weekNameText;
            
            if([reportItem.reportingLabel rangeOfString:NSLocalizedString(@"TITLE_WEEK", @"") options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                weekNameText = [NSString stringWithFormat:@"%@, %@", reportItem.reportingLabel, reportItem.weekDay];
            }
            else
            {
                weekNameText = [NSString stringWithFormat:@"%@", reportItem.reportingLabel];
            }
            
            htmlString = 
            [htmlString stringByAppendingString:
             [NSString stringWithFormat:
              @"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
              weekNameText,
              [NSString stringWithFormat:@"%@",reportItem.ingoingConverted],
              [NSString stringWithFormat:@"%@",reportItem.inrangeConverted],
              [NSString stringWithFormat:@"%@",reportItem.outgoingConverted]] ];
        }
        
        
    }    
    // NSLog(@"html %@",htmlString);
    
	return htmlString;
}	


- (NSString*)formCSVContent {
	NSString *htmlString=@"" ;
    for (int k=0;k<3 ;k++) {
        NSString *reportPeriod=@"WEEKLY";
        NSString *tableHeaderTitle=NSLocalizedString(@"SEGMENT_WEEKLY", @"");
        
        if (k==1) {
            reportPeriod=@"MONTHLY";
            tableHeaderTitle=NSLocalizedString(@"SEGMENT_MONTHLY", @"");
        }
        else if (k==2) {
            reportPeriod=@"YEARLY";
            tableHeaderTitle=NSLocalizedString(@"SEGMENT_YEARLY", @"");
        }
        
        /*htmlString = 
         [htmlString stringByAppendingString:
         [NSString stringWithFormat:
         @"<tr><td>%@ </td></tr>\n",reportPeriod]
         ];
         
         htmlString = 
         [htmlString stringByAppendingString:
         [NSString stringWithFormat:
         @"<tr><td>%@ </td></tr>\n",tableHeaderTitle]
         ];
         */
        htmlString=
        [htmlString stringByAppendingString:
         [NSString stringWithFormat:
          @"\"%@\",\"%@\",\"%@\",\"%@\"\n",tableHeaderTitle,NSLocalizedString(@"INGOING", @""),NSLocalizedString(@"INRANGE", @""),NSLocalizedString(@"OUTGOING", @"")]];
        
        NSMutableArray *tempArray=[self.dictionary objectForKey:reportPeriod];
        for (int i=0;i<[tempArray count];i++)
        {
            ReportItem *reportItem=[tempArray objectAtIndex:i];
            NSString *weekNameText;
            
            if([reportItem.reportingLabel rangeOfString:NSLocalizedString(@"TITLE_WEEK", @"") options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                weekNameText = [NSString stringWithFormat:@"%@, %@", reportItem.reportingLabel, reportItem.weekDay];
            }
            else
            {
                weekNameText = [NSString stringWithFormat:@"%@", reportItem.reportingLabel];   
            }
            htmlString =
            [htmlString stringByAppendingString:
             [NSString stringWithFormat:
              @"\"%@\",\"%@\",\"%@\",\"%@\"\n",
              weekNameText,
              [NSString stringWithFormat:@"%@",reportItem.ingoingConverted],
              [NSString stringWithFormat:@"%@",reportItem.inrangeConverted],
              [NSString stringWithFormat:@"%@",reportItem.outgoingConverted]] ];
        }
        
        
    }    
	////NSLog(@"CSV String : %@",cvsString);
	return htmlString;
}	

- (NSString*)getFormContentHeader 
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *string1=[dateFormatter stringFromDate:startingDate];
    NSString *string2=[dateFormatter stringFromDate:endingDate];

    NSString * string =
    [NSString stringWithFormat:
     @"%@ : %@ - %@",
     NSLocalizedString(@"REPORT_MYDATERANGE", @""),string1,
     string2
     ];
    ;
    //%@     %@\n
    
    return string;
    
}



#pragma mark -
#pragma mark Show Methods Sample

- (void)show {
	[SVProgressHUD show];
}

- (void)showWithStatus:(NSString *) status {
	[SVProgressHUD showWithStatus:status];
}


#pragma mark -
#pragma mark Dismiss Methods Sample

- (void)dismiss {
	[SVProgressHUD dismiss];
}

-(NSInteger) getExpectedCentrePosition:(NSString *)string forFontSize:(NSInteger) fontSize{
    CGSize maximumLabelSize = CGSizeMake(100,9999);
    CGSize expectedLabelSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]   constrainedToSize:maximumLabelSize
                                                      lineBreakMode:UILineBreakModeWordWrap];
    CGFloat width =expectedLabelSize.width;
    return width;

}
@end
