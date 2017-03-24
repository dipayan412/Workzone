//
//  MRGalleryViewController.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "YoutubeLoginViewController.h"

@interface GalleryItem : NSObject

@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *templateName;
@property (nonatomic, retain) NSString *templateFolderName;
@property (nonatomic, retain) NSString *dateTime;
@property (nonatomic, retain) NSDate *itemDate;
@property (nonatomic, retain) NSString *modifiedDateString;
@property (nonatomic, retain) NSString *takeNo;
@property (nonatomic, assign) int thumbnailFrame;

@end

@interface MRGalleryViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, YoutubeShareDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *goToPlayerButton;
    
@property (nonatomic) NSString *fromController;

-(IBAction)shareVideo:(id)sender;
-(IBAction)backButtonAction:(id)sender;

@end
