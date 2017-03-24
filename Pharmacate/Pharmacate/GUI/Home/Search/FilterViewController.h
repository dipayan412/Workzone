//
//  FilterViewController.h
//  Pharmacate
//
//  Created by Dipayan Banik on 8/17/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController

@property(nonatomic, strong) NSMutableArray *resultArray;

@property(nonatomic, strong) NSString *otcString;
@property(nonatomic, strong) NSString *supplementString;
@property(nonatomic, strong) NSString *prescriptionString;
@property(nonatomic, strong) NSString *homeopathicString;
@property(nonatomic, strong) NSString *medicineNameString;
@property(nonatomic, strong) NSString *ingredientString;
@property(nonatomic, strong) NSString *diseaseString;
@property(nonatomic, strong) NSString *symptomString;

@end
