//
//  City+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "City+Category.h"
#import "NSManagedObject+Category.h"
#import "NSMutableDictionary+Category.h"

@implementation City (Category)

- (NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* d = [super toDictionary];
    
    return d;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    // rename keys
    [d replaceKey:@"city_id" withKey:@"index"];
    
    [super populateFromDictionary:d];
}

+ (City*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    [d setObject:@"City" forKey:@"class"];
    
    City* city = (City*)[NSManagedObject createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
    
    return city;
}

@end
