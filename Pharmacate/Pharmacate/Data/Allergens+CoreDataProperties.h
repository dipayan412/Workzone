//
//  Allergens+CoreDataProperties.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/12/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Allergens.h"

NS_ASSUME_NONNULL_BEGIN

@interface Allergens (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *allergenId;
@property (nullable, nonatomic, retain) NSString *allergenName;

@end

NS_ASSUME_NONNULL_END
