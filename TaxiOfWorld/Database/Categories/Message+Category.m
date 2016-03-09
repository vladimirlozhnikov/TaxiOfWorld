//
//  Message+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Message+Category.h"
#import "NSManagedObject+Category.h"
#import "NSMutableDictionary+Category.h"

@implementation Message (Category)

- (NSMutableDictionary*) toDictionary
{
    User* from = self.from;
    self.from = nil;
    NSMutableDictionary* d = [super toDictionary];
    self.from = from;
    [d setObject:[from toDictionary] forKey:@"from"];
    //NSLog(@"%@", d);
    
    [d removeObjectForKey:@"class"];
    [d replaceKey:@"endPoint" withKey:@"end_point"];
    [d replaceKey:@"beginPoint" withKey:@"begin_point"];
    
    NSMutableDictionary* u = [d objectForKey:@"from"];
    [u removeObjectForKey:@"class"];
    [u removeObjectForKey:@"avatar"];
    [u removeObjectForKey:@"car"];
    [u removeObjectForKey:@"desc"];
    [u removeObjectForKey:@"email"];
    [u removeObjectForKey:@"license"];
    [u removeObjectForKey:@"messages"];
    [u removeObjectForKey:@"name"];
    [u removeObjectForKey:@"nickName"];
    [u removeObjectForKey:@"numberOfService"];
    [u removeObjectForKey:@"phone"];
    [u removeObjectForKey:@"phoneNumber"];
    [u removeObjectForKey:@"ratings"];
    [u removeObjectForKey:@"showToCollugues"];
    [u removeObjectForKey:@"showToCustomer"];
    [u removeObjectForKey:@"status"];
    [u removeObjectForKey:@"surName"];
    [u removeObjectForKey:@"tariff"];
    [u removeObjectForKey:@"type"];
    
    [u replaceKey:@"index" withKey:@"id"];
    
    //NSLog(@"%@", d);
    
    return d;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSMutableDictionary* d = (NSMutableDictionary*)dict;
    
    // rename keys
    [d replaceKey:@"begin_point" withKey:@"beginPoint"];
    [d replaceKey:@"end_point" withKey:@"endPoint"];
    [d replaceKey:@"id" withKey:@"index"];
    [d removeObjectForKey:@"attachment"];
    
    NSMutableDictionary* u = [NSMutableDictionary dictionaryWithDictionary:[d objectForKey:@"from"]];
    [u removeObjectForKey:@"avatar"];
    //[u removeObjectForKey:@"car"];
    [u removeObjectForKey:@"desc"];
    [u removeObjectForKey:@"email"];
    [u removeObjectForKey:@"license"];
    [u removeObjectForKey:@"messages"];
    //[u removeObjectForKey:@"name"];
    [u removeObjectForKey:@"nickName"];
    [u removeObjectForKey:@"numberOfService"];
    [u removeObjectForKey:@"phone"];
    //[u removeObjectForKey:@"phoneNumber"];
    [u removeObjectForKey:@"ratings"];
    [u removeObjectForKey:@"showToCollugues"];
    [u removeObjectForKey:@"showToCustomer"];
    [u removeObjectForKey:@"status"];
    [u removeObjectForKey:@"surName"];
    [u removeObjectForKey:@"tariff"];
    [u removeObjectForKey:@"type"];
    
    [u setObject:@"User" forKey:@"class"];
    [u replaceKey:@"userid" withKey:@"index"];
    
    [d removeObjectForKey:@"from"];
    [d setObject:u forKey:@"from"];
    
    [super populateFromDictionary:d];
}

+ (Message*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    [d setObject:@"Message" forKey:@"class"];
    Message* message = (Message*)[NSManagedObject createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
    
    return message;
}

@end
