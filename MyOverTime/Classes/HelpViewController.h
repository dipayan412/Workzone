//
//  HelpViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpViewController : UITableViewController<UIWebViewDelegate>
{
	UITableViewCell *helpContentCell;
	
	UIWebView *helpContentView;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *helpContentCell;
@property (nonatomic, retain) IBOutlet UIWebView *helpContentView;

@end
