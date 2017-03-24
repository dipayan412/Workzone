//
//  TutorialPopupVC.m
//  PhotoPuzzle
//
//  Created by Granjur on 01/04/2013.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import "TutorialPopupVC.h"

@interface TutorialPopupVC ()

@end

@implementation TutorialPopupVC
@synthesize delegate;

-(void)dealloc
{
//    self.delegate = nil;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeBtnClicked:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeClicked)])
    {
        [self.delegate closeClicked];
    }
}
#pragma mark - FTAnimation

- (void) show
{
    [self.view slideInFrom:kFTAnimationRight duration:0.8 delegate:nil];
}

-(void) hide
{
    [self.view slideOutTo:kFTAnimationRight duration:0.5 delegate:nil];
    
}
@end
