//
//  Disease+CoreDataProperties.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Disease.h"

NS_ASSUME_NONNULL_BEGIN

@interface Disease (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *diseaseId;
@property (nullable, nonatomic, retain) NSString *diseaseName;

@end

NS_ASSUME_NONNULL_END
