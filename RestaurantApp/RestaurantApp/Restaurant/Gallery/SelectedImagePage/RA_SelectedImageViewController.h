//
//  RA_SelectedImageViewController.h
//  RestaurantApp
//
//  Created by World on 12/20/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_SelectedImageViewController : UIViewController
{
    IBOutlet UIImageView *containerImageView;
}

@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) NSArray *picturesArray;
@property (nonatomic, assign) int arrayIndex;

@end
