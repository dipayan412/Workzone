//
//  RA_NewsDetailViewController.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_NewsDetailViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *containerWebView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUrlString:(NSString*)_url;

@end
