//
//  MRClipsViewController.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface MRClipsViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *carousel;

-(IBAction)goToPreview:(id)sender;

@end
