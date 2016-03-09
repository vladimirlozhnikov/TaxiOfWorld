//
//  Rating.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 27.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Rating : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * rate;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * userId;

@end
