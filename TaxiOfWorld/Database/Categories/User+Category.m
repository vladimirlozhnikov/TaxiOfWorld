//
//  User+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "User+Category.h"
#import "NSManagedObject+Category.h"
#import "NSMutableDictionary+Category.h"
#import "Rating+Category.h"
#import "Car+Category.h"
#import "Tariff+Category.h"

@implementation User (Category)

- (NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* d = nil;
    
    if ([self.messages count])
    {
        NSMutableArray* messages = [NSMutableArray array];
        for (Message* message in [self.messages allObjects])
        {
            [messages addObject:message];
            [self removeMessagesObject:message];
        }
        
        d = [super toDictionary];
        
        for (Message* message in messages)
        {
            [self addMessagesObject:message];
        }
    }
    else
    {
        self.messages = nil;
        d = [super toDictionary];
    }
    
    return d;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSMutableDictionary* d = (NSMutableDictionary*)dict;
    
    // rename keys
    [d replaceKey:@"userid" withKey:@"index"];
    [d replaceKey:@"username" withKey:@"name"];
    [d replaceKey:@"surname" withKey:@"surName"];
    [d replaceKey:@"nickname" withKey:@"nickName"];
    [d replaceKey:@"phonenumber" withKey:@"phoneNumber"];
    [d replaceKey:@"show_to_customer" withKey:@"showToCustomer"];
    [d replaceKey:@"show_to_collegues" withKey:@"showToCollugues"];
    [d replaceKey:@"description" withKey:@"desc"];
    [d replaceKey:@"number_of_service" withKey:@"numberOfService"];
    [d replaceKey:@"number_of_service" withKey:@"numberOfService"];
    
    // get avatar
    NSString* avatar = [d objectForKey:@"avatar"];
    if ([avatar length] > 0)
    {
        NSData* avatarData = [avatar dataUsingEncoding:NSUTF8StringEncoding];
        [d setObject:avatarData forKey:@"avatar"];
    }
    else
    {
        [d removeObjectForKey:@"avatar"];
    }
    
    NSArray* rates = [d objectForKey:@"rate_item"];
    for (NSDictionary* r in rates)
    {
        Rating* rating = [Rating createManagedObjectFromDictionary:r inContext:DELEGATE.managedObjectContext];
        [self addRatingsObject:rating];
    }
    [d removeObjectForKey:@"rate_item"];
    
    // create a car
    NSDictionary* c = [d objectForKey:@"car"];
    if (![c isEqual:[NSNull null]])
    {
        Car* car = [Car createManagedObjectFromDictionary:c inContext:DELEGATE.managedObjectContext];
        self.car = car;
    }
    [d removeObjectForKey:@"car"];
    
    // create a tariff
    NSDictionary* t = [d objectForKey:@"tariff"];
    if (![t isEqual:[NSNull null]])
    {
        if ([[[d objectForKey:@"type"] lowercaseString] isEqualToString:@"taxist"])
        {
            Tariff* tariff = [Tariff createManagedObjectFromDictionary:t inContext:DELEGATE.managedObjectContext];
            self.tariff = tariff;
        }
    }
    [d removeObjectForKey:@"tariff"];
    
    [d removeObjectForKey:@"messages"];
    
    [super populateFromDictionary:d];
}

+ (User*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    [d setObject:@"User" forKey:@"class"];
    User* user = (User*)[NSManagedObject createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
    
    return user;
}

@end
