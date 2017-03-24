//
//  SetDifficultyVC.m
//  PhotoPuzzle
//
//  Created by Granjur on 02/04/2013.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import "SetDifficultyVC.h"
#import "imagePreView.h"
@interface SetDifficultyVC ()

@end

@implementation SetDifficultyVC
@synthesize easyButton,normalButton,hardButton;
@synthesize isEasy,isMedium,isHard;
@synthesize selectedImage;
@synthesize Email;
@synthesize integer;

- (void)dealloc
{
    self.Email = nil;
    self.selectedImage = nil;
    self.easyButton = nil;
    self.normalButton = nil;
    self.hardButton = nil;
    [_imageTaken release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageTaken setImage:self.selectedImage];
    [self.easyButton setSelected:YES];
    self.isEasy = YES;
    [self updateView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)easyBtnAction:(id)sender
{
    [self.easyButton setSelected:YES];
    [self.normalButton setSelected:NO];
    [self.hardButton setSelected:NO];
    self.isEasy= YES;
    [self updateView];
}
- (IBAction)normalBtnAction:(id)sender
{
    [self.normalButton setSelected:YES];
    [self.easyButton setSelected:NO];
    [self.hardButton setSelected:NO];
    self.isEasy= YES;
    [self updateView];
}
- (IBAction)hardBtnAction:(id)sender
{
    [self.hardButton setSelected:YES];
    [self.easyButton setSelected:NO];
    [self.normalButton setSelected:NO];
    self.isEasy= YES;
    [self updateView];
}
- (void)updateView
{
    
    if([self.easyButton isSelected])
    {
        [self.easyButton setBackgroundImage:[UIImage imageNamed:@"easy_green.png"] forState:UIControlStateNormal];

    }
    else
    {
        [self.easyButton setBackgroundImage:[UIImage imageNamed:@"easy_text.png"] forState:UIControlStateNormal];
    }
    if([self.normalButton isSelected])
    {
        [self.normalButton setBackgroundImage:[UIImage imageNamed:@"normal_green.png"] forState:UIControlStateNormal];
    
    }
    else
    {
        [self.normalButton setBackgroundImage:[UIImage imageNamed:@"normal_text.png"] forState:UIControlStateNormal];
    }
    if([self.hardButton isSelected])
    {
        [self.hardButton setBackgroundImage:[UIImage imageNamed:@"hard_green.png"] forState:UIControlStateNormal];
    }
    else{
        [self.hardButton setBackgroundImage:[UIImage imageNamed:@"hard_text.png"] forState:UIControlStateNormal];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    /*
    UIView *rightview = [[UIView alloc] initWithFrame:CGRectMake(0,0,53,44)];
    UIButton* suspend1=[[UIButton alloc]initWithFrame:CGRectMake(0, 3, 40, 40)];
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header_edit.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    
    
    suspend1.clipsToBounds=YES;  //Commented  By Sher
     
     suspend1.contentMode=UIViewContentModeScaleAspectFit;
     [suspend1 setImage:[UIImage imageNamed:@"next_btn"] forState:UIButtonTypeCustom];
     [suspend1 addTarget:self action:@selector(continueToNext:) forControlEvents:UIControlEventTouchUpInside];
     [rightview addSubview:suspend1];
     [suspend1 release];
     UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
     self.navigationItem.rightBarButtonItem = customItem;
     [customItem release];
     [rightview release];
     */
    
    UIButton *editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame=CGRectMake(20, 3, 40, 40);
    //    editButton.backgroundColor=[UIColor clearColor];
    editButton.tintColor=nil;
    [editButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
   
    self.navigationController.navigationBarHidden = NO;
     UINavigationBar *navBar = [[self navigationController] navigationBar];
     UIImage *backgroundImage = [UIImage imageNamed:@"header_edit.png"];
     [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
     UIView *rightview = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,40)];
     rightview.backgroundColor=[UIColor clearColor];
     UIButton* suspend=[[UIButton alloc]initWithFrame:CGRectMake(0,0, 40, 40)];
     
     // suspend.layer.cornerRadius=20.0;
     suspend.clipsToBounds=YES;
     
     suspend.contentMode=UIViewContentModeScaleAspectFit;
    
    CGRect buttonFrame = CGRectMake(260, 3, 40, 40);
    suspend.frame = buttonFrame;
    
     [suspend setImage:[UIImage imageNamed:@"next_btn.png"] forState:UIControlStateNormal];
     [suspend addTarget:self action:@selector(continueToNext) forControlEvents:UIControlEventTouchUpInside];
     [rightview addSubview:suspend];
//     [suspend release];
     UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
    
    
//    UIView *rightview2 = [[UIView alloc] initWithFrame:CGRectMake(172,0,53,44)];
//    rightview.backgroundColor=[UIColor clearColor];
//    UIButton* suspend2=[[UIButton alloc]initWithFrame:CGRectMake(0,3, 40, 40)];
//    
//    // suspend.layer.cornerRadius=20.0;
//    suspend2.clipsToBounds=YES;
//    
//    suspend2.contentMode=UIViewContentModeScaleAspectFit;
//    [suspend2 setImage:[UIImage imageNamed:@"next_btn.png"] forState:UIButtonTypeCustom];
//    [suspend2 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [rightview2 addSubview:suspend2];
//    [suspend2 release];
//    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightview];
    
    
    
//     self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:editButton] autorelease];
//     self.navigationItem.rightBarButtonItem = customItem;
//    self.navigationItem.rightBarButtonItem = customItem2;
    
//    [rightview2 release];
//    [customItem2 release];
     [customItem release];
     [rightview release];
    
    self.navigationController.navigationBarHidden = YES;
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    [self.view addSubview:iv];
    [self.view addSubview:editButton];
    [self.view addSubview:suspend];
}
-(void)setint:(int)integer1
{
    self.integer=integer1;
}
- (void)continueToNext
{
    imagePreView *imageprocessing=[[[imagePreView alloc]init]autorelease];
    imageprocessing.selectedImage=self.selectedImage;
    [imageprocessing setint:self.integer];
    if([self.easyButton isSelected])
    {
        imageprocessing.complexityLevel=@"Easy";
    }
    else if([self.normalButton isSelected])
    {
        imageprocessing.complexityLevel=@"Medium";
    }
    else if([self.hardButton isSelected])
    {
        imageprocessing.complexityLevel=@"Hard";
    }
    imageprocessing.Email=self.Email;
    NSLog(@"email %@",self.Email);
    [self.navigationController pushViewController:imageprocessing animated:YES];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}
- (void)viewDidUnload {
    [self setImageTaken:nil];
    [super viewDidUnload];
}
@end
