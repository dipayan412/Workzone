//
//  RA_GalleryViewController.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RA_GalleryObject.h"
#import "RA_ImageCache.h"

@interface RA_GalleryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    IBOutlet UITableView *containerTableView;
}

@end
