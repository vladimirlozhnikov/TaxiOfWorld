//
//  Group+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Group+Category.h"
#import "NSManagedObject+Category.h"
#import "NSMutableDictionary+Category.h"
#import "City+Category.h"
#import "Country+Category.h"
#import <objc/runtime.h>

@implementation Group (Category)

- (NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* d = [super toDictionary];
    
    return d;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSMutableDictionary* d = (NSMutableDictionary*)dict;
    
    NSDictionary* c1 = [dict objectForKey:@"city"];
    if ([c1 count] > 0)
    {
        City* city = [City createManagedObjectFromDictionary:c1 inContext:DELEGATE.managedObjectContext];
        self.city = city;
    }
    [d removeObjectForKey:@"city"];
    
    NSDictionary* c2 = [d objectForKey:@"country"];
    if ([c2 count] > 0)
    {
        Country* county = [Country createManagedObjectFromDictionary:c2 inContext:DELEGATE.managedObjectContext];
        self.country = county;
    }
    [d removeObjectForKey:@"country"];
    
    // rename keys
    [d replaceKey:@"groupid" withKey:@"index"];
    [d replaceKey:@"description" withKey:@"desc"];
    [d replaceKey:@"is_open" withKey:@"isOpen"];
    
    [d removeObjectForKey:@"color"];
    [d removeObjectForKey:@"flag"];
    [d removeObjectForKey:@"user_surname"];
    [d removeObjectForKey:@"owner"];
    [d removeObjectForKey:@"user_email"];
    [d removeObjectForKey:@"user_nickname"];
    [d removeObjectForKey:@"user_name"];
    
    [super populateFromDictionary:d];
}

+ (Group*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    [d setObject:@"Group" forKey:@"class"];

    Group* group = (Group*)[NSManagedObject createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
    
    return group;
}

#pragma mark - Properties

- (BOOL) selected
{
    NSNumber* numberSelected = (NSNumber*)objc_getAssociatedObject(self, @"selected");
    return [numberSelected boolValue];
}

- (void) setSelected:(BOOL)selected
{
    NSNumber* numberSelected = [NSNumber numberWithBool:selected];
    objc_setAssociatedObject(self, @"selected", numberSelected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*) displayName
{
    return self.name;
}

@end
