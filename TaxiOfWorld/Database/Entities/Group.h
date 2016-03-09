//
//  Group.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, Country;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * isOpen;
@property (nonatomic, retain) NSString * ticket;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) City *city;

@end
