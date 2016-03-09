//
//  Message.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 24.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, User;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * flag;
@property (nonatomic, retain) NSString * beginPoint;
@property (nonatomic, retain) NSString * endPoint;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * timeWillBe;
@property (nonatomic, retain) Attachment *attachment;
@property (nonatomic, retain) User *from;

@end
