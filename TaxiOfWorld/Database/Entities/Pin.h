//
//  Pin.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Pin : NSManagedObject

@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * status;

@end
