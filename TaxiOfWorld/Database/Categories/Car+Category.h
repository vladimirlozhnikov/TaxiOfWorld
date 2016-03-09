//
//  Car+Category.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Car.h"

@interface Car (Category)

- (NSMutableDictionary*) toDictionary;
- (void) populateFromDictionary:(NSDictionary*)dict;
+ (Car*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context;

@end
