//
//  UserIdentificationViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserIdentificationViewController : UITableViewController<UITextFieldDelegate>
{
	UITableViewCell *userIdentificationCell;
	
	NSMutableDictionary *settingsDictionary;
	
	UITextField *userName;
	UITextField *companyName;
    
    IBOutlet UITextField *emailField;
    IBOutlet UITextView *descriptionView;
}

@property(nonatomic, retain) NSString *email;

@property (nonatomic, retain) IBOutlet UITableViewCell *userIdentificationCell;

@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;

@property (nonatomic, retain) IBOutlet UITextField *userName;
@property (nonatomic, retain) IBOutlet UITextField *companyName;

@end
