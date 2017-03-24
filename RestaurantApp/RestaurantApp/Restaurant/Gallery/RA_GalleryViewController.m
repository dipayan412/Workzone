//
//  RA_GalleryViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_GalleryViewController.h"
#import "RA_GalleryCellCell.h"
#import "RA_SelectedImageViewController.h"

@interface RA_GalleryViewController () <galleryCellDelegate>
{
    NSArray *imageArray;
    NSArray *_gallaryItems;
    
    RA_ImageCache *imgCh;
}
@property (nonatomic, retain) ASIHTTPRequest *galleryRequest;
@property (nonatomic, retain) NSArray *gallaryItems;
@property (nonatomic, assign) BOOL isImagesShowed;
@end

@implementation RA_GalleryViewController
@synthesize galleryRequest;
@synthesize gallaryItems = _gallaryItems;
@synthesize isImagesShowed;

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
    
    self.isImagesShowed = NO;
    
    // setting the title of the page to white color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //custom class created to store images into cache so that user do not have to wait each time when the images are to be loaded
    imgCh = [[RA_ImageCache alloc] init];
    
    //tableview attributes configured
    containerTableView.backgroundColor = kPageBGColor;
    containerTableView.separatorColor = [UIColor clearColor];
    
    //request server for images which are to be shown
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@?accesskey=%@", galleryAPI,AccessKey];
    NSURL *url = [NSURL URLWithString:urlStr];
    self.galleryRequest = [ASIHTTPRequest requestWithURL:url];
    galleryRequest.delegate = self;
    [galleryRequest startAsynchronous];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.isImagesShowed)
    {
        // if loading is in progress show the user to wait
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = AMLocalizedString(@"kWait", nil);
        hud.labelColor = [UIColor lightGrayColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    //loading view disappers if while loading user changes page
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [super viewWillDisappear:animated];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    //if server request succeeded
    if(request == self.galleryRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        if (error)
        {
            LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kParseResponse", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        
        NSArray *responseArray = [responseObject objectForKey:@"data"];
        NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
        for(int i=0; i<responseArray.count; i++)
        {
            NSDictionary *dic = [[responseArray objectAtIndex:i] objectForKey:@"Gallery"];
            
            RA_GalleryObject *galleryObject = [[RA_GalleryObject alloc] init];
            //a galleryobject contains an image and the id of the image sent from server
            galleryObject.objectId = [[dic objectForKey:@"ID"] intValue];
            galleryObject.imagePath = [dic objectForKey:@"Thumb_Path"];
            [itemsArray addObject:galleryObject];
        }
        
        _gallaryItems = [[NSArray alloc] initWithArray:itemsArray];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            for(RA_GalleryObject *object in _gallaryItems)
            {
                // creating a thread where images are fetched from server,stored in cache and then populated in an array
                NSMutableString *urlStr = [[NSMutableString alloc] init];
                [urlStr appendFormat:@"%@restaurant/%@",AdminPageURL,object.imagePath];
                UIImage *photo = [imgCh getImage:urlStr];
                [images addObject:photo];
            }
            imageArray = [[NSArray alloc] initWithArray:images];
            [containerTableView reloadData];
            
            // hide busy screen
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.isImagesShowed = YES;
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            imageArray = [[NSArray alloc] initWithArray:images];
            [containerTableView reloadData];
        });
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    // could not connect to server
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kConnectServer", nil) delegate:Nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles: nil];
    [alert show];
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
    //total row number is equal to the number of one third of total images as evry row can represent upto 3 images
    if(imageArray.count>0)
    {
        return (imageArray.count/3 + 1);
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //here a single row contains 3 imageview and 3 buttons under each imageview. every button is tagged with the index number of every item from the imageArray. so when a button is tapped we can determine which image has been chosen from the button's tag number
    static NSString *identifier = @"galleryCellId";
    RA_GalleryCellCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    int leftImageIndex = (int)indexPath.row * 3;
    int centerImageIndex = (int)indexPath.row * 3 + 1;
    int rightImageIndex = (int)indexPath.row * 3 + 2;
    
    if(cell == nil)
    {
//        cell = [[RA_GalleryCellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier tag1:tag1 tag2:tag2 tag3:tag3];
        cell = [[RA_GalleryCellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    int tag1 = -1;
    int tag2 = -1;
    int tag3 = -1;
    
    if(imageArray.count > leftImageIndex)
    {
        tag1 = leftImageIndex;
    }
    if(imageArray.count > centerImageIndex)
    {
        tag2 = centerImageIndex;
    }
    if(imageArray.count > rightImageIndex)
    {
        tag3  = rightImageIndex;
    }
    
    [cell reorderTags:tag1 tag2:tag2 tag3:tag3];
    
    if(imageArray.count > leftImageIndex)
    {
        cell.leftImageView.image = [imageArray objectAtIndex:leftImageIndex];
    }
    
    if(imageArray.count > centerImageIndex)
    {
        cell.centerImageView.image = [imageArray objectAtIndex:centerImageIndex];
    }
    if(imageArray.count > rightImageIndex)
    {
        cell.rightImageView.image = [imageArray objectAtIndex:rightImageIndex];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width/3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 * Method name: indexOfTappedImage
 * Description: deliver the selected image to the next page
 * Parameters: index of the image which has been selected
 */

-(void)indexOfTappedImage:(int)index
{
    //shows the tapped image in the next page
    RA_SelectedImageViewController *vc = [[RA_SelectedImageViewController alloc] initWithNibName:@"RA_SelectedImageViewController" bundle:nil];
    vc.selectedImage = [imageArray objectAtIndex:index];//the image which has been tapped
    NSLog(@"array index %d of count %d", index, imageArray.count);
    vc.arrayIndex = index;// index of the tapped image
    vc.picturesArray = imageArray;// total image array fetched from server
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    vc.title = AMLocalizedString(@"kImage", nil);
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: AMLocalizedString(@"kBack", nil) style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
