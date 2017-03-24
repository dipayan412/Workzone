//
//  ShareActionSheetVC.m
//  PhotoPuzzle
//
//  Created by Granjur on 03/04/2013.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import "ShareActionSheetVC.h"

@interface ShareActionSheetVC ()

@end

@implementation ShareActionSheetVC
@synthesize delegate;
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
-(IBAction)clickedButton:(id)sender
{
    UIButton * temp = (UIButton*)sender;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedButtonAtIndex:)])
    {
        [self.delegate clickedButtonAtIndex:temp.tag];
    }
}
#pragma mark - FTAnimation

- (void) show
{
    [self.view slideInFrom:kFTAnimationBottom duration:0.5 delegate:nil];
}

-(void) hide
{
    [self.view slideOutTo:kFTAnimationBottom duration:0.5 delegate:nil];
}
//#pragma mark- iphone 5 Customization
//-(void)viewWillLayoutSubviews
//{
//    self.view.frame = self.view.bounds;
//    [super viewWillLayoutSubviews];
//}
@end
