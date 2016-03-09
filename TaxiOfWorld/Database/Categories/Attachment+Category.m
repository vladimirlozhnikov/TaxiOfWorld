//
//  Attachment+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Attachment+Category.h"
#import "NSManagedObject+Category.h"
#import "NSMutableDictionary+Category.h"
#import "Helper.h"

@implementation Attachment (Category)

- (NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* d = [super toDictionary];
    
    return d;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSMutableDictionary* d = (NSMutableDictionary*)dict;
    
    // rename keys
    [d replaceKey:@"id" withKey:@"index"];
    
    NSString* url = [d objectForKey:@"url"];
    if ([url length] > 0)
    {
        //NSLog(@"%@", url);
        [Helper processImageDataWithURLString:[NSURL URLWithString:url] andBlock:^(NSData *imageData) {
            [d setObject:imageData forKey:@"data"];
            
            [super populateFromDictionary:d];
        }];
    }
}

+ (Attachment*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    [d setObject:@"Attachment" forKey:@"class"];
    Attachment* attachment = (Attachment*)[NSManagedObject createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
    
    return attachment;
}

@end
