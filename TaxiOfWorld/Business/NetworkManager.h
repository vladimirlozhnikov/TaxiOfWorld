//
//  NetworkManager.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 22.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "User.h"
#import "Pin.h"
#import "Group.h"
#import "Message.h"
#import "Rating.h"
#import "Country.h"
#import <CoreLocation/CoreLocation.h>

@interface NetworkManager : NSObject
{
    AFHTTPClient* httpClient;
}

- (void) register:(User*)user success:(void(^)(User* user, NSString* password))onSuccess onError:(void(^)(NSString* error))onError;

- (void) login:(NSString*)email password:(NSString*)password pin:(Pin*)pin language:(NSInteger)language version:(NSString*)version deviceToken:(NSData*)deviceToken success:(void(^)(NSString* session, User* user, NSArray* groups))onSuccess onError:(void(^)(NSString* error))onError;

- (void) updateMe:(void(^)())onSuccess onError:(void(^)(NSString* error))onError;

- (void) joinToGroup:(Group*)group ticket:(NSString*)ticket success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError;

- (void) leaveGroup:(Group*)group success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError;

- (void) usersOfGroup:(Group*)group fullInfo:(BOOL)fullInfo success:(void(^)(NSArray* usersOrPins))onSuccess onError:(void(^)(NSString* error))onError;

- (void) messages:(NSInteger)limit success:(void(^)(NSArray* messages))onSuccess onError:(void(^)(NSString* error))onError;

- (void) sendMessage:(Message*)message users:(NSArray*)users success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError;

- (void) updateCoordinates:(Pin*)pin success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError;

- (void) countries:(void(^)(NSArray* countries))onSuccess onError:(void(^)(NSString* error))onError;

- (void) cities:(Country*)country success:(void(^)(NSArray* cities))onSuccess onError:(void(^)(NSString* error))onError;

- (void) ping:(NSInteger)status success:(void(^)(NSInteger messageQuantity, NSString* version, NSArray* leftUsers, NSArray* joinedUSers))onSuccess onError:(void(^)(NSString* error))onError;

- (void) handleMessage:(Message*)message success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError;

- (void) pushRate:(User*)user rate:(Rating*)rating success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError;

- (void) getAddresses:(CLLocationCoordinate2D)position success:(void(^)(NSArray* addresses))onSuccess onError:(void(^)(NSString* error))onError;

@end
