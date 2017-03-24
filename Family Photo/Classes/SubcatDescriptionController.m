//
//  SubcatDescriptionController.m
//  RenoMate
//
//  Created by yogesh ahlawat on 17/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import "SubcatDescriptionController.h"
#import "DataBaseManager.h"
#import "CategoryDescriptionDB.h"
#import "DisplayImageController.h"
#import "SettingController.h"
#import "AddDetailViewController.h"
#import "WhosinAppDelegate.h"
#import "ApplicationPreference.h"
#import "UINavigationController+Operations.h"

@implementation SubcatDescriptionController

@synthesize subCatArray;
@synthesize catNameTextField;
@synthesize image;

@synthesize popOver;

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
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(85.0f/255.0f) green:(85.0f/255.0f) blue:(85.0f/255.0f) alpha:1.0f]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonPressed:)];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:(61.0f/255.0f) green:(121.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f]];
    
    UIButton *buttonS = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [buttonS setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [buttonS addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(settingButtonClicked:)];
    if([[UIDevice currentDevice] systemVersion].floatValue >= 7.0)
    {
        settingsButton.tintColor = [UIColor colorWithRed:(61.0f/255.0f) green:(121.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f];
    }
    else
    {
        settingsButton.tintColor = [UIColor lightGrayColor];
    }
    
    UIButton *buttonU = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [buttonU setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
    [buttonU addTarget:self action:@selector(uploadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    uploadButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadButtonClicked:)];
    uploadButton.tintColor = [UIColor colorWithRed:(61.0f/255.0f) green:(121.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f];
    
    seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 2, 170, 42)];
    seachBar.delegate = self;
    seachBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [seachBar setBackgroundColor:[UIColor clearColor]];
    
    searchItem = [[UIBarButtonItem alloc] initWithCustomView:seachBar];
    
    fSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    fSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    bottomToolbar.items = [NSArray arrayWithObjects:settingsButton, fSpace1, searchItem, fSpace2, uploadButton, nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSArray *categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    subCatArray = [[DataBaseManager getInstance] getSubCat:[categoryArray objectAtIndex:appDelegate.globalCategoryIndex]];
    
    self.title = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
    
    CALayer* mask = [[CALayer alloc] init];
    [mask setBackgroundColor: [UIColor blackColor].CGColor];
    [mask setFrame: CGRectMake(0.0f, 0.0f, seachBar.frame.size.width, seachBar.frame.size.height)];
    [mask setCornerRadius: 14.0f];
    [seachBar.layer setMask: mask];
    
    [subCatTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [seachBar resignFirstResponder];
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

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark table delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [subCatArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                   reuseIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImageView *v = [[UIImageView alloc] init] ;
        v.backgroundColor=[UIColor grayColor];
        cell.selectedBackgroundView = v;
        
        UIButton *cellAccesaryButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 0, 31, 24)];
        [cellAccesaryButton setImage:[UIImage imageNamed:@"arrow-1.png"] forState:UIControlStateNormal];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    CategoryDescriptionDB *obj = [subCatArray objectAtIndex:indexPath.row];
    
    NSString *photoloc = obj.PhotoRef;
    
    UIImage *img = [self imageToSquare:[UIImage imageWithContentsOfFile:photoloc]];
    
    if (obj.notes == nil || [obj.notes isEqualToString:@""] || [obj.notes isEqualToString:@"(null)"])
    {
        cell.textLabel.text = @"";
    }
    else
    {
        cell.textLabel.text = obj.notes;
    }
    
    if (obj.notes == nil || [obj.notes isEqualToString:@""] || [obj.notes isEqualToString:@"(null)"])
    {
        cell.detailTextLabel.text = @"No Location";
    }
    else
    {
        cell.detailTextLabel.text = obj.location;
    }
    
    cell.imageView.image = img;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSArray *categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    NSString *categoryName = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
    NSArray *allImage = [[[DataBaseManager getInstance] getSubCat:categoryName] mutableCopy];
    CategoryDescriptionDB *imageDes = [subCatArray objectAtIndex:indexPath.row];
    
    int index = -1;
    for (int i = 0; i < allImage.count; i++)
    {
        CategoryDescriptionDB *imageAtIndex = [allImage objectAtIndex:i];
        if ([imageAtIndex.PhotoRef isEqualToString:imageDes.PhotoRef])
        {
            index = i;
            break;
        }
    }
    
    DisplayImageController *ob = [[DisplayImageController alloc] initWithNibName:@"DisplayImageController" bundle:nil];
    ob.currentIndex = index;

    [self.navigationController pushViewController:ob animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    return 70;
}

#pragma mark added methods

- (UIImage *) imageToSquare:(UIImage *)_image
{
	UIImage *image1 = [[UIImage alloc] init] ;
	int dimension = 100;
	if(_image)
    {
		image1 = _image;
		float height = (float) CGImageGetHeight([image1 CGImage]);
		float width = (float) CGImageGetWidth([image1 CGImage]);
		float x1 = 0, y1 = 0;
		
		if(height < width)
        {
			float factor = height / dimension;
			image1 = [self newimage:_image WithSize:CGSizeMake(width/factor, dimension)];
			x1 = (width/factor - dimension) / 2;
		}
        else
        {
			float factor = width / dimension;
			image1 = [self newimage:_image WithSize:CGSizeMake(dimension, height/factor)];
			y1 = (height/factor - dimension) / 2;
		}
		CGImageRef imageRef = CGImageCreateWithImageInRect([image1 CGImage], CGRectMake((x1 < 0) ? 0 : x1, (y1 < 0) ? 0 : y1, dimension, dimension));
		image1 = [UIImage imageWithCGImage:imageRef];
		CGImageRelease(imageRef);
	}
	return image1;	
}

- (UIImage *) newimage:(UIImage *)_image WithSize:(CGSize)newSize
{
	UIImage *image1 = [[UIImage alloc] init] ;
	if(_image)
    {
		image1 = _image;
		UIGraphicsBeginImageContext(newSize);
		[image1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
		UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
		UIGraphicsEndImageContext();
		return newImage;
	}
	return image1;
}
#pragma mark search bar delegate 

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        seachBar.frame = CGRectMake(0, 2, 270, 42);
        
        CALayer* mask = [[CALayer alloc] init];
        [mask setBackgroundColor: [UIColor blackColor].CGColor];
        [mask setFrame: CGRectMake(0.0f, 0.0f, seachBar.frame.size.width, seachBar.frame.size.height)];
        [mask setCornerRadius: 14.0f];
        [seachBar.layer setMask: mask];
    }
    
    bottomToolbar.items = [NSArray arrayWithObjects:fSpace1, searchItem, fSpace2, nil];
    seachBar.showsCancelButton = YES;
    [self animateTextField:searchBar up:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        seachBar.frame = CGRectMake(0, 2, 170, 42);
        
        CALayer* mask = [[CALayer alloc] init];
        [mask setBackgroundColor: [UIColor blackColor].CGColor];
        [mask setFrame: CGRectMake(0.0f, 0.0f, seachBar.frame.size.width, seachBar.frame.size.height)];
        [mask setCornerRadius: 14.0f];
        [seachBar.layer setMask: mask];
    }
    
    bottomToolbar.items = [NSArray arrayWithObjects:settingsButton, fSpace1, searchItem, fSpace2, uploadButton, nil];
    seachBar.showsCancelButton = NO;
    [self animateTextField:searchBar up:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    WhosinAppDelegate *appDelegate = (WhosinAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSArray *categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    NSString *categoryName = [categoryArray objectAtIndex:appDelegate.globalCategoryIndex];
    
    if ([searchBar.text isEqualToString:@""])
    {
        subCatArray = [[DataBaseManager getInstance] getSubCat:categoryName];
    }
    else
    {
        subCatArray = [[DataBaseManager getInstance] getMatchingSubCat:searchText :categoryName];
    }
    
    [subCatTable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [seachBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [seachBar resignFirstResponder];
}

-(void)uploadButtonClicked:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.delegate = self;
	imagePicker.allowsEditing = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self presentModalViewController:imagePicker animated:YES];
    }
    else
    {
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.popOver setDelegate:self];
        
        [self.popOver setPopoverContentSize:CGSizeMake(320, 600) animated:NO];
        
        CGRect r = CGRectMake(220,160,320,600);
        [self.popOver presentPopoverFromRect:r inView:self.view permittedArrowDirections:0 animated:YES];
    }
}

-(void)settingButtonClicked:(id)sender
{
    SettingController *ob=[[SettingController alloc] init];
    [self.navigationController pushViewController:ob animated:YES];
}

-(void)cameraButtonPressed:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source 
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
	imagePicker.delegate = self;
	imagePicker.allowsEditing = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self presentModalViewController:imagePicker animated:YES];
    }
    else
    {
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.popOver setDelegate:self];
        
        [self.popOver setPopoverContentSize:CGSizeMake(320, 600) animated:NO];
        
        CGRect r = CGRectMake(220,160,320,600);
        [self.popOver presentPopoverFromRect:r inView:self.view permittedArrowDirections:0 animated:YES];
    }
}

