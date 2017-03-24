//
//  FilterViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/17/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "FilterViewController.h"

#define kOtc            @"OTC"
#define kSupplement     @"Supplement"
#define kPrescription   @"Prescription"
#define kHomeopathic    @"Homeopathic"
#define kMedicine       @"proprietary_name"
#define kIngredient     @"ingredient_synonyms"
#define kDisease        @"disease_synonyms"
#define kSymptom        @"symptom_synonyms"

@interface FilterViewController ()
{
    NSMutableArray *filteredArray;
    UILabel *scoreLabel;
}
@end

@implementation FilterViewController

@synthesize resultArray;
@synthesize otcString;
@synthesize supplementString;
@synthesize prescriptionString;
@synthesize homeopathicString;
@synthesize medicineNameString;
@synthesize ingredientString;
@synthesize diseaseString;
@synthesize symptomString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    filteredArray = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 60);
    [backButton setTitle:NSLocalizedString(kFilterCancel, nil) forState:UIControlStateNormal];
    [backButton setTitleColor:themeColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 80, 60);
    [postButton setTitleColor:themeColor forState:UIControlStateNormal];
    [postButton setTitle:NSLocalizedString(kFilterSearch, nil) forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:postButton];
    [self.view addSubview:customNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backButton.frame.size.width, 10, [UIScreen mainScreen].bounds.size.width - postButton.frame.size.width * 2, customNavigationBar.frame.size.height/2)];
    titleLabel.text = NSLocalizedString(kFilterTitle, nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, customNavigationBar.frame.size.height/2, titleLabel.frame.size.width, customNavigationBar.frame.size.height/2)];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.font = [UIFont systemFontOfSize:12.0f];
    scoreLabel.textColor = [UIColor lightGrayColor];
    scoreLabel.text = [NSString stringWithFormat:@"%@ %d", NSLocalizedString(kFilterScore, nil), [self filterResult]];
    [self.view addSubview:scoreLabel];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [customNavigationBar addSubview:separatorLine];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, separatorLine.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 30)];
    typeLabel.textColor = [UIColor lightGrayColor];
    typeLabel.text = NSLocalizedString(kFilterType, nil);
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:typeLabel];
    
    UILabel *otc = [[UILabel alloc] initWithFrame:CGRectMake(5, typeLabel.frame.origin.y + typeLabel.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width/2, 40)];
    otc.text = NSLocalizedString(kFilterOTC, nil);
    [self.view addSubview:otc];
    
    UISwitch *otcSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 61, otc.frame.origin.y, 51, 31)];
    otcSwitch.tag = 1;
    if([otcString isEqualToString:kOtc])
    {
        [otcSwitch setOn:YES animated:NO];
    }
    
    [otcSwitch addTarget:self action:@selector(switchValueChangedWithSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:otcSwitch];
    
    UILabel *supplement = [[UILabel alloc] initWithFrame:CGRectMake(5, otcSwitch.frame.origin.y + otcSwitch.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width/2, 40)];
    supplement.text = NSLocalizedString(kFilterSupplement, nil);
    [self.view addSubview:supplement];
    
    UISwitch *supplementSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 61, supplement.frame.origin.y, 51, 31)];
    supplementSwitch.tag = 2;
    if([supplementString isEqualToString:kSupplement])
    {
        [supplementSwitch setOn:YES animated:NO];
    }
    
    [supplementSwitch addTarget:self action:@selector(switchValueChangedWithSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:supplementSwitch];
    
    UILabel *prescription = [[UILabel alloc] initWithFrame:CGRectMake(5, supplementSwitch.frame.origin.y + supplementSwitch.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width/2, 40)];
    prescription.text = NSLocalizedString(kFilterPrescription, nil);
    [self.view addSubview:prescription];
    
    UISwitch *prescriptionSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 61, prescription.frame.origin.y, 51, 31)];
    prescriptionSwitch.tag = 3;
    if([prescriptionString isEqualToString:kPrescription])
    {
        [prescriptionSwitch setOn:YES animated:NO];
    }
    
    [prescriptionSwitch addTarget:self action:@selector(switchValueChangedWithSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:prescriptionSwitch];
    
    UILabel *homeopathic = [[UILabel alloc] initWithFrame:CGRectMake(5, prescriptionSwitch.frame.origin.y + prescriptionSwitch.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width/2, 40)];
    homeopathic.text = NSLocalizedString(kFilterHomeopathic, nil);
    [self.view addSubview:homeopathic];
    
    UISwitch *homeopathicSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 61, homeopathic.frame.origin.y, 51, 31)];
    homeopathicSwitch.tag = 4;
    if([homeopathicString isEqualToString:kHomeopathic])
    {
        [homeopathicSwitch setOn:YES animated:NO];
    }
    
    [homeopathicSwitch addTarget:self action:@selector(switchValueChangedWithSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:homeopathicSwitch];
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, homeopathicSwitch.frame.origin.y + homeopathicSwitch.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width, 30)];
    categoryLabel.textColor = [UIColor lightGrayColor];
    categoryLabel.text = NSLocalizedString(kFilterCategory, nil);
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:categoryLabel];
    
    UILabel *medicineName = [[UILabel alloc] initWithFrame:CGRectMake(5, categoryLabel.frame.origin.y + categoryLabel.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width/2, 40)];
    medicineName.text = NSLocalizedString(kFilterMedicineName, nil);
    [self.view addSubview:medicineName];
    
    UISwitch *medicineNameSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 61, medicineName.frame.origin.y, 51, 31)];
    medicineNameSwitch.tag = 5;
    if([medicineNameString isEqualToString:kMedicine])
    {
        [medicineNameSwitch setOn:YES animated:NO];
    }
    
    [medicineNameSwitch addTarget:self action:@selector(switchValueChangedWithSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:medicineNameSwitch];
    
    UILabel *ingredientName = [[UILabel alloc] initWithFrame:CGRectMake(5, medicineNameSwitch.frame.origin.y + medicineNameSwitch.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width/2, 40)];
    ingredientName.text = NSLocalizedString(kFilterIngredient, nil);
    [self.view addSubview:ingredientName];
    
    UISwitch *ingredientNameSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 61, ingredientName.frame.origin.y, 51, 31)];
    ingredientNameSwitch.tag = 6;
    if([ingredientString isEqualToString:kIngredient])
    {
        [ingredientNameSwitch setOn:YES animated:NO];
    }
    
    [ingredientNameSwitch addTarget:self action:@selector(switchValueChangedWithSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:ingredientNameSwitch];
    
    UILabel *diseaseName = [[UILabel alloc] initWithFrame:CGRectMake(5, ingredientNameSwitch.frame.origin.y + ingredientNameSwitch.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width/2, 40)];
    diseaseName.text = NSLocalizedString(kFilterDiseaseName, nil);
    [self.view addSubview:diseaseName];
    
    UISwitch *diseaseNameSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 61, diseaseName.frame.origin.y, 51, 31)];
    diseaseNameSwitch.tag = 7;
    if([diseaseString isEqualToString:kDisease])
    {
        [diseaseNameSwitch setOn:YES animated:NO];
    }
    
    [diseaseNameSwitch addTarget:self action:@selector(switchValueChangedWithSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:diseaseNameSwitch];
    
    UILabel *symptomName = [[UILabel alloc] initWithFrame:CGRectMake(5, diseaseNameSwitch.frame.origin.y + diseaseNameSwitch.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width/2, 40)];
    symptomName.text = NSLocalizedString(kFilterSymptom, nil);
    [self.view addSubview:symptomName];
    
    UISwitch *symptomNameSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 61, symptomName.frame.origin.y, 51, 31)];
    symptomNameSwitch.tag = 8;
    if([symptomString isEqualToString:kSymptom])
    {
        [symptomNameSwitch setOn:YES animated:NO];
    }
    
    [symptomNameSwitch addTarget:self action:@selector(switchValueChangedWithSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:symptomNameSwitch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)backButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)postButtonAction
{
    [self filterResult];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"filteredArrayPosted" object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:filteredArray, @"Filtered", otcString, kOtc, supplementString, kSupplement, prescriptionString, kPrescription, homeopathicString, kHomeopathic, medicineNameString, kMedicine, ingredientString, kIngredient, diseaseString, kDisease, symptomString, kSymptom, nil]];
    }];
}

