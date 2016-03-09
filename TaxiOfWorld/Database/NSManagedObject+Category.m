//
//  NSManagedObject+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "NSManagedObject+Category.h"
#import "PPDbManager.h"

@implementation NSManagedObject (Category)

- (NSMutableDictionary*) toDictionary
{
    NSArray* attributes = [[[self entity] attributesByName] allKeys];
    NSArray* relationships = [[[self entity] relationshipsByName] allKeys];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity: [attributes count] + [relationships count] + 1];
    
    [dict setObject:[[self class] description] forKey:@"class"];
    
    for (NSString* attr in attributes)
    {
        NSObject* value = [self valueForKey:attr];
        
        if (value != nil)
        {
            [dict setObject:value forKey:attr];
        }
    }
    
    for (NSString* relationship in relationships)
    {
        NSObject* value = [self valueForKey:relationship];
        
        if ([value isKindOfClass:[NSSet class]])
        {
            // To-many relationship
            
            // The core data set holds a collection of managed objects
            NSSet* relatedObjects = (NSSet*) value;
            
            // Our set holds a collection of dictionaries
            NSMutableSet* dictSet = [NSMutableSet setWithCapacity:[relatedObjects count]];
            
            for (NSManagedObject* relatedObject in relatedObjects)
            {
                [dictSet addObject:[relatedObject toDictionary]];
            }
            
            [dict setObject:dictSet forKey:relationship];
        }
        else if ([value isKindOfClass:[NSManagedObject class]])
        {
            // To-one relationship
            
            NSManagedObject* relatedObject = (NSManagedObject*) value;
            
            [dict setObject:[relatedObject toDictionary] forKey:relationship];
        }
    }
    
    return dict;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSManagedObjectContext* context = [self managedObjectContext];
    
    for (NSString* key in dict)
    {
        if ([key isEqualToString:@"class"])
        {
            continue;
        }
        
        NSObject* value = [dict objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]])
        {
            // This is a to-one relationship
            NSManagedObject* relatedObject = [NSManagedObject createManagedObjectFromDictionary:(NSDictionary*)value inContext:context];
            
            [self setValue:relatedObject forKey:key];
        }
        else if ([value isKindOfClass:[NSSet class]])
        {
            // This is a to-many relationship
            NSSet* relatedObjectDictionaries = (NSSet*) value;
            
            // Get a proxy set that represents the relationship, and add related objects to it.
            // (Note: this is provided by Core Data)
            NSMutableSet* relatedObjects = [self mutableSetValueForKey:key];
            
            for (NSDictionary* relatedObjectDict in relatedObjectDictionaries)
            {
                NSManagedObject* relatedObject = [NSManagedObject createManagedObjectFromDictionary:relatedObjectDict inContext:context];
                [relatedObjects addObject:relatedObject];
            }
        }
        else if (value != nil)
        {
            // This is an attribute
            if ([value isEqual:[NSNull null]])
            {
                [self setValue:@"" forKey:key];
            }
            else
            {
                [self setValue:value forKey:key];
            }
        }
    }
}

+ (NSManagedObject*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSString* class = [dict objectForKey:@"class"];
    NSString* index = [dict objectForKey:@"id"];
    
    if (![index length])
    {
        index = [dict objectForKey:@"groupid"];
    }
    if (![index length])
    {
        index = [dict objectForKey:@"userid"];
    }
    if (![index length])
    {
        index = [dict objectForKey:@"city_id"];
    }
    if (![index length])
    {
        index = [dict objectForKey:@"country_id"];
    }
    if (![index length])
    {
        index = [dict objectForKey:@"index"];
    }
    
    NSManagedObject* newObject = nil;
    if ([index length] > 0)
    {
        newObject = [PPDbManager itemForEntitiNameAndCriteria:class withCriteria:[NSString stringWithFormat:@"index LIKE '%@'", index]];
    }
    
    if (!newObject)
    {
        newObject = (NSManagedObject*)[NSEntityDescription insertNewObjectForEntityForName:class inManagedObjectContext:context];
    }
    
    if ([class isEqualToString:@"User"])
    {
        User* user = (User*)newObject;
        [user removeMessages:user.messages];
        [user removeRatings:user.ratings];
    }
    
    [newObject populateFromDictionary:dict];
    
    return newObject;
}

@end
