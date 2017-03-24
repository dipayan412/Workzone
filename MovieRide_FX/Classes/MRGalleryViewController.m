//
//  MRGalleryViewController.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRGalleryViewController.h"
#import "MRAppDelegate.h"
#import "MRPlayerViewController.h"
#import "ReflectionView.h"
#import "YoutubeActivity.h"
#import "MRUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MRGalleryViewController ()

@property (nonatomic, strong) NSArray *videoFiles;
@property (nonatomic, strong) NSString *folderPath;
@property (nonatomic, strong) NSArray *products;

@end

@implementation MRGalleryViewController

@synthesize videoFiles;

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

    self.carousel.type = iCarouselTypeCoverFlow2;
    self.carousel.bounceDistance = 0.33;
    //self.carousel.contentOffset = CGSizeMake(0.0, -10.0);
    self.carousel.clipsToBounds = YES;
        
    //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    //[tracker set:kGAIScreenName value:MRCheckPointGallery];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    NSError *error = nil;
    self.folderPath = [NSString stringWithFormat:@"%@/MovieRide", documentPath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.folderPath error:&error];
    NSMutableArray *videosTemp = [[NSMutableArray alloc] init];
    
    //load template object
    
    NSString *templatesPath = [[MRUtil applicationDocumentsDirectory] stringByAppendingPathComponent:@"templates"];
    
    for(NSString *names in files)
    {
        GalleryItem *item = [[GalleryItem alloc] init];
        NSString *fileName = [names stringByDeletingPathExtension];
        NSLog(@"fileName %@",fileName);
        NSArray *actualName = [fileName componentsSeparatedByString:@"_"];
        item.templateFolderName = [actualName objectAtIndex:0];
        
        item.templateName = [self getTemplateNameForItem:item];
        
        NSString *templatePath = [templatesPath stringByAppendingPathComponent:item.templateFolderName];
        MRTemplate *template = [MRTemplate templateFromPath:templatePath];
        item.thumbnailFrame = template.sequence.thumbnailFrame / 60 + 2.0;
        
        item.dateTime = [actualName objectAtIndex:1];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
        item.itemDate = [formatter dateFromString:item.dateTime];
        [formatter setDateFormat:@"MMMM dd yyyy"];
        item.modifiedDateString = [formatter stringFromDate:item.itemDate];
        
        NSString *takeNo = [actualName objectAtIndex:2];
        item.takeNo = takeNo;
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",self.folderPath, names];
        item.filePath = filePath;
        [videosTemp addObject:item];
    }
    
    [videosTemp sortUsingComparator:^NSComparisonResult(GalleryItem *date1, GalleryItem *date2) {
        // return date2 compare date1 for descending. Or reverse the call for ascending.
        return [date2.itemDate compare:date1.itemDate];
    }];
    
    self.videoFiles = [NSArray arrayWithArray:videosTemp];

    if(self.videoFiles.count == 0)
    {
        self.goToPlayerButton.enabled = NO;
        self.shareButton.enabled = NO;
    }
    
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
    if ([segue.identifier isEqualToString:@"GalleryToPlayer"])
    {
        MRPlayerViewController *playerController = (MRPlayerViewController *)segue.destinationViewController;
        playerController.fromController = @"MRGalleryViewController";
        GalleryItem *item = [self.videoFiles objectAtIndex:self.carousel.currentItemIndex];
        playerController.filePath = item.filePath;
    }
}
    
