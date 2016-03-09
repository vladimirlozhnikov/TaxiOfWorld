//
//  DropDownItem.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 26.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "DropDownItem.h"

@implementation DropDownItem
@synthesize displayName, object1, object2;

- (void)dealloc
{
    [name release];
    [super dealloc];
}

@end
