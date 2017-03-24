//
//  MRClipsViewController.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRClipsViewController.h"
#import "MRAppDelegate.h"
#import "ReflectionView.h"
#import "MRProduct.h"
#import "MRPreviewViewController.h"
#import "MRGalleryViewController.h"
#import "MRUtil.h"

@interface MRClipsViewController ()
{
    BOOL wrap;
}

@property (nonatomic) NSArray *products;

@end

@implementation MRClipsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)awakeFromNib {
    [self loadProducts];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.carousel.type = iCarouselTypeCoverFlow2;
    self.carousel.bounceDistance = 0.33;

    wrap = NO;
        
    //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    //[tracker set:kGAIScreenName value:MRCheckPointClips];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MRAppDelegate *adel = (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    if(adel.carosulCurrentItemIndex >= 0)
    {
        self.carousel.currentItemIndex = adel.carosulCurrentItemIndex;
    }
}

-(void)loadProducts
{
    NSString *productsFile = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"xml"];
    self.products = [MRProduct productsFromFile:productsFile];
    [self.carousel reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MRAppDelegate *adel = (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    adel.carosulCurrentItemIndex = self.carousel.currentItemIndex;
    
    if ([segue.identifier isEqualToString:@"Preview"]) {
        int index = [self.carousel currentItemIndex];
        MRProduct *product = [self.products objectAtIndex:index];
        
        MRPreviewViewController *previewController = (MRPreviewViewController *)segue.destinationViewController;
        previewController.product = product;
    }
    else if ([segue.identifier isEqualToString:@"Purchase"])
    {
        int index = [self.carousel currentItemIndex];
        MRProduct *product = [self.products objectAtIndex:index];
        
        MRPreviewViewController *previewController = (MRPreviewViewController *)segue.destinationViewController;
        previewController.product = product;
    }
    else if ([segue.identifier isEqualToString:@"Gallery"])
    {
        MRGalleryViewController *galleryController = (MRGalleryViewController *)segue.destinationViewController;
        galleryController.fromController = @"MRClipsViewController";
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.products count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CGRect frame = CGRectMake(0, 0, 180.0f * 2.13, 200.0f * 2.4);
            view = [[ReflectionView alloc] initWithFrame:frame];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 * 2.13, 0, 140.0f * 2.13, 200.0f * 2.4)];
            imageView.contentMode = UIViewContentModeScaleToFill;
            [imageView setTag:1];
            [view addSubview:imageView];
        }
        else
        {
            CGRect frame = CGRectMake(0, 0, 180.0f, 200.0f);
            view = [[ReflectionView alloc] initWithFrame:frame];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 140.0f, 200.0f)];
            imageView.contentMode = UIViewContentModeScaleToFill;
            [imageView setTag:1];
            [view addSubview:imageView];
        }
    }
    
    MRProduct *product = [self.products objectAtIndex:index];
    
    UIImage *image = [UIImage imageNamed:product.poster];
    UIImageView *imageView = (UIImageView *)[view viewWithTag:1];
    [imageView setImage:image];
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (index == carousel.currentItemIndex)
    {
        MRProduct *product = [self.products objectAtIndex:index];
        if([product.type isEqualToString:@"Paid"])
        {
            NSLog(@"paid Tapped");
            if([MRUtil isProducePurchased:product.templateFolder])
            {
                [self performSegueWithIdentifier:@"Preview" sender:self];
            }
            else
            {
                [self performSegueWithIdentifier:@"Purchase" sender:self];
            }
        }
        else
        {
            [self performSegueWithIdentifier:@"Preview" sender:self];
        }
    }
}

-(IBAction)goToPreview:(id)sender
{
    int index = [self.carousel currentItemIndex];
    MRProduct *product = [self.products objectAtIndex:index];
    if([product.type isEqualToString:@"Downloadable"])
    {
        NSLog(@"paid Tapped");
        if([MRUtil isProducePurchased:product.templateFolder])
        {
            [self performSegueWithIdentifier:@"Preview" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"Purchase" sender:self];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"Preview" sender:self];
    }
}

-(IBAction)unwindToClips:(UIStoryboardSegue *)segue
{
    NSLog(@"Unwinded to clips");
}

-(IBAction)unwindToClipsFromGallery:(UIStoryboardSegue *)segue
{
    NSLog(@"Unwinded to Clips");
}

@end
