//
//  SetDifficultyVC.h
//  PhotoPuzzle
//
//  Created by Granjur on 02/04/2013.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetDifficultyVC : UIViewController

@property (nonatomic, retain) IBOutlet UIButton * easyButton;
@property (nonatomic, retain) IBOutlet UIButton * normalButton;
@property (nonatomic, retain) IBOutlet UIButton * hardButton;
@property (nonatomic, retain) UIImage * selectedImage;
@property (nonatomic, retain) NSString * Email;
@property (retain, nonatomic) IBOutlet UIImageView *imageTaken;

@property (nonatomic, assign) BOOL isEasy;
@property (nonatomic, assign) BOOL isMedium;
@property (nonatomic, assign) BOOL isHard;

@property (nonatomic, assign) int integer;

- (IBAction)easyBtnAction:(id)sender;
- (IBAction)normalBtnAction:(id)sender;
- (IBAction)hardBtnAction:(id)sender;

- (void)updateView;
-(void)setint:(int)integer1;
@end