-(IBAction)backButtonAction:(id)sender
{
    MRAppDelegate *adel = (MRAppDelegate*)  [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if([self.fromController isEqualToString:@"MRHomeViewController"])
    {
        [self performSegueWithIdentifier:@"UnwindToHomeFromGallery" sender:self];
    }
    else if([self.fromController isEqualToString:@"MRClipsViewController"])
    {
        [self performSegueWithIdentifier:@"UnwindToClipsFromGallery" sender:self];
    }
    else if([self.fromController isEqualToString:@"MRPreviewViewController"])
    {
        [self performSegueWithIdentifier:@"UnwindToPreviewFromGallery" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"UnwindToInfoFromGallery" sender:self];
    }
}

-(IBAction)shareVideo:(id)sender
{
    MRAppDelegate *adel = (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    GalleryItem *item = [self.videoFiles objectAtIndex:self.carousel.currentItemIndex];
//    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[self.videoFiles objectAtIndex:self.carousel.currentItemIndex]];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:item.filePath];
    
    // pop ups the uiactivityviewcontroller
    
    // using local file to share video
    
//    NSLog(@"urlToVideoFile %@", fileURL);
    
    // creating items array: which items will be published to the social sites
    
    // user must have facebook enabled from device settings (simulator settings will work too)
    
    NSArray * activityItems = @[[NSString stringWithFormat:@"Be IN the movies with the MovieRide FX app.\n\nhttp://www.movieridefx.com"],fileURL];
    
    
    // Create the activity view controller passing in the activity provider, image and url we want to share along with the additional source we want to appear (youtube)
    
    YoutubeActivity *youtubeActivity = [[YoutubeActivity alloc] init];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:@[youtubeActivity]];
    [activityViewController setValue:@"My MovieRide FX movie" forKey:@"subject"];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypePostToTencentWeibo,UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
    
    activityViewController.completionHandler = ^(NSString *activityType, BOOL completed)
    {
        if(completed)
        {
//            NSLog(@"%@", activityType);
            if([activityType isEqualToString:@"com.apple.UIKit.activity.SaveToCameraRoll"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Video saved to camera roll." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            else if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToFacebook"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Video will be published to Facebook." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            else if([activityType isEqualToString:@"com.apple.UIKit.activity.Mail"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Mail will be sent shortly." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
        
        if([activityType isEqualToString:@"com.mobilica.youtubesharing"])
        {
            // for youtube share, present the youtube login viewcontroller, sharing is handled from there
            
            YoutubeLoginViewController *loginVC = [[YoutubeLoginViewController alloc] initWithNibName:@"YoutubeLoginViewController" bundle:nil];
            loginVC.delegate = self;
            loginVC.filePath = item.filePath;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:navController animated:YES completion:nil];
        }
    };
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)dismissYoutubeShareView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.videoFiles count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CGRect frame = CGRectMake(0, 0, 250.0f * 2.13, 180.0f * 2.4);
            view = [[UIView alloc] initWithFrame:frame];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 250.0f * 2.13, 178.0f * 2.4)];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.layer.borderColor = [UIColor clearColor].CGColor;
            imageView.layer.borderWidth = 1;
            imageView.layer.cornerRadius = 2.0f;
            
            [imageView setTag:1];
            [view addSubview:imageView];
            [view bringSubviewToFront:imageView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, imageView.frame.size.width, 44)];
            nameLabel.font = [UIFont systemFontOfSize:25];
            [nameLabel setTag:2];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:nameLabel];
            nameLabel.textColor = [UIColor whiteColor];
            [view bringSubviewToFront:nameLabel];
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 69, view.frame.size.width, 44)];
            dateLabel.font = [UIFont systemFontOfSize:25];
            [dateLabel setTag:3];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:dateLabel];
            dateLabel.textColor = [UIColor whiteColor];
            [view bringSubviewToFront:dateLabel];
        }
        else
        {
            CGRect frame = CGRectMake(0, 0, 250.0f, 180.0f);
            view = [[UIView alloc] initWithFrame:frame];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250.0f, 178.0f)];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.layer.borderColor = [UIColor clearColor].CGColor;
            imageView.layer.borderWidth = 1;
            imageView.layer.cornerRadius = 2.0f;
            
            [imageView setTag:1];
            [view addSubview:imageView];
            [view bringSubviewToFront:imageView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
            nameLabel.font = [UIFont systemFontOfSize:13];
            [nameLabel setTag:2];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:nameLabel];
            nameLabel.textColor = [UIColor whiteColor];
            [view bringSubviewToFront:nameLabel];
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 22, view.frame.size.width, 20)];
            dateLabel.font = [UIFont systemFontOfSize:13];
            [dateLabel setTag:3];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:dateLabel];
            dateLabel.textColor = [UIColor whiteColor];
            [view bringSubviewToFront:dateLabel];
        }
    }
    
    GalleryItem *item = [self.videoFiles objectAtIndex:index];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:item.filePath];
    
    UIImage *image = [self thumbnailFromVideoAtURL:fileURL forTime:item.thumbnailFrame];
    UIImageView *imageView = (UIImageView *)[view viewWithTag:1];
    [imageView setImage:image];
    
    UILabel *nameLabel = (UILabel *)[view viewWithTag:2];
    NSString *nameStr = [NSString stringWithFormat:@"%@, %@", item.templateName, item.takeNo.capitalizedString];
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@":" withString:@" "];
//    nameLabel.text = [NSString stringWithFormat:@"%@, %@", item.templateName, item.takeNo.capitalizedString];
    nameLabel.text = nameStr;
    nameLabel.backgroundColor = [UIColor blackColor];
    
    UILabel *dateLabel = (UILabel *)[view viewWithTag:3];
    dateLabel.backgroundColor = [UIColor blackColor];
    dateLabel.text = [NSString stringWithFormat:@"%@", item.modifiedDateString];
    
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if (index == carousel.currentItemIndex)
    {
        [self performSegueWithIdentifier:@"GalleryToPlayer" sender:self];
    }
}

