//
//  Tariff.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tariff : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * tariffDayCity;
@property (nonatomic, retain) NSString * tariffNightCity;
@property (nonatomic, retain) NSString * tariffDayOutCity;
@property (nonatomic, retain) NSString * tariffNightOutCity;
@property (nonatomic, retain) NSString * tariffWeekend;
@property (nonatomic, retain) NSString * tariffHoliday;
@property (nonatomic, retain) NSString * tariffSeat;
@property (nonatomic, retain) NSString * tariffTime;
@property (nonatomic, retain) NSString * tariffDowntime;

@end
