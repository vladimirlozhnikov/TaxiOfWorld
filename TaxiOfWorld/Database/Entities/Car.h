//
//  Car.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment;

@interface Car : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * licensePlate;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * seats;
@property (nonatomic, retain) NSString * youCanSmoke;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Car (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Attachment *)value;
- (void)removePhotosObject:(Attachment *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