-(void)adjustImageView:(UIImageView*)_imageView toImage:(UIImage*)_image
{
    //adjust the image size of the item, maintaing aspectfit
    _imageView.image = _image;
    
    float ratio = _image.size.width / _image.size.height;
    int widthOfImageViewShouldBe = ratio * _imageView.frame.size.height;
    int xShouldBe = self.view.frame.size.width/2 - (widthOfImageViewShouldBe / 2);
    
    CGRect imageFrame = _imageView.frame;
    imageFrame.origin.x = xShouldBe;
    imageFrame.size.width = widthOfImageViewShouldBe;
    _imageView.frame = imageFrame;
}

-(IBAction)unwindToGallery:(UIStoryboardSegue *)segue
{
    NSLog(@"Unwinded to Gallery");
}

- (UIImage *)thumbnailFromVideoAtURL:(NSURL *)url forTime:(int)_time
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    //  Get thumbnail at the very start of the video
    CMTime thumbnailTime = [asset duration];
//    thumbnailTime.value = 0;
    thumbnailTime.value = thumbnailTime.timescale * _time;
    
    //  Get image from the video at the given time
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:&err];
    if(err)
    {
        NSLog(@"err==%@, imageRef==%@", err, imageRef);
    }
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
//    NSLog(@"editable : %@", asset.exportable ? @"YES" : @"NO");

//    /*
    NSArray *metadata = [asset commonMetadata];
    
//    NSLog(@"meta count %d", metadata.count);
    for (AVMetadataItem* item in metadata)
    {
//        NSString *key = [item commonKey];
//        NSString *value = [item stringValue];
//        NSLog(@"key = %@, value = %@", key, value);
    }
    return thumbnail;
}
    
-(NSString*)getTemplateNameForItem:(GalleryItem*)_item
{
    if(!self.products || self.products.count < 1)
    {
        NSString *productsFile = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"xml"];
        self.products = [MRProduct productsFromFile:productsFile];
    }
    
    for(MRProduct *product in self.products)
    {
        if ([product.templateFolder isEqualToString:_item.templateFolderName])
        {
            return product.name;
        }
    }
    return @"";
}

@end

@implementation GalleryItem

@synthesize filePath;
@synthesize dateTime;
@synthesize modifiedDateString;
@synthesize templateName;
@synthesize templateFolderName;
@synthesize takeNo;
@synthesize thumbnailFrame;

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

@end
