//
//  Protocol.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 26.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@protocol DropDownItemProtocol <NSObject>
@property (nonatomic, retain) id object1;
@property (nonatomic, retain) id object2;
@property (nonatomic, retain) NSString* displayName;

@end

@protocol MapViewControllerProtocol <NSObject>
- (void) didMakeOrder:(id)sender;
- (void) didCancelOrder:(id)sender;
- (void) didWaitingTimeOut:(id)sender;

@optional
- (void) didWaitingClose:(id)sender;

@end

@protocol RateProtocol <NSObject>
- (void) didChooseRate:(NSNumber*)rate driver:(User*)driver;

@end