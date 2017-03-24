//
//  ProductDetailViewController.h
//  Pharmacate
//
//  Created by Dipayan Banik on 6/21/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController

@property(nonatomic) BOOL isTempValue;
@property(nonatomic) NSString *productId;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isTempValue:(BOOL)tempValue numRows:(int)rows;

@end
