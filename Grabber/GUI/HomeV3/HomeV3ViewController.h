//
//  HomeV3ViewController.h
//  Grabber
//
//  Created by World on 4/2/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HomeV3ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    IBOutlet UIView *shareView;
    IBOutlet UIView *takePicButtonBGView;
    IBOutlet UIImageView *productImageView;
    IBOutlet UITextView *descriptionTextView;
    IBOutlet UILabel *numberOfCharecterLabel;
    
    IBOutlet UIView *mapContainerView;
    IBOutlet UIView *gridView;
    IBOutlet UIView *segmentView;
    IBOutlet UIView *markerSelectionView;
    IBOutlet UIView *markerImageBGView;
    IBOutlet UIView *selectionView;
    IBOutlet UIView *takePhotoView;
    IBOutlet UIView *sharePhotoBGView;
    
    IBOutlet UIButton *mapViewButton;
    IBOutlet UIButton *gridViewButton;
    IBOutlet UIButton *captureButton;
    IBOutlet UIButton *closeShareButton;
    
    IBOutlet UISegmentedControl *filterSegmentedControlForMap;
    IBOutlet UISegmentedControl *filterSegmentedControlForGrid;
    
    IBOutlet UILabel *promoDetailsLabel;
    IBOutlet UILabel *grabLocationLabel;
    IBOutlet UILabel *grabCreatedTime;
    IBOutlet UIImageView *promoImageView;
    
    IBOutlet MKMapView *myMapView;
    IBOutlet UICollectionView *gridCollectionView;
}

@property (nonatomic, retain) NSString *userNameStr;
@property (nonatomic, retain) UIImage *proPic;

-(IBAction)captureButtonAction:(UIButton*)sender;
-(IBAction)bgTap:(id)sender;


-(IBAction)filterSegmentedControlAction:(UISegmentedControl*)sender;

-(IBAction)mapViewButtonAction:(id)sender;
-(IBAction)gridViewButtonAction:(id)sender;
-(IBAction)dowArrowButtonAction:(id)sender;
-(IBAction)disclosureButtonAction:(id)sender;
-(IBAction)viewButtonAction:(id)sender;
-(IBAction)sharingButtonAction:(id)sender;

-(IBAction)closeSharePageButtonAction:(id)sender;
-(IBAction)shareFromMarkerSelectionView:(id)sender;

@end
