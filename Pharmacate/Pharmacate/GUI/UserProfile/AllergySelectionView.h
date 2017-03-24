//
//  AllergySelectionView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllergySelectionViewDelegate <NSObject>

-(void)changeInSelectedAllergyArray:(NSArray*)allergenArray ProductArray:(NSArray*)productArray;

@end

@interface AllergySelectionView : UIView

@property(nonatomic) id<AllergySelectionViewDelegate> delegate;
@property(nonatomic, strong) NSMutableArray *selectedAllergyArray;

@end
