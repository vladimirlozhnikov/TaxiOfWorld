//
//  Tariff+Category.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Tariff+Category.h"
#import "NSManagedObject+Category.h"
#import "NSMutableDictionary+Category.h"

@implementation Tariff (Category)

- (NSMutableDictionary*) toDictionary
{
    NSMutableDictionary* d = [super toDictionary];
    
    return d;
}

- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSMutableDictionary* d = (NSMutableDictionary*)dict;
    
    // rename keys
    [d replaceKey:@"tariff_day_city" withKey:@"tariffDayCity"];
    [d replaceKey:@"tariff_day_out_city" withKey:@"tariffDayOutCity"];
    [d replaceKey:@"tariff_time" withKey:@"tariffTime"];
    [d replaceKey:@"tariff_seat" withKey:@"tariffSeat"];
    
    [d replaceKey:@"tariff_night_out_city" withKey:@"tariffNightOutCity"];
    [d replaceKey:@"tariff_holiday" withKey:@"tariffHoliday"];
    [d replaceKey:@"tariff_night_city" withKey:@"tariffNightCity"];
    [d replaceKey:@"tariff_weekend" withKey:@"tariffWeekend"];
    [d replaceKey:@"tariff_downtime" withKey:@"tariffDowntime"];
    
    [super populateFromDictionary:d];
}

+ (Tariff*) createManagedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dict];
    [d setObject:@"Tariff" forKey:@"class"];
    Tariff* tariff = (Tariff*)[NSManagedObject createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext];
    
    return tariff;
}

@end
