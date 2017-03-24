//
//  VisitDetailViewController.m
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "VisitDetailViewController.h"
#import "GLLVisit.h"

@interface VisitDetailViewController ()

@property (nonatomic, retain) GLLVisit *visit;

@end

@implementation VisitDetailViewController

@synthesize visit;
@synthesize popOver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil GLLVisit:(GLLVisit*)_visit
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.visit = _visit;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Detail";
    self.view.backgroundColor = detailsView.backgroundColor = [UIColor colorWithRed:247.0f / 255.0f green:247.0f /255.0f blue:247.0f / 255.0f alpha:1.0f];
    
    dateView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SectionHeaderBG.png"]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"dd/MM/yyyy";
    dateLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
    
    countryLabel.text = self.visit.country;
    cityLabel.text = self.visit.city;
    
    attachFileButton.layer.cornerRadius= editButton.layer.cornerRadius = deleteButton.layer.cornerRadius = 5.0f;
    
    if(self.visit.hasPhoto.boolValue)
    {
        photoImageView.image = [UIImage imageWithData:self.visit.photoData];
        [attachmentImageView setHidden:NO];
        [fileNameLabel setHidden:NO];
    }
    else
    {
        [attachmentImageView setHidden:YES];
        [fileNameLabel setHidden:YES];
    }
    
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        CGRect frame = photoImageView.frame;
        frame.size.height -= 30;
        photoImageView.frame = frame;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)attachFileButtonAction:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [imagePicker setDelegate:self];
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

-(IBAction)editButtonAction:(id)sender
{
    
}

-(IBAction)deleteButtonAction:(id)sender
{
    
}

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
    //    obj.img = img;
    
    photoImageView.image = img;
    
    self.visit.photoData = UIImagePNGRepresentation(img);
    self.visit.hasPhoto = [NSNumber numberWithBool:YES];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSError *error = nil;
    
    [attachmentImageView setHidden:NO];
    [fileNameLabel setHidden:NO];
    
    [context save:&error];
}

@end
