//
//  City+Category.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "City.h"

@interface City (Category)

- (NSMutableDictionary*) toDictionary;
- (void) populateFromDictionary:(NSDictionary*)dict;
+ (City*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context;

@end
