//
//  SelectedPictureViewController.h
//  Grabber
//
//  Created by World on 4/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPictureViewController : UIViewController
{
    IBOutlet UIImageView *selectedPictureImageView;
}
@property (nonatomic, retain) UIImage *selectedPicture;



@end
