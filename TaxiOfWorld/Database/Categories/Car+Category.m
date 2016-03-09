//
//  Car+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Car+Category.h"
#import "NSManagedObject+Category.h"
#import "NSMutableDictionary+Category.h"
#import "Attachment+Category.h"

@implementation Car (Category)

- (NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* d = [super toDictionary];
    
    return d;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSMutableDictionary* d = (NSMutableDictionary*)dict;
    
    // rename keys
    [d replaceKey:@"license_plate" withKey:@"licensePlate"];
    [d replaceKey:@"you_can_smoke" withKey:@"youCanSmoke"];
    
    NSArray* photos = [d objectForKey:@"photos"];
    for (NSDictionary* d in photos)
    {
        Attachment* attachment = [Attachment createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
        [self addPhotosObject:attachment];
    }
    [d removeObjectForKey:@"photos"];
    
    [super populateFromDictionary:d];
}

+ (Car*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    [d setObject:@"Car" forKey:@"class"];
    Car* car = (Car*)[NSManagedObject createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
    
    return car;
}

@end
