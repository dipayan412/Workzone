//
//  UserProfileViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "UserProfileViewController.h"
#import "PanelView.h"
#import "UserCredentialView.h"
#import "ProductSelectionView.h"
#import "DiseaseSelectionView.h"
#import "AllergySelectionView.h"
//#import "AllergyProductSelectionView.h"
#import "Allergens.h"
#import "Product.h"

@interface UserProfileViewController () <PanelViewDelegate, ProductSelectionViewDelegate, DiseaseSelectionViewDelegate, AllergySelectionViewDelegate>
{
    PanelView *panelView;
    float panelViewWidth;
    float panelViewHeight;
    
    BOOL isDataChanged;
    
    UserCredentialView *credentialView;
    ProductSelectionView *productSelectionView;
    DiseaseSelectionView *diseaseSelectionView;
    AllergySelectionView *allergySelectionView;
//    AllergyProductSelectionView *allergyProductSelectionView;
}

@end

@implementation UserProfileViewController

@synthesize selectedProductsArray;
@synthesize selectedDiseasesArray;
@synthesize selectedAllergenArray;
@synthesize selectedAllergicProductArray;
@synthesize selectedProfileSection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    panelViewWidth = 85.0f;
    isDataChanged = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    panelView = [[PanelView alloc] initWithFrame:CGRectMake(0, 0, panelViewWidth, panelViewWidth*4)];
    panelView.delegate = self;
    [self.view addSubview:panelView];
    
    CGRect currentViewFrame = CGRectMake(panelViewWidth, 0, [UIScreen mainScreen].bounds.size.width - panelViewWidth, [UIScreen mainScreen].bounds.size.height);
    
//    allergyProductSelectionView = [[AllergyProductSelectionView alloc] initWithFrame:currentViewFrame];
//    allergyProductSelectionView.delegate = self;
//    allergyProductSelectionView.selectedAllergyProductArray = [[NSMutableArray alloc] initWithArray:self.selectedAllergicProductArray];
//    [self.view addSubview:allergyProductSelectionView];
    
    allergySelectionView = [[AllergySelectionView alloc] initWithFrame:currentViewFrame];
    allergySelectionView.delegate = self;
    allergySelectionView.selectedAllergyArray = [[NSMutableArray alloc] initWithArray:self.selectedAllergenArray];
    [allergySelectionView.selectedAllergyArray addObjectsFromArray:self.selectedAllergicProductArray];
    [self.view addSubview:allergySelectionView];
    
    diseaseSelectionView = [[DiseaseSelectionView alloc] initWithFrame:currentViewFrame];
    diseaseSelectionView.delegate = self;
    diseaseSelectionView.selectedDiseaseArray = [[NSMutableArray alloc] initWithArray:self.selectedDiseasesArray];
    [self.view addSubview:diseaseSelectionView];
    
    productSelectionView = [[ProductSelectionView alloc] initWithFrame:currentViewFrame];
    productSelectionView.delegate = self;
    productSelectionView.selectedProductArray = [[NSMutableArray alloc] initWithArray:self.selectedProductsArray];
    [self.view addSubview:productSelectionView];
    
    credentialView = [[UserCredentialView alloc] initWithFrame:currentViewFrame];
    [self.view addSubview:credentialView];
    
    UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signOutButton setTitle:NSLocalizedString(kProfilePanelSignOut, nil) forState:UIControlStateNormal];
    [signOutButton setTitleColor:[UIColor colorWithRed:227.0f/255 green:69.0f/255 blue:84.0f/255 alpha:1.0f] forState:UIControlStateNormal];
    [signOutButton addTarget:self action:@selector(signOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    signOutButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - (panelViewWidth - 20), 90, panelViewWidth - 20);
    signOutButton.backgroundColor = [UIColor clearColor];
    
    if([self.selectedProfileSection isEqualToString:@"INFO"])
    {
        [panelView userInfoButtonAction:panelView.userInfoButtonAction];
    }
    else if([self.selectedProfileSection isEqualToString:@"CONDITION"])
    {
        [panelView diseaseButtonAction:panelView.diseaseButtonAction];
    }
    else if([self.selectedProfileSection isEqualToString:@"ALLERGY"])
    {
        [panelView allergyButtonAction:panelView.allergyButtonAction];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark PaneViewDelegate

-(void)backButtonAction
{
    if(isDataChanged)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:NSLocalizedString(kProfileSaveChangeAlertMessage, nil)
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(kProfileSaveChangeAlertOK, nil) style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [ServerCommunicationUser updateUserProductsWithProductArray:selectedProductsArray DiseaseArray:selectedDiseasesArray AllergenArray:selectedAllergenArray AllergicProductArray:selectedAllergicProductArray];
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(kProfileSaveChangeAlertDismiss, nil) style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)userInfoButtonAction
{
    [self.view bringSubviewToFront:credentialView];
}

-(void)productButtonAction
{
    [self.view bringSubviewToFront:productSelectionView];
}

-(void)diseaseButtonAction
{
    [self.view bringSubviewToFront:diseaseSelectionView];
}

-(void)allergyButtonAction
{
    [self.view bringSubviewToFront:allergySelectionView];
}

-(void)allergyProductButtonAction
{
//    [self.view bringSubviewToFront:allergyProductSelectionView];
}

#pragma mark ProductSelectionView Delegate Methods

-(void)changeInSelectedProductArray:(NSArray *)array
{
    selectedProductsArray = nil;
    selectedProductsArray = [[NSArray alloc] initWithArray:array];
    isDataChanged = YES;
}

#pragma mark DiseaseSelectionView Delegate Methods

-(void)changeInSelectedDiseaseArray:(NSArray *)array
{
    selectedDiseasesArray = nil;
    selectedDiseasesArray = [[NSArray alloc] initWithArray:array];
    isDataChanged = YES;
}

#pragma mark AllergySelectionView Delegate Methods

-(void)changeInSelectedAllergyArray:(NSArray *)allergenArray ProductArray:(NSArray *)productArray
{
    isDataChanged = YES;
    
    selectedAllergenArray = nil;
    selectedAllergenArray = [[NSArray alloc] initWithArray:allergenArray];
    
    selectedAllergicProductArray = nil;
    selectedAllergicProductArray = [[NSArray alloc] initWithArray:productArray];
}

#pragma mark AllergyProductSelectionView Delegate Methods

-(void)changeInSelectedAllergyProductArray:(NSArray *)array
{
    selectedAllergicProductArray = nil;
    selectedAllergicProductArray = [[NSArray alloc] initWithArray:array];
    isDataChanged = YES;
}

-(void)signOutButtonAction
{
    if([FBSDKAccessToken currentAccessToken])
    {
        
    }
    [UserDefaultsManager setUserToken:@""];
    [UserDefaultsManager setUserName:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