-(void)switchValueChangedWithSwitch:(UISwitch*)_switch
{
    if(_switch.tag == 1)
    {
        if(_switch.isOn)
        {
            otcString = kOtc;
        }
        else
        {
            otcString = @"";
        }
    }
    else if(_switch.tag == 2)
    {
        if(_switch.isOn)
        {
            supplementString = kSupplement;
        }
        else
        {
            supplementString = @"";
        }
    }
    else if(_switch.tag == 3)
    {
        if(_switch.isOn)
        {
            prescriptionString = kPrescription;
        }
        else
        {
            prescriptionString = @"";
        }
    }
    else if(_switch.tag == 4)
    {
        if(_switch.isOn)
        {
            homeopathicString = kHomeopathic;
        }
        else
        {
            homeopathicString = @"";
        }
    }
    else if(_switch.tag == 5)
    {
        if(_switch.isOn)
        {
            medicineNameString = kMedicine;
        }
        else
        {
            medicineNameString = @"";
        }
    }
    else if(_switch.tag == 6)
    {
        if(_switch.isOn)
        {
            ingredientString = kIngredient;
        }
        else
        {
            ingredientString = @"";
        }
    }
    else if(_switch.tag == 7)
    {
        if(_switch.isOn)
        {
            diseaseString = kDisease;
        }
        else
        {
            diseaseString = @"";
        }
    }
    else if(_switch.tag == 8)
    {
        if(_switch.isOn)
        {
            symptomString = kSymptom;
        }
        else
        {
            symptomString = @"";
        }
    }
    
    scoreLabel.text = [NSString stringWithFormat:@"Total result %d", [self filterResult]];
}

-(int)filterResult
{
//    if(![otcString isEqualToString:@""])
//    {
    [filteredArray removeAllObjects];
    for(NSDictionary *dict in resultArray)
    {
        if([[dict objectForKey:@"PRODUCT_TYPE"] isEqualToString:otcString])
        {
            if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:medicineNameString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:ingredientString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:diseaseString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:symptomString])
            {
                [filteredArray addObject:dict];
            }
        }
        else if([[dict objectForKey:@"PRODUCT_TYPE"] isEqualToString:supplementString])
        {
            if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:medicineNameString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:ingredientString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:diseaseString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:symptomString])
            {
                [filteredArray addObject:dict];
            }
        }
        else if([[dict objectForKey:@"PRODUCT_TYPE"] isEqualToString:prescriptionString])
        {
            if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:medicineNameString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:ingredientString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:diseaseString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:symptomString])
            {
                [filteredArray addObject:dict];
            }
        }
        else if([[dict objectForKey:@"PRODUCT_TYPE"] isEqualToString:homeopathicString])
        {
            if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:medicineNameString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:ingredientString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:diseaseString])
            {
                [filteredArray addObject:dict];
            }
            else if([[dict objectForKey:@"ENTITY_TYPE"] isEqualToString:symptomString])
            {
                [filteredArray addObject:dict];
            }
        }
    }
    return (int)filteredArray.count;
}

@end