-(UIImage*)rotateImage:(UIImage*)img withRotationType:(int)rotation
{
    CGImageRef imageRef = [img CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (alphaInfo == kCGImageAlphaNone)
    {
        alphaInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    bitmap = CGBitmapContextCreate(NULL, img.size.height, img.size.width, CGImageGetBitsPerComponent(imageRef), 4 * img.size.height, colorSpaceInfo, alphaInfo);
    CGColorSpaceRelease(colorSpaceInfo);
    
    CGContextTranslateCTM (bitmap, (rotation > 0 ? img.size.height : 0), (rotation > 0 ? 0 : img.size.width));
    CGContextRotateCTM (bitmap, rotation * M_PI / 2.0f);
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, img.size.width, img.size.height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    CGContextRelease(bitmap);
    return result;
}

#pragma mark UIImagePicker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self.popOver dismissPopoverAnimated:YES];
    }
    
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
//    if ([info objectForKey:@"UIImagePickerControllerMediaMetadata"])
//    {
//        int state = [[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"Orientation"] intValue];
//        NSLog(@"State = %d", state);
//        switch (state)
//        {
//            case 3:
//                //Rotate image to the left twice.
//                img = [UIImage imageWithCGImage:[img CGImage]];  //Strip off that pesky meta data!
//                img = [self rotateImage:[self rotateImage:img withRotationType:1] withRotationType:1];
//                break;
//                
//            case 6:
//                img = [UIImage imageWithCGImage:[img CGImage]];
//                img = [self rotateImage:img withRotationType:-1];
//                break;
//                
//            case 8:
//                img = [UIImage imageWithCGImage:[img CGImage]];
//                img = [self rotateImage:img withRotationType:1];
//                break;
//                
//            default:
//                break;
//        }
//    }
 
    img = [ApplicationPreference imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
    
    AddDetailViewController *obj = [[AddDetailViewController alloc] initWithNibName:@"AddDetailViewController" bundle:nil WithImage:img];
//    obj.img = img;

    
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self.popOver dismissPopoverAnimated:YES];
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    if (error)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    }
	else // All is well
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    }
    
    [alert show];
}

- (void) animateTextField: (UISearchBar*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = self.view.frame.size.height - 49;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = 264 - self.view.frame.size.height + moveUpValue + 50;
        }
        else
        {
            animatedDistance = 352 - self.view.frame.size.height + moveUpValue + 50;
        }
    }
    else
    {
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = 216 - self.view.frame.size.height + moveUpValue + 50;
        }
        else
        {
            animatedDistance = 162 - self.view.frame.size.height + moveUpValue + 50;
        }
    }
    
    if(animatedDistance > 0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f; 
        int movement = (up ? -movementDistance : movementDistance);
        
        
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        
        subCatTable.frame = CGRectMake(0, up ? movementDistance : 0, subCatTable.frame.size.width, subCatTable.frame.size.height + movement);
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);       
        
        [UIView commitAnimations];
    }
}

@end
