//
//  SearchLocationViewController.h
//  Grabber
//
//  Created by World on 3/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationObject.h"
@protocol SearchLocationDelegate <NSObject>

-(void)locationSelected:(LocationObject*)_locationObject;

@end

@interface SearchLocationViewController : UIViewController <ASIHTTPRequestDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    IBOutlet UISearchBar *locationSearchBar;
    IBOutlet UITableView *containerTableView;
    CLLocationManager *userLocationManeger;
}
@property (nonatomic, retain) id <SearchLocationDelegate> delegate;

@end
