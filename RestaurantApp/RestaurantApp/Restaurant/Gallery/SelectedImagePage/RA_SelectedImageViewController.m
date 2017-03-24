//
//  RA_SelectedImageViewController.m
//  RestaurantApp
//
//  Created by World on 12/20/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_SelectedImageViewController.h"

@interface RA_SelectedImageViewController ()

@end

@implementation RA_SelectedImageViewController

@synthesize selectedImage;
@synthesize picturesArray;
@synthesize arrayIndex;

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
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //setting page's background color
    containerImageView.backgroundColor = kPageBGColor;
    containerImageView.image = self.selectedImage;
    self.view.backgroundColor = kPageBGColor;
    
    //creating left and right gesture
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    //adding gestures to the imageview
    [containerImageView addGestureRecognizer:swipeLeft];
    [containerImageView addGestureRecognizer:swipeRight];
    containerImageView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * Method name: handleSwipe
 * Description: handle transitions of images respect to swiping right or left
 */

-(void)handleSwipe:(UISwipeGestureRecognizer*)swipe
{
    BOOL goToNext = NO;
    
    if(swipe.direction == UISwipeGestureRecognizerDirectionRight)//if swipe right than show the previous image
    {
        if(self.arrayIndex > 0)
        {
            self.arrayIndex--;
        }
        else
        {
            return;
        }
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)// if swipe left show the next image
    {
        if(self.arrayIndex < self.picturesArray.count - 1)
        {
            self.arrayIndex++;
            goToNext = YES;
        }
        else
        {
            return;
        }
    }
    
    //flipping images according to swipe direction. if swipe right to left then the flip will be from right to left and vice versa
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    if(goToNext)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    }
    containerImageView.image = [self.picturesArray objectAtIndex:self.arrayIndex];
	[UIView commitAnimations];
}



@end
