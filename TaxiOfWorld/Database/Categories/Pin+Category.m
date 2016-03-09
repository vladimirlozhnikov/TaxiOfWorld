//
//  Pin+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Pin+Category.h"
#import "NSManagedObject+Category.h"
#import "NSMutableDictionary+Category.h"

@implementation Pin (Category)

- (NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* d = [super toDictionary];
    
    return d;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSMutableDictionary* d = (NSMutableDictionary*)dict;
    
    // rename keys
    [d replaceKey:@"user_id" withKey:@"userId"];
    
    [super populateFromDictionary:d];
}

+ (Pin*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    [d setObject:@"Pin" forKey:@"class"];
    Pin* pin = (Pin*)[NSManagedObject createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
    
    return pin;
}

@end
