//
//  DropDownItem.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 26.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.h"

@interface DropDownItem : NSObject <DropDownItemProtocol>
{
    NSString* name;
    NSString* displayName;
    
    id object1;
    id object2;
}

@property (nonatomic, retain) id object1;
@property (nonatomic, retain) id object2;
@property (nonatomic, retain) NSString* displayName;

@end
