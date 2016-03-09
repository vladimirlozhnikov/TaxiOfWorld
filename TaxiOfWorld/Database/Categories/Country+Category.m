//
//  Country+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Country+Category.h"
#import "NSManagedObject+Category.h"
#import "NSMutableDictionary+Category.h"

@implementation Country (Category)

- (NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* d = [super toDictionary];
    
    return d;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    // rename keys
    [d replaceKey:@"country_id" withKey:@"index"];
    
    [super populateFromDictionary:d];
}

+ (Country*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    [d setObject:@"Country" forKey:@"class"];
    
    Country* country = (Country*)[NSManagedObject createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
    
    return country;
}

@end
