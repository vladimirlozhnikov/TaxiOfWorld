//
//  User.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car, Message, Pin, Rating, Tariff;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * surName;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * showToCustomer;
@property (nonatomic, retain) NSString * showToCollugues;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * license;
@property (nonatomic, retain) NSString * numberOfService;
@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) Pin *pin;
@property (nonatomic, retain) NSSet *ratings;
@property (nonatomic, retain) Car *car;
@property (nonatomic, retain) Tariff *tariff;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

- (void)addRatingsObject:(Rating *)value;
- (void)removeRatingsObject:(Rating *)value;
- (void)addRatings:(NSSet *)values;
- (void)removeRatings:(NSSet *)values;

@end
