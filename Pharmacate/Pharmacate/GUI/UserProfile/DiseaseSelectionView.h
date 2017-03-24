//
//  DiseaseSelectionView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiseaseSelectionViewDelegate <NSObject>

-(void)changeInSelectedDiseaseArray:(NSArray*)array;

@end


@interface DiseaseSelectionView : UIView

@property(nonatomic) id<DiseaseSelectionViewDelegate> delegate;
@property(nonatomic) NSMutableArray *selectedDiseaseArray;

@end
