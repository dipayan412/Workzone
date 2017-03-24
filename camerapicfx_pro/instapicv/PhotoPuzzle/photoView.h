//
//  photoView.h
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 6/9/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AdWhirlView.h"
#import "ALTabBarView.h"
#import "TutorialPopupVC.h"
#import "CamerActionSheetVC.h"
//#import "Chartboost.h"
@interface photoView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate,UITabBarDelegate/*,AdWhirlDelegate,ALTabBarDelegate */,TutorialPopupDelegate,CameraActionSheetDelegate/*,ChartboostDelegate*/>

{
    int ImagePickerControllerSourceType;
    NSMutableArray *dataArray1;
    BOOL imgPickerSelected;
    int totalImages;
    NSString *Email;
    UIImagePickerController *imagePicker;
    UIImageView *networkImage;
//    ALTabBarView * customizedTabBar;
    TutorialPopupVC * tutorialPopup;
    CamerActionSheetVC * cameraSheet;
}
- (IBAction)moreButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *moreButtonPressed;
@property (retain, nonatomic)NSString *Email;
@property (retain, nonatomic) IBOutlet UITableView *allPhotoTable;
@property (retain, nonatomic)IBOutlet UITabBar *tabBar;

/////////////// New Sher
@property (nonatomic, retain) ALTabBarView * customizedTabBar;
@property (nonatomic, retain) TutorialPopupVC * tutorialPopup;
@property (nonatomic, retain) IBOutlet UIImageView * bgImage;
@property (nonatomic, retain) IBOutlet UIImageView * arrowImage;
@property (nonatomic, retain) CamerActionSheetVC * cameraSheet;
- (void)pickPhotoFromCamera:(id)sender;
- (void)pickPhotoFromPhotoLibrary:(id)sender;
@end
