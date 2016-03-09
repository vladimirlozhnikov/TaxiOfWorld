//
//  Pin+Category.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Pin.h"

@interface Pin (Category)

- (NSMutableDictionary*) toDictionary;
- (void) populateFromDictionary:(NSDictionary*)dict;
+ (Pin*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context;

@end
