//
//  Rating+Category.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Rating.h"

@interface Rating (Category)

- (NSMutableDictionary*) toDictionary;
- (void) populateFromDictionary:(NSDictionary*)dict;
+ (Rating*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context;

@end
