//
//  Tariff+Category.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Tariff.h"

@interface Tariff (Category)

- (NSMutableDictionary*) toDictionary;
- (void) populateFromDictionary:(NSDictionary*)dict;
+ (Tariff*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context;

@end
