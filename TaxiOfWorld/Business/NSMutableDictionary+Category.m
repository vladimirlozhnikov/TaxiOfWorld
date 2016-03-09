//
//  NSMutableDictionary+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "NSMutableDictionary+Category.h"

@implementation NSMutableDictionary (Category)

- (void) replaceKey:(id)oldKey withKey:(id)newKey
{
    id value = [self objectForKey:oldKey];
    if (value)
    {
        [self setObject:value forKey:newKey];
        [self removeObjectForKey:oldKey];
    }
}

@end
