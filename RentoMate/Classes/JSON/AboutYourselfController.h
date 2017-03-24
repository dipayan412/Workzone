//
//  AboutYourselfController.h
//  Whosin
//
//  Created by Kumar Aditya on 18/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutYourselfController : UIViewController {
    UILabel *label1;
	UILabel *label2;
	UIButton *picButton;
	UIButton *saveButton;
	UIButton *skipButton;
	UITextView *textView;
	NSString *guid;
}
@property (nonatomic,retain) IBOutlet UILabel *label1;
@property (nonatomic,retain) IBOutlet UILabel *label2;
@property (nonatomic,retain) IBOutlet UIButton *picButton;
@property (nonatomic,retain) IBOutlet UIButton *saveButton;
@property (nonatomic,retain) IBOutlet UIButton *skipButton;
@property (nonatomic,retain) IBOutlet UITextView *textView;

@property (nonatomic,retain) IBOutlet NSString *guid;


-(void)skipButtonClicked;
-(void)saveButtonClicked;
@end
